function [paramfull,FitData,Final,DNA,Res,ResGA,L,U,fit_hist] = gelmafit(ExpData,beta0,GAparam,LMAparam,seed)
%% INPUTS
% ExpData = [Frequency, Real, Imaginary]
% beta0 = Initialization function
% GAparam = [fit_thresh, max_gen];
% LMAparam = [RandSeed, Stages];


FrequencyHz = ExpData(:,1);
TraceRs = ExpData(:,2);
TraceXs = ExpData(:,3);


%TOP GA call
% load data:   load('Datafull.mat','f1','TraceRs','TraceXs')

%% SETUP

%Bounds for all 11 variables for GA.
%1:Rs 2:Qb 3:alpha_b 4:Rb 5:Q_W 6:B 7:Q_h 8:alpha_h 9:R_int 10:Q_a 11:alpha_a
% L = [beta0(1)*0.5 beta0(2)*1e-2  0   beta0(4)*1e-1 beta0(5)*1e-2 beta0(6)*1e-2 beta0(7)*1e-2  0   beta0(9)*1e-1  beta0(10)*1e-2 0];
% U = [beta0(1)*5   beta0(2)*1e2   1   beta0(4)*1e1  beta0(5)*1e2  beta0(6)*1e2  beta0(7)*1e2   1   beta0(9)*1e1   beta0(10)*1e2  1];
L = [15,1e-9,0.8,1e2,1e-5,1e-3,1e-7,0.0,1e2,1e-6,0.0];
U = [20,1e-6,1.0,1e3,1e-3,1e00,1e-4,1.0,1e5,1e-2,1.0];

%GA operating paramsyou
% fit_thresh = 0.015;
% max_gen = 500;
fit_thresh = GAparam(1);
max_gen = GAparam(2);
plot_freq = 100;

% %LMA params
RandSeed = "N"; %Random seeding, N for no, Y for yes
Stages = 3; % number of 3-stage iterations
% RandSeed = LMAparam(1);
% Stages = LMAparam(2);



%% Phase 1: Genetic Algorithm Fit 
[DNA,raw_fit,fit_hist] = EIS_curvefit(FrequencyHz,TraceRs,TraceXs,L,U,fit_thresh,max_gen,seed,plot_freq);

ResGA = 1/raw_fit;

%% Phase 2: Running 3-Stage fit

[FitData,paramfull,Final,Res] = CNLS_fit(FrequencyHz,TraceRs,TraceXs, DNA ,RandSeed, Stages);


%% PLOTTING
f=FrequencyHz;

GAfit =DNA(1)+(DNA(2).*(1i.*2*pi*f).^(DNA(3))+(DNA(4)+(DNA(5).*(1i.*2*pi*f).^0.5).^(-1).*coth(DNA(6).*(1i*2*pi*f).^0.5)+ (DNA(7).*(1i.*2*pi*f).^DNA(8)+(DNA(9)+(DNA(10).*(1i.*2*pi*f).^DNA(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);...
 


figure()
semilogx(FrequencyHz,FitData(:,1),FrequencyHz, -FitData(:,2), FrequencyHz,TraceRs, FrequencyHz, -TraceXs )
legend on
xlabel('Frequency (Hz)');
ylabel('Z');
title('Fitted Parameters');
legend('real fit','imaginary fit', 'real data', 'imag data')


figure()
hold on
plot(FitData(:,1), -FitData(:,2), 'ob',real(GAfit),-imag(GAfit))
plot(TraceRs, -TraceXs, 'x');
xlabel('Zreal');
ylabel('Zimag');
title('Nyquist Plot');
legend('Fitted')

legend('Fitted', 'GA fit', 'Experimental')





end
