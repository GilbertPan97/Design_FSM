clc
clear all

%% Load function path
addpath('./util');
addpath(genpath('./rvctools'));

%% Kinematic parameters of flexure hinge in FSM
p1 = 85.18e-3;              p2 = 36.82e-3;
Rh(1,:) = [0, 0, 0];        Ph(1,:) = [p1, 0, 0];
Rh(2,:) = [pi/2, 0, 0];     Ph(2,:) = [p1, 0, 0];
Rh(3,:) = [0, 0, 0];        Ph(3,:) = [p2, 0, 0];
Rh(4,:) = [pi/2, 0, 0];     Ph(4,:) = [p2, 0, 0];

%% Structural dimension parameters of ERFH
structParas = struct('a',4e-3,'b',2e-3,'len',3e-3,'thi',3e-3,'wid',24e-3);
  
% Material properties of aluminum alloy
materParas = struct('E',7.1e10,'mu',0.33);
materParas.k = (12+11*materParas.mu)/(10+10*materParas.mu);
materParas.G = 2.669e10;

%% Calculation of single ERFH compliance matrix
C_s = CompMat_ERFH(structParas, materParas);


%% Analysis of deformation displacement of FSM
nbrFH = 4;
C_tmp = zeros(6,6);
C_e = zeros(6,6);
for i = 1:nbrFH
    Ad = adj_func(Rh(i,:), Ph(i,:), 1);
    Ad_t = adj_func(Rh(i,:), Ph(i,:), 3);
    C_tmp = Ad_t*C_s*Ad;
    C_e = C_e+C_tmp;
end
% Calculation of displacement
% Displacement = [D_x, D_y, D_z, R_x, R_y, R_z];
% Force = [F_x, F_y, F_z, M_x, M_y, M_z];
% tz = 133.75*1e-3;  % true
% ty = -43.5*1e-3;   % true
tz = 160.75*1e-3;
ty = -40*1e-3;
actForce = 0:12.5:100;
Fg_centr = zeros(1,6);
Disp_centr = zeros(6,size(actForce,2));
for i = 1:size(actForce,2)
    Fg_centr = [actForce(i), 0, 0, 0, actForce(i)*tz, -actForce(i)*ty];
    Disp_centr(:,i) = C_e*Fg_centr';
end

%% Get the experimental data
nbrImgs = 17;
squareSize = 10;
imgsPath = {'./imgs/left_Camera/', './imgs/right_Camera/'};
[camera1HTM, camera2HTM] = Calibrator(imgsPath, nbrImgs, squareSize);

H_board2centr = [0 0 -1 165; 0 -1 0 -25; -1 0 0 18.2; 0 0 0 1];

DispVec = trans2CentrDisp(camera1HTM, camera2HTM, H_board2centr);

%% calculate errors and compliance factor 
unloadForce = 100:-12.5:0;
experForce = [actForce, unloadForce];
t = 1;
for i = 2:size(experForce,2)-1
    Mz = -experForce(i)*ty;
    My = experForce(i)*tz;
    C_DyMz(t) = DispVec(2,i)/Mz;    % Delta_y/M_z
    C_DzMy(t) = DispVec(3,i)/My;    % Delta_z/M_y
    C_AyMy(t) = DispVec(5,i)/My;    % Alpha_y/M_y
    C_AzMz(t) = DispVec(6,i)/Mz;    % Alpha_z/M_z
    t = t+1;
end
fprintf('The average compliance Delta_y/M_z is:\n %s\n',mean(C_DyMz));
fprintf('Corresponding calculated value is: \n %s \n', C_e(2,6)*1e3);
fprintf('The average compliance Alpha_z/M_z is:\n %s\n',mean(C_AzMz));
fprintf('Corresponding calculated value is: \n %s \n', C_e(5,5));

fprintf('The average compliance Delta_z/M_y is:\n %s\n',mean(C_DzMy));
fprintf('Corresponding calculated value is: \n %s \n', C_e(3,5)*1e3);
fprintf('The average compliance Alpha_y/M_y is:\n %s\n',mean(C_AyMy));
fprintf('Corresponding calculated value is: \n %s \n\n', C_e(5,5));


%% repetitiive error
nbrLoad = size(actForce,2);
disp('The repetitiive error is:')
Dy_RepErr = mean(DispVec(2,1:nbrLoad)-fliplr(DispVec(2,nbrLoad:end)))
Dz_RepErr = mean(DispVec(3,1:nbrLoad)-fliplr(DispVec(3,nbrLoad:end)))
Ay_RepErr = mean(DispVec(5,1:nbrLoad)-fliplr(DispVec(5,nbrLoad:end)))
Az_RepErr = mean(DispVec(6,1:nbrLoad)-fliplr(DispVec(6,nbrLoad:end)))

%% results display
figure('Name','Displacement of FSM (caculation and expermental).')
subplot(2,3,1)
plot(actForce, Disp_centr(1,:)*1e3, 'd-r')
hold on
plot(actForce, DispVec(1,1:nbrLoad), 's-k', unloadForce, DispVec(1,nbrLoad:end), 's-k')
legend('Calculated', 'Expermental')
xlabel('Force (N)')
ylabel('X-Displacement (mm)')

subplot(2,3,2)
plot(actForce, Disp_centr(2,:)*1e3, 'd-r')
hold on
plot(actForce, DispVec(2,1:nbrLoad), 's-k', unloadForce, DispVec(2,nbrLoad:end), 's-k')
legend('Calculated', 'Expermental')
xlabel('Force (N)')
ylabel('Y-Displacement (mm)')

subplot(2,3,3)
plot(actForce, Disp_centr(3,:)*1e3, 'd-r')
hold on 
plot(actForce, DispVec(3,1:nbrLoad), 's-k', unloadForce, DispVec(3,nbrLoad:end), 's-k')
xlabel('Force (N)')
ylabel('Z-Displacement (mm)')

subplot(2,3,4)
plot(actForce, Disp_centr(4,:), 'd-r')
hold on 
plot(actForce, DispVec(4,1:nbrLoad), 's-k', unloadForce, DispVec(4,nbrLoad:end), 's-k')
xlabel('Force (N)')
ylabel('X-Angular (rad)')

subplot(2,3,5)
plot(actForce, Disp_centr(5,:), 'd-r')
hold on 
plot(actForce, DispVec(5,1:nbrLoad), 's-k', unloadForce, DispVec(5,nbrLoad:end), 's-k')
xlabel('Force (N)')
ylabel('Y-Angular (rad)')

subplot(2,3,6)
plot(actForce, Disp_centr(6,:), 'd-r')
hold on 
plot(actForce, DispVec(6,1:nbrLoad), 's-k', unloadForce, DispVec(6,nbrLoad:end), 's-k')
xlabel('Force (N)')
ylabel('Z-Angular (rad)')





