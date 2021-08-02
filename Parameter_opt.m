clc
clear all

%% Load path
addpath('./util');

%% Define the parameters to be optimized
rng_l = [2, 6]*1e-3;   % range of length (l)
rng_w = [8, 12]*1e-3;   
rng_t = [2, 4]*1e-3;
scal_l = rng_l(2)-rng_l(1);
scal_w = rng_w(2)-rng_w(1);
scal_t = rng_t(2)-rng_t(1);
a = 4e-3;  b = 2e-3;

beta = 0:0.2:1;
nbr = size(beta,2);
Cyf_t = zeros(1,nbr);     Cyf_w = zeros(1,nbr);     Cyf_l = zeros(1,nbr);
Cym_t = zeros(1,nbr);     Cym_w = zeros(1,nbr);     Cym_l = zeros(1,nbr);

%% Define material properties (aluminum alloy)
materParas = struct('E',7.1e10,'mu',0.33);
materParas.k = (12+11*materParas.mu)/(10+10*materParas.mu);
materParas.G = 2.669e10;

%% Variation of compliance relative to thickness (t)
for i = 1:nbr
    
    l = rng_l(1)+scal_l/2;
    w = rng_w(1)+scal_w/2;
    t = rng_t(1)+scal_t*beta(i);
    
    structParas = struct('a',a,'b',b,'len',l,'thi',t,'wid',w);
    
    C_s = CompMat_ERFH(structParas, materParas);
    Cyf_t(i) = C_s(2,2);
    Cym_t(i) = C_s(2,6);
end

%% Variation of compliance relative to width (t)
for i = 1:nbr
    
    l = rng_l(1)+scal_l/2;
    w = rng_w(1)+scal_w*beta(i);
    t = rng_t(1)+scal_t/2;
    
    structParas = struct('a',a,'b',b,'len',l,'thi',t,'wid',w);
    
    C_s = CompMat_ERFH(structParas, materParas);
    Cyf_w(i) = C_s(2,2);
    Cym_w(i) = C_s(2,6);
end

%% Variation(-) of compliance relative to length (l)
for i = 1:nbr
    
    l = rng_l(2)-scal_l*beta(i);
    w = rng_w(1)+scal_w/2;
    t = rng_t(1)+scal_t/2;
    
    structParas = struct('a',a,'b',b,'len',l,'thi',t,'wid',w);
    
    C_s = CompMat_ERFH(structParas, materParas);
    Cyf_l(i) = C_s(2,2);
    Cym_l(i) = C_s(2,6);
end

%% results display (Variation trend of compliance factors, C_y^F and C_y^M, in terms of t, w and l.)
figure('Name','fig.4')
subplot(2,2,1)
plot1 = plot(beta, Cyf_t, beta, Cyf_w, beta, Cyf_l,'MarkerSize',9,'LineWidth',1.3);
set(plot1(1),'DisplayName','Cy F(t)','Marker','diamond','Color',[1 0 0]);
set(plot1(2),'DisplayName','Cy F(w)','Marker','^','Color',[0 0 0]);
set(plot1(3),'DisplayName','Cy F(l)','Marker','square','Color',[0 0 1]);
xlabel('\beta , Variable Scale','FontSize',16, 'FontName','Times New Roman');
ylabel('Linear Compliance \Delta_y/F_y','FontSize',16,'FontName','Times New Roman');
legend('Cy F(t)', 'Cy F(w)', 'Cy F(l)')
set(legend, 'LineWidth', 0.5, 'FontSize',11, 'FontName','Times New Roman');
ax = gca;
ax.LineWidth = 1.5;
box(ax, 'on');

subplot(2,2,2)
plot2 = plot(beta, Cym_t, beta, Cym_w, beta, Cym_l,'MarkerSize',9,'LineWidth',1.3);
set(plot2(1),'DisplayName','Cy F(t)','Marker','diamond','Color',[1 0 0]);
set(plot2(2),'DisplayName','Cy F(w)','Marker','^','Color',[0 0 0]);
set(plot2(3),'DisplayName','Cy F(l)','Marker','square','Color',[0 0 1]);
xlabel('\beta , Variable Scale','FontSize',16, 'FontName','Times New Roman');
ylabel('Linear Compliance \Delta_y/F_y','FontSize',16,'FontName','Times New Roman');
ax = gca;
ax.LineWidth = 1.5;
box(ax, 'on');

%% Caculate compliance factors, C_x^F and C_z^F, in terms of w and l.
delta = 0:0.05:1;
t = 3.2e-3;
nbr1 = size(delta, 2);
Cxf = zeros(nbr1, nbr1);
Czf = zeros(nbr1, nbr1);

for i = 1:nbr1
    l = rng_l(1)+scal_l*delta(i);
    for j = 1:nbr1
        
        w = rng_w(1)+scal_w*delta(j);
        
        structParas = struct('a',a,'b',b,'len',l,'thi',t,'wid',w);
        
        C_s = CompMat_ERFH(structParas, materParas);
        Cxf(j,i) = C_s(1,1);
        Czf(j,i) = C_s(3,3);
    end
end

%% results display (Compliance factors, C_x^F and C_z^F, in terms of w and l.)
[X_l, Y_w] = meshgrid(rng_l(1):scal_l*0.05:rng_l(2), rng_w(1):scal_l*0.05:rng_w(2));
subplot(2,2,3)
mesh(X_l, Y_w, Cxf);
xlabel('l','FontAngle','italic','FontSize',16,'FontName','Times New Roman');
ylabel('w','FontAngle','italic','FontSize',16,'FontName','Times New Roman');
zlabel('\Delta_x/F_x','FontSize',14,'FontName','Times New Roman');
box on;
subplot(2,2,4)
plot4 = mesh(X_l, Y_w, Czf);
xlabel('l','FontAngle','italic','FontSize',16,'FontName','Times New Roman');
ylabel('w','FontAngle','italic','FontSize',16,'FontName','Times New Roman');
zlabel('\Delta_z/F_z','FontSize',14,'FontName','Times New Roman');
box on;


