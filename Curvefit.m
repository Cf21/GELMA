function [paramfull,FitData,Final, Res] = gelmafit(ExpData,beta0,GAparam, LMAparam)
%% INPUTS
% ExpData = [Frequency, Real, Imaginary]
% beta0 = Initialization function
% GAparam = [fit_thresh, max_gen]
% LMAparam = [RandSeed, Stages]


FrequencyHz = ExpData(:,1);
TraceRs = ExpData(:,2);
TraceXs = ExpData(:,3);


%TOP GA call
% load data:   load('Datafull.mat','f1','TraceRs','TraceXs')

%% SETUP

%Bounds for all 11 variables for GA.
%1:Rs 2:Qb 3:alpha_b 4:Rb 5:Q_W 6:B 7:Q_h 8:alpha_h 9:R_int 10:Q_a 11:alpha_a
L = [beta0(1)*0.5 beta0(2)*1e-3  0   beta0(4)*1e-1 beta0(5)*1e-3 beta0(6)*1e-2 beta0(7)*1e-3  0   beta0(9)*1e-1  beta0(10)*1e-2 0];
U = [beta0(1)*1.5 beta0(2)*1e3  1   beta0(4)*1e1 beta0(5)*1e3 beta0(6)*1e2 beta0(7)*1e3  1   beta0(9)*1e1  beta0(10)*1e2 1];


%GA operating params
fit_thresh = 0.015;
max_gen = 500;

%LMA params
RandSeed = "N"; %Random seeding, N for no, Y for yes
Stages = 3; % number of 3-stage iterations





%% Phase 1: Genetic Algorithm Fit 
[DNA,raw_fit] = EIS_curvefit(FrequencyHz,TraceRs,TraceXs,L,U,fit_thresh,max_gen)




%% Phase 2: Running 3-Stage fit

[FitData,paramfull,Final,Res] = CNLS_fit(FrequencyHz,TraceRs,TraceXs, DNA ,RandSeed, Stages);


%% PLOTTING


figure(2)
semilogx(FrequencyHz,FitData(:,1),FrequencyHz, -FitData(:,2), FrequencyHz,TraceRs, FrequencyHz, -TraceXs )
legend on
xlabel('Frequency (Hz)');
ylabel('Z');
title('Fitted Parameters');
legend('real fit','imaginary fit', 'real data', 'imag data')


figure(3)
hold on
plot(FitData(:,1), -FitData(:,2), 'ob')
plot(TraceRs, -TraceXs, 'x');
xlabel('Zreal');
ylabel('Zimag');
title('Nyquist Plot');
legend('Fitted')

legend('Fitted', 'Experimental')

end
