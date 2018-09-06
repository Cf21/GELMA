function [fitness,avg] = EIS_eval_fitness(pop,pop_size,f,real_data,imag_data)
%eval_fitness
%   accepts a population, evaluates the fitness, and returns fitness scores

%% CURVE DEFINITIONS FOR FIT
Z_CPE = @(Q,a,f) (Q.*(1i.*(f.*(2*pi))).^a).^-1; % general CPE impedance
Z_W = @(Q,B,f) ((Q.*sqrt(1i.*(f.*(2*pi)))).^-1).*coth(B.*sqrt(1i*(f.*(2*pi)))); % general Warburg element impedance

Z = @(f,R_S,Q_b,a_b,R_b,Q_W,B,Q_H,a_H,R_int,Q_ads,a_ads) ...
    R_S + (Z_CPE(Q_b,a_b,f).^-1 + (R_b + Z_W(Q_W,B,f) + (1./Z_CPE(Q_H,a_H,f) + 1./(R_int + Z_CPE(Q_ads,a_ads,f))).^-1).^-1).^-1;

%% FITNESS SCORING

% Initialize Fitness Score vector
fitness = zeros(pop_size,1);

% Evaluate fitness of every population member
for i = 1:pop_size
    
    % Generate real and imaginary curves from parameters
    curve = Z(f,pop(i,1),pop(i,2),pop(i,3),pop(i,4),pop(i,5),pop(i,6),pop(i,7),pop(i,8),pop(i,9),pop(i,10),pop(i,11));
    real_curve = real(curve);
    imag_curve = imag(curve);
    
    % Perform simultaneous Chi squared summation for both real and imaginary curves
    for j = 1:size(curve)
        fitness(i) = fitness(i) + ((real_data(j)-real_curve(j))^2)/abs(real_curve(j)) + ((imag_data(j)-imag_curve(j))^2)/abs(imag_curve(j));
    end
end

% Invert simultaneous Chi squared sum to create maximization problem and raw fitness score
fitness = 1./fitness;
avg = mean(fitness);

end