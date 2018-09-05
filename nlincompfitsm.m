function [beta,resnorm] = nlincompfit(Z_exp_real, Z_exp_imag, fdata, beta0,lb,ub,param)
%%
%real_data= real impedance data
%imag_data= Xs
%fdata = frequency data
%ub/lb = upper and lower bounds respectively of the fitting parameters
%(vectors)
% 
%%


%Take Experimental data and organize it or lsqdualfit
%for 
x_cell = {fdata, fdata};
y_cell = {Z_exp_real, Z_exp_imag};


syms f
b = sym('b', [1 5]);

Xin =param(1)+(b(1).*(1i.*f).^(param(3))+(param(4)+(b(2).*(1i.*f).^0.5).^(-1).*coth(b(3).*(1i*f).^0.5)...
    + (b(4).*(1i.*f).^param(8)+(param(9)+(b(5).*(1i.*f).^param(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);...
    
Zfreal = real(Xin);
Zfimag = imag(Xin);



ZRfcn = matlabFunction(Zfreal);
mdlreal = @(b,f) ZRfcn(b(1), b(2), b(3), b(4), b(5), f);

ZIfcn = matlabFunction(Zfimag);
mdlimag = @(b,f) ZIfcn(b(1), b(2), b(3), b(4), b(5), f);


mdl_cell = {mdlreal, mdlimag};





[beta1,resnorm] = lsqdualfit(x_cell, y_cell, mdl_cell, beta0,lb,ub);

% f1=fdata;                
% Xfit =beta1(1)+(beta1(2).*1e-5.*(1i.*f1).^(beta1(3))+(beta1(4)+(beta1(5).*(1i.*f1).^0.5).^(-1).*coth(beta1(6).*(1i*f1).^0.5)...
%     + (beta1(7).*(1i.*f1).^beta1(8)+(beta1(9)+(beta1(10).*1e-1.*(1i.*f1).^beta1(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);
% 
% RealFit=real(Xfit)
% ImagFit=imag(Xfit)
%                 
% x=10
% figure(3)
% legend on
% xlabel('Frequency (Hz)');
% ylabel('Z');
% title('Fitted Parameters');
% legend('real fit','imaginary fit', 'real data', 'imag data')
% semilogx(f1,RealFit,f1, -ImagFit, f1,Z_exp_real, f1, -Z_exp_imag )
% 
% figure(4)
% xlabel('Zreal');
% ylabel('Zimag');
% title('Nyquist Plot');
% legend('Fitted')
% hold on
% plot(RealFit,-ImagFit, 'ob')
% plot(Z_exp_real, -Z_exp_imag, 'or');
% legend('Fitted', 'Experimental')

beta=beta1;

% fprintf(' Rs = %f \n Qb = %f E-5 \n alpha_b = %f \n Rbulk = %f \n Qw = %f \n B = %f \n Qh = %f \n alpha_h = %f \n Rint = %f \n Qa = %f E-1 \n alpha_a = %f \n',beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8),beta(9),beta(10),beta(11));


%end %end for loop

%end