function [RT ACC]=CateSwitchAnalysisCCH(SM,subject_code)

Mtrial=1; % trial number
MID=2;  % material id
Mtask=3;%1=living/nonliving;2=size
MsemL=4; % semantic category for live;  1,nonliving; 2,living
MsemS=5; % semantic category for size;  1,bigger; 2,smaller
Mcorr=6; % correct response for this trial, left vs. right. 1 or 2;
Mres=7; % left or right key. left: living; right: nonliving;
Mscore=8; % 1: correct; 0 wrong;
MRT=9; % reaction time;
%Monset=10; % designed onset time
MAonset=11; % actually onset time
Mst=12;%task switch or not
Msr=13;%response switch or not
%%added information
Mcond=14;% 1: 4conds: 1=non_switch 2=task_swtich 3=response_switch 4=task&response_switch

    SM(1,Msr)=0;
    for idx=2:size(SM,1)
        if SM(idx-1,Mcorr)==SM(idx,Mcorr)
            SM(idx,Msr)=1; % response not switch
        else
            SM(idx,Msr)=2; % response switch
        end
    end
     % treat outlier
     sd=nanstd (SM(:,MRT));
     mn=nanmean(SM(:,MRT));
     SM(find(SM(:,MRT)<0.1),Mscore)=0; % treat too fast response as wrong
     SM(find(SM(:,MRT)>mn+3*sd | SM(:,MRT)<0.1),MRT)=nan;

    %load learning files
    subln=SM;
%     subln(subln(:,Mcond)==0,:)=[];%get rid of filler
    
    
    % group into 4 condition
    subln(subln(:,Mst)==1 & subln(:,Msr)==1,Mcond)=1;% non_switch
    subln(subln(:,Mst)==2 & subln(:,Msr)==1,Mcond)=2;% task_switch
    subln(subln(:,Mst)==1 & subln(:,Msr)==2,Mcond)=3;% response_switch
    subln(subln(:,Mst)==2 & subln(:,Msr)==2,Mcond)=4;% task&response_switch
      
   %% ACC & RT
   for cond=1:4 
       semtrial=subln(subln(:,Mcond)==cond,:);

       ACC(cond)=nanmean(semtrial(:,Mscore));
       RT(cond)=nanmean(semtrial(semtrial(:,Mscore)==1,MRT));
   end 
   
   
       semtrial=subln(subln(:,Mcond)==1 | subln(:,Mcond)==3,:); % taskrepeat
       ACC(5)=nanmean(semtrial(:,Mscore));
       RT(5)=nanmean(semtrial(semtrial(:,Mscore)==1,MRT));
       semtrial=subln(subln(:,Mcond)==2 | subln(:,Mcond)==4,:); % taskswitch
       ACC(6)=nanmean(semtrial(:,Mscore));
       RT(6)=nanmean(semtrial(semtrial(:,Mscore)==1,MRT));
       ACC(7)=ACC(5)-ACC(6); 
       RT(7)=RT(6)-RT(5);
       
       ACC=ACC([5 6 1:4 7]); % repeat switch noswith taskswitch responseswitch bothswith cost
       RT=RT([5 6 1:4 7]); % repeat switch noswith taskswitch responseswitch bothswith cost
       


