%% figure_S3
% Sub-function of Irish_Tuna.m; plot centers of ACEs & CEs in each hotspot.

%% Newfounland Basin

ind.AC = ismember(dates.AC,dates.META(META.Region == 1));
ind.CC = ismember(dates.CC,dates.META(META.Region == 1));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Newfoundland Basin - ACEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of ACE centers
sub_AC = tmp_AC(tmp_AC.Region == 1,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

hold on

% outline
m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3a.png','Resolution',300)

close gcf

clear ans

%% Newfoundland Basin - CEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.NB.lat1; LONLIMS = [regions.NB.lon2(1) regions.NB.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-5000:1000:-2000,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of CE centers
sub_CC = tmp_CC(tmp_CC.Region == 1,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

% outline
m_patch([regions.NB.lon2 regions.NB.lon2(1) regions.NB.lon2(1)],...
[regions.NB.lat2 fliplr(regions.NB.lat2)],'w');

m_plot(regions.NB.lon2,regions.NB.lat2,'k-','LineWidth',2);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-49,50.5,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3b.png','Resolution',300)

close gcf

clear ans

%% West European Basin

ind.AC = ismember(dates.AC,dates.META(META.Region == 4));
ind.CC = ismember(dates.CC,dates.META(META.Region == 4));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% West European Basin - ACEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.WEB.lat1; LONLIMS = regions.WEB.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of ACE centers
sub_AC = tmp_AC(tmp_AC.Region == 4,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);


cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3c.png','Resolution',300)

close gcf

clear ans

%% West European Basin - CEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.WEB.lat1; LONLIMS = regions.WEB.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of CE centers
sub_CC = CC(CC.Region == 4,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3d.png','Resolution',300)

close gcf

clear ans

%% Coastal Ireland

ind.AC = ismember(dates.AC,dates.META(META.Region == 2));
ind.CC = ismember(dates.CC,dates.META(META.Region == 2));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Coastal Ireland - ACEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = regions.CI.lon1;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of ACE centers
sub_AC = tmp_AC(tmp_AC.Region == 2,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

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


cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3e.png','Resolution',300)

close gcf

clear ans

%% Coastal Ireland - CEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.CI.lat1; LONLIMS = [regions.CI.lon2(1) regions.CI.lon1(2)];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-3000:500:-1000,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of CE centers
sub_CC = tmp_CC(tmp_CC.Region == 2,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

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

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3f.png','Resolution',300)

close gcf

clear ans

%% Bay of Biscay

ind.AC = ismember(dates.AC,dates.META(META.Region == 3));
ind.CC = ismember(dates.CC,dates.META(META.Region == 3));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Bay of Biscay - ADT

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = regions.Biscay.lon;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of ACE centers
sub_AC = tmp_AC(tmp_AC.Region == 3,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3g.png','Resolution',300)

close gcf

clear ans

%% Bay of Biscay - CEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Biscay.lat; LONLIMS = regions.Biscay.lon;
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',[-4000:1000:-1000 -500 -250 -100],'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of CE centers
sub_CC = tmp_CC(tmp_CC.Region == 3,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

% land
m_gshhs_i('patch',[.7 .7 .7]); 

hold on

% outline
m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);

m_northarrow(-15,58.75,1,'type',2,'linewi',2);
m_ruler([.77 .92],1.05,2,'fontsize',14,'ticklength',0.01);

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3h.png','Resolution',300)

close gcf

clear ans

%% Mediterranean Sea

ind.AC = ismember(dates.AC,dates.META(META.Region == 5));
ind.CC = ismember(dates.CC,dates.META(META.Region == 5));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);

%% Mediterranean Sea - ACEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of ACE centers
sub_AC = tmp_AC(tmp_AC.Region == 5,:);
trjID = unique(sub_AC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_AC.SSHMaxLongitude(trjID(i) == sub_AC.TrajectoryID),...
        sub_AC.SSHMaxLatitude(trjID(i) == sub_AC.TrajectoryID),'r-','LineWidth',2)
end
clear i
clear trjID

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

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3i.png','Resolution',300)

close gcf

clear ans

%% Mediterranean Sea - CEs

% figure
figure('Position',[667 184 685 586]);

LATLIMS = regions.Med.lat1; LONLIMS = [regions.Med.lon2(1) 22];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

% bathymetry
m_etopo2('contour',-5500:1000:-500,'edgecolor','k','LineWidth',1);

hold on

% plot trajectories of CE centers
sub_CC = tmp_CC(tmp_CC.Region == 5,:);
trjID = unique(sub_CC.TrajectoryID);

for i = 1:length(trjID)
    m_plot(sub_CC.SSHMaxLongitude(trjID(i) == sub_CC.TrajectoryID),...
        sub_CC.SSHMaxLatitude(trjID(i) == sub_CC.TrajectoryID),'b-','LineWidth',2)
end
clear i
clear trjID

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

cd([fdir 'figures']);
exportgraphics(gcf,'figure_S3j.png','Resolution',300)

close gcf

clear ans

clear sub*
clear tmp*
clear ind
clear L*