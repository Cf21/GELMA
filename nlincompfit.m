function [beta,resnorm] = nlincompfit(Z_exp_real, Z_exp_imag, fdata, beta0,lb,ub)
%%
%real_data= real impedance data
%imag_data= Xs
%fdata = frequency data
%ub/lb = upper and lower bounds respectively of the fitting parameters
%(vectors)
% 
%%


%Take Experimental data and organize it or lsqdualfit
x_cell = {fdata, fdata};
y_cell = {Z_exp_real, Z_exp_imag};


syms f
b = sym('b', [1 11]);

Xin =b(1)+(b(2).*(1i.*f).^(b(3))+(b(4)+(b(5).*(1i.*f).^0.5).^(-1).*coth(b(6).*(1i*f).^0.5)...
    + (b(7).*(1i.*f).^b(8)+(b(9)+(b(10).*(1i.*f).^b(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);...
    
Zfreal = real(Xin);
Zfimag = imag(Xin);



ZRfcn = matlabFunction(Zfreal);
mdlreal = @(b,f) ZRfcn(b(1), b(2), b(3), b(4), b(5), b(6), b(7), b(8), b(9), b(10), b(11), f);

ZIfcn = matlabFunction(Zfimag);
mdlimag = @(b,f) ZIfcn(b(1), b(2), b(3), b(4), b(5), b(6), b(7), b(8), b(9), b(10), b(11), f);


mdl_cell = {mdlreal, mdlimag};





[beta1,resnorm] = lsqdualfit(x_cell, y_cell, mdl_cell, beta0,lb,ub);

beta=beta1;


end