%% Irish Tuna Project
% The following runs code to process, analyze and plot data related to 
% tag deployments on tuna from Ireland.
%
% Author: Camille Pagniello, Stanford University (cpagniel@stanford.edu)
% 
% Last Update: 10/27/2022
%
%% Requirements
% Also requires m_map toolbox: https://www.eoas.ubc.ca/~rich/map.html

warning off;

% Location of Project on Google Drive
fdir = '/Users/cpagniello/Library/CloudStorage/GoogleDrive-cpagniel@stanford.edu/My Drive/Projects/Completed/IrishTuna/github/IrishTuna/';

%% Load Tag Data

run load_data

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
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
AC.Region(inpolygon(AC.SSHMaxLongitude,AC.SSHMaxLatitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

CC.Region = zeros(length(CC.SSHMaxLatitude),1);
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.NB.bndry(1,:),regions.NB.bndry(2,:))) = 1;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.CI.bndry(1,:),regions.CI.bndry(2,:))) = 2;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.Biscay.bndry(1,:),regions.Biscay.bndry(2,:))) = 3;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.WEB.bndry(1,:),regions.WEB.bndry(2,:))) = 4;
CC.Region(inpolygon(CC.SSHMaxLongitude,CC.SSHMaxLatitude,regions.Med.bndry(1,:),regions.Med.bndry(2,:))) = 5;

clear dd

%% Figure 1a

run figure_1a

%% Figure 1b

run figure_1b

%% Figure 2

run figure_2

%% Figure 3

run figure_3abc

%% Figure 6

run figure_6

%% Figure 7

run figure_7

%% Figure 8

run figure_8

%% Figure 9 to 13 

run figure_9
run figure_10
run figure_11
run figure_12
run figure_13

%% Figure 14

run figure_14

%% Figure S2

run figure_S2