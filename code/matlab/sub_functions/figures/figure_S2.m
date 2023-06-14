%% figure_3.m
% Sub-function of Irish_Tuna.m; plot time at temperature

%% Define temperature bins.

bins.temp = [0,5,10,12,14,16,18,20,22,24,26,28,45]; % last bin is > 28 deg C

%% Load *TimeAtTemp.csv files.

cd([fdir 'data/time_at_temp'])
files = dir('*TimeAtTemp.csv');

new = table();
TAT = table();
for i = 1:length(files)
    new = readtable(files(i).name);
    new.toppID = str2double(files(i).name(1:7)).*ones(height(new),1);
    TAT = [TAT; new];
end
clear i
clear new
clear files

TAT(:,[1:2 15:16]) = [];
TAT.DateTime = datetime(TAT.year,TAT.month,TAT.day);
TAT(:,13:16) = [];
TAT = movevars(TAT, 'toppID', 'Before', 'Bin1');
TAT = movevars(TAT, 'DateTime', 'Before', 'Bin1');

%% Load and bin WC *Series.csv files.

cd([fdir 'data/time_at_depth/WC/series'])
files = dir('*Series.csv');

for i = 1:length(files)
    tmp = readtable(files(i).name);

    dt = unique(tmp.Day);
    dt = dt(dt <= max(META.Date(META.TOPPid == str2double(files(i).name(1:7)))));
    for j = 1:length(dt)
        TAT.toppID(end+1) = str2double(files(i).name(1:7));
        TAT.DateTime(end) = dt(j);
        TAT(end,3:end) = array2table(histcounts(tmp.Temperature(tmp.Day == dt(j)),'BinEdges',bins.temp)./sum(tmp.Day == dt(j)));
    end
    clear j

    clear dt
    clear tmp
end
clear i
clear files

%% Load and bin WC *Archive.csv files.

cd([fdir 'data/time_at_depth/WC/archive'])
files = dir('*Archive.csv');

for i = 1:length(files)
    tmp = readtable(files(i).name);
    tmp = tmp(:,[1 3]);
    tmp.Properties.VariableNames = {'Time','Temperature'};
    tmp.Day = datetime(year(tmp.Time),month(tmp.Time),day(tmp.Time));

    dt = unique(tmp.Day);
    dt = dt(dt <= max(META.Date(META.TOPPid == str2double(files(i).name(1:7)))));
    for j = 1:length(dt)
        TAT.toppID(end+1) = str2double(files(i).name(1:7));
        TAT.DateTime(end) = dt(j);
        TAT(end,3:end) = array2table(histcounts(tmp.Temperature(tmp.Day == dt(j)),'BinEdges',bins.temp)./sum(tmp.Day == dt(j)));
    end
    clear j

    clear dt
    clear tmp
end
clear i
clear files

%% Load and bin Lotek *_clean.csv files.

cd([fdir 'data/time_at_depth/Lotek'])
files = dir('*_clean.csv');

for i = 1:length(files)
    tmp = readtable(files(i).name);
    tmp = tmp(:,[1 5]);
    tmp.Properties.VariableNames = {'Time','Temperature'};
    tmp.Day = datetime(year(tmp.Time),month(tmp.Time),day(tmp.Time));

    dt = unique(tmp.Day);
    dt = dt(dt <= max(META.Date(META.TOPPid == str2double(files(i).name(1:7)))));
    for j = 1:length(dt)
        TAT.toppID(end+1) = str2double(files(i).name(1:7));
        TAT.DateTime(end) = dt(j);
        TAT(end,3:end) = array2table(histcounts(tmp.Temperature(tmp.Day == dt(j)),'BinEdges',bins.temp)./sum(tmp.Day == dt(j)));
    end
    clear j

    clear dt
    clear tmp
end
clear i
clear files

%% Identify TaD Region, Season, Latitude and Longitude Based on Date

Season = zeros(height(TAT),1);
TAT = addvars(TAT,Season,'After','Bin12');
clear Season

