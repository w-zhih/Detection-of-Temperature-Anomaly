clear; clc; close all;

load('data.mat');

k = 8;
right_n = 0;

outlier = [];  % 用来记录异常点

for t = 1:150*31

test_data = data;
test_data(ceil(t/31),mod(t-1, 31) + 2) = test_data(ceil(t/31),mod(t-1, 31) + 2) + 20;
[f, W] = construct_graph(test_data, k);

f_filtered = zeros(150*31,1);
for i = 1:31*150
    weight = W(i,:);
    weight(i) = 1;
    weight = weight / sum(weight);
    f_filtered(i) = weight * f;
end

noise = f - f_filtered;

[val, idx] = max(noise);
if idx == t
    right_n = right_n + 1;
else
    outlier = [outlier;t,noise(t),idx,val];
    disp(t + ","+ find(noise>noise(t)));
end

if mod(t,15) == 0
    disp(right_n + "/" + t);
end



end

disp("Accuracy:" + right_n/150/31);
