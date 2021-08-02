function output_matrix = adj_func(R_vec, P_vec, flag)
% Rotation sequence: Rz->Ry->Rx

    t_hat = skew(P_vec);
    
    rx = R_vec(1);
    ry = R_vec(2);
    rz = R_vec(3);
    Rx = [1      0      0;
          0 cos(rx) -sin(rx);
          0 sin(rx) cos(rx)];
    Ry = [cos(ry)  0 sin(ry);
            0       1      0;
          -sin(ry) 0 cos(ry)];
    Rz = [cos(rz) -sin(rz) 0;
          sin(rz) cos(rz)  0;
           0      0       1];
    R = Rz*Ry*Rx;
    
    if flag==1  % Representation of adjoint matrix
        Ad = [R, zeros(3);
              t_hat*R, R];
        output_matrix = Ad;
        
    elseif flag==2  % Represents the inverse of adjoint matrix
        Ad_inv = [R', zeros(3);
                  -R'*t_hat, R'];
        output_matrix = Ad_inv;
        
    elseif flag==3
        Ad_trans = [R', -R'*t_hat;
                    zeros(3), R'];
        output_matrix = Ad_trans;
        
    else
        disp('error flag.');
    end
end

