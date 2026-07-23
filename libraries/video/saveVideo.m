% by Mateo Noriega
% Input: frames — cell array of uint8 frames
%        file_name — output filename
%        fps — frame rate
% Output: none — writes the frames as an MPEG-4 video to the output/ directory
function saveVideo(frames, file_name, fps)

  if ~exist('output', 'dir')
    mkdir('output');
  end

  path = strcat('output/', file_name);


  vid_obj = VideoWriter(path, 'MPEG-4'); % Sets video encoding to mp4 for compatibility

  vid_obj.FrameRate = fps;

  open(vid_obj);


  for i = 1:length(frames)
    writeVideo(vid_obj, frames{i});
  end

  % Debug
  %         Stored: file_path | resolution | fps | # of frames in the video

  fprintf('\nStored: %s | %d X %d | %g fps | %d frames\n', path, size(frames{1}, 2), size(frames{1}, 1), fps, length(frames))



  close(vid_obj);

end