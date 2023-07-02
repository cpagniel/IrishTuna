%% figure_5_and_tables_2_S5_S6.m
% Sub-function of Irish_Tuna.m; max daily diving depth bar graph,
% vs. ADT and map.

%% Max Daily Diving Depth

% compute max depth
max_depth = META.MaxDepth24h;
b = cellfun(@num2str,max_depth,'un',0); max_depth(ismember(b,'NA')) = {'NaN'};
max_depth = cell2mat(cellfun(@str2num,max_depth,'un',0));
clear b

META.MaxDepth = max_depth;

META = removevars(META, 'MaxDepth24h');
clear max_depth

%% Mean Max Daily Diving Depth for Each Tag

for i = 1:length(toppID)
    cnt = 0;
    for j = [2 3 4 1 5 0] % each hotspot and outside hotspots
        cnt = cnt + 1;
        max_d.stats.mean_per_tag(i,cnt) = mean(META.MaxDepth(META.TOPPid == toppID(i) & META.Region == j & isfinite(META.MaxDepth)),'omitnan');
    end
end
clear i
clear j
clear cnt

%% Median Daily Max Diving Depth per Hotspot

max_d.stats.median_per_hotspot = median(max_d.stats.mean_per_tag,'omitnan');
max_d.stats.mad_per_hotspot = mad(max_d.stats.mean_per_tag,1);

%% Max Daily Max Diving Depth in Each Hotsopot

cnt = 0;
for j = [2 3 4 1 5 0] % each hotspot and outside hotspots
    cnt = cnt + 1;
    max_d.stats.max(cnt) = max(META.MaxDepth(META.Region == j & isfinite(META.MaxDepth)));
end
clear j
clear cnt

%% Kruskal-Wallis Test

[~,~,stats] = kruskalwallis(max_d.stats.mean_per_tag);
c = multcompare(stats);

max_d.stats.p = c(:,[1:2 6]);

clear c
clear stats

close all

%% Figure 5a: Bar graph per hotspot.

figure()

b = bar(max_d.stats.median_per_hotspot,'FaceColor','flat');
b.CData = cmap_r;

hold on

errorbar(1:6,max_d.stats.median_per_hotspot,[],max_d.stats.mad_per_hotspot,'LineStyle','none','Color','k');

set(gca,'FontSize',20);
set(gca,'XTickLabel',{'CI','BoB','WEB','NB','Med','Outside'})
set(gca,"XTickLabelRotation",0);

ylabel('Median Daily Maximum Depth (m)','FontSize',22);
xlabel('Hotspot','FontSize',22);

grid on
grid minor

cd([fdir 'figures'])
exportgraphics(gcf,'figure_5a.png','Resolution',300);

close gcf

clear b

%% Bin ADT, EKE and Daily Maximum Diving Depth

% Load ADT data.
cd([fdir 'data/SSH/NAO']);
files = dir('NAO*');
ADT.NAO.adt = [];
ADT.NAO.ugosa = [];
ADT.NAO.vgosa = [];
ADT.NAO.time = [];
for i = 1:length(files)
    tmp.adt = ncread(files(i).name,'adt');
    tmp.ugosa = ncread(files(i).name,'ugosa');
    tmp.vgosa = ncread(files(i).name,'vgosa');
    tmp.time = ncread(files(i).name,'time'); tmp.time = datetime(1950,01,01,00,00,00) + days(tmp.time);

    ind = ismember(tmp.time,META.Date);

    tmp.adt = tmp.adt(:,:,ind);
    tmp.ugosa = tmp.ugosa(:,:,ind);
    tmp.vgosa = tmp.vgosa(:,:,ind);
    tmp.time = tmp.time(ind);

    if i == 1
        ADT.NAO.lon = ncread(files(i).name,'longitude'); ADT.NAO.lat = ncread(files(i).name,'latitude');
    end

    ADT.NAO.adt = cat(3,ADT.NAO.adt,tmp.adt);
    ADT.NAO.ugosa = cat(3,ADT.NAO.ugosa,tmp.ugosa);
    ADT.NAO.vgosa = cat(3,ADT.NAO.vgosa,tmp.vgosa);
    ADT.NAO.time = [ADT.NAO.time; tmp.time];

    clear tmp
    clear ind
end
clear i
clear files

% Only keep ADT data on days with a Daily Maximum Diving Depth
dates.max_d = unique(META.Date(isfinite(META.MaxDepth)));
ind = ismember(ADT.NAO.time,dates.max_d);
ADT.NAO.adt = ADT.NAO.adt(:,:,ind);
ADT.NAO.ugosa = ADT.NAO.ugosa(:,:,ind);
ADT.NAO.vgosa = ADT.NAO.vgosa(:,:,ind);
ADT.NAO.time = ADT.NAO.time(ind);

clear ind

% Median daily maximum diving depth in 1 x 1 deg bins.
binned.LONedges = -80:1:40;
binned.LATedges = 20:1:70;

[binned.max_d.mz,binned.LONmid,binned.LATmid] = twodmed(META.Longitude(isfinite(META.MaxDepth)),...
    META.Latitude(isfinite(META.MaxDepth)),META.MaxDepth(isfinite(META.MaxDepth)),binned.LONedges,binned.LATedges);

