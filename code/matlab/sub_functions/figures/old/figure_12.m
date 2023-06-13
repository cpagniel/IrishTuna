%% figure_12
% Sub-function of Irish_Tuna.m; plots fish trajectories, eddy centers, ADT
% and EKE in Newfoundland Basin hotspot

ind.AC = ismember(dates.AC,dates.META(META.Region == 1));
ind.CC = ismember(dates.CC,dates.META(META.Region == 1));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Fish Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

m_plot(META.Longitude(META.Region == 1),META.Latitude(META.Region == 1),'ko','MarkerFaceColor','y','MarkerSize',4)
clear i

m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

p_global = get(gca,'Position'); p_global(1) = p_global(1) - 0.05; p_global(3) = p_global(3) - 0.05;
set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'NB_geolocations.png')

% close gcf

clear ans

%% Anti-Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

sub_AC = tmp_AC(tmp_AC.Region == 1,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'NB_anticyclones.png')

% close gcf

clear ans

%% Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

sub_CC = tmp_CC(tmp_CC.Region == 1,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'NB_cyclones.png')

% close gcf

%% Bathymetry or Bathymetric Slope

cd([fdir 'data/bathy']);
bathy.z = ncread('SRTM_gradient.nc','z');
bathy.lon = ncread('SRTM_gradient.nc','lon'); bathy.lat = ncread('SRTM_gradient.nc','lat');

figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(linspace(-180,180,length(bathy.lon)),bathy.lat,...
    [bathy.z(1543:end,:); bathy.z(1:1542,:)].'); 
shading flat;

hold on

m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([-0.02 0.08]); colormap(flipud(cmocean('deep'))); 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.02:0.02:0.08;
ylabel(h,'Bathymetric Slope Gradient','FontSize',20);
p = h.Position; p(1) = p(1)+0.01; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'NB_bgrad.png')

% close gcf

%% ADT

cd([fdir 'data/SSH']);
SSH.NB.adt = ncread('NB_SSH.nc','adt');
SSH.NB.time = ncread('NB_SSH.nc','time'); SSH.NB.time = datetime(1950,01,01,00,00,00) + days(SSH.NB.time);
SSH.NB.lon = ncread('NB_SSH.nc','longitude'); SSH.NB.lat = ncread('NB_SSH.nc','latitude');

dates.SSH = datetime(year(SSH.NB.time),month(SSH.NB.time),day(SSH.NB.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 1));

figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.NB.lon,SSH.NB.lat,mean(SSH.NB.adt(:,:,ind.SSH),3).'); shading flat;

hold on

m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([-0.7 0.7]); cmocean balance; 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.7:0.2:0.7;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);
p = h.Position; p(1) = p(1)+0.01; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'NB_SSH.png')

% close gcf

%% EKE

cd([fdir 'data/SSH']);
SSH.NB.ugosa = ncread('NB_SSH.nc','ugosa'); SSH.NB.vgosa = ncread('NB_SSH.nc','vgosa'); 

SSH.NB.EKE = (mean(SSH.NB.ugosa(:,:,ind.SSH).^2,3) + mean(SSH.NB.vgosa(:,:,ind.SSH).^2,3))./2;

figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.NB.lon,SSH.NB.lat,SSH.NB.EKE.'); shading flat;

hold on

m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([0 0.32]); cmocean matter;

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = 0:0.04:0.32; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',20);
p = h.Position; p(1) = p(1)+0.01; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'NB_EKE.png')

% close gcf