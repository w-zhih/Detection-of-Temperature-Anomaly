k = 8;
i = 3229;
day = mod(i-1, 31) + 1;
sta = ceil(i/31);
[f, W] = construct_graph(data, k);
index = find(W(i,:));
no = ceil(index/31);
disp("Station "+sta+" Day "+day+":");
disp([data(sta,33:34),data(sta,day+1)]);
time = [];
for a = 1:length(index)
    time = [time;data(no(a),mod(index(a)-1, 31) + 2)];
end
res = [no',W(i,index)',data(no,33:34),time];
disp("Match:");
disp(res);