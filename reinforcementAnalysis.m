function out=reinforcementAnalysis(Reinforcematerial,subject_code)

train=Reinforcematerial(1:120,:);
%第4列1反馈A对B错，0反馈B对A错，
%第7列1选ACE，0选BDF
%第四列＝第7列则等到win的反馈，否则得到lose的反馈
AB=train(find(ismember(train(:,1),'A')),:); 
CD=train(find(ismember(train(:,1),'C')),:);
EF=train(find(ismember(train(:,1),'E')),:); 
ABaccu=nanmean(cell2mat(AB(:,7)));
CDaccu=nanmean(cell2mat(CD(:,7)));
EFaccu=nanmean(cell2mat(EF(:,7)));

% AB=AB(1:5,:); % use only first 5 trials
% CD=CD(1:5,:); % use only first 5 trials
% EF=EF(1:5,:); % use only first 5 trials
winstay=zeros(1,4);loseshift =zeros(1,4);
for part=1:4
    for idx=(part-1)*10+[1:9]
        if cell2mat(AB(idx,4))==cell2mat(AB(idx,7)) & cell2mat(AB(idx,7))==cell2mat(AB(idx+1,7))
            winstay(part)=winstay(part)+1;
        end
        if cell2mat(AB(idx,4))~=cell2mat(AB(idx,7)) & cell2mat(AB(idx,7))~=cell2mat(AB(idx+1,7))
            loseshift(part) =loseshift(part) +1;
        end
    end
    for idx=(part-1)*10+[1:9]
        if cell2mat(CD(idx,4))==cell2mat(CD(idx,7)) & cell2mat(CD(idx,7))==cell2mat(CD(idx+1,7))
            winstay(part)=winstay(part)+1;
        end
        if cell2mat(CD(idx,4))~=cell2mat(CD(idx,7)) & cell2mat(CD(idx,7))~=cell2mat(CD(idx+1,7))
            loseshift(part) =loseshift(part) +1;
        end
    end
    for idx=(part-1)*10+[1:9]
        if cell2mat(EF(idx,4))==cell2mat(EF(idx,7)) & cell2mat(EF(idx,7))==cell2mat(EF(idx+1,7))
            winstay(part)=winstay(part)+1;
        end
        if cell2mat(EF(idx,4))~=cell2mat(EF(idx,7)) & cell2mat(EF(idx,7))~=cell2mat(EF(idx+1,7))
            loseshift(part) =loseshift(part) +1;
        end
    end
end

results=Reinforcematerial(121:end,:);
Atril=find(ismember(results(:,1),'A'));
Btril=find(ismember(results(:,1),'B'));
     sd=nanstd(cell2mat(results(:,6)));
     mn=nanmean(cell2mat(results(:,6)));
     for i=1:size(results,1)
         if cell2mat(results(i,6))<0.1
            results(i,7)={nan};
         end
         if cell2mat(results(i,6))>mn+3*sd | cell2mat(results(i,6))<0.1
            results(i,6)={nan};
         end
     end
out.ChooseAAccu=nanmean(cell2mat(results(Atril,7)));
% out.ChooseART  =nanmean(cell2mat(results(Atril,6)));
out.ChooseART  =nanmean(cell2mat(results(find(ismember(results(:,1),'A') & cell2mat(results(:,7))>0),6)));
out.AvoidBAccu =nanmean(cell2mat(results(Btril,7)));
% out.AvoidBRT   =nanmean(cell2mat(results(Btril,6)));
out.AvoidBRT   =nanmean(cell2mat(results(find(ismember(results(:,1),'B') & cell2mat(results(:,7))>0),6)));
out.winstay=winstay;
out.loseshift=loseshift;
out.ABaccu=ABaccu;
out.CDaccu=CDaccu;
out.EFaccu=EFaccu;
% out.ChooseAAccu=nanmean(cell2mat(results(Atril,7)));
% out.ChooseART  =nanmean(cell2mat(results(find(ismember(results(:,1),'A') & cell2mat(results(:,7))>0),6)));
% out.AvoidBAccu =nanmean(cell2mat(results(Btril,7)));
% out.AvoidBRT   =nanmean(cell2mat(results(find(ismember(results(:,1),'B') & cell2mat(results(:,7))>0),6)));


%     fprintf('ChooseA 正确率为 %0.2f,反应时为 %0.2f \n',out.ChooseAAccu, out.ChooseART);
%     fprintf('AvoidB  正确率为 %0.2f,反应时为 %0.2f \n',out.AvoidBAccu, out.AvoidBRT);
