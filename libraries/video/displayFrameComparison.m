% by Mateo Noriega
% Input: frame1_rgb, frame2_rgb — two frames as uint8 arrays to compare side by side
% Output: none — renders both frames in a single figure window using subplot
function displayFrameComparison(frame1_rgb, frame2_rgb)
  figure('Units', 'pixels');

  subplot(1, 2, 1)
  imshow(frame1_rgb, 'InitialMagnification', 'fit')
  title('Frame 1')

  subplot(1, 2, 2)
  imshow(frame2_rgb, 'InitialMagnification', 'fit')
  title('Frame 2')

end