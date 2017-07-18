function out=shiftingAnalysis(rec,subject_code)
rec( find(rec(:,8)<0.1) , 7)=0;  % treat too fast response as wrong
rec(find(rec(:,8)>5 | rec(:,8)<0.1 ),8 )=nan;  % delete outliers as in Miyake 2004
     sd=nanstd(rec(:,8)); 
     mn=nanmean(rec(:,8));
rec(find(rec(:,8)>mn+3*sd),8)=mn+3*sd; % triming as  Miyake 2004

for idx=5:size(rec,1) % skip first 3 as  Miyake 2004
    if rec(idx-1,7)==1  % only use trials following right response 
        if rec(idx-1,4)==rec(idx,4)
            if mod(sum(rec(idx-1,[6 7]),2),2)==mod(sum(rec(idx,[6 7]),2),2)
                rec(idx,9)=1; % repeat task, repeat response
            else
                rec(idx,9)=2; % repeat task, switch response
            end
        else
            if mod(sum(rec(idx-1,[6 7]),2),2)==mod(sum(rec(idx,[6 7]),2),2)
                rec(idx,9)=3; % switch task, repeat response
            else
                rec(idx,9)=4; % switch task, switch response
            end
        end
    end
end

out(1) =nanmean(rec(find(rec(:,9)<3),7)); %repeatAccu
out(2) =nanmean(rec(find(rec(:,9)<3 & rec(:,7)==1 ),8)); %repeatRT 
out(3) =nanmean(rec(find(rec(:,9)>2),7)); %swithAccu 
out(4) =nanmean(rec(find(rec(:,9)>2 & rec(:,7)==1 ),8)); %switchRT
out(5) =nanmean(rec(find(rec(:,9)==1),7)); %repeatbothAccu
out(6) =nanmean(rec(find(rec(:,9)==1 & rec(:,7)==1 ),8)); %repeatbothRT 
out(7) =nanmean(rec(find(rec(:,9)==2),7)); %swithresponseAccu 
out(8) =nanmean(rec(find(rec(:,9)==2 & rec(:,7)==1 ),8)); %switchresponseRT
out(9) =nanmean(rec(find(rec(:,9)==3),7)); %switchtaskAccu
out(10)=nanmean(rec(find(rec(:,9)==3 & rec(:,7)==1 ),8)); %switchtaskRT 
out(11)=nanmean(rec(find(rec(:,9)==4),7)); %swithbothAccu 
out(12)=nanmean(rec(find(rec(:,9)==4 & rec(:,7)==1 ),8)); %switchbothRT
out(13)=length(find(rec(:,9)==1)); % # repeatboth
out(14)=length(find(rec(:,9)==2)); % # switchresponse
out(15)=length(find(rec(:,9)==3)); % # switchtask
out(16)=length(find(rec(:,9)==4)); % # switchboth
out(17)=out(4)-out(2); %RtCost
out(18)=out(1)-out(3); %AccuCost
%     fprintf('repeat 正确率为 %0.2f,反应时为 %0.2f \n',out.repeatAccu, out.repeatRT);
%     fprintf('switch 正确率为 %0.2f,反应时为 %0.2f \n',out.swithAccu, out.switchRT);