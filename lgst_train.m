function [all_theta] = lgst_train(X, y, num_labels, lambda,color_set)

	m = size(X, 1);
	n = size(X, 2);


	all_theta = zeros( n + 1,num_labels);
	X = [ones(m, 1) X];

	for c = 1:num_labels
    	init_theta = zeros(n + 1, 1);
    	options = optimset('GradObj', 'on', 'MaxIter', 50);
    	[theta] = fminunc (@(t)(CostFunction(t, X, (y == color_set(c)), lambda)), init_theta, options);
    	all_theta(:,c) = theta;
	end;

end