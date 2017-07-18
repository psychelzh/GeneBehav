function  resultsMat = FNRecogAnalysisCCH(Seq, subject_code)
%所有未使用的项都注释了。
% MID=1;% onset ordersca
% Mtrial=2; % trial number
% Mcond=3;% trail 1-> male; 2-> female
Moldnew = 4;% trail 1-> old-association; 2-> old-item-new-association; 3-> new items
% Mname = 5;% nametrial
% MAonset=6; % actual onset time
Mres = 7; % subject's response, 1->'s',2->'d',3->'f',4->'j',5->'k',6->'l'
% MRT=8;

subID = subject_code;
hits = mean(Seq(Seq(:, Moldnew) == 1, Mres) > 3);
if hits == 1
    hits = 0.99;
elseif hits == 0
    hits = 0.01;
end
FA_recomb = mean(Seq(Seq(:, Moldnew) == 2, Mres) > 3); % recombination false alarm
FA_new = mean(Seq(Seq(:, Moldnew) == 3, Mres) > 3); % new false alarm
FA_both = mean(Seq(Seq(:, Moldnew) ~= 1, Mres) > 3); % both new and recombination false alarm
if ~FA_recomb
    FA_recomb = 0.01;
end
if ~FA_new
    FA_new = 0.01;
end
if ~FA_both
    FA_both = 0.01;
end

if FA_recomb == 1
    FA_recomb = 0.99;
end
if FA_new == 1
    FA_new = 0.99;
end
if FA_both == 1
    FA_both = 0.99;
end


dprime_recomb = norminv(hits) - norminv(FA_recomb);
dprime_new = norminv(hits) - norminv(FA_new);
dprime_both = norminv(hits) - norminv(FA_both);
resultsMat(1) = subID;
resultsMat(2) = hits;
resultsMat(3) = FA_recomb;
resultsMat(4) = FA_new;
resultsMat(5) = FA_both;
resultsMat(6) = dprime_recomb;
resultsMat(7) = dprime_new;
resultsMat(8) = dprime_both;

% disp(['hits rate ' num2str(round(mean(resultsMat(:,2))*100)) '%'])
% disp(['foil rate ' num2str(round(mean(resultsMat(:,3))*100)) '%'])
% disp(['FA rate ' num2str(round(mean(resultsMat(:,4))*100)) '%'])
% disp(['dprime ' num2str(round(mean(resultsMat(:,5))*100)/100)])

