function DispVec = trans2CentrDisp(HTM1, HTM2, fixTrans)
%Function: 
%   trans2CentrDisp:transforms the HTM of the calibration board frame {B} into 
%   the deformation displacement vector of the FSM
%Input:
%   HTM1: HTM from camera1 frame {C1} to board frame {B}
%   HTM2: HTM from camera2 frame {C2} to board frame {B}
%   fixTrans: HTM from board frame {B} to end of FSM frame
%Output:
%   DispVec: deformation displacement vector of the FSM
    nbr = size(HTM1,3);
    initHom1 = HTM1(:,:,1)*fixTrans;    % HTM of End of FSM in frame {C}
    initHom2 = HTM2(:,:,1)*fixTrans;
    
    DispVec = zeros(6, nbr-1);
    for i=1:nbr
        if i ==1
            DispVec(:,i) = zeros(6,1);
        else
            DispHom1 = HTM1(:,:,i)*fixTrans;    % After displacement, HTM of FSM in frame {C}
            DispHom2 = HTM2(:,:,i)*fixTrans;
            DispMat1 = initHom1\DispHom1;
            DispMat2 = initHom2\DispHom2;
            rot1 = DispMat1(1:3,1:3);
            rot2 = DispMat2(1:3,1:3);
            RPY1 = rotm2eul(rot1,'ZYX');
            RVec1 = [RPY1(3), RPY1(2), RPY1(1)];
            DispVec1 = [DispMat1(1:3,4); RVec1'];

            RPY2 = rotm2eul(rot2,'ZYX');
            RVec2 = [RPY2(3), RPY2(2), RPY2(1)];
            DispVec2 = [DispMat2(1:3,4); RVec2'];

            DispVec(:,i) = (DispVec1+DispVec2)/2;
        end
    end
end

