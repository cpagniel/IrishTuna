%% figure_13
% Sub-function of Irish_Tuna.m; plots fish trajectories, eddy centers, ADT
% and EKE in Med hotspot

ind.AC = ismember(dates.AC,dates.META(META.Region == 5));
ind.CC = ismember(dates.CC,dates.META(META.Region == 5));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Fish Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% MM = unique(month(META.Date));
% cmap = [0.122,0.122,1; 0,0.773,1; 0.149,0.451,0; 0.298,0.902,0;...
%     0.914,1,0.745; 1,1,0; 1,0.666,0; 1,0,0; 0.659,0,0; 0.8,0.745,0.639;...
%     0.663,0,0.902; 1,1,1];
%
% for i = 1:length(MM)
%     m_plot(tmp.lon(MM(i) == month(tmp.date)),tmp.lat(MM(i) == month(tmp.date)),...
%         'ko','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','k','MarkerSize',5);
% end

m_plot(META.Longitude(META.Region == 5),META.Latitude(META.Region == 5),'ko','MarkerFaceColor','y','MarkerSize',4)
clear i

m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.74 .89],1.06,2,'fontsize',14,'ticklength',0.01);

p_global = get(gca,'Position'); p_global(1) = p_global(1) - 0.05; p_global(3) = p_global(3) - 0.05;
set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Med_geolocations.png')

% close gcf

%% Anti-Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

sub_AC = tmp_AC(tmp_AC.Region == 5,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.74 .89],1.06,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Med_anticyclones.png')

% close gcf

%% Cyclone Trajectories

figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

sub_CC = tmp_CC(tmp_CC.Region == 5,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.74 .89],1.06,2,'fontsize',14,'ticklength',0.01);

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Med_cyclones.png')

% close gcf

%% Bathymetry or Bathymetric Gradient

cd([fdir 'data/bathy']);
bathy.z = ncread('SRTM_gradient.nc','z');
bathy.lon = ncread('SRTM_gradient.nc','lon'); bathy.lat = ncread('SRTM_gradient.nc','lat');

figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(linspace(-180,180,length(bathy.lon)),bathy.lat,...
    [bathy.z(1543:end,:); bathy.z(1:1542,:)].'); 
shading flat;

hold on

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.74 .89],1.06,2,'fontsize',14,'ticklength',0.01);

caxis([-0.02 0.08]); colormap(flipud(cmocean('deep'))); 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.02:0.02:0.08;
ylabel(h,'Bathymetric Slope Gradient','FontSize',20);
p = h.Position; p(1) = p(1)+0.005; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Med_bgrad.png')

% close gcf

%% ADT

cd([fdir 'data/SSH']);
SSH.Med.adt = ncread('Med_SSH.nc','adt');
SSH.Med.time = ncread('Med_SSH.nc','time'); SSH.Med.time = datetime(1950,01,01,00,00,00) + days(SSH.Med.time);
SSH.Med.lon = ncread('Med_SSH.nc','longitude'); SSH.Med.lat = ncread('Med_SSH.nc','latitude');

dates.SSH = datetime(year(SSH.Med.time),month(SSH.Med.time),day(SSH.Med.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 5));

figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.Med.lon,SSH.Med.lat,mean(SSH.Med.adt(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.74 .89],1.06,2,'fontsize',14,'ticklength',0.01);

caxis([-0.25 0.25]); cmocean balance; 

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.25:0.05:0.25;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);
p = h.Position; p(1) = p(1)+0.005; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Med_SSH.png')

% close gcf

%% EKE

cd([fdir 'data/SSH']);
SSH.Med.ugosa = ncread('Med_ugosa.nc','ugosa'); SSH.Med.vgosa = ncread('Med_vgosa.nc','vgosa'); 
SSH.Med.lon = ncread('Med_ugosa.nc','longitude'); SSH.Med.lat = ncread('Med_ugosa.nc','latitude');
SSH.Med.time = ncread('Med_ugosa.nc','time'); SSH.Med.time = datetime(1950,01,01,00,00,00) + days(SSH.Med.time);

dates.SSH = datetime(year(SSH.Med.time),month(SSH.Med.time),day(SSH.Med.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 5));

SSH.Med.EKE = (mean(SSH.Med.ugosa(:,:,ind.SSH).^2,3,'omitnan') + mean(SSH.Med.vgosa(:,:,ind.SSH).^2,3,'omitnan'))./2;

figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(SSH.Med.lon,SSH.Med.lat,SSH.Med.EKE.'); shading flat;

hold on

m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

m_gshhs_i('patch',[.7 .7 .7]); 

hold on

m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,48.5,1,'type',2,'linewi',2);
m_ruler([.74 .89],1.06,2,'fontsize',14,'ticklength',0.01);

caxis([0 0.07]); cmocean matter;

h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = 0:0.01:0.07; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',20);
p = h.Position; p(1) = p(1)+0.005; h.Position = p;
clear h p

set(gca,'Position',p_global);

% cd([fdir 'figures']);
% saveas(gcf,'Med_EKE.png')

% close gcf