Region = zeros(height(TAT),1);
TAT = addvars(TAT,Region,'After','Season');
clear Region

Latitude = zeros(height(TAT),1);
TAT = addvars(TAT,Latitude,'After','Region');
clear Latitude

Longitude = zeros(height(TAT),1);
TAT = addvars(TAT,Longitude,'After','Latitude');
clear Longitude

% Make dates same format dd-mm-yyyy.
tmp.TAD.Date = datetime(year(TAT.DateTime),month(TAT.DateTime),day(TAT.DateTime));
tmp.META.Date = datetime(year(META.Date),month(META.Date),day(META.Date));

% Remove TAD dates not in metadata.
TAT = TAT(ismember(tmp.TAD.Date,tmp.META.Date),:);
tmp.TAD.Date = tmp.TAD.Date(ismember(tmp.TAD.Date,tmp.META.Date),:);

for i = 1:height(META)
    ind_time = find(tmp.TAD.Date == tmp.META.Date(i));
    ind_topp = find(TAT.toppID == META.TOPPid(i));

    ind = intersect(ind_time,ind_topp);

    TAT.Season(ind) = META.Season(i);
    TAT.Region(ind) = META.Region(i);
    TAT.Latitude(ind) = META.Latitude(i);
    TAT.Longitude(ind) = META.Longitude(i);
end
clear i
clear ind*
clear tmp

%% Compute mean in each bin for each tag.

toppID = unique(TAT.toppID);

for i = 1:length(toppID)
    cnt = 0;
    for j = [2 3 4 1 5 0]
        cnt = cnt + 1;
        tad.stats.mean_per_tag(i,cnt,:) = mean(table2array(TAT(TAT.toppID == toppID(i) & TAT.Region == j, 3:14)).*100,'omitnan');
        tad.stats.std_per_tag(i,cnt,:) = std(table2array(TAT(TAT.toppID == toppID(i) & TAT.Region == j, 3:14)).*100,'omitnan');
    end
end
clear i
clear j
clear cnt

%% Plot TaD

cnt = 0;
for i = [2 3 4 1 5 0] % each hotspot and outside hotspots

    figure();

    cnt = cnt + 1;

    tad.stats.mean_of_all_tags(cnt,:) = mean(tad.stats.mean_per_tag(:,cnt,:),'omitnan');
    tad.stats.std_of_all_tags(cnt,:) = std(tad.stats.mean_per_tag(:,cnt,:),'omitnan');

    b = barh(tad.stats.mean_of_all_tags(cnt,:));
    b.EdgeColor = 'k';
    b.FaceColor = cmap_r(cnt,:);
    b.LineWidth = 1;

    hold on

    er = errorbar(tad.stats.mean_of_all_tags(cnt,:),1:1:12,[],tad.stats.std_of_all_tags(cnt,:),'horizontal');
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    er.LineWidth = 1;

    set(gca,'ydir','reverse','FontSize',16,'linewidth',2,'tickdir','out');
    xlabel('Mean % Time at Depth','FontSize',20); ylabel('Depth (m)','FontSize',20);
    xlim([0 60]); set(gca,'XTick',0:5:60);
    set(gca,'XTickLabel',{'0','','10','','20','','30','','40','','50','','60'});
    set(gca,'XTickLabelRotation',0);
    ylim([0 13]);
    set(gca,'YTickLabels',{'0-5'; '5-10'; '10-50'; '50-100'; '100-150'; '150-200'; '200-250'; '250-300'; ...
        '300-500'; '500-700'; '700-1000'; '> 1000'});
    axis square
    grid on

    if i == 2
        rg = 'd';
    elseif i == 3
        rg = 'a';
    elseif i == 4
        rg = 'b';
    elseif i == 5
        rg = 'c';
    elseif i == 6
        rg = 'e';
    elseif i == 1
        rg = 'f';
    end

    cd([fdir 'figures']);
    exportgraphics(gcf,['figure_3_' rg '.png'],'Resolution',300);

    close all

end
clear i
clear b
clear er
clear eg