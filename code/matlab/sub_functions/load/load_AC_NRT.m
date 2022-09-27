%% load_AC_NRT.m
% Load near-real time anticyclonic eddy data from AVISO.

%% Go to File and Directory

cd([fdir '/data/eddies/'])
filename = 'Eddy_trajectory_nrt_3.2exp_anticyclonic_20180101_20220218.nc';

%% Create Index of Dates to Keep Based on Tuna Metadata

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates same format dd-mm-yyyy.
dd.AC_NRT.Date = datetime(year(tmp),month(tmp),day(tmp));

% Index of AC dates in metadata.
ind = ismember(dd.AC_NRT.Date,dd.META.Date);

AC_NRT = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

%% Load Remaining Variables

tmp = ncread(filename,'amplitude'); % in meters
AC_NRT.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
AC_NRT.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
AC_NRT.EffectiveContourLongitude = tmp.'; 

tmp = ncread(filename,'effective_radius'); % in meters
AC_NRT.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
AC_NRT.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
AC_NRT.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
AC_NRT.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
AC_NRT.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
AC_NRT.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
AC_NRT.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'observation_number');
AC_NRT.DaysSinceFirstDetection = tmp(ind);

tmp = ncread(filename,'track');
AC_NRT.TrajectoryID = tmp(ind);

clear tmp 
clear ind

%% Only Keep Eddies That Are Later Than Last Eddy in DT

ind = AC_NRT.Date > t_max;

AC_NRT = AC_NRT(ind,:);

clear ind
clear t_max

%% Only Keep Eddies Whose Centers in Within Study Area

regions.full.LATLIMS = [20 70]; regions.full.LONLIMS = [-80 40];
regions.full.bndry = [regions.full.LONLIMS(1) regions.full.LONLIMS(1)...
    regions.full.LONLIMS(2) regions.full.LONLIMS(2)...
    regions.full.LONLIMS(1);...
    regions.full.LATLIMS(1) regions.full.LATLIMS(2)...
    regions.full.LATLIMS(2) regions.full.LATLIMS(1)...
    regions.full.LATLIMS(1)];

ind = inpolygon(AC_NRT.SSHMaxLongitude,AC_NRT.SSHMaxLatitude,regions.full.bndry(1,:),regions.full.bndry(2,:));

AC_NRT = AC_NRT(ind,:);

clear ind

%% Make uniform date vector

dd.AC_NRT.Date = datetime(year(AC_NRT.Date),month(AC_NRT.Date),day(AC_NRT.Date));

clear filename