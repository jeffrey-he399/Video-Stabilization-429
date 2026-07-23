% by Mateo Noriega
% Input: frames - cell array of uint8 frames
%        correction - M by 3 correction matrix
% Output: stabilized — cell array of uint8 frames
function stabilized = applyStabilization(frames, correction)
  stabilized = cell(size(frames));
  M = length(frames);

  for i = 1:M
    tform = simtform2d(1, correction(i, 3), correction(i, 1:2)); % Get the change required for this frame
    warped = imwarp(frames{i}, tform, 'OutputView', imref2d(size(frames{1}))); % Apply the changes and keep canvas size as original (OutputView)
    
    stabilized{i} = warped;
  end
end