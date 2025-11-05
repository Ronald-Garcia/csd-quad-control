
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

C = eye(12);
D = zeros(12,4);

x = -3;
y = -4;
z = -0.4;
dotx = -1.4;
doty =-1.5;
dotz =-1.6;
phi = -7;
theta =-8;
psi = -9;
dotphi = -10;
dottheta = -11;
dotpsi = -12;

K = place(A, B, [x,y,z,dotx,doty,dotz,phi,theta,psi, dotphi,dottheta,dotpsi]);