%% figure_3.m
% Sub-function of Irish_Tuna.m; plot time at depth

%% Define depth bins.

bins.depth = [0,5,10,50,100,150,200,250,300,500,700,1000,5000]; % last bin is > 1000 m

%% Load *TimeAtDepth.csv files.

cd([fdir 'data/time_at_depth'])
files = dir('*TimeAtDepth.csv');

new = table();
TAD = table();
for i = 1:length(files)
    new = readtable(files(i).name);
    new.toppID = str2double(files(i).name(1:7)).*ones(height(new),1);
    TAD = [TAD; new];
end
clear i
clear new
clear files

TAD(:,[1:2 15:16]) = [];
TAD.DateTime = datetime(TAD.year,TAD.month,TAD.day);
TAD(:,13:16) = [];
TAD = movevars(TAD, 'toppID', 'Before', 'Bin1');
TAD = movevars(TAD, 'DateTime', 'Before', 'Bin1');

%% Load and bin WC *Series.csv files.

cd([fdir 'data/time_at_depth/WC/series'])
files = dir('*Series.csv');

for i = 1:length(files)
    tmp = readtable(files(i).name);

    dt = unique(tmp.Day);
    dt = dt(dt <= max(META.Date(META.TOPPid == str2double(files(i).name(1:7)))));
    for j = 1:length(dt)
        TAD.toppID(end+1) = str2double(files(i).name(1:7));
        TAD.DateTime(end) = dt(j);
        TAD(end,3:end) = array2table(histcounts(tmp.Depth(tmp.Day == dt(j)),'BinEdges',bins.depth)./sum(tmp.Day == dt(j)));
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
    tmp = tmp(:,1:2);
    tmp.Properties.VariableNames = {'Time','Depth'};
    tmp.Day = datetime(year(tmp.Time),month(tmp.Time),day(tmp.Time));

    dt = unique(tmp.Day);
    dt = dt(dt <= max(META.Date(META.TOPPid == str2double(files(i).name(1:7)))));
    for j = 1:length(dt)
        TAD.toppID(end+1) = str2double(files(i).name(1:7));
        TAD.DateTime(end) = dt(j);
        TAD(end,3:end) = array2table(histcounts(tmp.Depth(tmp.Day == dt(j)),'BinEdges',bins.depth)./sum(tmp.Day == dt(j)));
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
    tmp = tmp(:,1:2);
    tmp.Properties.VariableNames = {'Time','Depth'};
    tmp.Day = datetime(year(tmp.Time),month(tmp.Time),day(tmp.Time));

    dt = unique(tmp.Day);
    dt = dt(dt <= max(META.Date(META.TOPPid == str2double(files(i).name(1:7)))));
    for j = 1:length(dt)
        TAD.toppID(end+1) = str2double(files(i).name(1:7));
        TAD.DateTime(end) = dt(j);
        TAD(end,3:end) = array2table(histcounts(tmp.Depth(tmp.Day == dt(j)),'BinEdges',bins.depth)./sum(tmp.Day == dt(j)));
    end
    clear j

    clear dt
    clear tmp
end
clear i
clear files

%% Identify TaD Region, Season, Latitude and Longitude Based on Date

Season = zeros(height(TAD),1);
TAD = addvars(TAD,Season,'After','Bin12');
clear Season

Region = zeros(height(TAD),1);
TAD = addvars(TAD,Region,'After','Season');
clear Region

Latitude = zeros(height(TAD),1);
TAD = addvars(TAD,Latitude,'After','Region');
clear Latitude

Longitude = zeros(height(TAD),1);
TAD = addvars(TAD,Longitude,'After','Latitude');
clear Longitude

% Make dates same format dd-mm-yyyy.
tmp.TAD.Date = datetime(year(TAD.DateTime),month(TAD.DateTime),day(TAD.DateTime));
tmp.META.Date = datetime(year(META.Date),month(META.Date),day(META.Date));

% Remove TAD dates not in metadata.
TAD = TAD(ismember(tmp.TAD.Date,tmp.META.Date),:);
tmp.TAD.Date = tmp.TAD.Date(ismember(tmp.TAD.Date,tmp.META.Date),:);

for i = 1:height(META)
    ind_time = find(tmp.TAD.Date == tmp.META.Date(i));
    ind_topp = find(TAD.toppID == META.TOPPid(i));

    ind = intersect(ind_time,ind_topp);

    TAD.Season(ind) = META.Season(i);
    TAD.Region(ind) = META.Region(i);
    TAD.Latitude(ind) = META.Latitude(i);
    TAD.Longitude(ind) = META.Longitude(i);
end
clear i
clear ind*
clear tmp

%% Compute mean in each bin for each tag.

toppID = unique(TAD.toppID);

for i = 1:length(toppID)
    cnt = 0;
    for j = [2 3 4 1 5 0]
        cnt = cnt + 1;
        tad.stats.mean_per_tag(i,cnt,:) = mean(table2array(TAD(TAD.toppID == toppID(i) & TAD.Region == j, 3:14)).*100,'omitnan');
        tad.stats.std_per_tag(i,cnt,:) = std(table2array(TAD(TAD.toppID == toppID(i) & TAD.Region == j, 3:14)).*100,'omitnan');
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

    if i == 1
        rg = 'd';
    elseif i == 2
        rg = 'a';
    elseif i == 3
        rg = 'b';
    elseif i == 4
        rg = 'c';
    elseif i == 5
        rg = 'e';
    elseif i == 0
        rg = 'f';
    end

    cd([fdir 'figures']);
    exportgraphics(gcf,['figure_3_' rg '.png'],'Resolution',300);

    close all

end
clear i
clear cnt
clear b
clear er
clear rg