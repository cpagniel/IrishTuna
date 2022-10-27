%% figure_1a.m
% Sub-function of Irish_Tuna.m; plots SSM tracks of all tags colored by
% year.

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [20 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
 
%% Plot bathymetry.

[cs,ch] = m_etopo2('contourf',-8000:500:0,'edgecolor','none');

h1 = m_contfbar([.3 .7],.05,cs,ch,'endpiece','no','FontSize',16);
xlabel(h1,'Bottom Depth (m)');

colormap(m_colmap('blue'));

hold on

%% Plot land.

m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Plot SSM positions of tuna colored by year.

% Set colormap of year.
cmap1 = hot(length(unique(year(META.Date)))+1);
cmap2 = autumn(length(unique(year(META.Date))));
cmap = [cmap1(1:3,:); cmap2(4:end,:)];

% Get years.
yyyy = unique(year(META.Date));

% Plot each year.
for i = 1:length(yyyy)
    m(i) = m_plot(META.Longitude(yyyy(i) == year(META.Date)),...
        META.Latitude(yyyy(i) == year(META.Date)),...
        'ko','MarkerFaceColor',cmap(i,:),'MarkerSize',3,'MarkerEdgeColor','k');
    hold on
end
clear i

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

%% Add Legend

[~,icon] = legend(m,{num2str(yyyy)},'FontSize',14);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',12);
clear yyyy
clear icon*

%% Save figure.

cd([fdir 'figures']);
saveas(gcf,'figure_1a.png');

%% Clear

clear ax* c* h* m M *LIMS
clear ans

close gcf