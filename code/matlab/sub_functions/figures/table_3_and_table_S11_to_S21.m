%% table_3_and_table_S11_to_S21.m

%% Load MLD file outputed from Lawson et al. (2010) code.

MLD = readtable([fdir 'data/mld/irish_mld_2022sep6.csv']);
MLD.eventid = MLD.eventid/100;
MLD = renamevars(MLD,"eventid","toppID");

%% Format dates to dd-mm-yyyy.

tmp.iri.Date = datetime(year(MLD.date),month(MLD.date),day(MLD.date));
tmp.META.Date = datetime(year(META.Date),month(META.Date),day(META.Date));

%% Identify hotspot and season based on date.

% Hotspots
% 0 = Outside
% 1 = Newfoundland Basin (including Mann Eddy)
% 2 = Coastal Ireland
% 3 = Bay of Biscay
% 4 = West European Basin
% 5 = Mediterranean

% Seasons
% 1 = Winter which includes December, January and February.
% 2 = Spring which includes March, April and May.
% 3 = Summer which includes June, July and August.
% 4 = Fall which includes September, October and November.

MLD.Season = zeros(height(MLD),1);
MLD.Region = zeros(height(MLD),1);

for i = 1:height(META)
    ind_time = find(tmp.iri.Date == tmp.META.Date(i));
    ind_topp = find(MLD.toppID == META.TOPPid(i));

    ind = intersect(ind_time,ind_topp);

    MLD.Season(ind) = META.Season(i);
    MLD.Region(ind) = META.Region(i);
end
clear i
clear ind*

clear tmp

%% Compute summary statistics.

cnt = 0;
for i = [3 4 5 2 6 1] % hotspots including outside
    cnt = cnt + 1;

    mld.stats.ild_depth.mean(cnt) = mean(MLD.ild_depth(MLD.Region == i - 1),'omitnan');
    mld.stats.ild_depth.std(cnt) = std(MLD.ild_depth(MLD.Region == i - 1),'omitnan');
    mld.stats.ild_depth.cnt(cnt) = sum(MLD.Region == i - 1);

    mld.stats.ild_temp.mean(cnt) = mean(MLD.ild_temp(MLD.Region == i - 1),'omitnan');
    mld.stats.ild_temp.std(cnt) = std(MLD.ild_temp(MLD.Region == i - 1),'omitnan');
    mld.stats.ild_temp.cnt(cnt) = sum(MLD.Region == i - 1);
end

%% Two-sample t-test
% H0: Data in vectors X and Y comes from independent random samples from
% normal distributions with equal means and equal but unknown variances.
% HA: Data in vectors X and Y comes from independent random samples from
% normal distributions with unequal means.

% Across Hotspots, ILD_Depth
cnt_j = 0;
cnt_k = 0;
for j = [3 4 5 2 6 1] % hotspots including outside
    cnt_j = cnt_j + 1;
    for k = [3 4 5 2 6 1] % hotspots including outside
        cnt_k = cnt_k + 1;
        [mld.stats.ild_depth.h(cnt_j,cnt_k),mld.stats.ild_depth.p(cnt_j,cnt_k)] = ...
            ttest2(MLD.ild_depth(MLD.Region == j - 1),MLD.ild_depth(MLD.Region == k - 1));
    end
    cnt_k = 0;
end
clear j
clear k
clear cnt*

% Across Hotspots, ILD_Temp
cnt_j = 0;
cnt_k = 0;
for j = [3 4 5 2 6 1] % hotspots including outside
    cnt_j = cnt_j + 1;
    for k = [3 4 5 2 6 1] % hotspots including outside
        cnt_k = cnt_k + 1;
        [mld.stats.ild_temp.h(cnt_j,cnt_k),mld.stats.ild_temp.p(cnt_j,cnt_k)] = ...
            ttest2(MLD.ild_temp(MLD.Region == j - 1),MLD.ild_temp(MLD.Region == k - 1));
    end
    cnt_k = 0;
end
clear j
clear k
clear cnt*