function [DNA,rawfit] = EIS_curvefit(f,TraceRs,TraceXs,L,U,fit_thresh,max_gen,seed)

%% GA PARAMETERS (can be modified)

pop_size = 1000;
mutn_rate = 0.09;
keep_top_percent = 5;
n = 4;

%% PARAMETER BOUNDS
% Bounds = [ L1  L2  L3 ...  L11 ]
%          [ U1  U2  U3 ...  U11 ]
% %    R_S  Q_b  a_b  R_b  Q_W   B   Q_H  a_H  R_int Q_ads  a_ads
% L = [.5E1 1E-9  0   1E02 1E-5 1E-3 1E-7  0   1E02  1E-6    0];
% U = [.5E2 1E-6  1   1E03 1E-3 1E00 1E-4  1   1E03  1E-4    1];
bounds = [L; U];

%% Genetic Algorithm

% Initialize bext fit DNA vector
DNA = zeros(1,11);

% Set-up progress plot of GA
figure()
set(gcf,'Position',[500 500 1000 500])
hold on
grid on
ylim([0 inf])
xlim([0 inf])
title({'Genetic Algorithm Progess',['Population: ' num2str(pop_size) ' , Mutation Rate: ' num2str(mutn_rate*100) '% , Keep Fittest: ' num2str(keep_top_percent) '% , n = ' num2str(n)]})
ylabel('Raw Fitness Score')
xlabel('Generation')
red = plot(0,0,'r.','MarkerSize',10);
blue = plot(0,0,'b.','MarkerSize',10);
drawnow()
lgd = legend([red blue],{'Peak Fitness','Average Fitness'});
lgd.Location = 'southeast';
lgd.AutoUpdate = 'off';

% Initialize population
gen = 0;
pop = zeros(pop_size,11);
if seed == 0
    for i = 1:pop_size
        for j = 1:11
            pop(i,j)= (bounds(2,j)-bounds(1,j)).*rand() + bounds(1,j);
        end
    end
else
    pop(1,:) = seed;
    for k = 2:pop_size 
        % Mutate seed based on mutation rate
        child = EIS_mutate(seed,mutn_rate,bounds);
        
        % Add to pop
        pop(k,:) = child;
    end
end

% GA loop
while true
    
    % Iterate generation count
    gen = gen + 1;
    
    % Evaluate fitness
    [fitness,avg_fitness] = EIS_eval_fitness(pop,pop_size,f,TraceRs,TraceXs);
    
    % Sort by fitness score (best fitness to worst)
    pop = cat(2,pop,fitness);
    pop = sortrows(pop,12,'descend');
    fitness = pop(:,12);
    pop(:,12) = [];
    
    % Display avg/max fitness once every 100 generations
    if mod(gen,100) == 0
        %figure(1)
        plot(gen,avg_fitness,'b.','MarkerSize',10)
        plot(gen,fitness(1),'r.','MarkerSize',10)
        drawnow()
    end
    
    % If max generations exceeded or fitness threshold reached, stop
    if (gen >= max_gen) || (fitness(1) > fit_thresh)
        plot(gen,avg_fitness,'b.','MarkerSize',10)
        plot(gen,fitness(1),'r.','MarkerSize',10)
        drawnow()
        break
    end
    
    % Initiate next generation
    next_gen = zeros(pop_size,11);
    
    % Keep fittest population members according to top percentage
    keep = pop_size*(keep_top_percent/100);
    kept = 0;
    while kept < keep
        kept = kept + 1;
        next_gen(kept,:) = pop(kept,:);
    end
    
    % Generate probability for parent selection
    prob = EIS_gen_prob(fitness,n);
    
    for k = kept+1:2:pop_size %for k = kept+1:2:population_size
        % Parent Selection
        parent1 = EIS_select_parent(pop,prob);
        parent2 = EIS_select_parent(pop,prob);
        while parent1 == parent2
            parent2 = EIS_select_parent(pop,prob);
        end
        
        % Crossover randomly for each DNA element
        crossover = randi([0,1],1,11);
        
        % Generate 2 children from 2 parents & crossover
        [child1,child2] = EIS_gen_children(parent1,parent2,crossover);
        
        % Mutate children based on mutation rate
        child1 = EIS_mutate(child1,mutn_rate,bounds);
        child2 = EIS_mutate(child2,mutn_rate,bounds);
        
        % Add to new population (next generation)
        next_gen(k,:) = child1;
        if k+1 <= pop_size
            next_gen(k+1,:) = child2;
        end
    end
    
    % Assign next generation
    pop = next_gen;
    
end

DNA(1,:) = pop(1,:);
rawfit = fitness(1);

end