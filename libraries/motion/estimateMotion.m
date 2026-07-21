% by Mateo Noriega
% Input: 2 uint8 RGB frames (H x W x 3)
% Output: transform       - similarity transform object (use transform.A for the 3x3 transform matrix)
%         matched_pts1/2  - (x,y) coords of matched feature pairs in each frame
%         inliers         - logical vector, true = pair kept
function [transform, matched_pts1, matched_pts2, inliers] = estimateMotion(frame1_rgb, frame2_rgb)
  
% Step 1: Convert rgb frames to grayscale
  frame1_bw = rgb2gray(frame1_rgb);
  frame2_bw = rgb2gray(frame2_rgb);

% Step 2: Detect surf points
  surf_pts1 = detectSURFFeatures(frame1_bw, 'MetricThreshold', 100); % Default 1000
  surf_pts2 = detectSURFFeatures(frame2_bw, 'MetricThreshold', 100);

% Step 3: Extract features of detected points
  % features1/2 - M by 64 matrix where M is the number of features and 64 is the length of the descriptor of a feature
  %  64 = 4x4 sub-regions around feature x 4 numbers each (Σdx, Σdy, Σ|dx|, Σ|dy|)
  % coords1/2_xy - M by 2 matrix containing the actual position of the features extracted
  [features1, coords1_xy] = extractFeatures(frame1_bw, surf_pts1); 
  [features2, coords2_xy] = extractFeatures(frame2_bw, surf_pts2); 

% Step 4: Match features between frames
  % pairs_i = M by 2 matrix [i, j] (Feature i in frame1 matched to feature j in frame2, M total matches)
  % match_confidence = (For debugging) Distance between matched pairs (smaller = more confidence)
  % Set unique to true to enforce each feature in frame1 can only be matched with a single feature in frame2
  [pairs_i, match_confidence] = matchFeatures(features1, features2, 'Unique', true, 'MaxRatio', 0.8); % Default 0.6
                                                                     
% Step 5: Estimate transform from matched point pairs

  % Extract the (x,y) coords of each matched feature from both frames maintaining the same order as pairs_i
  matched_pts1 = coords1_xy.Location(pairs_i(:, 1), :);
  matched_pts2 = coords2_xy.Location(pairs_i(:, 2), :);

  % transform - Affine transformation matrix
  % inliers - (For debugging) Logic vector of same length as matched_pts1/2
  %   outlying which matched points RANSAC kept for the calculations of the transform matrix
  % 'similarity' - Captures shift, tilt and slight zoom
  [transform, inliers] = estgeotform2d(matched_pts1, matched_pts2, 'similarity', 'MaxDistance', 3); % Default 1.5

end