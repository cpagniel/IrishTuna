%% figure_S2.m
% Sub-function of Irish_Tuna.m; plots SSM tracks of all tags that went to the Med colored by
% tag.

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

%% Colormap for TOPP IDs That Went to The Med

TOPPid = unique(META.TOPPid(META.Region == 5));
cmap = [getPyPlot_cMap('Paired',12); 0 0 0; 1 1 1];

%% Plot SSM positions of tuna colored by tag.

% Plot each tag.
for i = 1:length(TOPPid)
    m(i) = m_plot(META.Longitude(TOPPid(i) == META.TOPPid),...
        META.Latitude(TOPPid(i) == META.TOPPid),...
        'o-','MarkerFaceColor',cmap(i,:),'MarkerSize',3,'MarkerEdgeColor','k','Color',cmap(i,:));
    hold on
end
clear i

%% Plot ICCAT regions.

% cd('/Volumes/GoogleDrive-115844804207666893078/My Drive/Projects/IrishTuna/ICCAT_polygons');
% M = m_shaperead('ICCAT_polygons');
% 
% for k=1:length(M.ncst)
%     m_line(M.ncst{k}(:,1),M.ncst{k}(:,2),'linewi',2,'color','k','LineStyle','-');
% end

%% Plot ocean regions.

m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
%m_text(-53,51.5,'Newfoundland Basin','FontWeight','bold');

m_line(regions.Rockall.bndry(1,:),regions.Rockall.bndry(2,:),'linewi',2,'color','k');
%m_text(-20.5,61.2,'Rockall Trough','FontWeight','bold');

m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');
%m_text(-2,51,'Bay of Biscay','FontWeight','bold');

m_line(regions.OffBiscay.bndry(1,:),regions.OffBiscay.bndry(2,:),'linewi',2,'color','k');
%m_text(-2,51,'Offshore of Bay of Biscay','FontWeight','bold');

m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');
%m_text(-4.5,32,'Mediterranean','FontWeight','bold');

%% Create figure border.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

%% Add north arrow and scale bar.

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.09,2,'fontsize',16,'ticklength',0.01);

%% Save figure.

cd([fdir 'figures']);
saveas(gcf,'figure_S2.png');

%% Add Legend

leg = legend(m,{num2str(TOPPid)},'Location','eastoutside','NumColumns',1,'FontSize',12);
icons = findobj(m, 'type', 'line');
set(icons,'MarkerSize',8);
clear TOPPid
clear icon*

%% Save figure.

cd([fdir 'figures']);
saveas(gcf,'figure_S2_legend.png');

%% Clear

clear ax* c* h* m M *LIMS
clear ans

close gcf