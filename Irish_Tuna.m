%% Irish Tuna Project
% The following runs code to process, analyze and plot data related to 
% tag deployments on tuna from Ireland.
%
% Author: Camille Pagniello, Stanford University (cpagniel@stanford.edu)
% 
% Last Update: 09/03/2022
%
%% Requirements
% Also requires m_map toolbox: https://www.eoas.ubc.ca/~rich/map.html

warning off;

% Location of Project on Google Drive
fdir = '/Volumes/GoogleDrive-115844804207666893078/My Drive/Projects/IrishTuna/';

%% Load and Rearrange Metadata

run load_metaSD

%% Map of Tracks with Ocean Regions, Colored by Year

run overview_map

%% Map of Tracks with Ocean Regions, Colored by Tag

% run tag_map

%% Map of Binned Tracks with Ocean Regions

run bin_map

%% Map of Tracks with Regions by Season, Colored by Month

run seasonal_map_v2

%% Map of Maximum Daily Depth in Each 1 x 1 deg Bin

run mean_max_depth

%% Load Eddy Data

run load_AC_DT
run load_AC_NRT

run load_CC_DT
run load_CC_NRT

AC = [AC_DT; AC_NRT];
CC = [CC_DT; CC_NRT];

clear *_DT *_NRT

dates.META = dd.META.Date;
dates.AC = [dd.AC_DT.Date; dd.AC_NRT.Date];
dates.CC = [dd.CC_DT.Date; dd.CC_NRT.Date];

AC.Region = zeros(length(AC.SSHMaxLatitude),1);
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.Rockall.bndry(1,:),regions.Rockall.bndry(2,:))) = 2;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.OffBiscay.bndry(1,:),regions.OffBiscay.bndry(2,:))) = 4;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

CC.Region = zeros(length(CC.SSHMaxLatitude),1);
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.Rockall.bndry(1,:),regions.Rockall.bndry(2,:))) = 2;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.OffBiscay.bndry(1,:),regions.OffBiscay.bndry(2,:))) = 4;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

clear dd

%% Map of Each Region 

run plot_NB_snapshots
run plot_Rockall_snapshots
run plot_BB_snapshots
run plot_OBB_snapshots
run plot_Med_snapshots

%% Plot PDTs in Each Region

run plot_pdt

%% Plot TimeSeries
% This code needs to be reviewed.

run plot_timeseries_IrishTuna

%% Plot Eddy Regional Histograms

run plot_eddy_regional_histograms