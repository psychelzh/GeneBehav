function [FNLearn, FNRecog, WM3, stopsignal, shiftnumber, stroop, ...
    CateSwitchACC, CateSwitchRT, antiSaccade, Reinfresult, UG, BART, ...
    KLearn,  KRecog,  shiftcolor,  filter,  WM2,  SPST,  Delay, SRT, CRT] ...
    = alyzSngl(subject_code, datapath)
%ALYZSNGL Analyzes data of one single subject.
%
%  2014��7��2�գ��޸���һ�¸�ʽ�Ͳ����Ż���ͬʱʹ��'more than one'���'not a
%  single'����Ϊ���ߵ���˼��Ӧ����'һ��Ҳû��'����������

logfid = fopen('logs.txt', 'a');
%% FNLearn
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'FNLearn_', subject_code)));
if  size(dataname, 1)  ==  0
    FNLearn = nan(1, 4);
    warning('no file for subjet %d on task %s', subject_code, 'FNLearn_')  %#ok<*WNTAG> %���ڸ���������ĿӦΪID������
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'FNLearn_');
else
    if  size(dataname, 1)  ~=  1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name); 
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs); %�˴������в�ֹһ������ļ�ʱ��ȡ�Ǹ������ļ���Ϊ����ļ���
    try 
        load(fullfile(datapath, sprintf('%s', dataname(i).name)));
        FNLearn = FNLearnAnalysisCCH(Seq, subject_code); %��һ�����load�������Ǳ���'Seq'����ͬ��
        %clearvars -except subject_code logfid datapath datapath FNLearn
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        FNLearn = [subject_code nan(1, 3)];
        %%clearvars -except subject_code logfid datapath datapath FNLearn
    end
end

%% FNRecogniton
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'FNRecog_', subject_code)));
if  size(dataname, 1)  ==  0
    FNRecog = nan(1, 8);
    warning('no file for subjet %d on task %s', subject_code, 'FNRecog_') 
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'FNRecog_');
else
    if  size(dataname, 1)  ~=  1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs); 
    try
        load(fullfile(datapath, sprintf('%s', dataname(i).name)));
        FNRecog = FNRecogAnalysisCCH(Seq, subject_code);
        %clearvars -except subject_code logfid datapath FNLearn FNRecog
    catch exception
        disp([sprintf('=======================================\n') ...
            exception.message ...
            sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        FNRecog = [subject_code nan(1, 7)];
        %clearvars -except subject_code logfid datapath FNLearn FNRecog
    end
end
%% working memory
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'WM3_', subject_code)));
if  size(dataname, 1)  ==  0
    WM3 = nan(1, 16);
    warning('no file for subjet %d on task %s', subject_code, 'WM3_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'WM3_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)));
        WM3 = WM3Analysis(rec, subject_code);
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM3
    catch exception
        disp([sprintf('=======================================\n') ...
            exception.message ...
            sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        WM3 = [subject_code nan(1, 15)];
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM3
    end
end

%% stopsignal
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'StopSignal_', subject_code)));
if  size(dataname, 1) == 0
    stopsignal = nan(1, 12);
    warning('no file for subjet %d on task %s', subject_code, 'StopSignal_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'StopSignal_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load(fullfile(datapath, sprintf('%s', dataname(i).name)))
        stopsignal = stopsignalAnalysis(Seeker, subject_code);
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        stopsignal = nan(1, 12);
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal
    end
end
%% shiftnumber 
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'ShiftNumber_', subject_code)));
if  size(dataname, 1) == 0
    shiftnumber = nan(1, 18);
    warning('no file for subjet %d on task %s', subject_code, 'ShiftNumber_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'ShiftNumber_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)))
        shiftnumber = shiftingAnalysis(rec, subject_code);
    %         fprintf('********* �����л�***************\n ')
    %         fprintf('repeat ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', shiftnumber.repeatAccu, shiftnumber.repeatRT);
    %         fprintf('switch ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n\n', shiftnumber.swithAccu, shiftnumber.switchRT);
    %          fprintf('switch costΪ %d ����\n\n', round((shiftnumber.switchRT-shiftnumber.repeatRT)*1000));
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        shiftnumber = nan(1, 16);
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber
    end        
