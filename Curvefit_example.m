%% Curvefit example script

load('Data.mat');

%% THE SETUP

%Initialization for all 11 variables for GA.
%1:Rs 2:Qb 3:alpha_b 4:Rb 5:Q_W 6:B 7:Q_h 8:alpha_h 9:R_int 10:Q_a 11:alpha_a
%This allows the upper lower bounds of everything to be determined by a
%host of initial values we already understand to be vaguely true with lots.
%we can experiment by reducing bounds later.
beta0 = [10 1e-7  0.5 100 1E-4 0.01  1E-5 0.5   1E02  1E-5    0.5];


%GA operating params
fit_thresh = 0.015;
max_gen = 50000;
seed = 0;

%LMA params
RandSeed = "N"; %Random seeding, N for no, Y for yes
Stages = 3; % number of 3-stage iterations


paramfull = 1; FitData = 1; Final = 1; Res = 1;



%Seems reduntant but valuable for larger data sets and parallizing
%experimental data runs.
ExpData(:,1) = FrequencyHz;
ExpData(:,2) = TraceRs;
ExpData(:,3) = TraceXs; 

GAparam = [fit_thresh, max_gen];
LMAparam = [RandSeed,Stages];

[paramfull,FitData,Final,DNA,Res,ResGA,L,U] = gelmafit(ExpData,beta0,GAparam,LMAparam,seed);
