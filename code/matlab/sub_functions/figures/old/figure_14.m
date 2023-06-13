%% figure_14.m
% Sub-function of Irish_Tuna.m; plots eddy histograms for each region

%% Change i to plot each region

% 1 = Newfoundland Basin (including Mann Eddy)
% 2 = Coastal Ireland
% 3 = Bay of Biscay
% 4 = West European Basin
% 5 = Mediterranean

i = 5;

%% Plot hisotgrams

ind.AC = ismember(dates.AC,dates.META(META.Region == i));
ind.CC = ismember(dates.CC,dates.META(META.Region == i));

tmp_AC = AC(ind.AC,:);
tmp_CC = CC(ind.CC,:);


figure;

hC_R{i} = histogram(tmp_CC.SpeedRadius(tmp_CC.Region == i)./1000,0:10:200,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','b');
hold on
hA_R{i} = histogram(tmp_AC.SpeedRadius(tmp_AC.Region == i)./1000,0:10:200,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','r');
axis tight;
axis square;
ylim([0 0.5]);
set(gca,'FontSize',22,'LineWidth',2);
set(gca,'YTickLabel',get(gca,'YTick')*100);
ylabel('% of Observations');
xlabel('Speed Radius (km)');

%saveas(gcf,['hist_radius_region_' num2str(i) '.png']);
%close all

figure;

hC_A{i} = histogram(tmp_CC.Amplitude(tmp_CC.Region == i).*100,0:5:100,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','b');
hold on
hA_A{i} = histogram(tmp_AC.Amplitude(tmp_AC.Region == i).*100,0:5:100,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','r');
axis tight;
axis square;
ylim([0 1]);
xticks([0 25 50 75 100]);
set(gca,'FontSize',22,'LineWidth',2);
set(gca,'YTickLabel',get(gca,'YTick')*100);
ylabel('% of Observations');
xlabel('Amplitude (cm)');

%saveas(gcf,['hist_amp_region_' num2str(i) '.png']);
%close all

figure;

hC_U{i} = histogram(tmp_CC.SpeedAverage(tmp_CC.Region == i).*100,0:5:150,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','b');
hold on
hA_U{i} = histogram(tmp_AC.SpeedAverage(tmp_AC.Region == i).*100,0:5:150,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','r');
axis tight;
axis square;
ylim([0 0.6]);
set(gca,'FontSize',22,'LineWidth',2);
set(gca,'YTickLabel',get(gca,'YTick')*100);
ylabel('% of Observations');
xlabel('U_{avg} (cm/s)');

%saveas(gcf,['hist_U_region_' num2str(i) '.png']);
%close all

figure;

hC_L{i} = histogram(double(tmp_CC.DaysSinceFirstDetection(tmp_CC.Region == i))./7,0:4:64,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','b');
hold on
hA_L{i} = histogram(double(tmp_AC.DaysSinceFirstDetection(tmp_AC.Region == i))./7,0:4:64,'Normalization','Probability','DisplayStyle','Stairs','LineWidth',2,'EdgeColor','r');
axis tight;
axis square;
ylim([0 0.8]); xlim([0 65]);
set(gca,'FontSize',22,'LineWidth',2);
set(gca,'YTickLabel',get(gca,'YTick')*100);
ylabel('% of Observations');
xlabel('Lifetime (weeks)');

%saveas(gcf,['hist_lifetime_region_' num2str(i) '.png']);
%close all

%% Stats

median(tmp_CC.SpeedRadius(tmp_CC.Region == i)./1000)
median(tmp_AC.SpeedRadius(tmp_AC.Region == i)./1000)

median(tmp_CC.Amplitude(tmp_CC.Region == i).*100)
median(tmp_AC.Amplitude(tmp_AC.Region == i).*100)

median(tmp_CC.SpeedAverage(tmp_CC.Region == i).*100)
median(tmp_AC.SpeedAverage(tmp_AC.Region == i).*100)

median(double(tmp_CC.DaysSinceFirstDetection(tmp_CC.Region == i))./7)
median(double(tmp_AC.DaysSinceFirstDetection(tmp_AC.Region == i))./7)
