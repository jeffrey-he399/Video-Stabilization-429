% by Mateo Noriega
% Input: file_name — name of the video file inside the sources/ directory
% Output: vid_obj — VideoReader object with the loaded video
function vid_obj = loadVideo(file_name)
  path = ['sources/' file_name]; % Relative path 

  if ~exist(path, 'file')
    error('\nVideo not found: %s', path)
  end

  vid_obj = VideoReader(path);

  % Debug
  %         Loaded: file_path | resolution | fps | # of frames in the video

  fprintf('\nLoaded: %s | %d X %d | %g fps | %d frames\n', vid_obj.Path, vid_obj.Width, vid_obj.Height, vid_obj.FrameRate, vid_obj.NumFrames)
end