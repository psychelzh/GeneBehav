function temp=WM2Analysis(rec,subject_code)

     sd=nanstd(rec(:,5));
     mn=nanmean(rec(:,5));
    rec(find(rec(:,5)<0.1 ),4)=0 ;
    rec(find(rec(:,5)>mn+3*sd | rec(:,5)<0.1 ),5)=nan ;
     
    temp(1)=subject_code; %% subject ID
    temp(2)=length(find(rec(:,4)>0))/4/22; %nanmean(rec(:,4));  
    temp(3)=nanmean(rec(find(rec(:,4)>0),5)); 
    temp(4)=length(find(~isnan(rec(:,4))))/4/22; % response rate
%     temp(4)=nanmean(cell2mat(rec(foilline,6))); 
%     temp(5)=nanmean(cell2mat(rec(matchline,5)));  
%     temp(6)=nanmean(cell2mat(rec(nonmatchline,5)));  
%     temp(7)=nanmean(cell2mat(rec(foilline,5))); 
    
%     fprintf('match    正确率为 %0.2f,反应时为 %0.2f \n',temp(5), temp(2))
%     fprintf('nonmatch 正确率为 %0.2f,反应时为 %0.2f \n',temp(6), temp(3))
%     fprintf('foil     正确率为 %0.2f,反应时为 %0.2f \n',temp(7), temp(4))