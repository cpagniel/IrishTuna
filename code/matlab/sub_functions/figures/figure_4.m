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

%% Loop through each hotspot.

cnt = 0;
for i = [2 3 4 1 5 0]

    cnt = cnt + 1;

    %% Get eddy data in hotspot.

    ind.AC = ismember(dates.AC,dates.META(META.Region == i));
    ind.CC = ismember(dates.CC,dates.META(META.Region == i));

    tmp_AC = AC(ind.AC,:);
    tmp_CC = CC(ind.CC,:);

    %% Plot hisotgrams

    figure(1);

    h = histogram([tmp_CC.SpeedRadius(tmp_CC.Region == i)./1000; tmp_AC.SpeedRadius(tmp_AC.Region == i)./1000],...
        0:5:200,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
    h_R(:,cnt) = h.Values;
    hold on
    axis tight;
    axis square;
    ylim([0 0.5]);
    set(gca,'FontSize',22,'LineWidth',2);
    set(gca,'YTickLabel',get(gca,'YTick')*100);
    ylabel('% of Observations');
    xlabel('Speed Radius (km)');

    if i  == 0
        cd([fdir 'figures']);
        exportgraphics(gcf,'hist_radius.png','Resolution',300);
    end

    figure(2);

    h = histogram([tmp_CC.Amplitude(tmp_CC.Region == i).*100; tmp_AC.Amplitude(tmp_AC.Region == i).*100],...
        0:2.5:100,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
    h_A(:,cnt) = h.Values;
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
        exportgraphics(gcf,'hist_amp.png','Resolution',300);
    end

    figure(3);

    h = histogram([tmp_CC.SpeedAverage(tmp_CC.Region == i).*100; tmp_AC.SpeedAverage(tmp_AC.Region == i).*100],...
        0:3.75:150,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
    h_U(:,cnt) = h.Values;
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
        exportgraphics(gcf,'hist_U.png','Resolution',300);
    end

    figure(4);

    h = histogram([double(tmp_CC.DaysSinceFirstDetection(tmp_CC.Region == i))./7; double(tmp_AC.DaysSinceFirstDetection(tmp_AC.Region == i))./7],...
        0:1.6:64,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor',cmap(cnt,:));
    h_L(:,cnt) = h.Values;
    hold on
    axis tight;
    axis square;
    ylim([0 0.8]); xlim([0 65]);
    set(gca,'FontSize',22,'LineWidth',2);
    set(gca,'YTickLabel',get(gca,'YTick')*100);
    ylabel('% of Observations');
    xlabel('Lifetime (weeks)');

    if i  == 0
        cd([fdir 'figures']);
        exportgraphics(gcf,'hist_lifetime.png','Resolution',300);
    end

end
