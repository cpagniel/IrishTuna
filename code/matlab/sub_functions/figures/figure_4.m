%% figure_4
% Sub-function of Irish_Tuna.m; time in mesopelagic (> 200 m) bar graph,
% vs. ADT and map.

%% Mean % Time in Mesopelagic for Each Tag

for i = 1:length(toppID)
    cnt = 0;
    for j = [2 3 4 1 5 0] % each hotspot and outside hotspots
        cnt = cnt + 1;
        meso.stats.mean_per_tag(i,cnt) = mean(sum(table2array(TAD(TAD.toppID == toppID(i) & TAD.Region == j,9:14)),2)*100,'omitnan');
        meso.stats.std_per_tag(i,cnt) = std(sum(table2array(TAD(TAD.toppID == toppID(i) & TAD.Region == j,9:14)),2)*100,'omitnan');
    end
end

%% Figure 4a: Bar graph per hotspot.

figure() 

b = bar(mean(meso.stats.mean_per_tag,'omitnan'),'FaceColor','flat');
b.CData = cmap;

hold on

errorbar(1:6,mean(meso.stats.mean_per_tag,'omitnan'),[],std(meso.stats.mean_per_tag,'omitnan'),'LineStyle','none','Color','k');

set(gca,'FontSize',20);
set(gca,'XTickLabel',{'CI','BoB','WEB','NB','Med','Outside'})
set(gca,"XTickLabelRotation",0);

ylabel('Mean % of Time in Mesopelagic','FontSize',22);
xlabel('Hotspot','FontSize',22);

grid on
grid minor

cd([fdir 'figures'])
exportgraphics(gcf,'figure_4a.png','Resolution',300);

close gcf

clear b

%%