%% table_S5_to_S12.m
% Sub-function of Irish_Tuna.m; compute p-values for Wilcoxon Rank Sum Test
% to evaluate difference in eddy statistics.

%% Combine sub tables from each hotspot into single table.

tmp.AC = table();
tmp.CC = table();
for i = 1:6
    tmp.AC = [tmp.AC; sub.AC{i}];
    tmp.CC = [tmp.CC; sub.CC{i}];
end

%% Kruskal-Wallis Test

% ACE
[~,~,stats] = kruskalwallis(tmp.AC.SpeedRadius/1000,tmp.AC.Region);
figure; c = multcompare(stats);
eddies.stats.AC.p.Ls = c(:,[1:2 6]);

[~,~,stats] = kruskalwallis(tmp.AC.Amplitude*100,tmp.AC.Region);
figure; c = multcompare(stats);
eddies.stats.AC.p.A = c(:,[1:2 6]);

[~,~,stats] = kruskalwallis(tmp.AC.SpeedAverage*100,tmp.AC.Region);
figure; c = multcompare(stats);
eddies.stats.AC.p.Uavg = c(:,[1:2 6]);

[~,~,stats] = kruskalwallis(double(tmp.AC.DaysSinceFirstDetection)/7,tmp.AC.Region);
figure; c = multcompare(stats);
eddies.stats.AC.p.Life = c(:,[1:2 6]);

% CE
[~,~,stats] = kruskalwallis(tmp.CC.SpeedRadius/1000,tmp.CC.Region);
figure; c = multcompare(stats);
eddies.stats.CC.p.Ls = c(:,[1:2 6]);

[~,~,stats] = kruskalwallis(tmp.CC.Amplitude*100,tmp.CC.Region);
figure; c = multcompare(stats);
eddies.stats.CC.p.A = c(:,[1:2 6]);

[~,~,stats] = kruskalwallis(tmp.CC.SpeedAverage*100,tmp.CC.Region);
figure; c = multcompare(stats);
eddies.stats.CC.p.Uavg = c(:,[1:2 6]);

[~,~,stats] = kruskalwallis(double(tmp.CC.DaysSinceFirstDetection)/7,tmp.CC.Region);
figure; c = multcompare(stats);
eddies.stats.CC.p.Life = c(:,[1:2 6]);

clear c
clear stats

close all