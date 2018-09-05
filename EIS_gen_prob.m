function [prob] = EIS_gen_prob(fitness,n)
%gen_prob
%   takes in fitness and linearity and generates probability for parent selection
n_fitness = (fitness).^n;
prob = n_fitness./sum(n_fitness);
end

