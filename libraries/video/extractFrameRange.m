% by Mateo Noriega
% Input: vid_obj — VideoReader object, start_idx and end_idx - (1-based range)
% Output: frames_rgb - cell array of uint8 frames, each of size Height x Width x 3
function frames_rgb = extractFrameRange(vid_obj, start_idx, end_idx)
  % Bounds check
  if (start_idx > vid_obj.NumFrames || start_idx < 1)
    error('\nStart index out of bounds: Got [%d], Max[%d]', start_idx, vid_obj.NumFrames)
  end

  if (end_idx > vid_obj.NumFrames || end_idx < 1)
    error('\nEnd index out of bounds: Got [%d], Max[%d]', end_idx, vid_obj.NumFrames)
  end

  if (start_idx > end_idx)
    error('\nWrong order in indexes: Start [%d], End[%d]', start_idx, end_idx)
  end

  % %
  frames = cell(1, end_idx - start_idx + 1);

  for i = start_idx:end_idx
    frames{i - start_idx + 1} = extractFrame(vid_obj, i); % Weird syntax because frames index needs to go from 1 to start - end
  end

  frames_rgb = frames;

end