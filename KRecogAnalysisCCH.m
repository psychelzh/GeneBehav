%{
analysis script for KCL, Yee Lu
20131110
%}
function  resultsMat=KRecogAnalysisCCH(Seq,subject_code)
% ResultsFile = dir('Results/sub*KRecog*');
% AnalySaveFile = 'resultsAna';
% mkdir('.',AnalySaveFile);
MID=1; %
Mtrial=2; % reaction time;
Moldnew=3; % 1 old. 2,new;
Mres=4; % 1, 2, 4, 8;
Mscore=5;
MRT=6;
MAonset=7; % actually onset time
% cd Results
subID = subject_code;
% for ii = 1:length(ResultsFile)
%     eval(sprintf('load %s',ResultsFile(ii).name));
%     subID = str2num(ResultsFile(ii).name(4:6));
    hits = mean(Seq(Seq(:,Moldnew)==1,Mres)>3);
    misses = mean(Seq(Seq(:,Moldnew)==1,Mres)<4);
    FA = mean(Seq(Seq(:,Moldnew)==2,Mres)>3);
    CR = mean(Seq(Seq(:,Moldnew)==2,Mres)<4);
    
    if ~FA, FA = 0.01; end
    if FA==1, FA = 0.99; end
    if ~hits, hits = 0.01; end
    if hits==1, hits = 0.99; end
    
    dprime = norminv(hits) - norminv(FA);
    resultsMat(1) = subID;
    resultsMat(2) = hits;
    resultsMat(3) = misses;
    resultsMat(4) = FA;
    resultsMat(5) = CR;
    resultsMat(6) = dprime;
% end
% disp(['hits rate ' num2str(round(mean(resultsMat(:,2))*100)) '%'])
% disp(['FA rate ' num2str(round(mean(resultsMat(:,4))*100)) '%'])
% disp(['dprime ' num2str(round(mean(resultsMat(:,6))*100)/100)])
% cd ../resultsAna
% save KTestAna resultsMat
% cd ../
