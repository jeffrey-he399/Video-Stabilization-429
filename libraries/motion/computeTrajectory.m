% by Mateo Noriega & Jeffrey He
% Input: vid_obj - VideoReader object with M frames
% Output: trajectory - M x 3 matrix where each frame contains the cumulative movement 
%                      data of the camera relative to the start of the video [dx, dy, dθ (in degrees)]
%
% Windows compatible version

function trajectory = computeTrajectory(vid_obj)
  vid_obj = VideoReader(fullfile(vid_obj.Path, vid_obj.Name)); % Use a fresh reader in case the original reader is at the end of the file

  estimated_frames = max(1, ceil(vid_obj.Duration * vid_obj.FrameRate));
  trajectory = zeros(estimated_frames, 3);

  frameA_rgb = readFrame(vid_obj);
  i = 1;

  while hasFrame(vid_obj)
    frameB_rgb = readFrame(vid_obj);

    transform = estimateMotion(frameA_rgb, frameB_rgb);

    dx = transform.Translation(1);
    dy = transform.Translation(2);
    dAngle = transform.RotationAngle;

    trajectory(i+1, :) = trajectory(i, :) + [dx, dy, dAngle]; % Accumulate in i+1
    frameA_rgb = frameB_rgb;
    i = i + 1;
  end

  trajectory = trajectory(1:i, :);
end
