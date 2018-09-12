function [beta,resnorm] = lsqdualfit(x_cell, y_cell, mdl_cell, beta0, lb,ub, varargin)

	
	x_vec = [];
	y_vec = [];
	mdl_vec = '@(beta,x) [';
	mdl_ind1 = 1;
	mdl_ind2 = 0;
	num_curves = length(x_cell);
	found_weights = 0;
	if ~found_weights
		wghts_cell = {};
		for ii = 1:num_curves
			wghts_cell{ii} = @(y) ones(size(y))/length(x_cell{ii});
		end
		varargin{end+1} = 'Weights';
		varargin{end+1} = wghts_cell;
	end
	
	wghts_argin_ind = 0;
	wghts_cell = {};
	for ii = 1:length(varargin)
		if strcmpi(varargin{ii}, 'weights')
			wghts_argin_ind = ii+1;
			wghts_cell = varargin{ii+1};
			if isa(wghts_cell{1}, 'function_handle')
				is_wght_func = 1;
				wghts_vec = '@(y) [';
			else
				is_wght_func = 0;
				wghts_vec = [];
			end
			break;
		end
	end
	
	for ii = 1:num_curves
		if length(x_cell{ii}) ~= length(y_cell{ii})
			error('Invalid input to NLINMULTIFIT');
		end
		if size(x_cell{ii},2) == 1
			x_cell{ii} = x_cell{ii}';
		end
		if size(y_cell{ii},2) == 1
			y_cell{ii} = y_cell{ii}';
		end
		x_vec = [x_vec, x_cell{ii}];
		y_vec = [y_vec, y_cell{ii}];
		mdl_ind2 = mdl_ind2 + length(x_cell{ii});
		mdl_vec = [mdl_vec, sprintf('mdl_cell{%d}(beta,x(%d:%d)), ', ii, mdl_ind1, mdl_ind2)];
		if ~isempty(wghts_cell)
			if is_wght_func
				wghts_vec = [wghts_vec, sprintf('wghts_cell{%d}(y(%d:%d)), ', ii, mdl_ind1, mdl_ind2)];
			else
				if size(wghts_cell{ii},2) == 1
					wghts_cell{ii} = wghts_cell{ii}';
				end
				wghts_vec = [wghts_vec, wghts_cell{ii}];
			end
		end
		mdl_ind1 = mdl_ind1 + length(x_cell{ii});
	end
	mdl_vec = [mdl_vec(1:end-2), '];'];
	mdl_vec = eval(mdl_vec);
	if ~isempty(wghts_cell)
		if is_wght_func
			wghts_vec = [wghts_vec(1:end-2), '];'];
			wghts_vec = eval(wghts_vec);
		end
		varargin{wghts_argin_ind} = wghts_vec;		
	end
		
%%,lb,ub

[beta,resnorm] = lsqcurvefit(mdl_vec,beta0,x_vec, y_vec,lb,ub,optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective', ... 
    'MaxFunctionEvaluations',50000,...%'SubproblemAlgorithm','cg','ScaleProblem', 'jacobian',...
    'MaxIterations',50000,'DiffMinChange', 1e-4 ,'FunctionTolerance',1e-10,'StepTolerance',1e-10, 'FiniteDifferenceType', 'central'));

end