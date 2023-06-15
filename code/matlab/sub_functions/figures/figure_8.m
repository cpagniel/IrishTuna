%% figure_8
% Sub-function of Irish_Tuna.m; plots zoomed in bin map, ADT
% and EKE in Newfoundland Basin hotspot

%% (a) Bin Map

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bin map
binned.LONedges = -80:1:40;
binned.LATedges = 20:1:70;

[binned.N,binned.LONmid,binned.LATmid] = twodhist(META.Longitude,META.Latitude,binned.LONedges,binned.LATedges);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.N); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

% outline
m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
h = colorbar('FontSize',20); 
colormap(flipud(hot(1500)));
ylabel(h,'Number of Daily Geolocations','FontSize',22);
caxis([0 75]);
h.Ticks = 0:25:75;

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_3a.png','Resolution',300)

close gcf

clear h
clear ans
clear p_global
clear binned

%% (b) EKE

% calculate EKE
cd([fdir 'data/SSH']);
ADT.NB.ugosa = ncread('NB_SSH.nc','ugosa'); ADT.NB.vgosa = ncread('NB_SSH.nc','vgosa'); 

ADT.NB.EKE = (mean(ADT.NB.ugosa(:,:,ind.SSH).^2,3) + mean(ADT.NB.vgosa(:,:,ind.SSH).^2,3))./2;

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot EKE
m_pcolor(ADT.NB.lon,ADT.NB.lat,ADT.NB.EKE.'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

% outline
m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([0 0.32]); cmocean matter;
h = colorbar('Fontsize',20); 
h.FontSize = 18; h.Ticks = 0:0.04:0.32; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',22);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_3b.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% (c) ADT

% load ADT
cd([fdir 'data/SSH']);
ADT.NB.adt = ncread('NB_SSH.nc','adt');
ADT.NB.time = ncread('NB_SSH.nc','time'); ADT.NB.time = datetime(1950,01,01,00,00,00) + days(ADT.NB.time);
ADT.NB.lon = ncread('NB_SSH.nc','longitude'); ADT.NB.lat = ncread('NB_SSH.nc','latitude');

dates.SSH = datetime(year(ADT.NB.time),month(ADT.NB.time),day(ADT.NB.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 1));

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot ADT
m_pcolor(ADT.NB.lon,ADT.NB.lat,mean(ADT.NB.adt(:,:,ind.SSH),3).'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

% outline
m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([-0.7 0.7]); 
cmocean balance; 
h = colorbar('FontSize',20); 
h.FontSize = 18; h.Ticks = -0.7:0.2:0.7;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',22);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_3c.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global
clear dates

%% (d) Mean Daily Maximum Diving Depth

% compute max depth
max_depth = META.MaxDepth24h;
b = cellfun(@num2str,max_depth,'un',0); max_depth(ismember(b,'NA')) = {'NaN'};
max_depth = cell2mat(cellfun(@str2num,max_depth,'un',0));
clear b

META.MaxDepth = max_depth;
clear max_depth

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bin map
binned.LONedges = -80:1:40;
binned.LATedges = 20:1:70;

[binned.mz,binned.LONmid,binned.LATmid,~,binned.stdz] = twodstats(META.Longitude,META.Latitude,META.MaxDepth,binned.LONedges,binned.LATedges);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.mz);

hold on

% bathymetry
m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

% outline
m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
h = colorbar('FontSize',20); 
cmap = colormap('parula'); 
colormap(flipud(cmap)); 
ylabel(h,'Mean Daily Maximum Depth (m)','FontSize',22);
caxis([0 400]);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_3d.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global
clear binned