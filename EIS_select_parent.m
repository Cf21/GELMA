function [parent] = EIS_select_parent(pop,prob)
%select_parent
%   chooses a parent from population according to probability
index = 1;
r = rand();
while r>0
    r = r - prob(index);
    index = index + 1;
end
index = index - 1;
parent = pop(index,:);
end

