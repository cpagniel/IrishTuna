%% load_data.m
% Sub-function of Irish_Tuna.m; loads and rearrages metadata from Simon
% Dedman's AllDailies_Irish.csv master metadata file.

%% Load AllDailies_Irish.csv metadata file

cd([fdir 'metadata']);
META_full = readtable('AllDailies_Irish.csv');

%% Extract SSM positions and dates from full metadata.

dat = datetime('01/01/1970') + days(META_full.Date);
lon = META_full.lon;
lat = META_full.lat;

%% Define oceanographic regions.

% 1 = Newfoundland Basin (including Mann Eddy)
% 2 = Coastal Ireland
% 3 = Bay of Biscay
% 4 = West European Basin
% 5 = Mediterranean

regions.NB.lon1 = [-44 -33]; regions.NB.lat1 = [39 52];
regions.NB.lon2 = [-50 -44]; regions.NB.lat2 = [39 52];
regions.NB.bndry = [regions.NB.lon1(2) regions.NB.lon2(1)...
    regions.NB.lon2(2) regions.NB.lon1(2)...
    regions.NB.lon1(2);...
    regions.NB.lat1(1) regions.NB.lat1(1)...
    regions.NB.lat1(2) regions.NB.lat1(2)...
    regions.NB.lat1(1)];

regions.CI.lon1 = [-16 -6]; regions.CI.lat1 = [50 60];
regions.CI.lon2 = [-16 -9.2957]; regions.CI.lat2 = [52 60];
regions.CI.bndry = [regions.CI.lon1(1) regions.CI.lon1(1)...
    regions.CI.lon1(2) regions.CI.lon1(2)...
    regions.CI.lon2(2) regions.CI.lon1(1);...
    regions.CI.lat2(1) regions.CI.lat1(2)...
    regions.CI.lat1(2) regions.CI.lat1(1)...
    regions.CI.lat1(1) regions.CI.lat2(1)];

regions.Biscay.lon = [-9.2957 0.2]; regions.Biscay.lat = [42.92 50];
regions.Biscay.bndry = [regions.Biscay.lon(1) regions.Biscay.lon(1)...
    regions.Biscay.lon(2) regions.Biscay.lon(2)...
    regions.Biscay.lon(1);...
    regions.Biscay.lat(1) regions.Biscay.lat(2)...
    regions.Biscay.lat(2) regions.Biscay.lat(1)...
    regions.Biscay.lat(1)];

regions.WEB.lon1 = [-20 -9.2957]; regions.WEB.lat1 = [42.92 52];
regions.WEB.lon2 = [-20 -16]; regions.WEB.lat2 = [50 52];
regions.WEB.bndry = [regions.WEB.lon1(1) regions.WEB.lon1(1)...
    regions.WEB.lon2(2)...
    regions.WEB.lon1(2) regions.WEB.lon1(2)...
    regions.WEB.lon1(1);...
    regions.WEB.lat1(1) regions.WEB.lat1(2)...
    regions.WEB.lat1(2)...
    regions.WEB.lat2(1) regions.WEB.lat1(1)...
    regions.WEB.lat1(1)];

regions.Med.lon1 = [0 36.5]; regions.Med.lat1 = [30 46];
regions.Med.lon2 = [-5.61 0]; regions.Med.lat2 = [35 40];
regions.Med.bndry = [regions.Med.lon2(1) regions.Med.lon2(1)...
    5 22,... 
    22 regions.Med.lon2(1);...
    regions.Med.lat1(1) regions.Med.lat2(2)...
    regions.Med.lat1(2) regions.Med.lat1(2)... 
    regions.Med.lat1(1) regions.Med.lat1(1)];

%% Determine Season of Observation

% 1 = Winter which includes December, January and February. 
% 2 = Spring which includes March, April and May. 
% 3 = Summer which includes June, July and August. 
% 4 = Fall which includes September, October and November. 

season = zeros(length(dat),1);
season(month(dat) == 12 | month(dat) == 1 | month(dat) == 2) = 1;
season(month(dat) == 3 | month(dat) == 4 | month(dat) == 5) = 2;
season(month(dat) == 6 | month(dat) == 7 | month(dat) == 8) = 3;
season(month(dat) == 9 | month(dat) == 10 | month(dat) == 11) = 4;

%% Determine Region of Observation

region = zeros(length(lat),1);
region(inpolygon(lon,lat,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
region(inpolygon(lon,lat,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
region(inpolygon(lon,lat,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
region(inpolygon(lon,lat,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
region(inpolygon(lon,lat,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

%% Create Table

META = table(META_full.toppid,dat,lon,lat,META_full.lon025,META_full.lat025,META_full.lon975,META_full.lat975,season,region,META_full.MaxDepth24h,'VariableNames',{'TOPPid','Date','Longitude','Latitude','Longitude025','Latitude025','Longitude975','Latitude975','Season','Region','MaxDepth24h'});

clear dat lon lat season region

%% Add Updated 5116034 track with all geolocation days

META(META.TOPPid == 5116034,:) = [];

cd([fdir 'data/SSM']);

tmp = readtable('511603400SSM.txt');

season = zeros(height(tmp),1);
season(month(tmp.datesec) == 12 | month(tmp.datesec) == 1 | month(tmp.datesec) == 2) = 1;
season(month(tmp.datesec) == 3 | month(tmp.datesec) == 4 | month(tmp.datesec) == 5) = 2;
season(month(tmp.datesec) == 6 | month(tmp.datesec) == 7 | month(tmp.datesec) == 8) = 3;
season(month(tmp.datesec) == 9 | month(tmp.datesec) == 10 | month(tmp.datesec) == 11) = 4;

region = zeros(height(tmp),1);
region(inpolygon(tmp.lon,tmp.lat,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
region(inpolygon(tmp.lon,tmp.lat,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
region(inpolygon(tmp.lon,tmp.lat,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
region(inpolygon(tmp.lon,tmp.lat,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
region(inpolygon(tmp.lon,tmp.lat,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

tmp_format = table(5116034*ones(height(tmp),1), ...
    datetime(year(tmp.datesec),month(tmp.datesec),day(tmp.datesec)), ...
    tmp.lon, ...
    tmp.lat, ...
    tmp.lon025, ...
    tmp.lat025, ...
    tmp.lon975, ...
    tmp.lat975, ...
    season, ...
    region, ...
    cell(repmat(char('NA'),height(tmp),1)), ...
    'VariableNames',{'TOPPid','Date','Longitude','Latitude',...
    'Longitude025','Latitude025','Longitude975','Latitude975',...
    'Season','Region','MaxDepth24h'});

tmp_format(tmp_format.Date > datetime(2017,06,05),:) = [];

META = [META; tmp_format];

clear tmp season region tmp_format

clear META_full