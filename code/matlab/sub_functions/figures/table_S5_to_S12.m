%% table_S5_to_S12.m
% Sub-function of Irish_Tuna.m; compute p-values for Wilcoxon Rank Sum Test
% to evaluate difference in eddy statistics.

%% Wilcoxon Rank Sum Test
% H0: Data in X and Y are samples from continous distributions with equal
% medians.
% HA: Data in X and Y are smaples from continous distributions whose
% medians are not equal.

for i = 1:6
    for j = 1:6
        [eddies.stats.AC.p.Ls(i,j),eddies.stats.AC.h.Ls(i,j),eddies.stats.AC.tstat.Ls(i,j)] = ranksum(sub.AC{i}.SpeedRadius/1000,sub.AC{j}.SpeedRadius/1000);
        [eddies.stats.AC.p.A(i,j),eddies.stats.AC.h.A(i,j),eddies.stats.AC.tstat.A(i,j)] = ranksum(sub.AC{i}.Amplitude*100,sub.AC{j}.Amplitude*100);
        [eddies.stats.AC.p.Uavg(i,j),eddies.stats.AC.h.Uavg(i,j),eddies.stats.AC.tstat.Uavg(i,j)] = ranksum(sub.AC{i}.SpeedAverage*100,sub.AC{j}.SpeedAverage*100);
        [eddies.stats.AC.p.Life(i,j),eddies.stats.AC.h.Life(i,j),eddies.stats.AC.tstat.Life(i,j)] = ranksum(double(sub.AC{i}.DaysSinceFirstDetection)/7,double(sub.AC{j}.DaysSinceFirstDetection)/7);

        [eddies.stats.CC.p.Ls(i,j),eddies.stats.CC.h.Ls(i,j),eddies.stats.CC.tstat.Ls(i,j)] = ranksum(sub.CC{i}.SpeedRadius/1000,sub.CC{j}.SpeedRadius/1000);
        [eddies.stats.CC.p.A(i,j),eddies.stats.CC.h.A(i,j),eddies.stats.CC.tstat.A(i,j)] = ranksum(sub.CC{i}.Amplitude*100,sub.CC{j}.Amplitude*100);
        [eddies.stats.CC.p.Uavg(i,j),eddies.stats.CC.h.Uavg(i,j),eddies.stats.CC.tstat.Uavg(i,j)] = ranksum(sub.CC{i}.SpeedAverage*100,sub.CC{j}.SpeedAverage*100);
        [eddies.stats.CC.p.Life(i,j),eddies.stats.CC.h.Life(i,j),eddies.stats.CC.tstat.Life(i,j)] = ranksum(double(sub.CC{i}.DaysSinceFirstDetection)/7,double(sub.CC{j}.DaysSinceFirstDetection)/7);

    end
end
clear i
clear j
clear sub