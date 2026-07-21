% by Mateo Noriega
% MATLAB does not recursively search subfolders so each library path must be added explicitly
function setup()
  addpath('libraries/video/');
  addpath('libraries/motion/');

  % addpath(genpath('libraries')); % Adds recursively all subfolders inside

end