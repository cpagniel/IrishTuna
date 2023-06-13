%% figure_9
% Sub-function of Irish_Tuna.m; plots fish trajectories, eddy centers, ADT
% and EKE in Coastal Ireland hotspot

ind.AC = ismember(dates.AC,dates.META(META.Region == 2));
ind.CC = ismember(dates.CC,dates.META(META.Region == 2));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Fish Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_plot(META.Longitude(META.Region == 2),META.Latitude(META.Region == 2),'ko','MarkerFaceColor','y','MarkerSize',4)
clear i

m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

p_global = get(gca,'Position'); p_global(1) = p_global(1) - 0.05; p_global(3) = p_global(3);
set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'CI_geolocations.png')

% close gcf

%% Anti-Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

sub_AC = tmp_AC(tmp_AC.Region == 2,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'CI_anticyclones.png')

% close gcf

%% Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

sub_CC = tmp_CC(tmp_CC.Region == 2,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'CI_cyclones.png')

% close gcf

%% Bathymetry or Bathymetric Gradient

cd([fdir 'data/bathy']);
bathy.z = ncread('SRTM_gradient.nc','z');
bathy.lon = ncread('SRTM_gradient.nc','lon'); bathy.lat = ncread('SRTM_gradient.nc','lat');

figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(linspace(-180,180,length(bathy.lon)),bathy.lat,...
    [bathy.z(1543:end,:); bathy.z(1:1542,:)].'); 
shading flat;

hold on

m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([-0.02 0.08]); colormap(flipud(cmocean('deep'))); 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.02:0.02:0.8;
ylabel(h,'Bathymetric Slope Gradient','FontSize',20);
p = h.Position; p(1) = p(1)+0.07; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'CI_bgrad.png')

% close gcf

%% ADT

cd([fdir 'data/SSH']);
SSH.CI.SSH = ncread('CI_SSH.nc','SSH');
SSH.CI.time = ncread('CI_SSH.nc','time'); SSH.CI.time = datetime(1950,01,01,00,00,00) + days(SSH.CI.time);
SSH.CI.lon = ncread('CI_SSH.nc','longitude'); SSH.CI.lat = ncread('CI_SSH.nc','latitude');

dates.SSH = datetime(year(SSH.CI.time),month(SSH.CI.time),day(SSH.CI.time));

ind.SSH = ismember(dates.SSH,dates.META(META.Region == 2));

figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.CI.lon,SSH.CI.lat,mean(SSH.CI.SSH(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([-0.15 0.15]); cmocean balance; 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.15:0.05:0.15;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);
p = h.Position; p(1) = p(1)+0.07; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'CI_SSH.png')

% close gcf

%% EKE

cd([fdir 'data/SSH']);
SSH.CI.ugosa = ncread('CI_SSH.nc','ugosa'); SSH.CI.vgosa = ncread('CI_SSH.nc','vgosa'); 

SSH.CI.EKE = (mean(SSH.CI.ugosa(:,:,ind.SSH).^2,3,'omitnan') + mean(SSH.CI.vgosa(:,:,ind.SSH).^2,3,'omitnan'))./2;

figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.CI.lon,SSH.CI.lat,SSH.CI.EKE.'); shading flat;

hold on

m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([0 0.025]); cmocean matter;

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = 0:0.005:0.025; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',20);
p = h.Position; p(1) = p(1)+0.07; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'CI_EKE.png')

% close gcf