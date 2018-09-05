%Curvefit statistics

%Will run the loop n times and see the deviation on the results.

%
%
n=50;
p2paramlist=zeros(n,12);
p1paramlist=zeros(n,12);

%% THE SETUP

load('Data.mat');


for i=1:1:n
tic
beta0 = [10 1e-4  0.5 100 1E-4 0.01  1E-4 0.5   1E02  1E-5    0.5];

%GA operating params
fit_thresh = 0.015;
max_gen = 2500;



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

[paramfull,FitData,Final,GAfinal ,Res, ResGA] = gelmafit(ExpData,beta0,GAparam, LMAparam);


p2paramlist(i,1:11) = Final(1:11);
p2paramlist(i,12) = Res;
p1paramlist(i,1:11) = GAfinal(1:11);
p1paramlist(i,12) = ResGA;

n
toc
end
