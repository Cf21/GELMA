

% Load frequency data (in Hz) and real / imaginary measurements

%load('Datafull.mat','f1','TraceRs','TraceXs')


% Bounds entered via lower (L) and upper (U) vectors as follows:

%    R_S  Q_b  a_b  R_b  Q_W   B   Q_H  a_H  R_int Q_ads  a_ads
L = [.5E1 1E-9  0   1E02 1E-5 1E-3 1E-7  0   1E02  1E-6    0];
U = [.5E2 1E-6  1   1E03 1E-3 1E00 1E-4  1   1E03  1E-4    1];

% Specify the raw fitness score threshold to stop the GA (raw scores seem
% to plateau around a score of 0.01)
fit_thresh = 0.015;

% Specify a cutoff for the max number of generations if the threshold score
% is not reached
%should be around 5k
max_gen = 500;

[DNA,raw_fit] = EIS_curvefit(f1,TraceRs,TraceXs,L,U,fit_thresh,max_gen)