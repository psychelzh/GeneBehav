function resultsMat=AntiSacAnalysisCCH(Seq,subject_code)
% MID = 1; % trial
% MLoc = 2; % location of 
% Mdirec = 3; % target direction
% Mdur = 4; % fixation duration
% Mres = 5; % left or right key;
MRT = 6; % reaction time;
Mscore = 7; % 1: correct; 0 wrong;
% MAonset = 8; % actually onset time

% Set invalid responses as NaN.
sd = nanstd(Seq(:, MRT));
mn = nanmean(Seq(:, MRT));
Seq(Seq(:, MRT) < 0.1, Mscore) = 0; % treat too fast response as wrong
Seq(Seq(:, MRT) > mn + 3 * sd | Seq(:, MRT) < 0.1, MRT)=nan;

resultsMat(1) = subject_code;
resultsMat(2) = mean(Seq(:, Mscore));
resultsMat(3) = nanmean(Seq(Seq(:, Mscore) > 0, MRT));