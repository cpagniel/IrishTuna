%% figure_S3_to_S5
% Sub-function of Irish_Tuna.m; plots timeseries and track for 3 tags. Need
% to manually edit filename each time.

%% Define filename.

% 5116034
% 5116043
% 5120057

cd([fdir 'data/archival']);

filename = '5120057_L330-2973_clean.csv';
% '5116034_14P0031_clean.csv';
% '5116043_16P1265_clean.csv';

%% Load PAT data.

PAT = readtable(filename);
PAT = PAT(:,[1:3 5]);

% Remove rows in table when there are temperature values missing
PAT(isnan(table2array(PAT(:,4))),:) = [];

% Remove rows in table when there are depth values missing
PAT(isnan(table2array(PAT(:,2))),:) = [];

% Rename Headers
PAT.Properties.VariableNames = {'Time' 'Depth' 'LightLevel' 'Temperature'};

[~,ind] = sort(PAT.Time);
PAT = PAT(ind,:);

% Remove dates before and after metadata.
min_date = min(META.Date(META.TOPPid == str2double(filename(1:7))));
max_date = max(META.Date(META.TOPPid == str2double(filename(1:7))));

ind = PAT.Time <= max_date & PAT.Time >= min_date;

PAT = PAT(ind,:);

% Fish was recaptured on 5/29/2021
if str2double(filename(1:7)) == 5120057
    PAT = PAT(PAT.Time <= datetime(2021,5,29),:);
end

%% Interpolate SSM positions to match PAT sampling frequency.

PAT.Longitude = interp1(datenum(META.Date(META.TOPPid == str2double(filename(1:7)))),...
    META.Longitude(META.TOPPid == str2double(filename(1:7))),datenum(PAT.Time));

PAT.Latitude = interp1(datenum(META.Date(META.TOPPid == str2double(filename(1:7)))),...
    META.Latitude(META.TOPPid == str2double(filename(1:7))),datenum(PAT.Time));

%% Determine hotspot.

PAT.Region = zeros(length(PAT.Latitude),1);
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

%% Determine season.

PAT.Season = zeros(length(PAT.Latitude),1);
PAT.Season(month(PAT.Time) == 12 | month(PAT.Time) == 1 | month(PAT.Time) == 2) = 1;
PAT.Season(month(PAT.Time) == 3 | month(PAT.Time) == 4 | month(PAT.Time) == 5) = 2;
PAT.Season(month(PAT.Time) == 6 | month(PAT.Time) == 7 | month(PAT.Time) == 8) = 3;
PAT.Season(month(PAT.Time) == 9 | month(PAT.Time) == 10 | month(PAT.Time) == 11) = 4;

%% Plot

figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

scatter(PAT.Time,PAT.Depth,4,PAT.Temperature,'filled');

set(gca,'ydir','reverse','FontSize',22,'LineWidth',2);

xlabel('Date','FontSize',26); ylabel('Depth (m)','FontSize',26);

cmocean thermal
h = colorbar; ylabel(h,'Temperature (^oC)','FontSize',26);
caxis([7 27]); h.Ticks = 7:2:27;

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) - 0.01;
h.Position(2) = h.Position(2) + 0.05;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);
clear p_global

xlim([datetime(year(PAT.Time(1)),8,1) datetime(year(PAT.Time(end)),9,1)])
ylim([-50 1000]);
box on;

hold on

cmap = [128 128 128; 56 108 176; 127 201 127; 255 255 153; 190 174 212; 253 192 134]./256;
ind = ischange(PAT.Region); ind = [1; find(ind); length(PAT.Region)];
for i = 1:length(ind)-1
    m(i) = patch([PAT.Time(ind(i)) PAT.Time(ind(i)) PAT.Time(ind(i+1)) PAT.Time(ind(i+1)) PAT.Time(ind(i))],...
        [-10 -50 -50 -10 -10],cmap(PAT.Region(ind(i))+1,:),'EdgeColor','none');
end
clear i ind

if str2double(filename(1:7)) == 5120043
    legend(m([1 11 2 4 8 3]),'Coastal Ireland','Bay of Biscay',...
        'West European Basin','Newfoundland Basin','Mediterranean Sea','Outside',...
        'Location','Best','NumColumns',2);
end
clear m

cd([fdir 'figures']);
if str2double(filename(1:7)) == 5120057
    exportgraphics(gcf,'figure_S6a.png','Resolution',300);
end

clear cmap

close gcf

%% Plot Track

figure('Position',[476 334 716 532],'Visible','on');

LATLIMS = [20 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

[cs,ch] = m_etopo2('contourf',-8000:500:0,'edgecolor','none');

h1 = m_contfbar([.3 .7],.05,cs,ch,'endpiece','no','FontSize',16);
xlabel(h1,'Bottom Depth (m)');

colormap(m_colmap('blue'));

hold on

m_gshhs_i('patch',[.7 .7 .7]);

hold on

MM = unique(month(META.Date));
cmap = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
        0.914,1,0.745; 0.9843,0.6039,0.6000; 1,0,0; 0.659,0,0;  0.9365,0.4000,0.0681; 1,0.666,0; 0.9943,0.8627,0.7294;...
        0.6510,0.8078,0.8902];

tmp.lon = META.Longitude(META.TOPPid == str2double(filename(1:7)));
tmp.lat = META.Latitude(META.TOPPid == str2double(filename(1:7)));
tmp.date = META.Date(META.TOPPid == str2double(filename(1:7)));

% Fish was recaptured on 5/29/2021
if str2double(filename(1:7)) == 5120057
    tmp.lon = tmp.lon(tmp.date <= datetime(2021,5,29),:);
    tmp.lat = tmp.lat(tmp.date <= datetime(2021,5,29),:);
    tmp.date = tmp.date(tmp.date <= datetime(2021,5,29),:);
end

for j = 1:length(MM)
    if isempty(tmp.lon(MM(j) == month(tmp.date)))
        m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap(j,:),'MarkerEdgeColor','k','MarkerSize',5);
        hold on
    else
        m(j) = m_plot(tmp.lon(MM(j) == month(tmp.date)),...
            tmp.lat(MM(j) == month(tmp.date)),...
            'ko','MarkerFaceColor',cmap(j,:),'MarkerEdgeColor','k','MarkerSize',5);
        hold on
    end
end
clear j
clear tmp

m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.CI.bndry(1,:),regions.CI.bndry(2,:),'linewi',2,'color','k');
m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');
m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

cd([fdir 'figures']);
if str2double(filename(1:7)) == 5120057
    exportgraphics(gcf,'figure_S6b.png','Resolution',300);
end

clear ax* c* h* m MM *LIMS
clear *_date
clear ans

clear filename

close all