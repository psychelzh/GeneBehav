function resultsMat = FNLearnAnalysisCCH(Seq, subject_code)
%以下四项未用，注释起来也许更好（张亮，20140701）
% MID=1;% onset ordersca
% Mtrial=2; % trial number
% Mcond=3;% trail 1-> male; 2-> female
% MAonset=4; % actual onset time
Mres = 5; % subject's response, 1->'f',2->'k'
MRT = 6;
if size(Seq, 2) > 4
    RR = mean(Seq(:, Mres) ~= 0);
    FR = mean(Seq(Seq(:, Mres) ~= 0, Mres) == 1);
    RT = mean(Seq(Seq(:, Mres) ~= 0, MRT));
else
    RR = nan;
    FR = nan;
    RT = nan;
end
resultsMat(1) = subject_code;
resultsMat(2) = RR;
resultsMat(3) = FR;
resultsMat(4) = RT;
