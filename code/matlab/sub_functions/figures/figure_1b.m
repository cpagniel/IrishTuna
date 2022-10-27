%% figure_1b.m
% Sub-function of Irish_Tuna.m; plots SSM tracks of binned by days in 1 x 1 degree bins.

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [20 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Bin SSM Positions

binned.LONedges = -80:1:40;
binned.LATedges = 20:1:70;

[binned.N,binned.LONmid,binned.LATmid] = twodhist(META.Longitude,META.Latitude,binned.LONedges,binned.LATedges);

m_pcolor(binned.LONmid,binned.LATmid,binned.N);

hold on

%% Plot land.

m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Plot ocean regions.

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

%% Create figure border.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

%% Add north arrow and scale bar.

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

%% Add colorbar

p = get(gca,'Position');

h = colorbar('FontSize',16); 
colormap(flipud(hot(1500)));
ylabel(h,'Number of Daily Geolocations','FontSize',16);
caxis([0 75]);
h.Ticks = 0:25:75;

set(gca,'Position',p);

clear cmap
clear p

%% Save

cd([fdir 'figures']);
saveas(gcf,'figure_1b.png')

%% Clear

clear h* binned
clear ans

close gcf