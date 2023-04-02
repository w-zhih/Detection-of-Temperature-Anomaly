function differ = compute_temp(data, No1, No2)

differ = 0;
for i = 1:31
    differ = differ + (data(No1,i+1)-data(No2,i+1))^2;
end
differ = differ / 31;
end