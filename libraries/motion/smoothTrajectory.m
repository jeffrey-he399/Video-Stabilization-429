% by Mateo Noriega
% Input: raw_traj - M x 3 matrix where each frame contains a cumulative raw
%                   movement of the camera
%        W - Window around current frame to smooth out from
% Output: smooth_traj - Smoothed out version of the raw trajectory
function smooth_traj = smoothTrajectory(raw_traj, W)
  if W >= size(raw_traj, 1)
    error('Window size W (%d) must be smaller than the number of frames (%d)', W, size(raw_traj, 1));
  end

  % This can be changed to use another smoothing out method
  smooth_traj = movmean(raw_traj, W);

end