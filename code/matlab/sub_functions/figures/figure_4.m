%% figure_4.m
% Sub-function of Irish_Tuna.m; plots eddy histograms with each region

%% Hotspots

% 2 = Coastal Ireland
% 3 = Bay of Biscay
% 4 = West European Basin
% 1 = Newfoundland Basin (including Mann Eddy)
% 5 = Mediterranean
% 0 = Outside

%% Colormap

cmap = [127 201 127; 255 255 153; 190 174 212; 56 108 176; 253 192 134; 128 128 128]./256;

%% Generate histograms.

sub = [];
for j = 1:2 % % loop through ACE and CE

    cnt = 0;

    for i = [2 3 4 1 5 0] % loop through each hotspot

        cnt = cnt + 1;

        %% Get eddy data in hotspot.
        if j == 1
            ind = ismember(dates.AC,dates.META(META.Region == i));
            tmp = AC(ind,:);
            tmp = tmp(tmp.Region == i,:);

            eddies.AC.realizations(cnt,1) = height(tmp);

            [~,ind,~] = unique(tmp.TrajectoryID,'last');
            tmp = tmp(ind,:);

            eddies.AC.cnt(cnt,1) = height(tmp);

            eddies.AC.Ls(cnt,1) = median(tmp.SpeedRadius./1000);
            eddies.AC.A(cnt,1) = median(tmp.Amplitude.*100);
            eddies.AC.Uavg(cnt,1) = median(tmp.SpeedAverage.*100);
            eddies.AC.Life(cnt,1) = median(double(tmp.DaysSinceFirstDetection)./7);

            sub.AC{cnt} = tmp;
        elseif j == 2
            ind = ismember(dates.CC,dates.META(META.Region == i));
            tmp = CC(ind,:);
            tmp = tmp(tmp.Region == i,:);

            eddies.CC.realizations(cnt,1) = height(tmp);

            [~,ind,~] = unique(tmp.TrajectoryID,'last');
            tmp = tmp(ind,:);

            eddies.CC.cnt(cnt,1) = height(tmp);

            eddies.CC.Ls(cnt,1) = median(tmp.SpeedRadius./1000);
            eddies.CC.A(cnt,1) = median(tmp.Amplitude.*100);
            eddies.CC.Uavg(cnt,1) = median(tmp.SpeedAverage.*100);
            eddies.CC.Life(cnt,1) = median(double(tmp.DaysSinceFirstDetection)./7);

            sub.CC{cnt} = tmp;
        end

        %% Plot hisotgrams and compute statistics.

        figure(1);

        histogram(tmp.SpeedRadius./1000,...
            0:5:200,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
        hold on
        axis tight;
        axis square;
        ylim([0 0.4]);
        set(gca,'FontSize',22,'LineWidth',2);
        set(gca,'YTickLabel',get(gca,'YTick')*100);
        ylabel('% of Observations');
        xlabel('Speed Radius (km)');

        if i  == 0
            cd([fdir 'figures']);
            if j == 1
                exportgraphics(gcf,'figure_4a.png','Resolution',300);
            elseif j == 2
                exportgraphics(gcf,'figure_4e.png','Resolution',300);
            end
        end

        figure(2);

        histogram(tmp.Amplitude.*100,...
            0:2.5:100,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
        hold on
        axis tight;
        axis square;
        ylim([0 1]);
        xticks([0 25 50 75 100]);
        set(gca,'FontSize',22,'LineWidth',2);
        set(gca,'YTickLabel',get(gca,'YTick')*100);
        ylabel('% of Observations');
        xlabel('Amplitude (cm)');

        if i  == 0
            cd([fdir 'figures']);
            if j == 1
                exportgraphics(gcf,'figure_4b.png','Resolution',300);
            elseif j == 2
                exportgraphics(gcf,'figure_4f.png','Resolution',300);
            end
        end

        figure(3);

        histogram(tmp.SpeedAverage.*100,...
            0:3.75:150,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
        hold on
        axis tight;
        axis square;
        ylim([0 0.6]);
        set(gca,'FontSize',22,'LineWidth',2);
        set(gca,'YTickLabel',get(gca,'YTick')*100);
        ylabel('% of Observations');
        xlabel('U_{avg} (cm/s)');

        if i  == 0
            cd([fdir 'figures']);
            if j == 1
                exportgraphics(gcf,'figure_4c.png','Resolution',300);
            elseif j == 2
                exportgraphics(gcf,'figure_4g.png','Resolution',300);
            end
        end

        figure(4);

        histogram(double(tmp.DaysSinceFirstDetection)./7,...
            0:1.6:64,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
        hold on
        axis tight;
        axis square;
        ylim([0 0.5]); xlim([0 65]);
        set(gca,'FontSize',22,'LineWidth',2);
        set(gca,'YTickLabel',get(gca,'YTick')*100);
        ylabel('% of Observations');
        xlabel('Lifetime (weeks)');

        if i  == 0
            cd([fdir 'figures']);
            if j == 1
                exportgraphics(gcf,'figure_4d.png','Resolution',300);
            elseif j == 2
                exportgraphics(gcf,'figure_4h.png','Resolution',300);
            end
        end
    end
    clear ind
    clear tmp

    if j == 1
        close all
    end

end
clear i
clear j
clear cnt

%% Wilcoxon Rank Sum Test
% H0: Data in X and Y are samples from continous distributions with equal
% medians.
% HA: Data in X and Y are smaples from continous distributions whose
% medians are not equal.

for i = 1:6
    for j = 1:6
        [stats_W.AC.p.Ls(i,j),stats_W.AC.h.Ls(i,j),stats_W.AC.tstat.Ls(i,j)] = ranksum(sub.AC{i}.SpeedRadius/1000,sub.AC{j}.SpeedRadius/1000);
        [stats_W.AC.p.A(i,j),stats_W.AC.h.A(i,j),stats_W.AC.tstat.A(i,j)] = ranksum(sub.AC{i}.Amplitude*100,sub.AC{j}.Amplitude*100);
        [stats_W.AC.p.Uavg(i,j),stats_W.AC.h.Uavg(i,j),stats_W.AC.tstat.Uavg(i,j)] = ranksum(sub.AC{i}.SpeedAverage*100,sub.AC{j}.SpeedAverage*100);
        [stats_W.AC.p.Life(i,j),stats_W.AC.h.Life(i,j),stats_W.AC.tstat.Life(i,j)] = ranksum(double(sub.AC{i}.DaysSinceFirstDetection)/7,double(sub.AC{j}.DaysSinceFirstDetection)/7);

        [stats_W.CC.p.Ls(i,j),stats_W.CC.h.Ls(i,j),stats_W.CC.tstat.Ls(i,j)] = ranksum(sub.CC{i}.SpeedRadius/1000,sub.CC{j}.SpeedRadius/1000);
        [stats_W.CC.p.A(i,j),stats_W.CC.h.A(i,j),stats_W.CC.tstat.A(i,j)] = ranksum(sub.CC{i}.Amplitude*100,sub.CC{j}.Amplitude*100);
        [stats_W.CC.p.Uavg(i,j),stats_W.CC.h.Uavg(i,j),stats_W.CC.tstat.Uavg(i,j)] = ranksum(sub.CC{i}.SpeedAverage*100,sub.CC{j}.SpeedAverage*100);
        [stats_W.CC.p.Life(i,j),stats_W.CC.h.Life(i,j),stats_W.CC.tstat.Life(i,j)] = ranksum(double(sub.CC{i}.DaysSinceFirstDetection)/7,double(sub.CC{j}.DaysSinceFirstDetection)/7);

    end
end
clear i
clear j
clear sub