%% figure_S7.m

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

    %% Set colormap by season.

    MM = unique(META.Season);
    cmap = ['b';'g';'y';'r'];

    %% Plot SSM Positions

    tmp.lon = META.Longitude(META.TOPPid == toppID(t));
    tmp.lat = META.Latitude(META.TOPPid == toppID(t));
    tmp.season = META.Season(META.TOPPid == toppID(t));

    cnt = 0;
    for j = [4 1 2 3]
        cnt = cnt + 1;
        if isempty(tmp.lon(MM(j) == tmp.season))
            m(cnt) = m_plot(-100,100,'o','MarkerFaceColor',cmap(j),'MarkerEdgeColor','k','MarkerSize',6);
            hold on
        else
            m(cnt) = m_plot(tmp.lon(MM(j) == tmp.season),...
                tmp.lat(MM(j) == tmp.season),...
                'ko','MarkerFaceColor',cmap(j),'MarkerEdgeColor','k','MarkerSize',6);
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

    [~,icon] = legend(m,{'Fall','Winter','Spring','Summer'},'FontSize',14);
    icons = findobj(icon, 'type', 'line');
    set(icons,'MarkerSize',12);
    clear MM
    clear icon*

    %% Add TOPP ID

    p = patch([0.25 0.65 0.65 0.25],[1.325 1.325 1.45 1.45],'w');
    tt = text(0.3,1.385,num2str(toppID(t)),'color','k','FontSize',20);

    %% Save figure.

    cd([fdir 'figures/S7']);
    exportgraphics(gcf,[num2str(toppID(t)) '_map.png'],'Resolution',300);

    %% Clear

    clear ax* c* h* m M *LIMS
    clear ans

    close gcf

end