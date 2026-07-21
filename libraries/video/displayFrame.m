% by Mateo Noriega
% Input: frame_rgb — single frame as a uint8 array (color or grayscale)
% Output: none — renders the frame in a new figure window
function displayFrame(frame_rgb)
  figure('Units', 'pixels');

  imshow(frame_rgb, 'InitialMagnification', 'fit'); % I had issues with my monitor resolution and the image apearing at 2x size, this fixes it

  title('Frame');

end