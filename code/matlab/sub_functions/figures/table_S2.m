%% table_S2
% Sub-function of Irish_Tuna.m; calculate residency of each tag in each
% region

%% Count occurrences in each region

tbl_S2 = groupcounts(META,{'TOPPid','Region'},'IncludeEmptyGroups',true);
tbl_S2 = removevars(tbl_S2, 'Percent');
tbl_S2 = unstack(tbl_S2,'GroupCount','Region');
tbl_S2 = renamevars(tbl_S2,{'x0','x1','x2','x3','x4','x5'},{'Outside','NB','CI','BoB','WEB','Med'});
tbl_S2 = movevars(tbl_S2, 'Outside', 'After', 'Med');
tbl_S2 = movevars(tbl_S2, 'NB', 'Before', 'Med');