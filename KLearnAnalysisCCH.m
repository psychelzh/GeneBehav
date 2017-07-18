%{
analysis script for KCL, Yee Lu
20131110
%}
function resultsMat=KLearnAnalysisCCH(Seq,subject_code)
% ResultsFile = dir('Results/sub*KLearn*');
% AnalySaveFile = 'resultsAna';
% mkdir('.',AnalySaveFile);
MID=1; % trial
Mtrial=2; % character number
Mcond=3; % presented for how many times
Mortho=4; % orthographic category; 1: left/right; 2: up/down;
Mres=5; % left or right key. counterbalance across subjects;
MRT=6; % reaction time;
Mscore=7; % 1: correct; 0 wrong;
Monset=8; % designed onset time
MAonset=9; % actually onset time
subID = subject_code;
% cd results;
% for ii = 1:length(ResultsFile)
%     eval(sprintf('load %s',ResultsFile(ii).name));
%     subID = str2num(ResultsFile(ii).name(4:6));

     sd=nanstd (Seq(:,MRT));
     mn=nanmean(Seq(:,MRT));
     Seq(find(Seq(:,MRT)<0.1),Mscore)=0; % treat too fast response as wrong
     Seq(find(Seq(:,MRT)>mn+3*sd | Seq(:,MRT)<0.1),MRT)=nan;


    RR = nanmean(Seq(:,Mres)~=0);
    CR = nanmean(Seq(:,Mscore));
    RT = nanmean(Seq(Seq(:,Mscore)==1,MRT));
    Utrial = unique(Seq(:,Mtrial));
    for ii = 1:length(Utrial)
        rep_tmp = Seq(Seq(:,Mtrial) == Utrial(ii) & Seq(:,MRT)>0.1 & Seq(:,Mscore)==1,:);
        if size(rep_tmp,1) == 2
            rep_prime_item(ii) = rep_tmp(1,MRT) - rep_tmp(2,MRT);
        else rep_prime_item(ii) = NaN;
        end
    end
    rep_prime = nanmean(rep_prime_item);
    resultsMat(1) = subID;
    resultsMat(2) = RR;
    resultsMat(3) = CR;
    resultsMat(4) = RT;
    resultsMat(5) = rep_prime;
% end
% disp(['response rate ' num2str(round(mean(resultsMat(:,2))*100)) '%'])
% disp(['correct rate ' num2str(round(mean(resultsMat(:,3))*100)) '%'])
% disp(['response time ' num2str(round(mean(resultsMat(:,4))*100)/100)])
% cd ../resultsAna
% save KLearnAna resultsMat
% cd ../
