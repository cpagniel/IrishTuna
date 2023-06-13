%% figure_S1
% Sub-function of Irish_Tuna.m; calculate residency of each tag in each
% region

%% Mean % of Deployment Days

cmap = [127 201 127; 255 255 153; 190 174 212; 56 108 176; 253 192 134; 128 128 128]./256;

b = bar(mean((table2array(tbl_S2(:,2:7))./sum(table2array(tbl_S2(:,2:7)),2))*100),'FaceColor','flat');
b.CData = cmap;

hold on

errorbar(1:6,mean((table2array(tbl_S2(:,2:7))./sum(table2array(tbl_S2(:,2:7)),2))*100),[],std((table2array(tbl_S2(:,2:7))./sum(table2array(tbl_S2(:,2:7)),2))*100),'LineStyle','none','Color','k');

set(gca,'FontSize',20);
set(gca,'XTickLabel',{'CI','BoB','WEB','NB','Med','Outside'})
set(gca,"XTickLabelRotation",0);

ylabel('Mean % of Deployment Days','FontSize',22);
xlabel('Hotspot','FontSize',22);

cd([fdir 'figures'])
exportgraphics(gcf,'figure_S1.png','Resolution',300);

close gcf

clear b
clear cmap