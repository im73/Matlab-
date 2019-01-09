function p = lgst_predict(all_theta, X)

m = size(X, 1);
num_labels = size(all_theta, 1);
p = zeros(size(X, 1), 1);
X = [ones(m, 1) X];



sig = sigmoid(X * all_theta);
[maxSig, maxSig_2] = max(sig');
p = maxSig_2';



end