function [camera1HTM, camera2HTM] = Calibrator(imgsPath, nbrImgs, squareSize)
% Calibrator is a function to obtain HTM from camera frame to world(chessboard) frame
%   imgsPath(1*2 cell): the path of the two cameras to collect images (image suffix .bmp)
%   nbrImgs: the number of images of per camera
%   squareSize: square size of the calibration board (mm)
    
    % Define images to process
    imageFileNames1 = cell(1, nbrImgs);
    imageFileNames2 = cell(1, nbrImgs);
    for i = 1: nbrImgs
        imageFileNames1{i} = [imgsPath{1}, num2str(i), '.bmp'];
        imageFileNames2{i} = [imgsPath{2}, num2str(i), '.bmp'];
    end

    % Detect checkerboards in images
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames1, imageFileNames2);

    % Generate world coordinates of the checkerboard keypoints
    % squareSize = 10;  % in units of 'millimeters'
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);

    % Read one of the images from the first stereo pair
    I1 = imread(imageFileNames1{1});
    [mrows, ncols, ~] = size(I1);

    % Calibrate the camera
    [stereoParams, pairsUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
        'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
        'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
        'ImageSize', [mrows, ncols]);

    % % View reprojection errors
    % h1=figure; showReprojectionErrors(stereoParams);

    % Visualize pattern locations
    h2=figure; showExtrinsics(stereoParams, 'CameraCentric');

    % % Display parameter estimation errors
    % displayErrors(estimationErrors, stereoParams);

    % You can use the calibration data to rectify stereo images.
    I2 = imread(imageFileNames2{1});
    [J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
    
    camera1HTM = zeros(4,4,nbrImgs);
    camera2HTM = zeros(4,4,nbrImgs);
    
    for i = 1:nbrImgs
        R_cam1 = stereoParams.CameraParameters1.RotationMatrices(:,:,i);
        R_cam2 = stereoParams.CameraParameters2.RotationMatrices(:,:,i);
        t_cam1 = stereoParams.CameraParameters1.TranslationVectors(i,:);
        t_cam2 = stereoParams.CameraParameters2.TranslationVectors(i,:);
        camera1HTM(:,:,i) = [R_cam1', t_cam1'; zeros(1,3), 1];
        camera2HTM(:,:,i) = [R_cam2', t_cam2'; zeros(1,3), 1];
    end
    
    %% plot frame {C} and calibrate board frame {B}
    figure(2)
    HTM_Cam = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    trplot(HTM_Cam, 'frame', 'CP', 'length', 20);
    for i = 1:nbrImgs
       hold on
       trplot(HTM_Cam*camera1HTM(:,:,i),'length', 15, 'rviz');
    end
    axis auto
end

