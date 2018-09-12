%% PARAMETERS

% Load measured data
load('Data.mat')

% Set thresholds / seeds
fit_thresh = 0.015;
max_gen = 10;
seed = 0;
runs = 2;
plot_freq = 1;


% Set parameter bounds
L = [15,1e-9,0.8,1e2,1e-5,1e-3,1e-7,0.0,1e2,1e-6,0.0];
U = [20,1e-6,1.0,1e3,1e-3,1e00,1e-4,1.0,1e5,1e-2,1.0];


%% GA OUTPUTS

DNA_multi_run = zeros(runs,11);
fitness_multi_run = zeros(runs,1);
fit_hist_multi_run = zeros(ceil(max_gen/plot_freq),runs*3);

for i = 1:runs
    l = i*3;
    k = l-1;
    j = l-2;
    [DNA_multi_run(i,:),fitness_multi_run(i),fit_hist_multi_run(:,[j k l])] = EIS_curvefit(FrequencyHz,TraceRs,TraceXs,L,U,fit_thresh,max_gen,seed,plot_freq);
    %close all
end

%% STATISTICS

DNA_avg = mean(DNA_multi_run);
DNA_std_dev = std(DNA_multi_run);
DNA_percent_variation = zeros(runs,11);
for i = 1:runs
    DNA_percent_variation(i,:) = (abs(DNA_multi_run(i,:) - DNA_avg)./DNA_avg)*100;
end

%% PLOTTING
%{
for i = 1:runs
    EIS_plot(DNA_multi_run(i,:),FrequencyHz,TraceRs,TraceXs)
end
%}