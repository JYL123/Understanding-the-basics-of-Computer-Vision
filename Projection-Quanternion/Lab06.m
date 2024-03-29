close all; 
clear all;

pts = zeros(8, 3);
pts(1,: ) = [-1 -1 -1]; 
pts(2,: ) = [1 -1 -1];
pts(3,: ) = [1 1 -1];
pts(4,: ) = [-1 1 -1];
pts(5,: ) = [-1 -1 1];
pts(6,: ) = [1 -1 1];
pts(7,: ) = [1 1 1];
pts(8,: ) = [-1 1 1];
disp('Q1');
disp('=====================================================================');
disp('3D points:');
pts

initialPosition = [0 0 -5];
theta = pi/6; % rotation angle
n = [0; 1; 0]; % rotation axis
r = [0 initialPosition(1,1) initialPosition(1,2) initialPosition(1,3)]; % add sp=0
cam_pos = zeros( 4, 3);
cam_pos(1, : ) = [ 0 0 -5];

% quanternion multiplication
%first rotation 
R1 = rotateByEquation(r, n, -theta)
cam_pos(2, : ) = R1.';

%second rotation
R1 = [0 R1(1,1) R1(2,1) R1(3,1)];
R2 = rotateByEquation(R1, n, -theta);
cam_pos(3, : ) = R2.';

%third rotation
R2 = [0 R2(1,1) R2(2,1) R2(3,1)];
R3 = rotateByEquation(R2, n, -theta);
cam_pos(4, : ) = R3.';

disp('Q2');
disp('=====================================================================');
disp('camera location 1:');
cam_pos(1,: )
disp('camera location 2:');
cam_pos(2,: )
disp('camera location 3:');
cam_pos(3,: )
disp('camera location 4:');
cam_pos(4,: )

disp('Q3');
disp('=====================================================================');
% use roll, pitch and yaw to represent rotation
% represent world coordination in a camera perspective?
% w = 0; phi = 30 degree (pi/6) (for the first rotation); k = 0;
w = 0;
phi = pi/6;
k = 0;
disp('using roll, pitch and yaw representation for rotation, the computed matrices are : ');
rpymat_1 = [1 0 0; 0 1 0; 0 0 1]
rpymat_2 = rpyRotation(w, pi/6, k) % 30 degree
rpymat_3 = rpyRotation(w, pi/3, k) % 60 degree
rpymat_4 = rpyRotation(w, pi/2, k) % 90 degree

% rotation represented by quanternion
% rotational axis = [ 0; 1; 0] (3x1 row matrix)
% rotation degree = 30
% define q as colnum matrix
w = [0; 1; 0]; % rotational axis
disp('using quaternion representation for rotation, the computed matrices are : ');
quatmat_1 = [1 0 0; 0 1 0; 0 0 1] % rotation matrix: [x, y, z] x = 100, y=010, z=001
quatmat_2 = quanRotation(pi/6, w)
quatmat_3 = quanRotation(pi/3, w)
quatmat_4 = quanRotation(pi/2, w)

%checking rpy and quan
disp('Verfication: ');
frame1= rpymat_1 - quatmat_1
frame2 = rpymat_2 - quatmat_2
frame3 = rpymat_3 - quatmat_3
frame4 = rpymat_4 - quatmat_4

disp('Q4');
disp('=====================================================================');
disp('Please note that 2 projection model figures are saved in the folder. The displayed figure when the program is executed is only orthographic model.')
%Projecting the 3D points
nframes = 4;
npts = size(pts,1);
U = zeros(nframes, npts); % 4*3
V = zeros(nframes, npts); % 4*3

% Compute u,v for each 3D point with perspective model for 4 frames
% for frame1, compute (u, v)
for m = 1 : 8
    Sp = pts(m, : );
    Tf = cam_pos(1, : );
    U(1, m) = computePerspectiveU(Sp.', Tf.',quatmat_1(1,:).', quatmat_1(3,:).');
    V(1, m) = computePerspectiveV(Sp.', Tf.',quatmat_1(2,:).', quatmat_1(3,:).');
    
