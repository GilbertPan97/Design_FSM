function [fitresult, gof] = smoothingFits(time, data1, data2)
%CREATEFITS(TIME,ANS,ANS1)
%  Create fits.
%
%  Data for 'untitled fit 1' fit:
%      X Input : time
%      Y Output: ans
%  Data for 'untitled fit 2' fit:
%      X Input : time
%      Y Output: ans1
%  Output:
%      fitresult : a cell-array of fit objects representing the fits.
%      gof : structure array with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 19-Jul-2021 10:40:35 自动生成

%% Initialization.

% Initialize arrays to store fits and goodness-of-fit.
fitresult = cell( 2, 1 );
gof = struct( 'sse', cell( 2, 1 ), ...
    'rsquare', [], 'dfe', [], 'adjrsquare', [], 'rmse', [] );

%% Fit: 'fit 1'.
[xData, yData] = prepareCurveData( time, data1 );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.243960156304557;

% Fit model to data.
[fitresult{1}, gof(1)] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'Smoothing Spline fit' );
% figure('Name','Final state of FSM (time valiable).')
subplot(2,2,1);
h = plot( fitresult{1}, xData, yData ,'>');
legend( h, 'Expermental', 'Curve fit', 'Location', 'NorthWest' );
% Label axes
xlabel('Time (min)')
ylabel('Z-Displacement (mm)')
grid on

%% Fit: 'fit 2'.
[xData, yData] = prepareCurveData( time, data2 );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.163681211852632;

% Fit model to data.
[fitresult{2}, gof(2)] = fit( xData, yData, ft, opts );

% Plot fit with data.
subplot(2,2,2)
h = plot( fitresult{2}, xData, yData ,'>');
legend( h, 'Expermental', 'Curve fit', 'Location', 'NorthEast' );
% Label axes
xlabel('Time (min)')
ylabel('Y-Angular (rad)')
grid on


