function [] = EIS_plot(DNA,f,TraceRs,TraceXs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Z_CPE = @(Q,a,f) (Q.*(1i.*(f.*(2*pi))).^a).^-1; % general CPE impedance
Z_W = @(Q,B,f) ((Q.*sqrt(1i.*(f.*(2*pi)))).^-1).*coth(B.*sqrt(1i*(f.*(2*pi)))); % general Warburg element impedance

Z = @(f,R_S,Q_b,a_b,R_b,Q_W,B,Q_H,a_H,R_int,Q_ads,a_ads) ...
    R_S + (Z_CPE(Q_b,a_b,f).^-1 + (R_b + Z_W(Q_W,B,f) + (1./Z_CPE(Q_H,a_H,f) + 1./(R_int + Z_CPE(Q_ads,a_ads,f))).^-1).^-1).^-1;

% Generate real and imaginary curves from parameters
curve = Z(f,DNA(1),DNA(2),DNA(3),DNA(4),DNA(5),DNA(6),DNA(7),DNA(8),DNA(9),DNA(10),DNA(11));
real_curve = real(curve);
imag_curve = imag(curve);

figure()
semilogx(f,real_curve,f, -imag_curve,f,TraceRs,f, -TraceXs )
legend on
xlabel('Frequency (Hz)');
ylabel('Z');
title('Fitted Parameters');
legend('real fit','imaginary fit', 'real data', 'imag data')


figure()
hold on
plot(real_curve, -imag_curve, 'ob')
plot(TraceRs, -TraceXs, 'x');
xlabel('Zreal');
ylabel('Zimag');
title('Nyquist Plot');
legend('Fitted')

legend('Fitted', 'Experimental')


end

