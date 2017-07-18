function stroop=stroopAnalysis(result,subject_code)
%     result(find(cell2mat(result(:,1))==1),:)=[];% delete practice
     if size(result,1)~=96  
        error(sprintf('some trials missed in subject %d !!',subject_code))
     end
      % 32418红，32511绿，34013兰，40644黄      r g b y
     result(:,8)={0}; % incongruent
     result((strncmp(result(:,3),'r',1) & cell2mat(result(:,4))==32418) | ...
                 (strncmp(result(:,3),'g',1) & cell2mat(result(:,4))==32511) | ...
                 (strncmp(result(:,3),'b',1) & cell2mat(result(:,4))==34013) | ...
                 (strncmp(result(:,3),'y',1) & cell2mat(result(:,4))==40644),8)={1}; %% cong
     temp=cell2mat(result(:,8));
     result(:,9)=num2cell([0; 2*temp(1:end-1)+(temp(2:end))+1]); % II 1,IC 2,CI 3,CC 4
     
     RT=cell2mat(result(:,5));
     RW=cell2mat(result(:,7));
     sd=nanstd(RT);
     mn=nanmean(RT);
     RW(RT<0.1)=0; % treat too fast response as wrong
     RT(RT>mn+3*sd | RT<0.1)=nan;
     if size(RT,1)~=96  
        error(sprintf('RT of some trials missed in subject %d !!',subject_code))
     end

%      if size(find(RW==0 | isnan(RT)),1)>15
%          sprintf('too much error in %s!!',ItemList{i})
%          return
%      end

    stroop(1) =subject_code; %% subject ID 14:22 
    stroop(2) =nanmean(RT( cell2mat(result(:,8))==1 & RW>0 ));   %cong
    stroop(3) =nanmean(RT( cell2mat(result(:,8))==0 & RW>0 ));   %incong
    stroop(4) =stroop(3)-stroop(2) ; %% effect size
    stroop(5) =mean(RW( cell2mat(result(:,8))==1 ));   %cong
    stroop(6) =mean(RW( cell2mat(result(:,8))==0 ));   %incong
    stroop(7) =stroop(5)-stroop(6); %% effect size
    stroop(8) =nanmean(RT(cell2mat(result(:,9))==1 & RW>0 )); %% II
    stroop(9) =nanmean(RT(cell2mat(result(:,9))==2 & RW>0 )); %% IC
    stroop(10)=nanmean(RT(cell2mat(result(:,9))==3 & RW>0 )); %% CI
    stroop(11)=nanmean(RT(cell2mat(result(:,9))==4 & RW>0 )); %% CC
    stroop(12)=mean(RW(cell2mat(result(:,9))==1)); %% II
    stroop(13)=mean(RW(cell2mat(result(:,9))==2)); %% IC
    stroop(14)=mean(RW(cell2mat(result(:,9))==3)); %% CI
    stroop(15)=mean(RW(cell2mat(result(:,9))==4)); %% CC
    stroop(16)=nanmean(RT( cell2mat(result(1:48,8))==0 & RW(1:48)>0 ))-nanmean(RT( cell2mat(result(1:48,8))==1 & RW(1:48)>0 ));
    stroop(17)=nanmean(RT(find( cell2mat(result(49:96,8))==0 & RW(49:96)>0 )+48))-nanmean(RT(find( cell2mat(result(49:96,8))==1 & RW(49:96)>0 )+48));

    stroop(18)=length(find(cell2mat(result(:,9))==1 & RW>0 ));
    stroop(19)=length(find(cell2mat(result(:,9))==2 & RW>0 ));
    stroop(20)=length(find(cell2mat(result(:,9))==3 & RW>0 ));
    stroop(21)=length(find(cell2mat(result(:,9))==4 & RW>0 ));
%     sprintf('一致反应时%0.2f\n不一致反应时%0.2f\n一致正确率%0.2f\n不一致正确率%0.2f',temp(2),temp(3),temp(5),temp(6));
% b=[temp(2),temp(3);temp(5),temp(6)]'
% plot(b)
% legend('RT', 'accuracy')
% 

