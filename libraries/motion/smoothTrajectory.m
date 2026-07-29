% by Mateo Noriega & Jeffrey He
% Input: raw_traj - M x 3 matrix where each frame contains a cumulative raw
%                   movement of the camera
%        W - Window around current frame to smooth out from
% Output: smooth_traj - Smoothed out version of the raw trajectory
function smooth_traj = smoothTrajectory(raw_traj, W)

  M = size(raw_traj, 1); % Number of frames

  % Make sure the smoothing window is shorter than the video:
  if W >= M
    error('Window size W (%d) must be smaller than the number of frames (%d)', ...
      W, M);
  end

  % Setup a window size containing 15 previous frames, 1 current frame and
  % 15 future frames:
  if mod(W, 2) == 0
    W = W + 1;
  end

  % Number of frames required for the previous and future frames:
  half_window = (W - 1) / 2;

  % Estimate the general camera movement at the beginning and ending of the 
  % video:
  velocity_span = min(W, M);

  % Estimate average trajectory change at the beginning:
  start_velocity = (raw_traj(velocity_span,:) - raw_traj(1,:)) / ...
      (velocity_span - 1);

  % Estimate average trajectory change at the ending:
  end_velocity = (raw_traj(end,:) - raw_traj(end-velocity_span+1,:)) / ...
      (velocity_span - 1);

  % Generate artificial frames before the video begins:
  pre_frames = (-half_window:-1)';

  % Generate artificial frames after the video ends:
  post_frames = (1:half_window)';

  % Extrapolate the trajectory backward before the first actual frame:
  pre_padding = raw_traj(1,:) + pre_frames * start_velocity;

  % Extrapolate the trajectory forward after the final actual frame:
  post_padding = raw_traj(end,:) + post_frames * end_velocity;

  % Create padded trajectory based on past, current and post trajectory:
  padded_traj = [pre_padding; raw_traj; post_padding];

  % Smooth the padded trajectory based on padded trajectory:
  padded_smooth = movmean(padded_traj, W, 1);

  % Remove the artificial trajectory samples and only return frames belong
  % to the actual video:
  smooth_traj = padded_smooth(half_window + 1 : half_window + M, :);
end
