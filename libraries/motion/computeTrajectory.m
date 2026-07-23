% by Mateo Noriega
% Input: vid_obj - VideoReader object with M frames
% Output: trajectory - M x 3 matrix where each frame contains the cumulative movement 
%                      data of the camera relative to the start of the video [dx, dy, dθ (in degrees)]
function trajectory = computeTrajectory(vid_obj)
  M = vid_obj.NumFrames;
  trajectory = zeros(M, 3);

  for i = 1:(M-1)
    frameA_rgb = extractFrame(vid_obj, i);
    frameB_rgb = extractFrame(vid_obj, i+1);

    transform = estimateMotion(frameA_rgb, frameB_rgb);

    dx = transform.Translation(1);
    dy = transform.Translation(2);
    dAngle = transform.RotationAngle;

    trajectory(i+1, :) = trajectory(i, :) + [dx, dy, dAngle]; % Accumulate in i+1
  end
end