function [child] = EIS_mutate(child,mut_rate,bounds)
%mutate
%   takes in child and mutation rate to generate a mutated child

% Loop through each parameter in the DNA
for i =1:11
    % Check for mutation
    if rand() <= mut_rate
        dice = randi([0 2],1); % roll 3 sided dice
        if dice == 0
            child(i) = child(i)*(rand() + 1); % increase parameter by up to 2x
        elseif dice == 1
            child(i) = child(i)*(0.5*rand() + 0.5); % decrease parameter by down to 0.5x
        else
            child(i)= (bounds(2,i)-bounds(1,i))*rand() + bounds(1,i); % randomly select new value within parameter bounds
        end
    end
    
    % Verify boundary conditions are not exceeded
    if child(i) > bounds(2,i)
        child(i) = bounds(2,i);
    elseif child(i) < bounds(1,i)
        child(i) = bounds(1,i);
    end
end

end