end
%% stroop
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'Stroop_', subject_code)));
if  size(dataname, 1) == 0
    stroop = nan(1, 21);
    warning('no file for subjet %d on task %s', subject_code, 'Stroop_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'Stroop_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)));
        stroop = stroopAnalysis(result, subject_code);
    %         fprintf('********* stroop ***************\n')
    %         fprintf('һ�·�Ӧʱ%0.2f\n��һ�·�Ӧʱ%0.2f\nһ����ȷ��%0.2f\n��һ����ȷ��%0.2f\n', stroop(2), stroop(3), stroop(5), stroop(6));
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        stroop = [subject_code nan(1, 20)];
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop
    end
end



%% category switch
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'CateSwitch_', subject_code)));
if  size(dataname, 1) == 0
    CateSwitchACC = nan(1, 7); CateSwitchRT = nan(1, 7);
    warning('no file for subjet %d on task %s', subject_code, 'CateSwitch_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'CateSwitch_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)));
        [CateSwitchRT, CateSwitchACC] = CateSwitchAnalysisCCH(SM, subject_code);
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        CateSwitchACC = nan(1, 7); CateSwitchRT = nan(1, 7);
    end
%         fprintf('********* ����л�?***************\n')
%         fprintf('      no swith    ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', CateSwitchACC(1), CateSwitchRT(1));
%         fprintf('    task swith    ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', CateSwitchACC(2), CateSwitchRT(2));
%         fprintf('response swith    ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', CateSwitchACC(3), CateSwitchRT(3));
%         fprintf('    both swith    ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', CateSwitchACC(4), CateSwitchRT(4));
%          fprintf('switch costΪ %d ����\n\n', round((CateSwitchRT(2)-CateSwitchRT(1))*1000));
    %clearvars -except subject_code logfid datapath  FNLearn FNRecog WM stopsignal shiftnumber stroop CateSwitchACC CateSwitchRT
end

%     %%
%         fprintf('********* ֪ʶ���� ***************\n')
%         fprintf('���������ֽ����ݣ���ʱ�����ṩ���\n\n')

%% antiSaccade
dataname = dir(fullfile(datapath, sprintf('%ssub%03d_*', 'AntiSac_', subject_code)));
if  size(dataname, 1) == 0
    antiSaccade = nan(1, 3);
    warning('no file for subjet %d on task %s', subject_code, 'AntiSac_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'AntiSac_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)));
        antiSaccade = AntiSacAnalysisCCH(Seq, subject_code);
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        antiSaccade = nan(1, 3);
    end
%         fprintf('********* ע��ָ�� ***************\n')
%         fprintf('ƽ��ӦʱΪ��%d \n', antiSaccade(2))
%         fprintf('    ��ȷ��Ϊ��%0.2f \n\n', antiSaccade(3))
    %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop CateSwitchACC CateSwitchRT antiSaccade
end



%% reinforcement
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'Reinf_', subject_code)));
if  size(dataname, 1) == 0
    Reinfresult.ChooseAAccu = nan; Reinfresult.ChooseART = nan;Reinfresult.AvoidBAccu = nan; Reinfresult.AvoidBRT = nan;
    Reinfresult.winstay = nan(1, 4);Reinfresult.loseshift = nan(1, 4);Reinfresult.ABaccu = nan;Reinfresult.CDaccu = nan;Reinfresult.EFaccu = nan;
    warning('more than one file for subjet %d on task %s', subject_code, 'Reinf_')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'Reinf_');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)));
        Reinfresult = reinforcementAnalysis(Reinforcematerial, subject_code);
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        Reinfresult.ChooseAAccu = nan; Reinfresult.ChooseART = nan;Reinfresult.AvoidBAccu = nan; Reinfresult.AvoidBRT = nan;
        Reinfresult.winstay = nan(1, 4);Reinfresult.loseshift = nan(1, 4);Reinfresult.ABaccu = nan;Reinfresult.CDaccu = nan;Reinfresult.EFaccu = nan;
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop CateSwitchACC CateSwitchRT antiSaccade Reinfresult
    end
end
%% Ultimate game
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'Ultimate_', subject_code)));
if  size(dataname, 1) == 0
    UG.acceptmin = nan; UG.offer = nan;UG.computermin = nan;
    warning('more than one file for subjet %d on task %s', subject_code, 'Ultimate')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'Ultimate');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    try
        load (fullfile(datapath, sprintf('%s', dataname(i).name)));
        UG.acceptmin = acceptmin; UG.offer = offer(1); UG.computermin = computermin;
    %         fprintf('********* reinforcement ***************\n')
    %         fprintf('���� ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', Reinfresult.ChooseAAccu, Reinfresult.ChooseART);
    %         fprintf('�ܺ�  ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n\n', Reinfresult.AvoidBAccu, Reinfresult.AvoidBRT);
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop CateSwitchACC CateSwitchRT antiSaccade Reinfresult UG
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
        UG.acceptmin = nan;
        UG.offer = nan;
        UG.computermin = nan;
        %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop CateSwitchACC CateSwitchRT antiSaccade Reinfresult UG
    end
