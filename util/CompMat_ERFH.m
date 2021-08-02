function C_erfh = CompMat_ERFH(structParas, materParas)
% CompMat_ERFH is designed for calculation of RFH compliance matrix.

%% local variable (ERFH dimension parameters)
a = structParas.a; b = structParas.b;
l = structParas.len; t = structParas.thi; w = structParas.wid;

%% local variable (material properties)
E = materParas.E;
mu = materParas.mu;
k = materParas.k;
G = materParas.G;

%% Complex integral terms
N1 = -8*[(t^2+4*b*t+6*b^2)/(t^2*(4*b+t)^2*(2*b+t))+...
    6*b*(2*b+t)*atan(sqrt(4*b/t+1))/(t^(5/2)*(4*b+t)^(5/2))];   % \int frac{cos}{f^3}

N2 = pi/(2*b)-(2*(2*b+t))/(b*sqrt(t)*sqrt(4*b+t))*atan(sqrt(4*b/t+1));  % \int frac{cos}{f}

N3 = 1/b-(2*b+t)/(2*b^2)*log(2*b/t+1);  % \int frac{sin*cos}{f}

N4 = (3*pi+4)/(4*b)+(pi+1)*t/(2*b^2)+pi*t^2/(8*b^3)-...
    (2*b+t)^3/(2*b^3*sqrt(t)*sqrt(4*b+t))*atan(sqrt(4*b/t+1));   % \int frac{cos^3}{f}

N5 = (t-2*b)/(b^2*t^2)-1/(b^2*(t+2*b));     % \int frac{sin*cos}{f^3}

N6 = pi/(2*b^3)-2*(2*b+t)*(6*b^2-4*b*t-t^2)/(b^2*t^2*(4*b+t)^2)-...
    2*(2*b+t)*(24*b^4-8*b^3*t+14*b^2*t^2+8*b*t^3+t^4)/...
    (b^3*t^(5/2)*(4*b+t)^(5/2))*atan(sqrt(4*b/t+1));    % \int frac{cos^3}{f^3}

%% calculate compliance factors
C11 = l/(E*w*t)-a/(E*w)*N2;

C22_bending = 2*l/(E*w*t^3)*(l^2+6*a*l+6*a^2)-(3*a^2*l)/(E*w)*N1+...
    (3*a^2*l)/(E*w)*N5-(3*a^3)/(E*w)*N6;
C22_shearing = k*l/(G*w*t)-k*a/(G*w)*N2;
C22 = C22_bending+C22_shearing;

C33_bending = 2*l/(E*w^3*t)*(6*a^2+6*a*l+l^2)-12*a^2*l/(E*w^3)*N2+12*a^2*l/(E*w^3)*N3-...
    12*a^3/(E*w^3)*N4;
C33_shearing = k*l/(G*w*t)-k*a/(G*w)*N2;
C33 = C33_bending+C33_shearing;

C44 = -7*a/(8*G*w)*N1-7*a/(2*G*w^3)*N2+7*l/(2*G*w*t^3)+7*l/(2*G*w^3*t);

C55 = 12*l/(E*w^3*t)-12*a/(E*w^3)*N2;

C66 = 12*l/(E*w*t^3)-3*a/(E*w)*N1;

C53 = -1/2*(2*a+l)*C55;  C35 = -1/2*(2*a+l)*C55;

C62 = 1/2*(2*a+l)*C66;   C26 = 1/2*(2*a+l)*C66;

%% compliance metrix of ERFH
C_erfh = [C11 0 0 0 0 0;
         0 C22 0 0 0 C26;
         0 0 C33 0 C35 0;
         0 0 0 C44 0 0;
         0 0 C53 0 C55 0;
         0 C62 0 0 0 C66];
end

