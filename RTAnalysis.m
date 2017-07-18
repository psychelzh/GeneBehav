function [SRT, CRT] = RTAnalysis(sid, datapath)
%Analyze data of reaction time.

%By Zhang Liang, 05/18/2015.
logfid = fopen('logs.txt', 'a');
if nargin <= 1
    datapath = '.'; %Used when data files are in the same folder of this script.
end
%% SRT analysis.
SRTfile = dir(fullfile(datapath, sprintf('SRT_Header_*sub%d_*', sid)));
SRT = nan(1, 2);
if isempty(SRTfile)
    SRTfile = dir(fullfile(datapath, sprintf('SRT_Header_*Sub%d.csv', sid)));
    if isempty(SRTfile)
        fprintf(logfid, 'no file for subjet %d on task SRT\n', sid);
    end
end
if length(SRTfile) > 1 %More than one file for this task.
    fprintf(logfid, 'more than one file for subjet %d on task SRT\n', sid);
    SRTfile(2:end) = []; %Use the first occurence for analysis.
end
if length(SRTfile) == 1
    SRTtable = readtable(fullfile(datapath, SRTfile.name));
    if ~isempty(SRTtable)
        if isnumeric(SRTtable.Mean)
            SRT(1) = SRTtable.Mean;
        else
            SRT(1) = str2double(SRTtable.Mean); %Average of RT.
        end
        if isnumeric(SRTtable.Median)
            SRT(2) = SRTtable.Median;
        else
            SRT(2) = str2double(SRTtable.Median); %Median of RT.
        end
    end
end
%% CRT analysis.
CRTfile = dir(fullfile(datapath, sprintf('CRT_Header_*sub%d_*', sid)));
CRT = nan(1, 2);
if isempty(CRTfile)
    CRTfile = dir(fullfile(datapath, sprintf('CRT_Header_*Sub%d.csv', sid)));
    if isempty(CRTfile)
        fprintf(logfid, 'no file for subjet %d on task CRT\n', sid);
    end
end
if length(CRTfile) > 1 %More than one file for this task.
    fprintf(logfid, 'more than one file for subjet %d on task CRT\n', sid);
    CRTfile(2:end) = []; %Use the first occurence for analysis.
end
if length(CRTfile) == 1
    CRTtable = readtable(fullfile(datapath, CRTfile.name));
    if ~isempty(CRTtable)
        if isnumeric(CRTtable.Correct_Mean)
            CRT(1) = CRTtable.Correct_Mean;
        else
            CRT(1) = str2double(CRTtable.Correct_Mean); %Average of RT.
        end
        if isnumeric(CRTtable.Correct_Median)
            CRT(2) = CRTtable.Correct_Median;
        else
            CRT(2) = str2double(CRTtable.Correct_Median); %Median of RT.
        end
    end
end
fclose(logfid);