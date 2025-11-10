
p.m         = 1.587;    % kg  https://arxiv.org/pdf/2202.07021
p.g         = 9.80665;  % m/s^2; % Acceleration due to gravity

p.A         = 0.0625;   % m^2 
p.rho       = 1.225;    % kg/m^3
p.R         = 0.127;    % m (propeller radius)

p.Ar        = pi*p.R^2;
p.L         = 0.243;    % m      https://arxiv.org/pdf/2202.07021
p.k         = 3.17e-5;  % N-s^2  https://arxiv.org/pdf/2202.07021
p.b         = 7.69e-7;  % N-ms^2 https://arxiv.org/pdf/2202.07021
p.Ixx       = 0.0213;   % kg-m^2 https://arxiv.org/pdf/2202.07021
p.Iyy       = p.Ixx;    % kg-m^2 
p.Izz       = 0.0282;   % kg-m^2 https://arxiv.org/pdf/2202.07021
p.kD        = 0.25;     % kg/s

A = [0,0,0,1,0,0,0,0,0,0,0,0;...
     0,0,0,0,1,0,0,0,0,0,0,0;...
     0,0,0,0,0,1,0,0,0,0,0,0;...
     0,0,0,-p.kD/p.m,0,0,0,p.g,0,0,0,0;...
     0,0,0,0,-p.kD/p.m,0,-p.g,0,0,0,0,0;...
     0,0,0,0,0,-p.kD/p.m,0,0,0,0,0,0;...
     0,0,0,0,0,0,0,0,0,1,0,0;...
     0,0,0,0,0,0,0,0,0,0,1,0;...
     0,0,0,0,0,0,0,0,0,0,0,1;...
     0,0,0,0,0,0,0,0,0,0,0,0;...
     0,0,0,0,0,0,0,0,0,0,0,0;...
     0,0,0,0,0,0,0,0,0,0,0,0;...
     ];

B = [zeros(5,4);1/p.m, 0,0,0; zeros(3,4); 0,1/p.Ixx, 0,0;0,0,1/p.Iyy,0; 0,0,0,1/p.Izz];

C = zeros(6, 12);
C(1:3, 1:3) = eye(3);
C(4:6, 7:9) = eye(3);
D = zeros(size(C,1),4);

x_K = -3;
y_K = -4;
z_K = -0.4;
dotx_K = -1.4;
doty_K =-1.5;
dotz_K =-1.6;
phi_K = -7;
theta_K =-8;
psi_K = -9;
dotphi_K = -10;
dottheta_K = -11;
dotpsi_K = -12;

K = place(A, B, [x_K,y_K,z_K,dotx_K,doty_K,dotz_K,phi_K,theta_K,psi_K, dotphi_K,dottheta_K,dotpsi_K]);
L = place(A', C', [-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16])';

lin_sys = ss(A,B,C,D);

dt = 0.1;

dlin_sys = c2d(lin_sys, dt);

Ad = dlin_sys.A;
Bd = dlin_sys.B;
Cd = dlin_sys.C;
Dd = dlin_sys.D;

Kd = place(Ad, Bd, [0.01,0.13,0.2,0,0.3,0,0.1,0,0.022,0.33,0.22,0.11]);
Ld = place(Ad', Cd', [0.01,0.13,0.2,0,0.3,0,0.1,0,0.022,0.33,0.22,0.11])';