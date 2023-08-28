%% figure_2.m
% Sub-function of Irish_Tuna.m; plots bin map of all tags in each season.

%% Loop through each season

for i = 1:length(unique(META.Season))

    %% Create figure.

    figure('Position',[476 362 706 504]);

    %% Set projection of map.

    LATLIMS = [20 70]; LONLIMS = [-80 40];
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

    %% Bin SSM Positions

    binned.LONedges = -80:1:40;
    binned.LATedges = 20:1:70;

    [binned.N,binned.LONmid,binned.LATmid] = twodhist(META.Longitude(META.Season == i),META.Latitude(META.Season == i),...
        binned.LONedges,binned.LATedges);

    m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.N);

    hold on

    %% Plot land.

    m_gshhs_i('patch',[.7 .7 .7]);

    hold on

    %% Plot ICCAT regions.

    m_line([-45 -45],[20 70],'linewi',2,'color','k','linestyle','--')

    %% Plot ocean regions.

    m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.CI.bndry(1,:),regions.CI.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');

    m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');

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

    %% Add colorbar

    % p = get(gca,'Position');

    % h = colorbar('FontSize',16);
    colormap(flipud(hot(1500)));
    % ylabel(h,'Number of Daily Geolocations','FontSize',16);
    caxis([0 50]);
    % h.Ticks = 0:10:50;

    % set(gca,'Position',p);

    % clear p

    %% Save figure.

    cd([fdir 'figures']);
    exportgraphics(gcf,['figure_2_' num2str(i) '.png'],'Resolution',300);

    %% Clear

    clear ax* c* h* *LIMS
    clear ans

    close gcf

end

clear i
clear tmp