end
%% BART
dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*.log', 'Bart_', subject_code)));
if  size(dataname, 1) == 0
    BART = nan;
    warning('more than one file for subjet %d on task %s', subject_code, 'Bart')
    fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'Bart');
else
    if  size(dataname, 1) ~= 1
        warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
        fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
    end
    bs = [dataname.bytes]; [~, i] = max(bs);
    BART = BartAnalysis(fullfile(datapath, dataname(i).name));
%         fprintf('********* reinforcement ***************\n')
%         fprintf('���� ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', Reinfresult.ChooseAAccu, Reinfresult.ChooseART);
%         fprintf('�ܺ�  ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n\n', Reinfresult.AvoidBAccu, Reinfresult.AvoidBRT);
    %clearvars -except subject_code logfid datapath FNLearn FNRecog WM stopsignal shiftnumber stroop CateSwitchACC CateSwitchRT antiSaccade Reinfresult UG BART
end

%% KLearn
    dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'KLearn_', subject_code)));
    if  isempty(dataname)
        KLearn = nan(1, 5);
        warning('no file for subjet %d on task %s', subject_code, 'KLearn_') %#ok<*WNTAG>
        fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'KLearn_');
    else
        bs = [dataname.bytes]; [~, i] = max(bs);
        try
            load (fullfile(datapath, sprintf('%s', dataname(i).name)));
            KLearn = KLearnAnalysisCCH(Seq, subject_code);
        catch exception
            disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
            fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
            KLearn = nan(1, 5);
        end
%         fprintf('********* ����ѧϰ ***************\n')
% disp(['response rate ' num2str(round(mean(resultsMat(:, 2))*100)) '%'])
% disp(['correct rate ' num2str(round(mean(resultsMat(:, 3))*100)) '%'])
% disp(['response time ' num2str(round(mean(resultsMat(:, 4))*100)/100)])
        %clearvars -except subject_code logfid datapath KLearn
    end
%% KRecog
    dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'KRecog_', subject_code)));
    if  isempty(dataname)
        KRecog = nan(1, 6);
        warning('no file for subjet %d on task %s', subject_code, 'KRecog_')
        fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'KRecog_');
    else
        if  size(dataname, 1) ~= 1, 
            warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
            fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
        end
        bs = [dataname.bytes]; [~, i] = max(bs);
        try
            load (fullfile(datapath, sprintf('%s', dataname(i).name)));
            KRecog = KRecogAnalysisCCH(Seq, subject_code);
        catch exception
            disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
            fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
            KRecog = nan(1, 6);
        end
%         fprintf('********* ���ż��� ***************\n')
%         disp(['dprime ' num2str(round(mean(resultsMat(:, 6))*100)/100)])
%         fprintf('dprime: %5.1f\n\n',   KRecog(6));
        %clearvars -except subject_code logfid datapath KLearn KRecog
    end
    

%% ShiftingColor
    dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'ShiftingColor_', subject_code)));
    if  isempty(dataname)
        shiftcolor = nan(1, 18);
        warning('no file for subjet %d on task %s', subject_code, 'shiftcolor')
        fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'shiftcolor');
   else
        if  size(dataname, 1) ~= 1, 
            warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
            fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
        end
        bs = [dataname.bytes]; [~, i] = max(bs);
        try
            load (fullfile(datapath, sprintf('%s', dataname(i).name)))
            shiftcolor = shiftingAnalysis(rec, subject_code);
    %         fprintf('********* �����л�***************\n ')
    %         fprintf('repeat ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', shiftcolor.repeatAccu,  shiftcolor.repeatRT);
    %         fprintf('switch ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n\n', shiftcolor.swithAccu,  shiftcolor.switchRT);
    %          fprintf('switch costΪ %d ����\n\n', round((shiftcolor.switchRT-shiftcolor.repeatRT)*1000));
            %clearvars -except subject_code logfid datapath KLearn KRecog shiftcolor
        catch exception
            disp([exception.message ' Please check the data!']);
            fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
            shiftcolor = nan(1, 18);
        end            
    end

