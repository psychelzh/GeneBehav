function AlyzDailyData(expDate)
%ALYZDAILYDATA a conversion from the function AnalysizAllData.m
%   EXPDATE is the date (FORMAT: yyyy-mm-dd, or mm-dd) of the experiment.

%Initiated by Zhang, Liang. 05/13/2015

fid = fopen('\raw_add.log', 'a');
fprintf(fid, '========================================================\n%s Checking...\n', date);
fprintf(fid, 'Experiment Date: %s\n', expDate);
if ~exist('\sublist.txt', 'file')
    confirmstr = input('No sublist file found, will input your sublist?([Y]/N)', 's');
    if strcmpi(confirmstr, 'Y') || strcmpi(confirmstr, 'YES') || isempty(confirmstr)
        substr = input('Please input your sublist:', 's');
        eval(['sublist = [', substr, '];']);
    else
        fprintf(fid, 'Error: No checking takes place, because no sublist file found!\n========================================================\n');
        error('UDF:FILENOTFOUND', 'No sublist file found.');
    end
else
    subf = fopen('\sublist.txt', 'r'); % Note the file sublist.txt have to be created mannually.
    while ~feof(subf)
        dateStr = fgetl(subf);
        if strfind(dateStr, expDate)
            eval(['sublist = [', fgetl(subf), '];']);
            break;
        end
    end    
    fclose(subf);
