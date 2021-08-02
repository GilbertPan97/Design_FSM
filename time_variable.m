clc
clear all

%% Load function path
addpath('./util');
addpath(genpath('./rvctools'));

%% Get the initial state
nbrImgs = 21;
squareSize = 10;
imgsPath = {'./imgs/left_Camera/', './imgs/right_Camera/'};
[camera1HTM, camera2HTM] = Calibrator(imgsPath, nbrImgs, squareSize);

H_board2centr = [0 0 -1 165; 0 -1 0 -25; -1 0 0 18.2; 0 0 0 1];

DispVec = trans2CentrDisp(camera1HTM, camera2HTM, H_board2centr);

%% calculate errors and compliance factor 
time = 0:5:20;

%% results display
smoothingFits(time, DispVec(3,17:end), DispVec(5,17:end));
disp('Repetitive error of FSM final state without external load:')
Dz_ini = DispVec(3,17)
Ay_ini = DispVec(5,17)
disp('After 15 min, the error decreased to:')
Dz_15 = DispVec(3,20)
Ay_15 = DispVec(5,20)




