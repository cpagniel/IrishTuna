%% figure_10
% Sub-function of Irish_Tuna.m; plots fish trajectories, eddy centers, ADT
% and EKE in Bay of Biscay hotspot

ind.AC = ismember(dates.AC,dates.META(META.Region == 3));
ind.CC = ismember(dates.CC,dates.META(META.Region == 3));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Fish Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = [-9.2 0.2];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_plot(META.Longitude(META.Region == 3),META.Latitude(META.Region == 3),'ko','MarkerFaceColor','y','MarkerSize',4)
clear i

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

p_global = get(gca,'Position'); p_global(1) = p_global(1) - 0.05; p_global(3) = p_global(3) - 0.05;
set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Biscay_geolocations.png')

% close gcf

%% Anti-Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = [-9.2 0.2];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

sub_AC = tmp_AC(tmp_AC.Region == 3,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Biscay_anticyclones.png')

% close gcf

%% Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = [-9.2 0.2];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

sub_CC = tmp_CC(tmp_CC.Region == 3,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Biscay_cyclones.png')

% close gcf

%% Bathymetry or Bathymetric Gradient

cd([fdir 'data/bathy']);
bathy.z = ncread('SRTM_gradient.nc','z');
bathy.lon = ncread('SRTM_gradient.nc','lon'); bathy.lat = ncread('SRTM_gradient.nc','lat');

figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = [-9.2 0.2];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(linspace(-180,180,length(bathy.lon)),bathy.lat,...
    [bathy.z(1543:end,:); bathy.z(1:1542,:)].'); 
shading flat;

hold on

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([-0.02 0.08]); colormap(flipud(cmocean('deep'))); 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.02:0.02:0.08;
ylabel(h,'Bathymetric Slope Gradient','FontSize',20);
p = h.Position; p(1) = p(1)+0.01; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Biscay_bgrad.png')

% close gcf

%% ADT

cd([fdir 'data/SSH']);
SSH.Biscay.SSH = ncread('Biscay_SSH.nc','SSH');
SSH.Biscay.time = ncread('Biscay_SSH.nc','time'); SSH.Biscay.time = datetime(1950,01,01,00,00,00) + days(SSH.Biscay.time);
SSH.Biscay.lon = ncread('Biscay_SSH.nc','longitude'); SSH.Biscay.lat = ncread('Biscay_SSH.nc','latitude');

dates.SSH = datetime(year(SSH.Biscay.time),month(SSH.Biscay.time),day(SSH.Biscay.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 3));

figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = [-9.2 0.2];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.Biscay.lon,SSH.Biscay.lat,mean(SSH.Biscay.SSH(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([-0.15 0.15]); cmocean balance; 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.15:0.05:0.15;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);
p = h.Position; p(1) = p(1)+0.01; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Biscay_SSH.png')

% close gcf

%% EKE

cd([fdir 'data/SSH']);
SSH.Biscay.ugosa = ncread('Biscay_SSH.nc','ugosa'); SSH.Biscay.vgosa = ncread('Biscay_SSH.nc','vgosa'); 

SSH.Biscay.EKE = (mean(SSH.Biscay.ugosa(:,:,ind.SSH).^2,3,'omitnan') + mean(SSH.Biscay.vgosa(:,:,ind.SSH).^2,3,'omitnan'))./2;

figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = [-9.2 0.2];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.Biscay.lon,SSH.Biscay.lat,SSH.Biscay.EKE.'); shading flat;

hold on

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

caxis([0 0.01]); cmocean matter;

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = 0:0.005:0.02; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',20);
p = h.Position; p(1) = p(1)+0.01; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Biscay_EKE.png')

% close gcf