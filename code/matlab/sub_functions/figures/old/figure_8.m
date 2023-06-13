%% figure_8.m
% Sub-function of Irish_Tuna.m; plot full timeseries and map 

%% Get File List

cd([fdir 'data/archival']);
filename = '5116043_16P1265_clean.csv';

%% Load Data

cd([fdir 'data/archival']);
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

%% Interpolate SSM Positions to Match PAT Sampling Frequency

PAT.Longitude = interp1(datenum(META.Date(META.TOPPid == str2double(filename(1:7)))),...
    META.Longitude(META.TOPPid == str2double(filename(1:7))),datenum(PAT.Time));
PAT.Latitude = interp1(datenum(META.Date(META.TOPPid == str2double(filename(1:7)))),...
    META.Latitude(META.TOPPid == str2double(filename(1:7))),datenum(PAT.Time));

%% Determine Region

PAT.Region = zeros(length(PAT.Latitude),1);
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
PAT.Region(inpolygon(PAT.Longitude,PAT.Latitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

%% Plot

figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

scatter(PAT.Time,PAT.Depth,4,PAT.Temperature,'filled');

set(gca,'ydir','reverse','FontSize',22,'LineWidth',2);

xlabel('Date','FontSize',26); ylabel('Depth (m)','FontSize',26);

cmocean thermal
h = colorbar; ylabel(h,'Temperature (^oC)','FontSize',26);
caxis([7 27]); h.Ticks = 7:2:27;
%clear h

axis tight; ylim([-50 1000]);
box on;

hold on

cmap = [128 128 128; 56 108 176; 127 201 127; 255 255 153; 190 174 212; 253 192 134]./256;
ind = ischange(PAT.Region); ind = [1; find(ind); length(PAT.Region)];
for i = 1:length(ind)-1
    m(i) = patch([PAT.Time(ind(i)) PAT.Time(ind(i)) PAT.Time(ind(i+1)) PAT.Time(ind(i+1)) PAT.Time(ind(i))],...
        [-10 -50 -50 -10 -10],cmap(PAT.Region(ind(i))+1,:),'EdgeColor','none');
end
clear i ind

leg = legend(m([1 11 2 4 8 3]),'Coastal Ireland','Bay of Biscay',...
    'West European Basin','Newfoundland Basin','Mediterranean Sea','Outside',...
    'Location','Best');
clear m

cd([fdir 'figures']);
saveas(gcf,['figure_8_timeseries_' num2str(filename(1:7)) '.png']);

clear leg
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
%m_text(-53,51.5,'Newfoundland Basin','FontWeight','bold');

m_line(regions.CI.bndry(1,:),regions.CI.bndry(2,:),'linewi',2,'color','k');
%m_text(-20.5,61.2,'Coastal Ireland','FontWeight','bold');

m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');
%m_text(-2,51,'Bay of Biscay','FontWeight','bold');

m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');
%m_text(-2,51,'West European Basin','FontWeight','bold');

m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');
%m_text(-4.5,32,'Mediterranean','FontWeight','bold');

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

[~,icon] = legend(m,{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'FontSize',14);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',12);
clear MM
clear icon*

cd([fdir 'figures']);
saveas(gcf,['figure_8_map_' num2str(filename(1:7)) '.png']);

clear ax* c* h* m M *LIMS
clear ans
