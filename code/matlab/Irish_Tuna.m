%% Irish Tuna
% The following runs code to process, analyze and plot data related to 
% tag deployments on tuna from Ireland.
%
% Author: Camille Pagniello, Stanford University (cpagniel@stanford.edu)
% 
% Last Update: 07/02/2023
%
%% Requirements
% Also requires m_map toolbox: https://www.eoas.ubc.ca/~rich/map.html

warning off;

% Location of Project on Google Drive
fdir = '/Users/cpagniello/Library/CloudStorage/GoogleDrive-cpagniel@stanford.edu/My Drive/Projects/Completed/IrishTuna/github/IrishTuna/';

% Colormap for Regions
% CI, BoB, WEB, NB, Med, Outside
cmap_r = [127 201 127; 255 255 153; 190 174 212; 56 108 176; 253 192 134; 128 128 128]./256;

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

%% Figure 1

run figure_1a
run figure_1b

%% Figure 2

run figure_2

%% Figure 3

run figure_3

%% Figure 4 and Tables 2, S3 & S4

run figure_4_and_tables_2_S3_S4

%% Figure 5 and Tables 2, S5 & S6

run figure_5_and_tables_2_S5_S6

%% Figure 6

run figure_6

%% Figure 7 and Table 4

run figure_7_and_table_4

%% Table S9 to S16

run table_S9_to_S16

%% Figure 8

run figure_8

%% Figure 9

run figure_9

%% Table 3 and Table S7 and S8

run table_3_and_table_S7_to_S8

%% Table S2

run table_S2

%% Figure S1

run figure_S1

%% Figure S2

run figure_S2

%% Figure S3

run figure_S3

%% Figure S4 to S6

run figure_S4_to_S6

%% Figure S7 to S11

run figure_S7_to_S11