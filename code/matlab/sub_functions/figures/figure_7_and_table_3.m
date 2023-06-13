%% figure_7_and_table_3.m
% Sub-function of Irish_Tuna.m; plots eddy histograms with each region and
% compute eddy statistics.

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

            eddies.stats.AC.realizations(cnt,1) = height(tmp);

            [~,ind,~] = unique(tmp.TrajectoryID,'last');
            tmp = tmp(ind,:);

            eddies.stats.AC.cnt(cnt,1) = height(tmp);

            eddies.stats.AC.median.Ls(cnt,1) = median(tmp.SpeedRadius./1000);
            eddies.stats.AC.mad.Ls(cnt,1) = mad(tmp.SpeedRadius./1000,1);
            eddies.stats.AC.median.A(cnt,1) = median(tmp.Amplitude.*100);
            eddies.stats.AC.mad.A(cnt,1) = mad(tmp.Amplitude.*100,1);
            eddies.stats.AC.median.Uavg(cnt,1) = median(tmp.SpeedAverage.*100);
            eddies.stats.AC.mad.Uavg(cnt,1) = mad(tmp.SpeedAverage.*100,1);
            eddies.stats.AC.median.Life(cnt,1) = median(double(tmp.DaysSinceFirstDetection)./7);
            eddies.stats.AC.mad.Life(cnt,1) = mad(double(tmp.DaysSinceFirstDetection)./7,1);

            sub.AC{cnt} = tmp;
        elseif j == 2
            ind = ismember(dates.CC,dates.META(META.Region == i));
            tmp = CC(ind,:);
            tmp = tmp(tmp.Region == i,:);

            eddies.stats.CC.realizations(cnt,1) = height(tmp);

            [~,ind,~] = unique(tmp.TrajectoryID,'last');
            tmp = tmp(ind,:);

            eddies.stats.CC.cnt(cnt,1) = height(tmp);

            eddies.stats.CC.median.Ls(cnt,1) = median(tmp.SpeedRadius./1000);
            eddies.stats.CC.mad.Ls(cnt,1) = mad(tmp.SpeedRadius./1000,1);
            eddies.stats.CC.median.A(cnt,1) = median(tmp.Amplitude.*100);
            eddies.stats.CC.mad.A(cnt,1) = mad(tmp.Amplitude.*100,1);
            eddies.stats.CC.median.Uavg(cnt,1) = median(tmp.SpeedAverage.*100);
            eddies.stats.CC.mad.Uavg(cnt,1) = mad(tmp.SpeedAverage.*100,1);
            eddies.stats.CC.median.Life(cnt,1) = median(double(tmp.DaysSinceFirstDetection)./7);
            eddies.stats.CC.mad.Life(cnt,1) = mad(double(tmp.DaysSinceFirstDetection)./7,1);

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

    close all

end
clear i
clear j
clear cnt