end
if exist('sublist', 'var')
    alldataname = { 'ID' ...
                'FNLearn_RresponseRate' 'FNLearn_FitRate' 'FNLearn_RT' ...
                'FNRecog_HitRate' 'FNRecog_FArecomb' 'FNRecog_FAnew' 'FNRecog_FAboth' 'FNRecog_dprimeRecomb' 'FNRecog_dprimeNew' 'FNRecog_dprimeBoth' ...
                'WM_overallRT' 'WM_overallAccu' 'WM_matchRT' 'WM_nonmatchRT' 'WM_foilRT'  'WM_matchAccu' 'WM_nonmatchAccu' 'WM_foilAccu' 'WM_FAnonmatch' 'WM_FAfoil' 'WM_FAnonmatchfoil'  'WM_dprimeNonmatch' 'WM_dprimeFoil' 'WM_dprimeNonmatchfoil'  'WM_ResponseRate' ...
                'stopsignal_GoMedianRT' 'stopsignal_GoAccu' 'stopsignal_stopRate' 'stopsignal_post132medianRT' 'stopsignal_SSRT' 'stopsignal_SSD' 'stopsignal_RTafterInhi' 'stopsignal_RTafterNonInhi'...
                'shiftnumber_repeatAccu' 'shiftnumber_repeatRT' 'shiftnumber_switchAccu' 'shiftnumber_switchRT' 'shiftnumber_repeatbothAccu' 'shiftnumber_repeatbothRT' 'shiftnumber_switchresponseAccu' 'shiftnumber_switchresponseRT' 'shiftnumber_switchtaskAccu' 'shiftnumber_switchtaskRT' 'shiftnumber_switchbothAccu' 'shiftnumber_switchbothRT' 'shiftnumber_repeatBothN' 'shiftnumber_switchresponseN' 'shiftnumber_switchtaskN' 'shiftnumber_switchBothN' 'shiftnumber_switchcostRT' 'shiftnumber_switchcostACC' ...
                'Stroop_RTCon' 'Stroop_RTInCon' 'Stroop_RTIncon_Con' 'Stroop_AccuCon' 'Stroop_AccuInCon' 'Stroop_AccuCon_InCon' 'Stroop_RTII' 'Stroop_RTIC' 'Stroop_RTCI' 'Stroop_RTCC' 'Stroop_AccuII' 'Stroop_AccuIC' 'Stroop_AccuCI' 'Stroop_AccuCC' 'Stroop_First48'  'Stroop_Last48' 'Stroop_II_N' 'Stroop_IC_N' 'Stroop_CI_N' 'Stroop_CC_N' ...
                'CateSwitch_repeatRT' 'CateSwitch_switchRT' 'CateSwitch_repreatbothRT' 'CateSwitch_switchtaskRT' 'CateSwitch_switchresponseRT' 'CateSwitch_switchbothRT' 'CateSwitch_switchcostRT' 'CateSwitch_repeatAccu' 'CateSwitch_switchAccu' 'CateSwitch_repreatbothAccu' 'CateSwitch_switchtaskAccu' 'CateSwitch_switchresponseAccu' 'CateSwitch_switchbothAccu' 'CateSwitch_switchcostAccu'...
                'antiSaccade_accu' 'antiSaccade_RT'  ... % Note that here gives a wrong order, try typing "'antiSaccade_accu' 'antiSaccade_RT'" instead.
                'Reinforce_ChooseAAccu' 'Reinforce_ChooseART' 'Reinforce_AvoidBAccu' 'Reinforce_AvoidBRT' 'Reinforce_winstay1' 'Reinforce_winstay2' 'Reinforce_winstay3' 'Reinforce_winstay4' 'Reinforce_loseshift1' 'Reinforce_loseshift2' 'Reinforce_loseshift3' 'Reinforce_loseshift4' 'Reinforce_ABaccu' 'Reinforce_CDaccu' 'Reinforce_EFaccu' ...
                'UG_offerSelf' 'UG_acceptmin' 'UG_computermin' ...
                'BART' ...
                'KLearn_RR' 'KLearn_CR' 'KLearn_RT' 'KLearn_RepPrime'...
                'KReco_hits' 'KReco_misses' 'KReco_FA' 'KReco_CR' 'KReco_dprime'...
                'shiftcolor_repeatAccu' 'shiftcolor_repeatRT' 'shiftcolor_swithAccu' 'shiftcolor_switchRT' 'shiftcolor_repeatbothAccu' 'shiftcolor_repeatbothRT' 'shiftcolor_swithresponseAccu' 'shiftcolor_switchresponseRT' 'shiftcolor_swithtaskAccu' 'shiftcolor_switchtaskRT' 'shiftcolor_swithbothAccu' 'shiftcolor_switchbothRT' 'shiftcolor_repeatBothN' 'shiftcolor_switchresponseN' 'shiftcolor_switchtaskN' 'shiftcolor_switchBothN' 'shiftcolor_switchcostRT' 'shiftcolor_switchcostACC'...
                'filter_allACC' 'filter_allRT' 'filter_d0ACC' 'filter_d0RT' 'filter_d2ACC' 'filter_d2RT' 'filter_d4ACC' 'filter_d4RT' 'filter_d6ACC' 'filter_d6RT' 'filter_d46_02Acc' 'filter_d46_02RT'  'filter_d6_0Acc' 'filter_d6_0RT' 'filter_dprime' 'filter_capacity'...
                'SpatialWM_allACC' 'SpatialWM_allRT' 'SpatialWM_ResponseRate' ...
                'SPST.RT_ln_old' 'SPST.RT_ln_similar' 'SPST.RT_mem_lure1' 'SPST.RT_mem_lure2' 'SPST.RT_mem_lure3' 'SPST.RT_mem_lure4' 'SPST.RT_mem_lure5' 'SPST.RT_mem_old' 'SPST.RT_mem_foild' 'SPST.FA' 'SPST.d_lure1' 'SPST.d_lure2' 'SPST.d_lure3' 'SPST.d_lure4' 'SPST.d_lure5' 'SPST.d_old' ...
                'Delaydiscout_last5K' 'Delaydiscout_lastK' 'Delaydiscout_fitK' 'Delaydiscout_fitM' 'Delaydiscout_fitLL' ...
                'SRT_mean' 'SRT_Median' 'CRT_mean' 'CRT_Median' ...
                };
    alldata = nan(length(sublist), length(alldataname));
    try % In case error occurs and file is not closed.
        for subidx = 1 : length(sublist)
            subject_code = sublist(subidx)  %#ok < NOPRT >  Print SUBJECT_ID.
            [FNLearn, FNRecog, WM3, stopsignal, shiftnumber, stroop, ...
                CateSwitchACC, CateSwitchRT, antiSaccade, Reinfresult, UG, BART, ...
                KLearn, KRecog, shiftcolor, filter, WM2, SPST, Delay, SRT, CRT] = alyzSngl(subject_code, expDate);
            alldata(subidx, :) = [...
                subject_code ...
                FNLearn(2:4)...
                FNRecog(2:8)...
                WM3(2:16)...
                stopsignal([1:5 10:12])...
                shiftnumber ...
                stroop(2:21)...
                CateSwitchRT CateSwitchACC ...
                antiSaccade([2 3])...
                Reinfresult.ChooseAAccu Reinfresult.ChooseART Reinfresult.AvoidBAccu Reinfresult.AvoidBRT Reinfresult.winstay Reinfresult.loseshift Reinfresult.ABaccu Reinfresult.CDaccu Reinfresult.EFaccu ...
                UG.offer UG.acceptmin UG.computermin ...
                BART ...
                KLearn(2:5)...
                KRecog(2:6)...
                shiftcolor ...
                filter(2:17)...
                WM2(2:4)...
                SPST.RT_ln SPST.RT_mem SPST.FA SPST.d...
                Delay(2:6)...
                SRT CRT ...
                ];

            if mean(shiftnumber([1 3])) < 0.7
                    fprintf(fid, '被试 %d 切换能力测验 太多错误，请重做\n', subject_code);
            end                     

            if mean(shiftcolor([1 3])) < 0.7
                    fprintf(fid, '被试 %d 颜色形状切换任务 太多错误，请重做\n', subject_code);
            end                   

            if CateSwitchACC < 0.7
                    fprintf(fid, '被试 %d 反应转换能力测试 太多错误，请重做\n', subject_code);
            end

            if antiSaccade(2) < 0.5
                    fprintf(fid, '被试 %d 眼动控制测验 正确率太低，请重做\n', subject_code);
            end

            if WM3(16) < 0.7
                    fprintf(fid, '被试 %d 工作记忆（WM3） 太多没有按键或者没有记录到按键，请重做\n', subject_code);
            end

            if WM2(4) < 0.7
                    fprintf(fid, '被试 %d 空间工作记忆（WM2） 太多没有按键或者没有记录到按键，请重做\n', subject_code);
            end

            if stopsignal(3) < 0.2
                    fprintf(fid, '被试 %d 反映抑制能力 太少抑制，请重做\n', subject_code);
            elseif stopsignal(3) > 0.8 
                    fprintf(fid, '被试 %d 反映抑制能力 太多抑制，请重做\n', subject_code);
            end

            if mean(stroop([5 6])) < 0.7
                    fprintf(fid, '被试 %d 认知冲突解决能力 太多错误，请重做\n', subject_code);
            end


            if filter(2) < 0.6
                    fprintf(fid, '被试 %d 排除干扰任务 太多错误，请重做\n', subject_code);
            end

            if Delay(4) < -40
                    fprintf(fid, '被试 %d 跨期决策任务 拟合不好，请重做\n', subject_code);
            end
        end
        curpath = pwd;
        datapath = '\OutData';
        cd(datapath)
        xlswrite(sprintf('GenData_%s', datestr(now, 'mm-dd-HH-MM')), [alldataname; num2cell(alldata)]);
        cd(curpath)
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!')])
        curpath = pwd;
        datapath = '\OutData';
        cd(datapath)
        xlswrite(sprintf('GenData_%s', datestr(now, 'mm-dd-HH-MM')), [alldataname; num2cell(alldata)]);
        cd(curpath)
    end
    fprintf(fid, 'Checked successfully, and excel file generated!\n========================================================\n');
else
    fprintf(fid, 'Error: No checking takes place, because there is some error in expDate!\n========================================================\n');
    error('UDF:SUBNOTFOUND', 'No sublist created. Probably you have input wrong expDate!');
end
fclose(fid);
if exist('exception', 'var')
    rethrow(exception);
end
