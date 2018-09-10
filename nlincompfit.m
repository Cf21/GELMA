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
datafull=Z_exp_real+1i*Z_exp_imag;


syms f

%f=fdata;
b = sym('b', [1 11]);

Xin =b(1)+(b(2).*(1i.*2*pi*f).^(b(3))+(b(4)+(b(5).*(1i.*2*pi*f).^0.5).^(-1).*coth(b(6).*(1i*2*pi*f).^0.5)...
    + (b(7).*(1i.*2*pi*f).^b(8)+(b(9)+(b(10).*(1i.*2*pi*f).^b(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);...
    
Zfreal = real(Xin);
Zfimag = imag(Xin);

Zfcnfull= matlabFunction(Xin);
mdlfull = @(b,f) Zfcnfull(b(1), b(2), b(3), b(4), b(5), b(6), b(7), b(8), b(9), b(10), b(11),f);

%fun = @(r)exp(-d*r)-y;

mdlfull = @(b) b(1)+(b(2).*(1i.*2*pi*f).^(b(3))+(b(4)+(b(5).*(1i.*2*pi*f).^0.5).^(-1).*coth(b(6).*(1i*2*pi*f).^0.5)...
    + (b(7).*(1i.*2*pi*f).^b(8)+(b(9)+(b(10).*(1i.*2*pi*f).^b(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);... ;

ZRfcn = matlabFunction(Zfreal);
mdlreal = @(b,f) ZRfcn(b(1), b(2), b(3), b(4), b(5), b(6), b(7), b(8), b(9), b(10), b(11), f);

ZIfcn = matlabFunction(Zfimag);
mdlimag = @(b,f) ZIfcn(b(1), b(2), b(3), b(4), b(5), b(6), b(7), b(8), b(9), b(10), b(11), f);



mdl_cell = {mdlreal, mdlimag};


%[beta1,resnorm] = lsqnonlin(mdlfull,beta0,fdata, y_cell, lb,ub)%optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ... 
 %   'MaxFunctionEvaluations',50000, 'MaxIterations',50000,'DiffMinChange', 1e-6 ,'FunctionTolerance',1e-10, ...
  %  'StepTolerance',1e-10 ,'ScaleProblem', 'jacobian', 'FiniteDifferenceType', 'central'));

[beta1,resnorm] = lsqdualfit(x_cell, y_cell, mdl_cell, beta0,lb,ub);

beta=beta1;


end