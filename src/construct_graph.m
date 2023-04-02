function [graph_V, graph_W] = construct_graph(init_data, k)
graph_W = zeros(150*31, 150*31);
graph_V = zeros(150*31, 1);

corr_1 = zeros(150, 150);

i = 1:150;
low_lat = i(init_data(i,33)<23);
mid_lat = i(init_data(i,33)>23 & init_data(i,33)<50);
high_lat = i(init_data(i,33)>50);

% 低纬度只考虑温度差
for i = low_lat
    for j = low_lat
        if i ~= j
            temp = compute_temp(init_data, i, j);
            cor = abs(300/temp);
            corr_1(i,j) = cor;
            corr_1(j,i) = cor;
        end
    end
end

corr_2 = sum(corr_1);
out_i = corr_2>0 & corr_2<1;
corr_1(out_i,:) = 0;
out_i = find(out_i);
out_corr = zeros(150, 1);
% 离群值无法用高纬度其他数据表征，需要用中纬度数据表征
for j = mid_lat
    temp = compute_temp(init_data, out_i, j);
    out_corr(j) = abs(100 / temp);
end
out_k = sort(out_corr, 'descend');
out_k = out_k(k);
out_corr(out_corr<out_k) = 0;
corr_1(out_i,:) = out_corr;

% 高纬度只考虑温度差
mid_high_lat = [mid_lat, high_lat];
for i = high_lat
    for j = mid_high_lat
        if i ~= j
            temp = compute_temp(init_data, i, j);
            corr_1 = abs(100 / temp);
        end
    end
end



% 根据距离、纬度差\温度数据判断两气象站的相关度
for i = mid_lat
    for j = mid_lat
        if i ~= j
            d = compute_d(init_data(i,34),init_data(i,33),init_data(j,34),init_data(j,33));
            R = 6.3714e6;
            temp = compute_temp(init_data, i, j);
            cor = 100 / ((d/R-1)*5 + temp + (init_data(i,33)-init_data(j,33)));
            corr_1(i,j) = abs(cor);
        end
    end
end

corr_2 = sort(corr_1, 2, 'descend');  % 对每行进行排序
dist_k = corr_2(:,k);
% max_corr = max(corr_1, [], 2);
for i = mid_high_lat
    for j = mid_high_lat
        if corr_1(i,j)<dist_k(i)
            corr_1(i,j) = 0;
        end
    end
end


% 根据时间差、corr_1
for i = 1:150*31
    graph_V(i) = init_data(ceil(i/31), mod(i-1, 31)+2);
    for j = 1:150*31
        if i ~= j
            sta_i = ceil(i/31);
            sta_j = ceil(j/31);
            day_i = mod(i-1, 31) + 1;
            day_j = mod(j-1, 31) + 1;

            if day_i == day_j
                w = corr_1(sta_i, sta_j);
                graph_W(i,j) = w;
            elseif abs(day_i-day_j) == 1
                if sta_i == sta_j
                    graph_W(i,j) = 5;
                else
                    w = corr_1(sta_i, sta_j) * 0.2;
                    graph_W(i,j) = w;
                end
            end
        end
    end
end


end