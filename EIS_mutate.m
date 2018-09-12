function [child] = EIS_mutate(child,mut_rate,bounds)
%mutate
%   takes in child and mutation rate to generate a mutated child

% Loop through each parameter in the DNA
for i =1:11
    % Check for mutation
    if rand() <= mut_rate
        dice = randi([0 2],1); % roll 3 sided dice
        if dice == 0
            child(i)= (bounds(2,i)-bounds(1,i))*rand() + bounds(1,i); % randomly select new value within parameter bounds
        else
            child(i) = child(i)*normrnd(1,0.1); % increase / decrease based on normal distribution around current value
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

