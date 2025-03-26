% MATLAB Code for Ellipsoid Fitting with LiDAR Data (Updated)

% Generate synthetic LiDAR point cloud data directly on the ellipsoid surface
N = 1000; % Number of points

theta = 2 * pi * rand(N, 1); % Random azimuth angles
phi = pi * rand(N, 1) - pi/2; % Random elevation angles

a = 10; b = 8; c = 6; % Semi-axes of the ellipsoid

% Generate points directly on the ellipsoid surface
x = a * cos(theta) .* cos(phi);
y = b * sin(theta) .* cos(phi);
z = c * sin(phi);

pointCloud = [x y z]; % Points are now directly on the ellipsoid surface

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

scatter3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3), 10, 'b', 'filled'); % LiDAR points
hold on;

% Generate fitted ellipsoid for visualization
[X, Y, Z] = ellipsoid(x0, y0, z0, a_fit, b_fit, c_fit, 30); % Create ellipsoid mesh grid

surf(X, Y, Z, 'FaceAlpha', 0.5, 'EdgeColor', 'none'); % Plot fitted ellipsoid with transparency

colormap autumn; % Set colormap for visualization
xlabel('X-axis (meters)');
ylabel('Y-axis (meters)');
zlabel('Z-axis (meters)');
title('LiDAR Point Cloud and Fitted Ellipsoid with Grid');
axis equal;
grid on; % Add grid for better visualization
legend({'LiDAR Points', 'Fitted Ellipsoid'}, 'Location', 'best');
