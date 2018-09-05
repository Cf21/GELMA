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
x_cell = {fdata*2*pi, fdata*2*pi};
y_cell = {Z_exp_real, Z_exp_imag};


syms f
b = sym('b', [1 6]);

Xin =b(1)+(param(2).*(1i.*f).^(b(2))+(b(3)+(param(5).*(1i.*f).^0.5).^(-1).*coth(param(6).*(1i*f).^0.5)...
    + (param(7).*(1i.*f).^b(4)+(b(5)+(param(10).*(1i.*f).^b(6)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);...
    
Zfreal = real(Xin);
Zfimag = imag(Xin);



ZRfcn = matlabFunction(Zfreal);
mdlreal = @(b,f) ZRfcn(b(1), b(2), b(3), b(4), b(5), b(6), f);

ZIfcn = matlabFunction(Zfimag);
mdlimag = @(b,f) ZIfcn(b(1), b(2), b(3), b(4), b(5), b(6), f);


mdl_cell = {mdlreal, mdlimag};



[beta1,resnorm] = lsqdualfit(x_cell, y_cell, mdl_cell, beta0,lb,ub);



beta=beta1;
