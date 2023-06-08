%% figure_2.m
% Sub-function of Irish_Tuna.m; plots SSM tracks of all tags in each season
% colored by month.

%% Loop through each season

for i = 1:length(unique(META.Season))

    %% Create figure.

    figure('Position',[476 362 706 504]);

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

    %% Set colormap by month.

    MM = unique(month(META.Date));
    %cmap = getPyPlot_cMap('Paired',12);
    cmap = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
        0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
        0.663,0,0.902; 1,1,1];
    cmap_v2 = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
        0.914,1,0.745; 0.9843,0.6039,0.6000; 1,0,0; 0.659,0,0;  0.9365,0.4000,0.0681; 1,0.666,0; 0.9943,0.8627,0.7294;...
        0.6510,0.8078,0.8902];

    %% Plot SSM positions of tuna colored by month.

    % Plot each tag.
    for j = 1:length(MM)
        if i == 1 && (j == 12 || j == 1 || j == 2)
            m(j) = m_plot(META.Longitude(MM(j) == month(META.Date)),...
                META.Latitude(MM(j) == month(META.Date)),...
                'ko','MarkerFaceColor',cmap_v2(j,:),'MarkerEdgeColor','k','MarkerSize',3);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap_v2(j,:),'MarkerEdgeColor','k','MarkerSize',3);
        end
        if i == 2 && (j == 3 || j == 4 || j == 5)
            m(j) = m_plot(META.Longitude(MM(j) == month(META.Date)),...
                META.Latitude(MM(j) == month(META.Date)),...
                'ko','MarkerFaceColor',cmap_v2(j,:),'MarkerEdgeColor','k','MarkerSize',3);
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap_v2(j,:),'MarkerEdgeColor','k','MarkerSize',3);
        end

        if i == 3 && (j == 6 || j == 7 || j == 8)
            m(j) = m_plot(META.Longitude(MM(j) == month(META.Date)),...
                META.Latitude(MM(j) == month(META.Date)),...
                'ko','MarkerFaceColor',cmap_v2(j,:),'MarkerSize',3,'MarkerEdgeColor','k');
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap_v2(j,:),'MarkerEdgeColor','k','MarkerSize',3);
        end

        if i == 4 && (j == 9 || j == 10 || j == 11)
            m(j) = m_plot(META.Longitude(MM(j) == month(META.Date)),...
                META.Latitude(MM(j) == month(META.Date)),...
                'ko','MarkerFaceColor',cmap_v2(j,:),'MarkerSize',3,'MarkerEdgeColor','k');
            hold on
        else
            m(j) = m_plot(-100,100,'o','MarkerFaceColor',cmap_v2(j,:),'MarkerEdgeColor','k','MarkerSize',3);
        end
    end
    clear j

    %% Plot ICCAT regions.

    m_line([-45 -45],[20 70],'linewi',2,'color','k','linestyle','--')

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

    %% Add title.

    if i == 1
        title('Winter','FontSize',26);
    elseif i == 2
        title('Spring','FontSize',26);
    elseif i == 3
        title('Summer','FontSize',26);
    elseif i == 4
        title('Fall','FontSize',26);
    end

    %% Add Legend

%     [~,icon] = legend(m,{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'FontSize',14,'Location','bestoutside');
%     icons = findobj(icon, 'type', 'line');
%     set(icons,'MarkerSize',12);
%     clear MM
%     clear icon*

    %% Save figure.

    cd([fdir 'figures']);
    exportgraphics(gcf,['figure_2_' num2str(i) '.png'],'Resolution',300);

    %% Clear

    clear ax* c* h* m M *LIMS
    clear ans

    close gcf

end

clear i
clear tmp
clear MM