%% figure_7.m
% Sub-function of Irish_Tuna.m; plots max daily depth in each degree bin

%% Extract Max Depth from META_full

max_depth = META_full.MaxDepth24h;
b = cellfun(@num2str,max_depth,'un',0); max_depth(ismember(b,'NA')) = {'NaN'};
max_depth = cell2mat(cellfun(@str2num,max_depth,'un',0));
clear b

META.MaxDepth = max_depth;
clear max_depth

%% Create figure and axes for bathymetry. 

figure('Position',[476 334 716 532]);

%% Set projection of map.

LATLIMS = [20 70]; LONLIMS = [-80 40];
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

%% Bin Max Depth to Compute Mean (or Median)

binned.LONedges = -80:1:40;
binned.LATedges = 20:1:70;

% Mean Max Depth
[binned.mz,binned.LONmid,binned.LATmid,~,binned.stdz] = twodstats(META.Longitude,META.Latitude,META.MaxDepth,binned.LONedges,binned.LATedges);

% Median Max Depth
%[binned.mz,binned.LONmid,binned.LATmid] = twodmed(META.Longitude,META.Latitude,META.MaxDepth,binned.LONedges,binned.LATedges);

m_pcolor(binned.LONmid,binned.LATmid,binned.mz);

hold on

%% Plot land.

m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Plot ocean regions.

m_line(regions.NB.bndry(1,:),regions.NB.bndry(2,:),'linewi',2,'color','k');
%m_text(-53,51.5,'Newfoundland Basin','FontWeight','bold');

m_line(regions.Rockall.bndry(1,:),regions.Rockall.bndry(2,:),'linewi',2,'color','k');
%m_text(-20.5,61.2,'Rockall Trough','FontWeight','bold');

m_line(regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:),'linewi',2,'color','k');
%m_text(-2,51,'Bay of Biscay','FontWeight','bold');

m_line(regions.OffBiscay.bndry(1,:),regions.OffBiscay.bndry(2,:),'linewi',2,'color','k');
%m_text(-2,51,'Offshore of Bay of Biscay','FontWeight','bold');

m_line(regions.Med.bndry(1,:),regions.Med.bndry(2,:),'linewi',2,'color','k');
%m_text(-4.5,32,'Mediterranean','FontWeight','bold');

%% Create figure border.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

%% Add north arrow and scale bar.

m_northarrow(-75,65,4,'type',2,'linewi',2);
m_ruler([.78 .98],.1,2,'fontsize',16,'ticklength',0.01);

%% Add colorbar

p = get(gca,'Position');
p(1) = p(1)-0.03;

h = colorbar('FontSize',16); cmap = colormap('parula'); colormap(flipud(cmap)); 
ylabel(h,'Mean Daily Maximum Depth (m)','FontSize',16);
caxis([0 400]);

set(gca,'Position',p);

%% Save

cd([fdir 'figures']);
saveas(gcf,'figure_7.png')

%% Clear

clear h* binned
clear p
clear ans
clear *LIMS

close gcf