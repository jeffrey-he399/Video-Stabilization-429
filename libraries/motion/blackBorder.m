% by Jeffrey He
% Input:
%   frames     - cell array containing the already stabilized frames
%   correction - M by 3 stabilization correction matrix [dx, dy, dTheta]
%
% Output:
%   borderless - stabilized frames cropped to a common valid region and
%                resized back to the original video resolution
%   crop_rect  - crop used for every frame [x, y, width, height]
function [borderless, crop_rect] = blackBorder(frames, correction)
  % Number of frames:
  M = length(frames);
  
  % Read dimention of first frame:
  frame_size = size(frames{1});
  H = frame_size(1);
  W = frame_size(2);
  output_ref = imref2d([H, W]);
  
  % Create floating point mask. Every image location is assumed to be true
  % unless real image content is not present in the loop:
  common_valid = true(H, W);
  source_mask = ones(H, W);
  
  % Process the correction associated with every stabilized frame:
  for i = 1:M
    tform = simtform2d(1, correction(i, 3), correction(i, 1:2));
    warped_mask = imwarp(source_mask, tform, 'linear', ...
      'OutputView', output_ref);

    common_valid = common_valid & (warped_mask >= 1 - 1e-6);
  end

  % Find the largest valid rectangle area that contains only true pixels
  % and has approximately the same aspect ratio as the original video:
  [crop_y, crop_x, crop_h, crop_w] = largestValidCrop(common_valid, H, W);
  crop_rect = [crop_x, crop_y, crop_w, crop_h];

  borderless = cell(size(frames));
  rows = crop_y:(crop_y + crop_h - 1);
  cols = crop_x:(crop_x + crop_w - 1);
  
  % Apply the same crop to every stabilized frame:
  for i = 1:M
    cropped_frame = frames{i}(rows, cols, :);
    borderless{i} = imresize(cropped_frame, [H, W]);
  end
end

% Finding the largest rectangle containing only true pixel with original 
% video's aspect ratio:
function [best_y, best_x, best_h, best_w] = largestValidCrop(valid_mask, H, W)
  
  % Invert the validity mask, converting the logical result to double:
  invalid = double(~valid_mask);
  summed = zeros(H + 1, W + 1);
  summed(2:end, 2:end) = cumsum(cumsum(invalid, 1), 2);
    
  % Candidate crop parameters:
  low_h = 1;
  high_h = H;
  best_y = [];
  best_x = [];
  best_h = 0;
  best_w = 0;

  % Finding the largest usable crop by using binary search:
  while low_h <= high_h
    
    % Test the height halfway between the lower and upper bounds:
    candidate_h = floor((low_h + high_h) / 2);
    % Calculate the width that preserves the original aspect ratio:
    candidate_w = min(W, max(1, floor(candidate_h * W / H)));
    
    % Calculate the number of invalid pixels inside every possible
    % candidate_h by candidate_w rectangle:
    rectangle_sums = ...
      summed((candidate_h + 1):end, (candidate_w + 1):end) ...
      - summed(1:(end - candidate_h), (candidate_w + 1):end) ...
      - summed((candidate_h + 1):end, 1:(end - candidate_w)) ...
      + summed(1:(end - candidate_h), 1:(end - candidate_w));

    % Locate candidate rectangles containing zero invalid pixels:
    [candidate_rows, candidate_cols] = find(rectangle_sums == 0);
    
    % If no vakud rectabgke exists at this size, the candidate is too
    % large:
    if isempty(candidate_rows)
      high_h = candidate_h - 1;
      continue;
    end

    % Calculate the valid crop closest to the image centre:
    target_y = (H - candidate_h) / 2 + 1;
    target_x = (W - candidate_w) / 2 + 1;
    centre_distance = ...
      (candidate_rows - target_y).^2 + (candidate_cols - target_x).^2;
    [~, closest] = min(centre_distance);
    
    % Saving best rectangle parameters found at this size: 
    best_y = candidate_rows(closest);
    best_x = candidate_cols(closest);
    best_h = candidate_h;
    best_w = candidate_w;
    low_h = candidate_h + 1;
  end
end