end

% for frame2, compute (u, v)
for m = 1 : 8
    Sp = pts(m, : );
    Tf = cam_pos(2, : );
    U(2, m ) = computePerspectiveU(Sp.', Tf.',quatmat_2(1,:).', quatmat_2(3,:).');
    V(2, m ) = computePerspectiveV(Sp.', Tf.',quatmat_2(2,:).', quatmat_2(3,:).');
    
end

for m = 1 : 8
    Sp = pts(m, : );
    
   % for frame3, compute (u, v)
    Tf = cam_pos(3, : );
    U(3, m ) = computePerspectiveU(Sp.', Tf.',quatmat_3(1,:).', quatmat_3(3,:).');
    V(3, m ) = computePerspectiveV(Sp.', Tf.',quatmat_3(2,:).', quatmat_3(3,:).');
    
end

for m = 1 : 8
    Sp = pts(m, : );
    
   % for frame4, compute (u, v)
    Tf = cam_pos(4, : );
    U(4, m ) = computePerspectiveU(Sp.', Tf.',quatmat_4(1,:).', quatmat_4(3,:).');
    V(4, m ) = computePerspectiveV(Sp.', Tf.',quatmat_4(2,:).', quatmat_4(3,:).');
    
end

%show figure
 for fr = 1 : nframes  % for each frame
     subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*'); 
     for p = 1 : npts % for each point
          text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p)); 
     end
 end
 
 % Compute u,v for each 3D point with orthographic model for 4 frames
