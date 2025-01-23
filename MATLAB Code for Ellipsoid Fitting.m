% MATLAB Code for Ellipsoid Fitting with LiDAR Data

% Generate synthetic LiDAR point cloud data (replace with real LiDAR data)
N = 1000; % Number of points
theta = 2 * pi * rand(N, 1);
phi = pi * rand(N, 1) - pi/2;
a = 10; b = 8; c = 6; % Semi-axes of the ellipsoid
x = a * cos(theta) .* cos(phi);
y = b * sin(theta) .* cos(phi);
z = c * sin(phi);
pointCloud = [x y z] + randn(N, 3) * 0.1; % Add noise

% Calculate centroid
centroid = mean(pointCloud, 1);
x0 = centroid(1);
y0 = centroid(2);
z0 = centroid(3);

% Center the data
centeredData = pointCloud - centroid;

% Compute covariance matrix
C = cov(centeredData);

% Perform eigen decomposition
[V, D] = eig(C); % V = eigenvectors, D = eigenvalues (diagonal matrix)

% Extract semi-axes lengths from eigenvalues
semi_axes = sqrt(diag(D));
a_fit = semi_axes(1);
b_fit = semi_axes(2);
c_fit = semi_axes(3);

% Display results
fprintf('Ellipsoid Center: (%.2f, %.2f, %.2f)\n', x0, y0, z0);
fprintf('Fitted Semi-Axes: a = %.2f, b = %.2f, c = %.2f\n', a_fit, b_fit, c_fit);

% Plot original point cloud and fitted ellipsoid
figure;
scatter3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3), 10, 'b', 'filled');
hold on;

% Generate ellipsoid for visualization
[X, Y, Z] = ellipsoid(x0, y0, z0, a_fit, b_fit, c_fit, 30);
surf(X, Y, Z, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
colormap autumn;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('LiDAR Point Cloud and Fitted Ellipsoid');
axis equal;
grid on;
