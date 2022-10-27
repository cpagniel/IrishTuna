%% figure_6.m
% Sub-function of Irish_Tuna.m; plots pdt per hotspot per season

%% Load PDTs from Wildlife Computers

cd([fdir 'data/pdt']);
files = dir('*.csv');

old = [];
for i = 1:length(files)
    if ismember(str2double(files(i).name(1:7)),unique(META.TOPPid))
        opts = detectImportOptions(files(i).name);
        opts.DataLines(1) = 2;
        opts.VariableNamesLine = 1;

        new = readtable(files(i).name,opts);
        new = new(:,[1 3:7]);
        new.Properties.VariableNames = {'PDTNumber','Date','Depth','MinTemp','MaxTemp','MeanTemp'};

        toppID = ones(height(new),1).*str2double(files(i).name(1:7));
        new = addvars(new,toppID,'Before','PDTNumber');

        min_date = min(META.Date(META.TOPPid == toppID(1)));
        max_date = max(META.Date(META.TOPPid == toppID(1)));

        ind = new.Date <= max_date & new.Date >= min_date;

        pdt = [old; new(ind,:)];

        old = pdt;
        clear *new opts
    end
end
clear i toppID
clear files
clear ind
clear *_date

%% Load PDTs from Lotek

cd([fdir 'data/bin_TempTS']);
files = dir('*.csv');

for i = 1:length(files)
    if ismember(str2double(files(i).name(1:7)),unique(META.TOPPid))
        opts = detectImportOptions(files(i).name);
        opts.DataLines(1) = 2;
        opts.VariableNamesLine = 1;

        new = readtable(files(i).name,opts);
        new = new(:,[2:3 6 7 5]);
        new.Properties.VariableNames = {'Date','Depth','MinTemp','MaxTemp','MeanTemp'};
        
        [~,~,PDTNumber] = unique(new.Date);
        new = addvars(new,PDTNumber,'Before','Date');

        toppID = ones(height(new),1).*str2double(files(i).name(1:7));
        new = addvars(new,toppID,'Before','PDTNumber');

        min_date = min(META.Date(META.TOPPid == toppID(1)));
        max_date = max(META.Date(META.TOPPid == toppID(1)));

        ind = new.Date <= max_date & new.Date >= min_date;

        pdt = [old; new(ind,:)];

        old = pdt;
        clear *new opts
    end
end
clear i toppID
clear old
clear files
clear ind
clear *_date
clear PDTNumber

%% Identify PDT Region and Season Based on Date

Season = zeros(height(pdt),1);
pdt = addvars(pdt,Season,'After','MeanTemp');
clear Season

Region = zeros(height(pdt),1);
pdt = addvars(pdt,Region,'After','Season');
clear Region

% Make dates same format dd-mm-yyyy.
tmp.pdt.Date = datetime(year(pdt.Date),month(pdt.Date),day(pdt.Date));
tmp.META.Date = datetime(year(META.Date),month(META.Date),day(META.Date));

% Remove pdt dates not in metadata.
pdt = pdt(ismember(tmp.pdt.Date,tmp.META.Date),:);
tmp.pdt.Date = tmp.pdt.Date(ismember(tmp.pdt.Date,tmp.META.Date),:);

for i = 1:height(META)
    ind_time = find(tmp.pdt.Date == tmp.META.Date(i));
    ind_topp = find(pdt.toppID == META.TOPPid(i));

    ind = intersect(ind_time,ind_topp);

    pdt.Season(ind) = META.Season(i);
    pdt.Region(ind) = META.Region(i);
end
clear i
clear ind*
clear tmp

%% Plot

for j = 1
    for i = 1:4
        binned.Temp = 0:1:30; %floor(min(pdt.MinTemp)):1:ceil(max(pdt.MaxTemp));
        binned.Depth = 0:4:1000; %min(pdt.Depth):4:max(pdt.Depth);
    
        [binned.N,binned.Temp,binned.Depth,binned.binT,binned.binD] = histcounts2([pdt.MinTemp(pdt.Season == i & pdt.Region == j-1); ...
            pdt.MeanTemp(pdt.Season == i & pdt.Region == j-1); ...
            pdt.MaxTemp(pdt.Season == i & pdt.Region == j-1)], ...
            [pdt.Depth(pdt.Season == i & pdt.Region == j-1); ...
            pdt.Depth(pdt.Season == i & pdt.Region == j-1); ...
            pdt.Depth(pdt.Season == i & pdt.Region == j-1)],binned.Temp,binned.Depth);
        binned.N(binned.N == 0) = NaN;

        N = length(unique(pdt.toppID(pdt.Season == i & pdt.Region == j-1)));
    
        figure('Position',[476 446 283 420]);
    
        imagescn(binned.Temp,binned.Depth,log(binned.N).');
        shading flat;
    
        set(gca,'ydir','reverse','FontSize',18,'linewidth',2);
        xlabel('Temperature (^oC)','FontSize',20); ylabel('Depth (m)','FontSize',20);
        xlim([binned.Temp(1) binned.Temp(end)]); ylim([binned.Depth(1) binned.Depth(end)]);

        colormap(turbo);
        %h = colorbar('eastoutside'); ylabel(h,'ln(Frequency of Occurence)','FontSize',14);
        caxis([0 7]);

        if j == 2
            rg = 'Newfoundland Basin';
        elseif j == 3
            rg = 'Coastal Ireland';
        elseif j == 4
            rg = 'Bay of Biscay';
        elseif j == 5
            rg = 'West European Basin';
        elseif j == 6
            rg = 'Mediterranean';
        elseif j == 1
            rg = 'Outside';
        end

        if i == 1 
            ss = 'Winter';
        elseif i == 2
            ss = 'Spring';
        elseif i == 3
            ss = 'Summer';
        elseif i == 4
            ss = 'Fall';
        end

        text(20,955,['n = ' num2str(N)],'FontSize',20,'FontWeight','bold');

        cd([fdir 'figures']);
        saveas(gcf,['figure_6_' rg '_' ss '.png']);

        keyboard()

        clear N
        clear ss rg
        clear binned

        close gcf

    end
end
clear i j
clear tmp
