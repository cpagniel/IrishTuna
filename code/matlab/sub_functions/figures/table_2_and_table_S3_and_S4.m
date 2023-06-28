%% table_2_and_table_S11_to_S21.m

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

    mld.stats.ild_depth.median(cnt) = median(MLD.ild_depth(MLD.Region == i - 1),'omitnan');
    mld.stats.ild_depth.mad(cnt) = mad(MLD.ild_depth(MLD.Region == i - 1),1);
    mld.stats.ild_depth.cnt(cnt) = sum(MLD.Region == i - 1);

    mld.stats.ild_temp.median(cnt) = median(MLD.ild_temp(MLD.Region == i - 1),'omitnan');
    mld.stats.ild_temp.mad(cnt) = mad(MLD.ild_temp(MLD.Region == i - 1),1);
    mld.stats.ild_temp.cnt(cnt) = sum(MLD.Region == i - 1);
end
clear i

%% Kruskal-Wallis with Tukey's Post Hoc Comparisons

% ILD_Depth
[~,~,stats] = kruskalwallis(MLD.ild_depth,MLD.Region);
c = multcompare(stats);

mld.stats.ild_depth.p = c(:,[1:2 6]);

% ILD_Temp
[~,~,stats] = kruskalwallis(MLD.ild_temp,MLD.Region);
c = multcompare(stats);

mld.stats.ild_temp.p = c(:,[1:2 6]);