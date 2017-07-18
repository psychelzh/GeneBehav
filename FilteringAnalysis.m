function temp=FilteringAnalysis(rec,subject_code)
     sd=nanstd(rec(:,6));
     mn=nanmean(rec(:,6));
    rec(rec(:,6)<0.1 ,5)=0 ;
    rec(rec(:,6)>mn+3*sd | rec(:,6)<0.1 ,6)=nan ;
    
    
    temp(1)=subject_code; %% subject ID
    temp(2)=nanmean(rec(:,5));  % total acc
    temp(3)=nanmean(rec(rec(:,5)>0,6)); %total meanRT
    
    temp(4) =nanmean(rec(rec(:,3)==0,5));  % d0 acc
    temp(5) =nanmean(rec(rec(:,3)==0 & rec(:,5)>0,6)); %d0 meanRT
    temp(6) =nanmean(rec(rec(:,3)==2,5));  % d2 acc
    temp(7) =nanmean(rec(rec(:,3)==2 & rec(:,5)>0,6)); %d2 meanRT
    temp(8) =nanmean(rec(rec(:,3)==4,5));  % d4 acc
    temp(9) =nanmean(rec(rec(:,3)==4 & rec(:,5)>0,6)); %d4 meanRT
    temp(10)=nanmean(rec(rec(:,3)==6,5));  % d6 acc
    temp(11)=nanmean(rec(rec(:,3)==6 & rec(:,5)>0,6)); %d6 meanRT
    temp(12)=nanmean(rec(rec(:,3)>=4,5))-nanmean(rec(rec(:,3)<4,5)); %d46-d02 acc
    temp(13)=nanmean(rec(rec(:,3)>=4 & rec(:,5)>0,6))-nanmean(rec(rec(:,3)<4 & rec(:,5)>0,6)); %d46-d02 RT
    temp(14)=temp(10)-temp(4);%d6-d0 acc
    temp(15)=temp(11)-temp(5);%d6-d0 RT
    
    hits= length(find(rec(:,2)==1 & rec(:,5)==1 ))/length(find(rec(:,2)==1));
    FA  = length(find(rec(:,2)==0 & rec(:,5)==0 ))/length(find(rec(:,2)==0));
    if FA==0, FA = 0.01; end
    if FA==1, FA = 0.99; end
    if hits==0, hits = 0.01; end
    if hits==1, hits = 0.99; end
    temp(16)= norminv(hits) - norminv(FA); % dprime
    temp(17)= 2*(hits-FA); %memory capacity :KS(H-F), from Ophir 2009 PNAS

