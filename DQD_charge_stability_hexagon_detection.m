%% Double quantum dot (DQD) charge stability diagram hexagon detection
%  This script takes an image of the DQD charge stability diagram and
%  detects the current peaks and extracts any apparent hexagon patterns.
%  Author: Dr Faris Abualnaja
%  Date: 21/03/2021

%% Notes on the code
% centres11, centres21, radii11, radii21 are the circles that we wish to
% display and follow the theory. centres1,centres2,radii1,radii2 show us
% all possible circles that the program detects.

%% Clear command window and close all previously opened figures
clc;
close all;

%% Read image
rgb_image   = imread('.../image.png');

% Resize (if needed) and plot
rgb_image   = imresize(rgb_image, 2);

% Display image
figure;
imshow(rgb_image);

%% Create intensity profile
ind_image   = rgb2ind(rgb_image, jet);

% Display intensity profile of image
figure;
imshow(ind_image);

%% Filter image
% Create gaussian filter to remove noise
% Be sure to have the Image Processing Toolbox to use 'fspecial'
% May need to adjust filter options
filter = fspecial('gaussian', [10 10],10);

% Filter noise from intensity image
image_filtered = imfilter(ind_image, filter);

% Display filtered intensity image
figure;
imshow(image_filtered);

%% Calculate grayscale threshold
threshold = multithresh(image_filtered, 5);
seg_gray_image = uint8(imquantize(image_filtered, threshold));
figure;
imshow(seg_gray_image, []);
hold off

%% Find local maximums in matrix
Local_Maximum = imregionalmax(seg_gray_image);
figure;
imshow(Local_Maximum, []);

%% Find buonudaries of local maximums
[Local_Maximum_Boundaries,Local_Maximum_Label] = bwboundaries(Local_Maximum,'holes');
hold on
for k = 1:length(Local_Maximum_Boundaries)
  boundary = Local_Maximum_Boundaries{k};
  plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 4)
end

%% Lines for Hexagon
% Need to adjust depending on image resolution, filteration, and threshold

% Sensitivity in circle detection may need to be ajusted
[centers1,radii1] = imfindcircles(Local_Maximum,[3 9], 'Sensitivity',0.915);
if isempty([centers1,radii1]) ~= 1
    h1 = viscircles(centers1,radii1, 'Color',[0 0 1], 'LineWidth', 5);
    plot(centers1(:,1), centers1(:,2), 'b.', 'MarkerSize', 5)
end
[centers2,radii2] = imfindcircles(Local_Maximum,[10 30], 'Sensitivity',0.75);
if isempty([centers2,radii2]) ~= 1
    h1 = viscircles(centers2,radii2, 'Color',[1 0 0], 'LineWidth', 5);
    plot(centers2(:,1), centers2(:,2), 'b.', 'MarkerSize', 5)
end

% Connect lines using:
% line([centers1(5,1), centers1(1,1)], [centers1(5,2), centers1(1,2)],...
%      'Color',[1 0 0], 'LineWidth', 5)

hold off
%% Plot Hexagon on Original Image (Hexagon 5)
figure;
imshow(rgb_image);
hold on
if isempty([centers1,radii1]) ~= 1
    h1 = viscircles(centers1,radii1, 'Color',[1 0 0], 'LineWidth', 5);
    plot(centers1(:,1), centers1(:,2), 'b.', 'MarkerSize', 5)
end

% Connect lines using
% line([centers1(5,1), centers1(1,1)], [centers1(5,2), centers1(1,2)],...
%      'Color',[1 0 0], 'LineWidth', 5)

hold off