% by Mateo Noriega
% Input: vid_obj — VideoReader object, index — frame number (1 to NumFrames)
% Output: frame_rgb — single frame as a uint8 array of size Height x Width x 3
function frame_rgb = extractFrame(vid_obj, index)
  % Bounds check
  if (index > vid_obj.NumFrames || index < 1)
    error('\nIndex out of bounds: Got [%d], Max[%d]', index, vid_obj.NumFrames)
  end

  frame_rgb = read(vid_obj, index);

end