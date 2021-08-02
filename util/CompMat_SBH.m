function C_sbh = CompMat_SBH(structParas, materParas)
% CompMat_RFH is designed for calculation of RFH compliance matrix.
%   a and b are 

%% 初始化结构参数
l = structParas.len; h = structParas.thi; b = structParas.wid;

%% 材料属性初始化
E = materParas.E;
mu = materParas.mu;
k = materParas.k;
G = materParas.G;

A = 2*b*h;
Ix = h*(2*b)^3/12;
Iy = 2*b*h^3/12;

C_sbh = diag([l^3/(12*E*Iy), l^3/(12*E*Ix), l/(E*A), l/(E*Ix), l/(E*Iy), l/(G*(Ix+Iy))]);

end

