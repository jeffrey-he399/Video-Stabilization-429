clc;
clear;

setup();

%% Video library

% % Test loadVideo
disp("## Test loadVideo")
video_obj = loadVideo('test.mp4');


% % Test extractFrame
disp("## Test extractFrame")
frame_rgb = extractFrame(video_obj, 20);

disp(size(frame_rgb));


% % Test extractFrameRange
disp("## Test extractFrameRange")
range_rgb = extractFrameRange(video_obj, 1, 10);

disp(length(range_rgb))


% % Test displayFrame
disp("## Test displayFrame")
%displayFrame(frame_rgb);
%imwrite(frame_rgb, 'testFrame.jpg');


% % Test displayFrameComparison
disp("## Test displayFrameComparison")
%displayFrameComparison(range_rgb{1}, range_rgb{10});


% % Test saveVideo
disp("## Test saveVideo")
%saveVideo(range_rgb, 'testSave_o.mp4', video_obj.FrameRate);


%% Motion library

% % Test synthetic estimateMotion
disp("## Test estimateMotion (synthetic)")

% Load pre-generated synthetic images from sources/
synth1_rgb = imread('sources/test_synthetic_mov1.png');
synth2_rgb = imread('sources/test_synthetic_mov2.png');

transform_synth = estimateMotion(synth1_rgb, synth2_rgb);

disp('Expected translation: [50, 30]')
disp('Estimated translation:')
disp(transform_synth.Translation)


% % Test video frame estimateMotion
disp("## Test estimateMotion (real video)")

% Extract two frames close together for visible but matchable motion
video_obj2 = loadVideo('test.mp4');
frameA_rgb = extractFrame(video_obj2, 1);
frameB_rgb = extractFrame(video_obj2, 10);

% Get transform + matched points + inliers for visualization
[transform_real, matched_pts1, matched_pts2, inliers] = estimateMotion(frameA_rgb, frameB_rgb);

disp('Estimated transform matrix:')
disp(transform_real.A)

% ---- by Claude: manual montage visualization (replaces showMatchedFeatures — fixes Retina zoom) ----
montage_img = [frameA_rgb, frameB_rgb];
offset = size(frameA_rgb, 2);
pts1 = matched_pts1(inliers,:);
pts2_offset = [matched_pts2(inliers,1) + offset, matched_pts2(inliers,2)];

figure('Name', 'Matched Features — real video', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
imshow(montage_img, 'InitialMagnification', 'fit');
hold on;
plot([pts1(:,1), pts2_offset(:,1)]', [pts1(:,2), pts2_offset(:,2)]', 'y-');
plot(pts1(:,1), pts1(:,2), 'go', 'MarkerSize', 4);
plot(pts2_offset(:,1), pts2_offset(:,2), 'ro', 'MarkerSize', 4);
title('Inlier matched features (frame 1 vs frame 10)');
hold off;
% ---- end Claude ----