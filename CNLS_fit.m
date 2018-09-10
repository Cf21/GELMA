function [FitData,paramfull,Final,Res] = CNLS_fit(FrequencyHz,TraceRs,TraceXs, param ,RandSeed, stage)

%% Input
% f= frequency data in Hz
% TraceRs = real experimental data
% param = initial starting DNA parameters from the GA
% TraceXs = imaginary experimental data
% RandSeed =  Option to do random seeds in with the fit generations 
%  Stages = Number of interations for the stages


%% OUTPUT
% ExpData = [Real data, Imaginary Data, Frequency]
% FitData = [Real data, Imaginary Data, Frequency]
% paramfull = List of the successful parameters at every improvement, 11
% variables and the 12th is the residual at every iteration
% Final = The successful param only
% Res = the final resual

%FrequencyHz=2*pi*FrequencyHz;
%
%resb=1e10;% The minimum residual before saving a value, 

%FrequencyHz=0.5*logspace(6,1,500);

% if RandSeed=="Y"
%     iter = 5;
%     iter2 = 5;
% else 
%     iter = 1;
%     iter2 = 1;
% end


%beta0 = param;% [Rs(i),Qb(i),alpha_b(i),R_bulk(i),Qw(i),B(i),Qh(i),alpha_h(i),Rint(i),Qa(i),alpha_a(i)];
lb = [param(1)*0.5,param(2)*0.001,0,param(4)*0.5,param(5)*0.001,param(6)*0.001,param(7)*0.001,0,param(9)*0.001,param(10)*0.001,0];
ub = [param(1)*1.5,param(2)*1000,1,param(4)*1.5,param(5)*1000,param(6)*1000,param(7)*1000,1,param(9)*1000,param(10)*1000,1];

[Final,Res] = nlincompfit(TraceRs,TraceXs,FrequencyHz,param,lb,ub);


paramfull(1:11) = Final;
%paramfull(12)=Res;
f=FrequencyHz;
Xfit =param(1)+(param(2).*(1i.*2*pi*f).^(param(3))+(param(4)+(param(5).*(1i.*2*pi*f).^0.5).^(-1).*coth(param(6).*(1i*2*pi*f).^0.5)+ (param(7).*(1i.*2*pi*f).^param(8)+(param(9)+(param(10).*(1i.*2*pi*f).^param(11)).^(-1)).^(-1)).^(-1)).^(-1)).^(-1);...
  
%% OUTPUTS

FitData(:,1) = real(Xfit);FitData(:,2) = imag(Xfit);FitData(:,3) = f;
%Final = param(:);
%Test

 %smaller number 
%paramfull=zeros((iter*2+iter2)*stage,12);
%count=1;


%%

    % for n=1:1:stage
    %     fprintf('\n Stage %i Complete. \n Best Residual is %i fit\n',n-1,resb)
    % r1 = rand(4,iter);
    % r1(1)=1;
    % r2 = rand(1,iter);
    % r2(1)=1;
    % rg = rand(11,iter);
    % rg(:,1)=1;
    % 
    % ng = randi([-2 4],11,iter);
    % ng(:,1)=1;
    % qn=randi([-2 4],4,iter);
    % qn(:,1)=0;
    % bn=randi([-2 2],1,iter);
    % bn(1)=0;
    % an=randi([30 100],3,iter)*0.01;
    % an(:,1)=1;
    % 
    % rQ=r1.*10.^qn;
    % rB=r2.*10.^bn;
    % 
    % Rs = param(1)*rg(1,:).*(2.^bn);
    % Qb = param(2)*r1(1,:).*10.^qn(1,:);
    % alpha_b = param(3)*an(1,:);
    % R_bulk = param(4)*rg(2,:).*(2.^bn);
    % Qw = param(5)*r1(2,:).*10.^qn(2,:);
    % B = param(6)*rB;
    % Qh = param(7)*r1(3,:).*10.^qn(3,:);
    % alpha_h = param(8)*an(2,:);
    % Rint = param(9)*rg(3,:).*(2.^bn);
    % Qa = param(10)*r1(4,:).*10.^qn(4,:);
    % alpha_a = param(11)*an(3,:);
    % 
    % %%
    % %%QQBQQ 
    % % Fitting to the data using following assumptions:
    % % 1) All model capacitors are linear/ideal (not CPE) TF: alpha=1
    % % 2) All resistors values are taken from the experimental data extracted
    % % approimately as shown from JWen paper (Rs curve inflection points)
    % check1=0;
    % for i=1:1:iter
    % 
    % beta0=[Qb(i),Qw(i),B(i),Qh(i),Qa(i)];
    % lb=[Qb(i)*0.01,Qw(i)*0.01,B(i)*0.01,Qh(i)*0.01,Qa(i)*0.01];
    % ub=[Qb(i)*10,Qw(i)*10,B(i)*10,Qh(i)*10,Qa(i)*10];
    % 
    % [beta1,res]=nlincompfitsm(TraceRs,TraceXs,FrequencyHz,beta0,lb,ub,param);
    % 
    % if res<resb
    %     paramfull(count,[1 3 4 8 9 11]) = param([1 3 4 8 9 11]);
    %     paramfull(count,[2 5 6 7 10]) = beta1(:);
    %     paramfull(count,12)=res;
    %     count=count+1;
    %     check1 = 1;
    %     b=beta1
    %     resb=res
    % end
    % fprintf('\n %i of %i of QQBQQ fit\n',i,iter)
    % 
    % end
    % 
    % %Updating param with successful variables from stage 1 fit
    % if check1==1
    %     param([2 5 6 7 10]) = b(:);
    % end
    % 
    % %%
    % %%Stage 2 fit with Resistive components and non-ideal 
    % % Fitting to the data using following assumptions:
    % % With initial reactive components fit, resistor values are adjusted
    % check2=0;
    % for i=1:1:iter
    %     fprintf('\n Iteration %i of %i of RARARA fit\n',i,iter)
    % 
    %     beta0=[Rs(i),alpha_b(i),R_bulk(i),alpha_h(i),Rint(i),alpha_a(i)];
    %     lb=[Rs(i)*0.8,alpha_b(i)*0.2,R_bulk(i)*0.8,alpha_h(i)*0.2,Rint(i)*0.8,alpha_a(i)*0.2];
    %     ub=[Rs(i)*1.2,1,R_bulk(i)*1.2,1,Rint(i)*1.3,1];
    % 
    %     [beta1,res]=nlincompfitrr(TraceRs,TraceXs,FrequencyHz,beta0,lb,ub,param);
    % 
    %     if res<resb
    %         paramfull(count,[2 5 6 7 10]) = param([2 5 6 7 10]);
    %         paramfull(count,[1 3 4 8 9 11]) = beta1(:);
    %         paramfull(count,12)=res;
    %         count=count+1;
    %         check2=1;
    %         b=beta1;
    %         resb=res;
    %     end
    %     fprintf('\n Iter %i Complete. \n Best Residual is %i fit\n',i,resb)
    % 
    % end
    % 
    % if check2==1
    %     param([1 3 4 8 9 11]) = b(:);
    % end
