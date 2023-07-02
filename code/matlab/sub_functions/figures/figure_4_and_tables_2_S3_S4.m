%% figure_4_and_tables_2_S3_S4.m
% Sub-function of Irish_Tuna.m; time in mesopelagic (> 200 m) bar graph,
% vs. ADT and map.

%% Mean % Time in Mesopelagic for Each Tag

for i = 1:length(toppID)
    cnt = 0;
    for j = [2 3 4 1 5 0] % each hotspot and outside hotspots
        cnt = cnt + 1;
        meso.stats.mean_per_tag(i,cnt) = mean(sum(roundn(table2array(TAD(TAD.toppID == toppID(i) & TAD.Region == j,9:14))*100,-1),2),'omitnan');
    end
end
clear i
clear j
clear cnt

%% Median % Time in Mesopelagic per Hotspot

meso.stats.median_per_hotspot = median(meso.stats.mean_per_tag,'omitnan');
meso.stats.mad_per_hotspot = mad(meso.stats.mean_per_tag,1);

%% Kruskal-Wallis Test

[~,~,stats] = kruskalwallis(meso.stats.mean_per_tag);
c = multcompare(stats);

meso.stats.p = c(:,[1:2 6]);

clear c
clear stats

close all

%% Figure 4a: Bar graph per hotspot.

figure()

b = bar(meso.stats.median_per_hotspot,'FaceColor','flat');
b.CData = cmap_r;

hold on

errorbar(1:6,meso.stats.median_per_hotspot,[],meso.stats.mad_per_hotspot,'LineStyle','none','Color','k');

set(gca,'FontSize',20);
set(gca,'XTickLabel',{'CI','BoB','WEB','NB','Med','Outside'})
set(gca,"XTickLabelRotation",0);

ylabel('Median % of Time in Mesopelagic','FontSize',22);
xlabel('Hotspot','FontSize',22);

grid on
grid minor

cd([fdir 'figures'])
exportgraphics(gcf,'figure_4a.png','Resolution',300);

close gcf

clear b

%% Bin ADT, EKE and Median Percent Time in Mesopelagic 

% Load ADT and EKE data.
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

% Only keep ADT data on days with a TAD
dates.TAD = unique(TAD.DateTime);
ind = ismember(ADT.NAO.time,dates.TAD);
ADT.NAO.adt = ADT.NAO.adt(:,:,ind);
ADT.NAO.ugosa = ADT.NAO.ugosa(:,:,ind);
ADT.NAO.vgosa = ADT.NAO.vgosa(:,:,ind);
ADT.NAO.time = ADT.NAO.time(ind);

clear ind

% Median time in mesopelagic in 1 x 1 deg bins.
binned.LONedges = -80:1:40;
binned.LATedges = 20:1:70;

[binned.meso.mz,binned.LONmid,binned.LATmid] = twodmed(TAD.Longitude,TAD.Latitude,sum(table2array(TAD(:,9:14)),2).*100,binned.LONedges,binned.LATedges);

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
meso.meso = binned.meso.mz(:);
meso.adt = binned.adt.mz(:);
meso.eke = binned.eke.mz(:);

[meso.lon,meso.lat] = meshgrid(binned.LONmid,binned.LATmid);
meso.lon = meso.lon(:); meso.lat = meso.lat(:);

meso.adt = meso.adt(~isnan(meso.meso));
meso.eke = meso.eke(~isnan(meso.meso));
meso.lon = meso.lon(~isnan(meso.meso));
meso.lat = meso.lat(~isnan(meso.meso));
meso.meso = meso.meso(~isnan(meso.meso));

meso.region = zeros(length(meso.lat),1);
meso.region(inpolygon(meso.lon,meso.lat,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
meso.region(inpolygon(meso.lon,meso.lat,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
meso.region(inpolygon(meso.lon,meso.lat,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
meso.region(inpolygon(meso.lon,meso.lat,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
meso.region(inpolygon(meso.lon,meso.lat,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

%% Figure 4b: median ADT vs. median percent time in mesopelagic

figure()
h(6) = scatter(meso.adt(meso.region == 0),meso.meso(meso.region == 0),30,cmap_r(6,:),'filled');
hold on
cnt = 0;
for i = [2 3 4 1 5]
    cnt = cnt + 1;
    h(cnt) = scatter(meso.adt(meso.region == i),meso.meso(meso.region == i),30,cmap_r(cnt,:),'filled');
    hold on
end
scatter(meso.adt(meso.region == 3),meso.meso(meso.region == 3),30,cmap_r(2,:),'filled')
clear i
clear cnt

set(gca,'FontSize',16);

box on
grid on
grid minor

xlabel('Median Absolute Dynamic Topography (m)','FontSize',20);
ylabel('Median % Time in Mesopelagic','FontSize',20);

xlim([-1 1]);
axis square

legend(h,{'CI','BoB','WEB','NB','Med','Outside'},'Location','northwest','NumColumns',1)

cd([fdir 'figures'])
exportgraphics(gcf,'figure_4b.png','Resolution',300);

close gcf

clear h

%% Spearman's Rank Correlation Coefficient

cnt = 0;
for i = [2 3 4 1 5 0]
    cnt = cnt + 1;
    [meso.stats.pearson.rho(cnt),meso.stats.pearson.p(cnt)] = corr(meso.adt(meso.region == i),meso.meso(meso.region == i),"type","Spearman");
end
clear i

[meso.stats.pearson.rho(cnt+1),meso.stats.pearson.p(cnt+1)] = corr(meso.adt,meso.meso,"type","Spearman");
clear cnt

%% Figure 4c: Map of percent time in mesopelagic

% Create figure and axes for bathymetry.
figure('Position',[476 334 716 532]);

% Set projection of map.
LATLIMS = [20 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

% Bin SSM Positions
m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.meso.mz);

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
cmap = getPyPlot_cMap('gnuplot2_r',11);
colormap(cmap(2:end,:));
y = ylabel(h,'Median % Time in Mesopelagic','FontSize',16);
caxis([0 10]);
h.Ticks = 0:5:10;

set(gca,'Position',p);
y.Position(1) = y.Position(1) - 0.2;

clear p

% Save
cd([fdir 'figures']);
exportgraphics(gcf,'figure_4c.png','Resolution',300)

%%Clear
clear h*
clear y
clear ans

close gcf