% Median ADT in 1 x 1 deg bins
ADT.NAO.median_adt = median(ADT.NAO.adt,3,'omitnan'); % median ADT over all time when ABT are present

[tmp.lon,tmp.lat] = meshgrid(ADT.NAO.lon,ADT.NAO.lat);
tmp.adt = ADT.NAO.median_adt.';

[binned.adt.mz,binned.LONmid,binned.LATmid] = twodmed(tmp.lon(:),tmp.lat(:),tmp.adt(:),binned.LONedges,binned.LATedges);

% Median EKE in 1 x1 deg bins
ADT.NAO.median_EKE = median(ADT.NAO.ugosa.^2 + ADT.NAO.vgosa.^2,3,'omitnan')./2;

tmp.eke = ADT.NAO.median_EKE.';

[binned.eke.mz,binned.LONmid,binned.LATmid] = twodmed(tmp.lon(:),tmp.lat(:),tmp.eke(:),binned.LONedges,binned.LATedges);

clear tmp

% Determine Region of Observation
max_d.max_d = binned.max_d.mz(:);
max_d.adt = binned.adt.mz(:);
max_d.eke = binned.eke.mz(:);

[max_d.lon,max_d.lat] = meshgrid(binned.LONmid,binned.LATmid);
max_d.lon = max_d.lon(:); max_d.lat = max_d.lat(:);

max_d.adt = max_d.adt(~isnan(max_d.max_d));
max_d.eke = max_d.eke(~isnan(max_d.max_d));
max_d.lon = max_d.lon(~isnan(max_d.max_d));
max_d.lat = max_d.lat(~isnan(max_d.max_d));
max_d.max_d = max_d.max_d(~isnan(max_d.max_d));

max_d.region = zeros(length(max_d.lat),1);
max_d.region(inpolygon(max_d.lon,max_d.lat,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
max_d.region(inpolygon(max_d.lon,max_d.lat,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
max_d.region(inpolygon(max_d.lon,max_d.lat,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
max_d.region(inpolygon(max_d.lon,max_d.lat,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
max_d.region(inpolygon(max_d.lon,max_d.lat,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

%% Figure 5b: median ADT vs. median daily maximum diving depth

% Plot ADT vs. % Daily Max Depth
figure()
h(6) = scatter(max_d.adt(max_d.region == 0),max_d.max_d(max_d.region == 0),30,cmap_r(6,:),'filled');
hold on
cnt = 0;
for i = [2 3 4 1 5]
    cnt = cnt + 1;
    h(cnt) = scatter(max_d.adt(max_d.region == i),max_d.max_d(max_d.region == i),30,cmap_r(cnt,:),'filled');
    hold on
end
scatter(max_d.adt(max_d.region == 3),max_d.max_d(max_d.region == 3),30,cmap_r(2,:),'filled')
clear i
clear cnt

set(gca,'FontSize',16);

box on
grid on
grid minor

xlabel('Median Absolute Dynamic Topography (m)','FontSize',20);
ylabel('Median Daily Maximum Depth (m)','FontSize',20);

xlim([-1 1]);
axis square

legend(h,{'CI','BoB','WEB','NB','Med','Outside'},'Location','northwest','NumColumns',1)

cd([fdir 'figures'])
exportgraphics(gcf,'figure_5b.png','Resolution',300);

close gcf

clear h

%% Spearman's Rank Correlation Coefficient

cnt = 0;
for i = [2 3 4 1 5 0]
    cnt = cnt + 1;
    [max_d.stats.pearson.rho(cnt),max_d.stats.pearson.p(cnt)] = corr(max_d.adt(max_d.region == i),max_d.max_d(max_d.region == i),"type","Spearman");
end
clear i

[max_d.stats.pearson.rho(cnt+1),max_d.stats.pearson.p(cnt+1)] = corr(max_d.adt,max_d.max_d,"type","Spearman");
clear cnt

%% Figure 5c: Map of daily maximum diving depth

% Create figure and axes for bathymetry.
figure('Position',[476 334 716 532]);

% Set projection of map.
LATLIMS = [20 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

% Bin SSM Positions
m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.max_d.mz);

hold on

% Plot land.
m_gshhs_i('patch',[.7 .7 .7]);

hold on

% Plot ICCAT regions.
m_line([-45 -45],[20 70],'linewi',2,'color','k','linestyle','--')

% Plot ocean regions.
m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.CI.bndry(1,:),regions.CI.bndry(2,:),'linewi',2,'color','k');
m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');
m_line(regions.WEB.bndry(1,:),regions.WEB.bndry(2,:),'linewi',2,'color','k');
m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');

% Create figure border.
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

% Add north arrow and scale bar.
m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

% Add colorbar
p = get(gca,'Position');

h = colorbar('FontSize',16);
cmap = getPyPlot_cMap('gnuplot2_r');
colormap(cmap(5:end-3,:));
ylabel(h,'Median Daily Maximum Depth (m)','FontSize',16);
caxis([0 400]);

p(1) = p(1) - 0.03;
set(gca,'Position',p);

clear p

% Save
cd([fdir 'figures']);
exportgraphics(gcf,'figure_5c.png','Resolution',300)

%%Clear
clear h*
clear ans

close gcf