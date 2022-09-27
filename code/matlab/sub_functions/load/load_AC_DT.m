%% load_AC_DT.m
% Load anticyclonic eddy data from AVISO.

%% Go to File and Directory

cd([fdir '/data/eddies/'])
filename = 'META3.1exp_DT_allsat_Anticyclonic_long_19930101_20200307.nc';

%% Create Index of Dates to Keep Based on Tuna Metadata

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);
t_max = max(tmp);

% Make dates same format dd-mm-yyyy.
dd.AC_DT.Date = datetime(year(tmp),month(tmp),day(tmp));
dd.META.Date = datetime(year(META.Date),month(META.Date),day(META.Date));

% Index of AC dates in metadata.
ind = ismember(dd.AC_DT.Date,dd.META.Date);

AC_DT = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

%% Load Remaining Variables

tmp = ncread(filename,'amplitude'); % in meters
AC_DT.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
AC_DT.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
AC_DT.EffectiveContourLongitude = tmp.'; 

tmp = ncread(filename,'effective_radius'); % in meters
AC_DT.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
AC_DT.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
AC_DT.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
AC_DT.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
AC_DT.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
AC_DT.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
AC_DT.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'observation_number');
AC_DT.DaysSinceFirstDetection = tmp(ind);

tmp = ncread(filename,'track');
AC_DT.TrajectoryID = tmp(ind);

clear tmp 
clear ind

%% Only Keep Eddies Whose Centers in Within Study Area

regions.full.LATLIMS = [20 70]; regions.full.LONLIMS = [-80 40];
regions.full.bndry = [regions.full.LONLIMS(1) regions.full.LONLIMS(1)...
    regions.full.LONLIMS(2) regions.full.LONLIMS(2)...
    regions.full.LONLIMS(1);...
    regions.full.LATLIMS(1) regions.full.LATLIMS(2)...
    regions.full.LATLIMS(2) regions.full.LATLIMS(1)...
    regions.full.LATLIMS(1)];

ind = inpolygon(AC_DT.SSHMaxLongitude,AC_DT.SSHMaxLatitude,regions.full.bndry(1,:),regions.full.bndry(2,:));

AC_DT = AC_DT(ind,:);

clear ind

%% Make uniform date vector

dd.AC_DT.Date = datetime(year(AC_DT.Date),month(AC_DT.Date),day(AC_DT.Date));

clear filename