% for frame1, compute (u, v)
for m = 1 : 8
    Sp = pts(m, : );
    Tf = cam_pos(1, : );
    U(1, m) = computeOrthographicU(Sp.', Tf.',quatmat_1(1,:).');
    V(1, m) = computeOrthographicV(Sp.', Tf.',quatmat_1(2,:).');
    
end

% for frame2, compute (u, v)
for m = 1 : 8
    Sp = pts(m, : );
    Tf = cam_pos(2, : );
    U(2, m ) = computeOrthographicU(Sp.', Tf.',quatmat_2(1,:).');
    V(2, m ) = computeOrthographicV(Sp.', Tf.',quatmat_2(2,:).');
    
end

for m = 1 : 8
    Sp = pts(m, : );
    
   % for frame3, compute (u, v)
    Tf = cam_pos(3, : );
    U(3, m ) = computeOrthographicU(Sp.', Tf.',quatmat_3(1,:).');
    V(3, m ) = computeOrthographicV(Sp.', Tf.',quatmat_3(2,:).');
    
end

for m = 1 : 8
    Sp = pts(m, : );
    
   % for frame4, compute (u, v)
    Tf = cam_pos(4, : );
    U(4, m ) = computeOrthographicU(Sp.', Tf.',quatmat_4(1,:).');
    V(4, m ) = computeOrthographicV(Sp.', Tf.',quatmat_4(2,:).');
    
end

%show figure
 for fr = 1 : nframes  % for each frame
     subplot(2,2,fr), plot(U(fr,:), V(fr,:), '*'); 
     for p = 1 : npts % for each point
          text(U(fr,p)+0.02, V(fr,p)+0.02, num2str(p)); 
     end
 end


disp(' ');
disp('Q5');
disp('=====================================================================');
% homographic matrix mapping from flate plane pattern to frame 3 
M = zeros(8, 9);
% 3d point projects on the plane, up, vp, zp
c = cam_pos(3, : );
% 3d point projects on frame3
p1 = pts(1, : );
uc = computePerspectiveU(p1.', c.',quatmat_3(1,:).', quatmat_3(3,:).');
vc = computePerspectiveV(p1.', c.',quatmat_3(2,:).', quatmat_3(3,:).');
% construct M
M(1, : ) = homographyMatrixMappingOnU (p1(1,1), p1(1,2), p1(1,3), uc);
M(2, : ) = homographyMatrixMappingOnV (p1(1,1), p1(1,2), p1(1,3), vc);

% 3d point projects on the plane, up, vp, zp
p2 = pts(2, : );
% 3d point projects on frame3
uc = computePerspectiveU(p2.', c.',quatmat_3(1,:).', quatmat_3(3,:).');
vc = computePerspectiveV(p2.', c.',quatmat_3(2,:).', quatmat_3(3,:).');
% construct M
M(3, : ) = homographyMatrixMappingOnU (p2(1,1), p2(1,2), p2(1,3), uc);
M(4, : ) = homographyMatrixMappingOnV (p2(1,1), p2(1,2), p2(1,3), vc);

% 3d point projects on the plane, up, vp, zp
p3 = pts(3, : );
% 3d point projects on frame3
uc = computePerspectiveU(p3.', c.',quatmat_3(1,:).', quatmat_3(3,:).');
vc = computePerspectiveV(p3.', c.',quatmat_3(2,:).', quatmat_3(3,:).');
% construct M
M(5, : ) = homographyMatrixMappingOnU (p3(1,1), p3(1,2), p3(1,3), uc);
M(6, : ) = homographyMatrixMappingOnV (p3(1,1), p3(1,2), p3(1,3), vc);

% 3d point projects on the plane, up, vp, zp
p4 = pts(4, : );
% 3d point projects on frame3
uc = computePerspectiveU(p4.', c.',quatmat_3(1,:).', quatmat_3(3,:).');
vc = computePerspectiveV(p4.', c.',quatmat_3(2,:).', quatmat_3(3,:).');
% construct M
M(7, : ) = homographyMatrixMappingOnU (p4(1,1), p4(1,2), p4(1,3), uc);
M(8, : ) = homographyMatrixMappingOnV (p4(1,1), p4(1,2), p4(1,3), vc);

% svd
[U, S, V] = svd(M);
% get the last row of transpose = get the last col
H = [V(1, 9) V(2, 9) V(3, 9); V(4, 9) V(5, 9) V(6, 9); V(7, 9) V(8, 9) V(9, 9);];
% normalization
H = H/V(9, 9);
%checking
ans = H*pts(1, : ).';

disp('Nomalized homography matrix:');
H

% assume rotation: 3*3; translation: 1*3 
% pFlate is 3*1 row matrix
% p1: up, vp
% p3: uc, vp
function U = homographyMatrixMappingOnU (x, y, z, uc)
    U = [x y z 0 0 0 -uc*x -uc*y -uc*z];
end

function V = homographyMatrixMappingOnV (x, y, z, vc)
    V = [0 0 0 x y z -vc*x -vc*y -vc*z];
end

% Compute U (horizontal) for orthographic model
% x, y, z are intrinsic parameters of the camera with z being kf (depth)
% matrix orientation is formatted as in the lecture notes
function U = computeOrthographicU(Sp, Tf, x) 
    U = ((Sp-Tf).' * x);
end

% Compute V (vertical) for orthographic model
% x, y, z are intrinsic parameters of the camera with z being kf (depth)
% matrix orientation is formatted as in the lecture notes
function V = computeOrthographicV(Sp, Tf, y) 
    V = ((Sp-Tf).' * y);
end


% Compute U (horizontal) for perspective model
% x, y, z are intrinsic parameters of the camera with z being kf (depth)
% matrix orientation is formatted as in the lecture notes
function U = computePerspectiveU(Sp, Tf, x, z) 
    U = ((Sp-Tf).' * x)/((Sp-Tf).' * z);
end 

% Compute V (vertical) for perspective model
% x, y, z are intrinsic parameters of the camera with z being kf (depth)
% matrix orientation is formatted as in the lecture notes
function V = computePerspectiveV(Sp, Tf, y, z) 
    V = ((Sp-Tf).' * y)/((Sp-Tf).' * z);
end 

% quanternion rotation 
% 1x4 column matrix as quanternion, rotational degree as theta, rotational
% axis w
function Rt = quanRotation(theta, w)
q = [cos(theta/2) sin(theta/2)*w(1,1) sin(theta/2)*w(2,1) sin(theta/2)*w(3,1)];
    Rt = [
        q(1,1)^2+q(1,2)^2-q(1,3)^2-q(1,4)^2 2*(q(1,2)*q(1,3)-q(1,1)*q(1,4)) 2*(q(1,2)*q(1,4)+q(1,1)*q(1,3));
        2*(q(1,2)*q(1,3) + q(1,1)*q(1,4)) q(1,1)^2+q(1,3)^2-q(1,2)^2-q(1,4)^2 2*(q(1,3)*q(1,4)-q(1,1)*q(1,2));
        2*(q(1,2)*q(1,4)-q(1,1)*q(1,3)) 2*(q(1,3)*q(1,4)+q(1,1)*q(1,2)) q(1,1)^2+q(1,4)^2-q(1,2)^2-q(1,3)^2;
    ];
end

%rpy rotation with phi = pi/6
function Rt = rpyRotation(w, phi, k)
    Rt = [
    cos(k)*cos(phi) cos(k)*sin(phi)*sin(w)-sin(k)*cos(w) cos(k)*sin(phi)*cos(w)+sin(k)*sin(w);     
    sin(k)*cos(phi) sin(k)*sin(phi)*sin(w)+cos(k)*cos(w) sin(k)*sin(phi)*cos(w)-cos(k)*sin(w);
    -sin(phi) cos(phi)*sin(w) cos(phi)*cos(w);
    ];
end 

% r (4x1): initial position; n: rotation axis; theta: rotation angle
function R = rotateByEquation(r, n, theta)
    v_p = [r(1,2) r(1,3) r(1,4)]; % 0,0,-5
    c = (v_p*cos(theta)).' + dot(v_p, n)*n*(1-cos(theta)) + (cross(n, v_p.'))*sin(theta);
    R = c;
 end 
 
function R = rotateByMatrix (r, n, theta)
    q = [cos(theta/2) sin(theta/2)*r(1,2) sin(theta/2)*r(1,3) sin(theta/2)*r(1,4)];
    Q = [cos(theta/2) -sin(theta/2)*r(1,2) -sin(theta/2)*r(1,3) -sin(theta/2)*r(1,4)];
    p = [0 r(1,2) r(1,3) r(1, 4)];
    
    qp = [
        q(1,1)*p(1,1)-q(1,2)*p(1,2)-q(1,3)*p(1,3)-q(1,4)*p(1,4)
        
        q(1,1)*p(1,2)+q(1,2)*p(1,1)+q(1,3)*p(1,4)-q(1,4)*p(1,3)
        
        q(1,1)*p(1,3)-q(1,2)*p(1,4)+q(1,3)*p(1,1)+q(1,4)*p(1,2)
        
        q(1,1)*p(1,4)+q(1,2)*p(1,3)-q(1,3)*p(1,2)+q(1,4)*p(1,1)
    ];
    
    qp = qp.'; %transpose to row vector
    
    R = [
        qp(1,1)*Q(1,1)-qp(1,2)*Q(1,2)-qp(1,3)*Q(1,3)-qp(1,4)*Q(1,4)
        
        qp(1,1)*Q(1,2)+qp(1,2)*Q(1,1)+qp(1,3)*Q(1,4)-qp(1,4)*Q(1,3)
        
        qp(1,1)*Q(1,3)-qp(1,2)*Q(1,4)+qp(1,3)*Q(1,1)+qp(1,4)*Q(1,2)
        
        qp(1,1)*Q(1,4)+qp(1,2)*Q(1,3)-qp(1,3)*Q(1,2)+qp(1,4)*Q(1,1)
    ];
    
end