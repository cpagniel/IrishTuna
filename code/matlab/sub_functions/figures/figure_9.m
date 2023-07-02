%% figure_9
% Sub-function of Irish_Tuna.m; plot ADT and EKE for WEB, CI, BoB and Med.

%% West European Basin - ADT

cd([fdir 'data/SSH']);
ADT.WEB.adt = ncread('WEB_SSH.nc','adt');
ADT.WEB.time = ncread('WEB_SSH.nc','time'); ADT.WEB.time = datetime(1950,01,01,00,00,00) + days(ADT.WEB.time);
ADT.WEB.lon = ncread('WEB_SSH.nc','longitude'); ADT.WEB.lat = ncread('WEB_SSH.nc','latitude');

dates.SSH = datetime(year(ADT.WEB.time),month(ADT.WEB.time),day(ADT.WEB.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 4));

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.WEB.lat1; LONLIMS = regions.WEB.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot ADT
m_pcolor(ADT.WEB.lon,ADT.WEB.lat,mean(ADT.WEB.adt(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([-0.15 0.15]);
cmocean balance; 
h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.15:0.05:0.15;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9a.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% West European Basin - EKE

% calculate EKE
cd([fdir 'data/SSH']);
ADT.WEB.ugosa = ncread('WEB_SSH.nc','ugosa'); ADT.WEB.vgosa = ncread('WEB_SSH.nc','vgosa'); 

ADT.WEB.EKE = mean(ADT.WEB.ugosa(:,:,ind.SSH).^2 + ADT.WEB.vgosa(:,:,ind.SSH).^2,3)./2;

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.WEB.lat1; LONLIMS = regions.WEB.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot EKE
m_pcolor(ADT.WEB.lon,ADT.WEB.lat,ADT.WEB.EKE.'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([0 0.025]); cmocean matter;
h = colorbar('Fontsize',20); 
h.FontSize = 18; h.Ticks = 0:0.005:0.025; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',22);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9b.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% Coastal Ireland - ADT

cd([fdir 'data/SSH']);
ADT.CI.adt = ncread('CI_SSH.nc','adt');
ADT.CI.time = ncread('CI_SSH.nc','time'); ADT.CI.time = datetime(1950,01,01,00,00,00) + days(ADT.CI.time);
ADT.CI.lon = ncread('CI_SSH.nc','longitude'); ADT.CI.lat = ncread('CI_SSH.nc','latitude');

dates.SSH = datetime(year(ADT.CI.time),month(ADT.CI.time),day(ADT.CI.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 2));

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot ADT
m_pcolor(ADT.CI.lon,ADT.CI.lat,mean(ADT.CI.adt(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([-0.15 0.15]); 
cmocean balance; 
h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.15:0.05:0.15;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9c.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% Coastal Ireland - EKE

% calculate EKE
cd([fdir 'data/SSH']);
ADT.CI.ugosa = ncread('CI_SSH.nc','ugosa'); ADT.CI.vgosa = ncread('CI_SSH.nc','vgosa'); 

ADT.CI.EKE = mean(ADT.CI.ugosa(:,:,ind.SSH).^2 + ADT.CI.vgosa(:,:,ind.SSH).^2,3)./2;

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = [regions.CI.lon2(1) regions.CI.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot EKE
m_pcolor(ADT.CI.lon,ADT.CI.lat,ADT.CI.EKE.'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_patch([regions.CI.lon2 regions.CI.lon2(1) regions.CI.lon2(1)],...
[regions.CI.lat1(1) regions.CI.lat1(1) regions.CI.lat2(1) regions.CI.lat1(1)],'w');

m_plot(regions.CI.lon2,[regions.CI.lat2(1) regions.CI.lat1(1)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([0 0.025]); cmocean matter;
h = colorbar('Fontsize',20); 
h.FontSize = 18; h.Ticks = 0:0.005:0.025; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',22);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9d.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% Bay of Biscay - ADT

cd([fdir 'data/SSH']);
ADT.BoB.adt = ncread('BoB_SSH.nc','adt');
ADT.BoB.time = ncread('BoB_SSH.nc','time'); ADT.BoB.time = datetime(1950,01,01,00,00,00) + days(ADT.BoB.time);
ADT.BoB.lon = ncread('BoB_SSH.nc','longitude'); ADT.BoB.lat = ncread('BoB_SSH.nc','latitude');

dates.SSH = datetime(year(ADT.BoB.time),month(ADT.BoB.time),day(ADT.BoB.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 3));

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = regions.Biscay.lon;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot ADT
m_pcolor(ADT.BoB.lon,ADT.BoB.lat,mean(ADT.BoB.adt(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

% bathymetry
m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([-0.15 0.15]);
cmocean balance; 
h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.15:0.05:0.15;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9e.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% Bay of Biscay - EKE

% calculate EKE
cd([fdir 'data/SSH']);
ADT.BoB.ugosa = ncread('BoB_SSH.nc','ugosa'); ADT.BoB.vgosa = ncread('BoB_SSH.nc','vgosa'); 

ADT.BoB.EKE = mean(ADT.BoB.ugosa(:,:,ind.SSH).^2 + ADT.BoB.vgosa(:,:,ind.SSH).^2,3)./2;

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = regions.Biscay.lon;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot EKE
m_pcolor(ADT.BoB.lon,ADT.BoB.lat,ADT.BoB.EKE.'); shading flat;

hold on

% bathymetry
m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([0 0.025]); cmocean matter;
h = colorbar('Fontsize',20); 
h.FontSize = 18; h.Ticks = 0:0.005:0.025; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',22);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9f.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% Mediterranean Sea - ADT

cd([fdir 'data/SSH']);
ADT.Med.adt = ncread('Med_SSH.nc','adt');
ADT.Med.time = ncread('Med_SSH.nc','time'); ADT.Med.time = datetime(1950,01,01,00,00,00) + days(ADT.Med.time);
ADT.Med.lon = ncread('Med_SSH.nc','longitude'); ADT.Med.lat = ncread('Med_SSH.nc','latitude');

dates.SSH = datetime(year(ADT.Med.time),month(ADT.Med.time),day(ADT.Med.time));
ind.SSH = ismember(dates.SSH,dates.META(META.Region == 4));

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot ADT
m_pcolor(ADT.Med.lon,ADT.Med.lat,mean(ADT.Med.adt(:,:,ind.SSH),3,'omitnan').'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([-0.25 0.25]);
cmocean balance; 
h = colorbar('eastoutside'); 
h.FontSize = 18; h.Ticks = -0.25:0.05:0.25;
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005 - 0.02;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
p_global(1) = p_global(1) - 0.02;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9g.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global

%% Mediterranean Sea - EKE

% calculate EKE
cd([fdir 'data/SSH']);
ADT.Med.ugosa = ncread('Med_ugosa_vgosa.nc','ugosa'); ADT.Med.vgosa = ncread('Med_ugosa_vgosa.nc','vgosa'); 

ADT.Med.EKE = mean(ADT.Med.ugosa(:,:,ind.SSH).^2 + ADT.Med.vgosa(:,:,ind.SSH).^2,3)./2;

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% plot EKE
m_pcolor(ADT.Med.lon,ADT.Med.lat,ADT.Med.EKE.'); shading flat;

hold on

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_patch([regions.Med.lon2(1) 5 regions.Med.lon2(1) regions.Med.lon2(1)],...
[regions.Med.lat2(2) regions.Med.lat1(2) regions.Med.lat1(2) regions.Med.lat2(2)],'w');

m_plot([regions.Med.lon2(1) 5],[regions.Med.lat2(2) regions.Med.lat1(2)],'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

% colormap
caxis([0 0.07]); cmocean matter;
h = colorbar('Fontsize',20); 
h.FontSize = 18; h.Ticks = 0:0.01:0.07; 
ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',22);

% adjust position of elements
p_global = get(gca,'Position');
h.Position(1) = h.Position(1) + 0.005 - 0.02;
h.Position(2) = h.Position(2) + 0.08;
h.Position(3) = h.Position(3) + 0.01;
h.Position(4) = h.Position(4) - 0.12;
p_global(1) = p_global(1) - 0.02;
set(gca,'Position',p_global);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_9h.png','Resolution',300)

close gcf

clear ans
clear h
clear p_global