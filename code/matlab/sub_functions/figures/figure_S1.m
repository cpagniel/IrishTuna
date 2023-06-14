%% figure_S1
% Sub-function of Irish_Tuna.m; calculate residency of each tag in each
% region

%% Mean % of Deployment Days

b = bar(mean((table2array(tbl_S2(:,2:7))./sum(table2array(tbl_S2(:,2:7)),2))*100),'FaceColor','flat');
b.CData = cmap_r;

hold on

errorbar(1:6,mean((table2array(tbl_S2(:,2:7))./sum(table2array(tbl_S2(:,2:7)),2))*100),[],std((table2array(tbl_S2(:,2:7))./sum(table2array(tbl_S2(:,2:7)),2))*100),'LineStyle','none','Color','k');

set(gca,'FontSize',20);
set(gca,'XTickLabel',{'CI','BoB','WEB','NB','Med','Outside'})
set(gca,"XTickLabelRotation",0);

ylabel('Mean % of Deployment Days','FontSize',22);
xlabel('Hotspot','FontSize',22);

grid on
grid minor

cd([fdir 'figures'])
exportgraphics(gcf,'figure_S1.png','Resolution',300);

close gcf

clear b