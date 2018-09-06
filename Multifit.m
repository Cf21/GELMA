%% Curvefit example script

load('Data.mat');

%% THE SETUP




beta0 = [10 1e-7  0.5 100 1E-4 0.01  1E-5 0.5   1E02  1E-5    0.5];


%GA operating params
fit_thresh = 0.015;
max_gen = 50000;


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

%Run the fit multiple times

for i
    tic

    [paramfull,FitData,Final,DNA,Res,ResGA,L,U] = gelmafit(ExpData,beta0,GAparam, LMAparam);


    toc
end