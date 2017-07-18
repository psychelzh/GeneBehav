function data = stopsignalAnalysis(Seeker, ~)
% Questions:
%  1,  What about the input argument 'subject_code'(Here replaced by ~)? And all of those
%  variables not used at the time?
%  2,  What abut the function 'find'?
type = 1;
JitterType = 1;
LEFT = 70;
RIGHT = 74;
RT = Seeker(:, 8);
sd = nanstd(RT);
mn = nanmean(RT);
Seeker((Seeker(:, 8) < 0.1 & Seeker(:, 8) > 0) | Seeker(:, 8) > mn + 3 * sd, 8) = nan; % 反应时在(0, 0.1)区间和在三个标准差之外的去除。

%%% kluge to create ladders from Seeker
Ladder1  =  Seeker(Seeker(:, 5) == 1, 6);
Ladder2  =  Seeker(Seeker(:, 5) == 2, 6);
Ladder3  =  Seeker(Seeker(:, 5) == 3, 6);
Ladder4  =  Seeker(Seeker(:, 5) == 4, 6);
[r, ~]  =  size(Seeker); num_blocks  =  Seeker(r, 2);

if JitterType == 1,  CUTOFF  =  11; else CUTOFF = 6; end;

% ymax = max(max([Ladder1 Ladder2 Ladder3 Ladder4]));
% ymin = min(min([Ladder1 Ladder2 Ladder3 Ladder4]));
% if ymin > 0, 
% 	ymin = 0;
% end;
% xmax = 4 * num_blocks;

% for a = 1:size(Ladder1), 
% 	Ladder1Plot(2 * a-1) = Ladder1(a);
% 	Ladder2Plot(2 * a-1) = Ladder2(a);
% 	Ladder3Plot(2 * a-1) = Ladder3(a);
% 	Ladder4Plot(2 * a-1) = Ladder4(a);
% 	Ladder1Plot(2 * a) = Ladder1(a);
% 	Ladder2Plot(2 * a) = Ladder2(a);
% 	Ladder3Plot(2 * a) = Ladder3(a);
% 	Ladder4Plot(2 * a) = Ladder4(a);
% end;

% %%%%% plotting
% fhandle = figure;
% subplot(2, 2, 1);
% for a = 1:size(Ladder1)-1;
% 	hold on;
% 	plot(a:a + 1, Ladder1Plot(2 * a-1:2 * a),  'b');
% 	plot([a + 1 a + 1], Ladder1Plot(2 * a:2 * a + 1),  'b');
% end;
% title(['Sub' num2str(subject_code)]); %% cch added
% axis([1 xmax ymin ymax]);
% subplot(2, 2, 2);
% for a = 1:size(Ladder2)-1;
% 	hold on;
% 	plot(a:a + 1, Ladder2Plot(2 * a-1:2 * a),  'b');
% 	plot([a + 1 a + 1], Ladder2Plot(2 * a:2 * a + 1),  'b');
% end;
% axis([1 xmax ymin ymax]);
% subplot(2, 2, 3);
% for a = 1:size(Ladder3)-1;
% 	hold on;
% 	plot(a:a + 1, Ladder3Plot(2 * a-1:2 * a),  'b');
% 	plot([a + 1 a + 1], Ladder3Plot(2 * a:2 * a + 1),  'b');
% end;
% axis([1 xmax ymin ymax]);
% subplot(2, 2, 4);
% for a = 1:size(Ladder4)-1;
% 	hold on;
% 	plot(a:a + 1, Ladder4Plot(2 * a-1:2 * a),  'b');
% 	plot([a + 1 a + 1], Ladder4Plot(2 * a:2 * a + 1),  'b');
% end;
% axis([1 xmax ymin ymax]);
% print(fhandle, '-dpsc', '-append', 'SSLadder'); %% cch added
% close(fhandle)

