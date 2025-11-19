
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

p.dThres    = 0.01;     % m 
p.omegaMax = 500^2;     % rad/s

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

x_K = -4.0;
y_K = -1.8;
z_K = -1.8;
dotx_K = -4.02;
doty_K =-3.03;
dotz_K =-3.01;
phi_K = -2.3;
theta_K =-2.4;
psi_K = -2.5;
dotphi_K = -1.11;
dottheta_K = -1.62;
dotpsi_K = -1.63;

eig_K_c = [x_K,y_K,z_K,dotx_K,doty_K,dotz_K,phi_K,theta_K,psi_K, dotphi_K,dottheta_K,dotpsi_K];
eig_L_c = [-5,-3.1,-3.2,-5.1,-5.2,-5.3,-2.6,-2.5,-2.4,-2.3,-2.2,-2.1];
K = place(A, B, eig_K_c);
L = place(A', C', eig_L_c)';

lin_sys = ss(A,B,C,D);

dt = 0.01;

dlin_sys = c2d(lin_sys, dt);

Ad = dlin_sys.A;
Bd = dlin_sys.B;
Cd = dlin_sys.C;
Dd = dlin_sys.D;

Kd = place(Ad, Bd, exp(eig_K_c * dt));
Ld = place(Ad', Cd', exp(eig_L_c * dt))';

bL = p.b * p.L;
Lk = p.L * p.k;
b2 = 2*p.b;
u2omega = 1/(4*p.b * p.k * p.L) * [bL, b2, 0, Lk; bL, 0, b2, -Lk; bL, -b2, 0, Lk; bL, 0, -b2, -Lk];
omega2u = [ones(1,4) * p.k; Lk, 0, -Lk, 0; 0, Lk, 0, -Lk; p.b, -p.b, p.b, -p.b];


p.wp = [[8,3,5]', [7,9,10]', [5,1,1]', [3,8,3]', [8,2,9]', [3;2;3], [6;5;4], [9;6;5]];