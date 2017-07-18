function temp = WM3Analysis(rec, subject_code)
RT = cell2mat(rec(:, 6));
%RW = cell2mat(rec(:, 5));
sd = nanstd(RT);
mn = nanmean(RT);
for i = 1:size(rec, 1)
    if cell2mat(rec(i, 6)) < 0.1
        rec(i, 5) = {0};
    end
    if cell2mat(rec(i, 6)) > mn + 3*sd | cell2mat(rec(i, 6)) < 0.1
        rec(i, 6) = {nan};
    end
    if isempty(rec{i, 5})
        rec(i, 5) = {nan};
    end
end

matchline =        find(ismember(rec(:, 4), 'match'));
nonmatchline =     find(ismember(rec(:, 4), 'nonmatch'));
foilline =         find(ismember(rec(:, 4), 'foil'));
corrmatchline =    find(ismember(rec(:, 4), 'match') & cell2mat(rec(:, 5)) > 0);
corrnonmatchline = find(ismember(rec(:, 4), 'nonmatch') & cell2mat(rec(:, 5)) > 0);
corrfoilline =     find(ismember(rec(:, 4), 'foil') & cell2mat(rec(:, 5)) > 0);

temp(1) = subject_code; %% subject ID
%The former code is 'temp(2) = nanmean(cell2mat(rec(find(cell2mat(rec(:,
%5)) > 0), 6)));  %overall RT'
temp(2) = nanmean(cell2mat(rec(cell2mat(rec(:, 5)) > 0, 6)));  %overall RT 
temp(3) = length(find(cell2mat(rec(:, 5)) > 0)) / 6 / 12;  %overall accu
temp(4) = nanmean(cell2mat(rec(corrmatchline, 6)));  
temp(5) = nanmean(cell2mat(rec(corrnonmatchline, 6))); 
temp(6) = nanmean(cell2mat(rec(corrfoilline, 6))); 
temp(7) = length(corrmatchline) / length(matchline);  
temp(8) = length(corrnonmatchline) / length(nonmatchline);  
temp(9) = length(corrfoilline) / length(foilline);  

temp(10) = length(find(ismember(rec(:, 4), 'nonmatch') & cell2mat(rec(:, 5)) == 0)) / length(nonmatchline); % FAnonmatch 
temp(11) = length(find(ismember(rec(:, 4), 'foil') & cell2mat(rec(:, 5)) == 0)) / length(foilline); %FAfoil
temp(12) = (temp(11) + temp(10)) / 2; %FAnonmatchfoil
if temp(7) == 1
    temp(7) = 0.99;
elseif temp(7) == 0
    temp(7) = 0.01;
end
if temp(10) == 1
    temp(10) = 0.99;
elseif temp(10) == 0
    temp(10) = 0.01;
end
if temp(11) == 1
    temp(11) = 0.99;
elseif temp(11) == 0
    temp(11) = 0.01;
end
if temp(12) == 1
    temp(12) = 0.99;
elseif temp(12) == 0
    temp(12) = 0.01;
end

temp(13) = norminv(temp(7)) - norminv(temp(10)); %dprimeMatchNonMatch 
temp(14) = norminv(temp(7)) - norminv(temp(11)); %dprimeMatchFoil 
temp(15) = norminv(temp(7)) - norminv(temp(12)); %dprimeMatchNonMatchFoil 

temp(16) = length(find(~isnan(cell2mat(rec(:, 5))))) / 6 / 12; % response rate

%     fprintf('match    正确率为 %0.2f, 反应时为 %0.2f \n', temp(5),  temp(2))
%     fprintf('nonmatch 正确率为 %0.2f, 反应时为 %0.2f \n', temp(6),  temp(3))
%     fprintf('foil     正确率为 %0.2f, 反应时为 %0.2f \n', temp(7),  temp(4))