%%%% Actual Analysis...
if type == 1
%GRTmedian = median(Seeker(find(((Seeker(:, 3) == 0 & Seeker(:, 4) == 0&Seeker(:, 7) == LEFT)|Seeker(:, 3) == 0 & (Seeker(:, 4) == 1&Seeker(:, 7) == RIGHT))&Seeker(:, 3) == 0), 8)) * 1000;
%GRTmean = mean(Seeker(find(((Seeker(:, 3) == 0 & Seeker(:, 4) == 0&Seeker(:, 7) == LEFT)|Seeker(:, 3) == 0 & (Seeker(:, 4) == 1&Seeker(:, 7) == RIGHT))&Seeker(:, 3) == 0), 8)) * 1000;
% x = Seeker(find(((Seeker(:, 3) == 0 & Seeker(:, 4) == 0 & Seeker(:, 7) == LEFT) | (Seeker(:, 3) == 0 & Seeker(:, 4) == 1 & Seeker(:, 7) == RIGHT)) ), 8) * 1000;
% GRTmedian = median(x(132:end))
x = Seeker(((Seeker(132:end, 3) == 0 & Seeker(132:end, 4) == 0 & Seeker(132:end, 7) == LEFT) | (Seeker(132:end, 3) == 0 & Seeker(132:end, 4) == 1 & Seeker(132:end, 7) == RIGHT)), 8) * 1000;
GRTmedian = nanmedian(x);

inhi = find(Seeker(:, 3) == 1 & Seeker(:, 10) == 1); inhi = Seeker(intersect([inhi + 1;inhi + 2], 1:size(Seeker, 1)), :); % two trials after inhibition
inhiRT = nanmean(inhi((inhi(:, 3) == 0 & inhi(:, 4) == 0 & inhi(:, 7) == LEFT) | (inhi(:, 3) == 0 & inhi(:, 4) == 1 & inhi(:, 7) == RIGHT), 8)) * 1000;
noninhi = find(Seeker(:, 3) == 1 & Seeker(:, 10) == -1); noninhi = Seeker(intersect([noninhi + 1;noninhi + 2], 1:size(Seeker, 1)), :); % two trials after noninhibition
noninhiRT = nanmean(noninhi((noninhi(:, 3) == 0 & noninhi(:, 4) == 0 & noninhi(:, 7) == LEFT) | (noninhi(:, 3) == 0 & noninhi(:, 4) == 1 & noninhi(:, 7) == RIGHT), 8)) * 1000;

end

if type == 2 || type == 3
GRTmedian = median(Seeker(Seeker(:, 3) == 0 & Seeker(:, 8) > 0, 8)) * 1000;
GRTmean = mean(Seeker(Seeker(:, 3) == 0 & Seeker(:, 8) > 0, 8)) * 1000;
end

Ladder1mean = nanmean(Ladder1(CUTOFF:num_blocks * 4));
Ladder2mean = nanmean(Ladder2(CUTOFF:num_blocks * 4));
Ladder3mean = nanmean(Ladder3(CUTOFF:num_blocks * 4));
Ladder4mean = nanmean(Ladder4(CUTOFF:num_blocks * 4));
SSDfifty = nanmean([Ladder1mean Ladder2mean Ladder3mean Ladder4mean]);
SSRT = GRTmedian-SSDfifty;

%Seeker label:
%1. trial number (64 each block); 2. block number (4 in total); 3. Go/nogo;
%4. stimuli left (0)/stimuli right (1); 5. staircase (?); 6. staircase
%value?; 7. response left (70)/response right (74); 8. RT of each trial; 9.
%absolute time since beginning of block; 
Accu = length(find(Seeker(:, 3) == 0 & ( (Seeker(:, 4) == 0 & Seeker(:, 7) == LEFT) | ( Seeker(:, 4) == 1 & Seeker(:, 7) == RIGHT ) )))/length(find( Seeker(:, 3) == 0));
meanrt  =  1000 * nanmedian(Seeker(Seeker(:, 3) == 0 & Seeker(:, 7) ~= 0  & ( (Seeker(:, 4) == 1 & Seeker(:, 7) == RIGHT) | ( Seeker(:, 4) == 0 & Seeker(:, 7) == LEFT ) ), 8));
stoprate = length(find(Seeker(:, 10) == 1))/64;


if type == 1
    DimErrors = sum((Seeker(:, 3) == 0 & ( (Seeker(:, 4) == 0 & Seeker(:, 7) == RIGHT) | ( Seeker(:, 4) == 1 & Seeker(:, 7) == LEFT ) )));
    data  =  [meanrt Accu stoprate GRTmedian SSRT Ladder1mean Ladder2mean Ladder3mean Ladder4mean SSDfifty inhiRT noninhiRT ];
else
    data  =  [meanrt Accu stoprate GRTmedian SSRT Ladder1mean Ladder2mean Ladder3mean Ladder4mean SSDfifty inhiRT noninhiRT ];
end
% title(sprintf('SSRT = %0.2f', SSRT))