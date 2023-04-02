function d = compute_d(alpha_a, beta_a, alhpa_b, beta_b)
% alpha: 纬度
% beta: 经度
R = 6.3714e6;
d = R * acos(cos(alpha_a/180*pi-alhpa_b/180*pi)*cos(beta_a/180*pi)*cos(beta_b/180*pi) + sin(alpha_a/180*pi)*sin(alhpa_b/180*pi));

end