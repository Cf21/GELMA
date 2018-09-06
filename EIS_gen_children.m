function [child1,child2] = EIS_gen_children(parent1,parent2,crossover)
%gen_children
%   takes in 2 parents and the crossover form and generates 2 children
child1 = zeros(1,11);
child2 = zeros(1,11);
for i = 1:11
    if crossover(i)
        child1(i) = parent1(i);
        child2(i) = parent2(i);
    else
        child1(i) = parent2(i);
        child2(i) = parent1(i);
    end
end
end

