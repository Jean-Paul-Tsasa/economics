% This file extracts the cyclical components and calculates the empirical moments
% This implementation was written by Jean-Paul K. Tsasa
% In case you spot mistakes, email us at tsasa.jean-paul@uqam.ca
 %
 %
 % Copyright (C) 2017 Tsasa.
 %
%This MatLab program uses the following functions or files hpf.m, bpf.m and filtk.m
%
%Step0: Put the following files in the same folder called DATA_EXCUT 
%(you are free to change the name)
	%MatLab file1: hpf.m 	%for HP filter
	%MatLab file2: bpf.m	%for BP filter
	%MatLab file3: filtk.m	%for BP filter

%Step1: Then put your EXCEL data file in DATA_EXCUT folder

%%Say: data_input.xlsx

%%Note: data.xlsx file contains data in log
%Also data.xlsx contains the padding data (apply moving average for 12 periods)
%PADDING DATA because we will apply a symmetric BP filter with K = 12

%Step2: Load the EXCEL and specify the NAME of file and the RANGE
%For instance:
y = xlsread('data_input','data_log','A1:Z124')

%Step3: Save your MAT file

save y

%Step4: First differenced (FD) filter
%Define the lagged series by dropping the last observation
ylag = y(1:123,:)

%Subtract the lag series from the current series
%yfd: first-differenced series

yfd = y(2:124,:) - ylag

%Step5: Hodrick-Prescott (HP) filter
%The m-file creating HP filter is hpf.m
%Filter series by specifying the arguments in the function: g=hpf(y,lam) 
%y: original series 
%g: name of the growth component of the filtered series 
%lam is the smoothing parameter 
%Ravn and Uhlig (2002, REStat) recommends setting ?lam? at 
%1600 for the quarterly frequency
%6.25 for the annual frequency
%yhp: name of the filtered series (cyclical component)

yhp = y-hpf(y,1600)

%Step6: BP FILTER
%The m-file creating HP filter is bpf.m
%Filter series by specifying the arguments in the function: yf=bpf(y,up,dn,K)
%y: original series
%up: minimum periodicity of the cyclical component
%dn: maximum periodicity of the cyclical component
%K: number of the leads/lags 
%we applied a truncation lag parameter of K=12 (standard)
%ybp: name of the filtered series (cyclical component)

 ybp = bpf(y,6,32,12)

%Step7: Empirical moment filter
%Note: Now consider the DEPADDING DATA
%%Say: data_input_dep.xlsx
%%data_input_dep.xlsx file come from the following MAT files: 
	%yfd: FD filtered data
	%yhp: HP filtered data
	%ybp: BP filtered data

%Step8: Load the EXCEL deppading data and specify the NAME of file and the RANGE

yfd_dep = xlsread('data_input_dep','filtered_data','A1:Z99')
save yfd_dep

yhp_dep = xlsread('data_input_dep','filtered_data','A101:Z200')
save yhp_dep

ybp_dep = xlsread('data_input_dep','filtered_data','A201:Z300')
save ybp_dep

%Standard deviation
std_fd = std(yfd_dep) %fd filter 
std_hp = std(yhp_dep) %hp filter
std_bp = std(ybp_dep) %bp filter

%Correlation coefficient
R_fd = corrcoef (yfd_dep) %fd filter
R_hp = corrcoef(yhp_dep) %hp filter
R_bp = corrcoef(ybp_dep) %bp filter
