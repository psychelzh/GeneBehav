function delay=DelayDiscountAnalysis(kvalArray,rewardArray,timeArray,choiceArray,subject_code)
delay(1)=subject_code;
delay(2)=nanmean(kvalArray(end-4:end));
delay(3)=nanmean(kvalArray(end));

r1 = repmat(60,length(rewardArray),1); %% changed to 60 because 60 was setup in experiment
d1 = zeros(length(timeArray),1);
r2 = rewardArray(1:end);
d2 = timeArray(1:end);
choice = choiceArray(1:end);

% if ~isempty(find(r2<0))
%     delay(4:6)=nan;
%     sprintf('subject %d have negative r2',subject_code)
%     return
% end

data = [r1 d1 r2 d2 choice];
data(find(choice==0),:)=[]; % delete unresponded trials
[delay(4) delay(5) delay(6)] = FitK(data); %k, m, LL