%%Stage 3 full 11 fit attempt: redistribute all params?
%%Create new searching space slightly more narrow.
    % r1 = rand(4,iter2); r1(1)=1;
    % r2 = rand(1,iter2); r2(1)=1;
    % rg = rand(11,iter2); rg(:,1)=1;
    % 
    % ng = randi([-1 1],11,iter2); ng(:,1)=1;
    % qn=randi([-1 1],4,iter2); qn(:,1)=0;
    % bn=randi([-1 1],1,iter2); bn(1)=0;
    % an=randi([50 100],3,iter2)*0.01; an(:,1)=1;
    % 
    % Rs = param(1)*rg(1,:).*(10.^bn);
    % Qb = param(2)*r1(1,:).*10.^qn(1,:);
    % alpha_b = param(3)*an(1,:);
    % R_bulk = param(4)*rg(2,:).*(10.^bn);
    % Qw = param(5)*r1(2,:).*10.^qn(2,:);
    % B = param(6)*r2.*10.^bn;
    % Qh = param(7)*r1(3,:).*10.^qn(3,:);
    % alpha_h = param(8)*an(2,:);
    % Rint = param(9)*rg(3,:).*(10.^bn);
    % Qa = param(10)*r1(4,:).*10.^qn(4,:);
    % alpha_a = param(11)*an(3,:);
    % 
    % check3 = 0;
    % for i=1:1:iter2
    % fprintf('\n Iteration %i of %i for full param fit\n',i,iter2)
    % 
    % beta0 = [Rs(i),Qb(i),alpha_b(i),R_bulk(i),Qw(i),B(i),Qh(i),alpha_h(i),Rint(i),Qa(i),alpha_a(i)];
    % lb = [Rs(i)*0.8,Qb(i)*0.1,0,R_bulk(i)*0.8,Qw(i)*0.1,B(i)*0.1,Qh(i)*0.1,0,Rint(i),Qa(i)*0.1,0];
    % ub = [Rs(i)*1.2,Qb(i)*10,1,R_bulk(i)*1.2,Qw(i)*10,B(i)*10,Qh(i)*10,1,Rint(i),Qa(i)*10,1];
    % 
    % [beta1,res] = nlincompfit(TraceRs,TraceXs,FrequencyHz,beta0,lb,ub);
    % 
    % if res<resb
    %     paramfull(count,1:11) = beta1(:);
    %     paramfull(count,12)=res;
    %     count=count+1;
    %     check=1;
    %     b=beta1;
    %     resb=res;
    % end
    % fprintf('\n Iter %i Complete. \n Best Residual is %f fit\n',i,resb)
    % 
    % %end Stage
    % 
    % %Update param
    % if check3==1
    %     param(1)=b(1);
    %     param(2)=b(2);
    %     param(3)=b(3);
    %     param(4)=b(4);
    %     param(5)=b(5);
    %     param(6)=b(6);
    %     param(7)=b(7);
    %     param(8)=b(8);
    %     param(9)=b(9);
    %     param(10)=b(10);
    %     param(11)=b(11);
    % end
    % 
    % end
    % 
    % 
    % 


               
end %Function End
