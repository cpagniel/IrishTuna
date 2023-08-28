%% figures_S5.m

%% Get Unique TOPP IDs

toppID = unique(META.TOPPid);

%% Loop Through All TOPP IDs 

for t = 1:length(toppID)

    %% Create figure and axes for bathymetry.

    figure('Position',[476 334 716 532]);

    %% Set projection of map.

    LATLIMS = [20 70]; LONLIMS = [-80 40];
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

    %% Plot bathymetry.

    [cs,ch] = m_etopo2('contourf',-8000:500:0,'edgecolor','none');

    colormap(m_colmap('blue'));

    hold on

    %% Plot land.

    m_gshhs_i('patch',[.7 .7 .7]);

    hold on

    %% Set colormap by month.

    MM = unique(month(META.Date));
    cmap = [0.122,0.122,1 ; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
        0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
        0.663,0,0.902; 1,1,1];
%     cmap = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
%         0.914,1,0.745; 0.9843,0.6039,0.6000; 1,0,0; 0.659,0,0;  0.9365,0.4000,0.0681; 1,0.666,0; 0.9943,0.8627,0.7294;...
%         0.6510,0.8078,0.8902];

    %% Plot SSM Positions

    tmp.lon = META.Longitude(META.TOPPid == toppID(t));
    tmp.lat = META.Latitude(META.TOPPid == toppID(t));
    tmp.date = META.Date(META.TOPPid == toppID(t));
%     ind = tmp.date > datetime(2021,05,29);
%     tmp.lon(ind) = []; tmp.lat(ind) = []; tmp.date(ind) = [];

    for j = 1:length(MM)
        if isempty(tmp.lon(MM(j) == month(tmp.date)))
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap(j,:),'MarkerEdgeColor','k','MarkerSize',6);
            hold on
        else
            m(j) = m_plot(tmp.lon(MM(j) == month(tmp.date)),...
                tmp.lat(MM(j) == month(tmp.date)),...
                'ko','MarkerFaceColor',cmap(j,:),'MarkerEdgeColor','k','MarkerSize',6);
            hold on
        end
    end
    clear j
    clear tmp

    %% Plot ICCAT management line.

    m_line([-45 -45],[20 70],'linewi',2,'color','k','linestyle','--')

    %% Plot hotspot boundaries.

    m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.CI.bndry(1,:),regions.CI.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');

    %% Create figure border.

    m_grid('linewi',2,'tickdir','in','linest','none','fontsize',20);

    %% Add north arrow and scale bar.

    m_northarrow(-75,65,4,'type',2,'linewi',2);
    m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

    %% Add Legend

    [~,icon] = legend(m,{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'FontSize',14);
    icons = findobj(icon, 'type', 'line');
    set(icons,'MarkerSize',12);
    clear MM
    clear icon*

    %% Add TOPP ID

    patch([0.35 0.75 0.75 0.35],[1.325 1.325 1.45 1.45],'w');
    text(0.4,1.385,num2str(toppID(t)),'color','k','FontSize',20);

    %% Save figure.

    cd([fdir 'figures/S5']);
    exportgraphics(gcf,[num2str(toppID(t)) '_map.png'],'Resolution',300);

    %% Clear

    clear ax* c* h* m M *LIMS
    clear ans

    close gcf

end