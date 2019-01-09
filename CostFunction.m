

function [J, grad] = CostFunction(theta, X, y, lambda)

m = length(y); % number of training examples


J = 0;
grad = zeros(size(theta));
%代价函数
sig = sigmoid(X * theta);
cost = -y .* log(sig) - (1 - y) .* log(1 - sig);
theta(1)=0;
J = (1 / m) * sum(cost) + (lambda / (2 * m)) * sum(theta .^ 2);
%梯度
grad = (1 / m) .* (X' * (sig - y)) + (lambda / m) * theta;



grad = grad(:);

end