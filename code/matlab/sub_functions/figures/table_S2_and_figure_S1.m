%% table_S2_and_figure_S1
% Sub-function of Irish_Tuna.m; calculate residency of each tag in each
% region

%% Count occurrences in each region

tbl_S2 = groupcounts(META,{'TOPPid','Region'},'IncludeEmptyGroups',true);
tbl_S2 = removevars(tbl_S2, 'Percent');
tbl_S2 = unstack(tbl_S2,'GroupCount','Region');
tbl_S2 = renamevars(tbl_S2,{'x0','x1','x2','x3','x4','x5'},{'Outside','NB','CI','BoB','WEB','Med'});
tbl_S2 = movevars(tbl_S2, 'Outside', 'After', 'Med');
tbl_S2 = movevars(tbl_S2, 'NB', 'Before', 'Med');

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