%% Filtering
    dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'Filtering_', subject_code)));
    if  isempty(dataname)
        filter = nan(1, 17);
        warning('no file for subjet %d on task %s', subject_code, 'Filtering')
        fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'Filtering');
    else
        if  size(dataname, 1) ~= 1, 
            warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
            fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
        end
        bs = [dataname.bytes]; [~, i] = max(bs);
        try
            load (fullfile(datapath, sprintf('%s', dataname(i).name)));
            filter = FilteringAnalysis(rec, subject_code);
        catch exception
            disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
            fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
            filter = nan(1, 17);
        end
        %%% print summary result:
%         fprintf('*********�����ų�***************\n')
%         fprintf('Filtering speed: %5.1fms\n',  nanmean(rec(:, 6))*1000);
%         fprintf('��ȷ��: %5.1f%%\n',  mean(rec(:, 5) =  = 1)*100);
        %clearvars -except subject_code logfid datapath KLearn KRecog shiftcolor filter
    end
%% working memory
    dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'spatial_2back_', subject_code)));
    if  isempty(dataname)
        WM2 = nan(1, 4);
        warning('no file for subjet %d on task %s', subject_code, 'spatial_2back')
        fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'spatial_2back');
    else
        if  size(dataname, 1) ~= 1, 
            warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
            fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
        end
        bs = [dataname.bytes]; [~, i] = max(bs);
        try
            load (fullfile(datapath, sprintf('%s', dataname(i).name)));
            WM2 = WM2Analysis(rec, subject_code);
        catch exception
            disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
            fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
            WM2 = nan(1, 4);
        end
%         fprintf('********* �ռ���� ***************\n')
%         fprintf('match    ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', WM(5),  WM(2))
%         fprintf('nonmatch ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', WM(6),  WM(3))
%         fprintf('foil     ��ȷ��Ϊ %0.2f, ��ӦʱΪ %0.2f \n', WM(7),  WM(4))
%         fprintf('��ȷ��: %5.1f%%\n', WM(2)*100)
       %clearvars -except subject_code logfid datapath KLearn KRecog shiftcolor filter WM2 
    end
    %% PatternSep_Test
%     dataname = dir([datapath, sprintf('\\%sSub%03d_*', 'PatternSep_Test_', subject_code));
%     if  isempty(dataname)
%         PatternSep.repeatAccu = nan; PatternSep.repeatRT = nan; PatternSep.swithAccu = nan; PatternSep.switchRT = nan;
%         warning('no file for subjet %d on task %s', subject_code, 'PatternSep_Test'))
%     else
%         bs = [dataname.bytes]; [~, i] = max(bs);
%         load ([datapath, sprintf('\\%s', dataname(i).name))
%         fprintf('********* ͼ����� ***************\n ')
%         patternaccu = (TO_rate+LS_rate+FN_rate)/3;
%         fprintf('��ȷ��: %5.1f%%\n\n', ((TO_rate+LS_rate+FN_rate)/3)*100);
%         %clearvars -except subject_code patternaccu
%     end
    SPST = SPSTanalysisCCH(subject_code, datapath);
    %clearvars -except subject_code logfid datapath KLearn KRecog shiftcolor filter WM  SPST
%% Delay discount
    dataname = dir(fullfile(datapath, sprintf('%sSub%03d_*', 'DelayDiscount_', subject_code)));
    if  isempty(dataname)
        Delay = nan(1, 6);
        warning('no file for subjet %d on task %s', subject_code, 'DelayDiscount_')
        fprintf(logfid, 'no file for subjet %d on task %s\n', subject_code, 'DelayDiscount_');
    else
        if  size(dataname, 1) ~= 1, 
            warning('more than one file for subjet %d on task %s', subject_code, dataname(1).name)
            fprintf(logfid, 'more than one file for subjet %d on task %s\n', subject_code, dataname(1).name);
        end
        bs = [dataname.bytes]; [~, i] = max(bs);
        try
            load (fullfile(datapath, sprintf('%s', dataname(i).name)));
            Delay = DelayDiscountAnalysis(kvalArray, rewardArray, timeArray, choiceArray, subject_code);
       %clearvars -except subject_code logfid datapath KLearn KRecog shiftcolor filter WM SPST Delay
        catch exception
            disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')]);
            fprintf(logfid, '***************************************\nError data: %s\n***************************************\n', dataname(i).name);
            Delay = nan(1, 6);
        end
    end
%% Ressponse time
% RTanalysis
    [SRT, CRT] = RTAnalysis(subject_code, datapath); %Use edit RTAnalysis to read the code of it.
%%
fclose(logfid);