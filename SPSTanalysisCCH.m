function out=SPSTanalysisCCH(subject_code, datapath)

    logfh = fopen('SPSTdebuglog.log', 'a');
    %% load results files
    %% learning phase
    fname = fullfile(datapath, sprintf('SPST_Sub%03d_studylog.txt', subject_code));
    fid = fopen(fname);                        % Open the file
    if fid>0
        line=0;
        while ~feof(fid)
            line=line+1;
            RowR=fgetl(fid); %% get thefirst row information. get data one by one;
            if strmatch('Trialnum	filename	response	rt',RowR)
                skipline=line;
            end
        end
        fclose(fid);
        if ~exist('skipline', 'var')
           warning('SPSTtask:NoBeginning', 'Better check file %s, file header not found! Exiting...', fname);
           fprintf(logfh, '%s, header error.\n', fname);
           out.RT_ln = nan(1, 2);
            out.RT_mem = nan(1, 7);
            out.FA = nan;
            out.d = nan(1, 6);
           fclose(logfh);
           return
        end
       
        fid=fopen(fname);
        
        data = textscan(fid,'%d Set C\\%3s %1s %s %d %f',128,'headerlines',skipline,'Delimiter','\t');
        n1=data{1};%trail ID
        line=size(n1,1);
        n2=cellfun(@str2num,data{2},'UniformOutput',false);
        n2=cell2mat(n2); %pic ID
        n3=2-strcmp(data{3},'a');%1=a 2=b
        n4=data{5};%resp
        n5=data{6};%rt
        if ~isequal(n1', 1:128)
            warning('SPSTtask:NotEnoughTrial', 'Better check file %s, not right # of trials! Exiting...', fname);
            fprintf(logfh, '%s, trial number error.\n', fname);
            out.RT_ln = nan(1, 2);
            out.RT_mem = nan(1, 7);
            out.FA = nan;
            out.d = nan(1, 6);
            fclose(fid);
            fclose(logfh);
            return
        end      
        subln=[n1 n2 n3 n4 n5]; %1=TID;2=PID;3=file(a/b);4=res;5=rt; ln: short for learn (study phase).
        clear data n*;
        fclose(fid);
    else
         subln=[];
    end

    %% memory phase
    fname = fullfile(datapath, sprintf('SPST_Sub%03d_testlog.txt', subject_code));
%     fname = sprintf('..\\..\\Behav%s\\SPST_Sub%03d_testlog.txt', fstr, subject_code);
    fid = fopen(fname);                      % Open the file
    if fid>0
       line=0;
       while ~feof(fid);
           line=line+1;
           RowR=fgetl(fid);
           if strmatch('Trialnum	filename	condition	LureBin',RowR);
               skipline=line;
           end
       end
       fclose(fid);
       if ~exist('skipline', 'var')
           warning('SPSTtask:NoBeginning', 'Better check file %s, file header not found! Exiting...', fname);
           fprintf(logfh, '%s, header error.\n', fname);
           out.RT_ln = nan(1, 2);
            out.RT_mem = nan(1, 7);
            out.FA = nan;
            out.d = nan(1, 6);
           fclose(logfh);
           return
       end
       
       fid=fopen(fname);  
        data = textscan(fid,'%d Set C\\%3s %1s %s %d %d %d %d %f ',192,'headerlines',skipline,'Delimiter','\t');  % Read memory data as strings
        n1=data{1};%trail ID
         n2=cellfun(@str2num,data{2},'UniformOutput',false);
        n2=cell2mat(n2); %pic ID
        n3=2-strcmp(data{3},'a');%1=a 2=b
        n4=data{5};%0=old/target, 1=similar/lure, 2=new/foil
        n4=n4+1;%conds 1=old/target, 2=similar/lure, 3=new/foil
        n5=data{6};%LureBin 1~5
        n6=data{7};%res
        n7=data{8};%acc
        n8=data{9};%rt
       % line1=size(n1,1);
%         if size(n1,1)~=192
%           clear data n*
%         end
       
       
   %     submem=[n1 n2 n3 n4 n5 n6 n7 n8];%1=TID;2=PID;3=file(a/b);4=mem_cond;5=level of lure;6=res;7=acc;8=rt
        if ~isequal(n1', 1:192)
            warning('SPSTtask:NotEnoughTrial', 'Better check file %s, not right # of trials! Exiting...', fname);
            fprintf(logfh, '%s, trial number error.\n', fname);
            out.RT_ln = nan(1, 2);
            out.RT_mem = nan(1, 7);
            out.FA = nan;
            out.d = nan(1, 6);
            fclose(fid);
            fclose(logfh);
            return
        end
        submem=[n1 n2 n3 n4 n5 n6 n7 n8];%1=TID;2=PID;3=file(a/b);4=mem_cond;5=level of lure;6=res;7=acc;8=rt; mem: short for memory (test phase).
        
        clear data n*;
        fclose(fid);
     else
         submem=[];
     end
    
    if isempty(subln) || isempty(submem)
        out.RT_ln=nan(1,2);
        out.RT_mem=nan(1,7);
        out.FA=nan(1,1);
        out.d=nan(1,6);
        fclose(logfh);
        return
    end
    %% add cond into learning data to check the learning performance: (acc &) rt
    %subln data structual: 1=TID;2=PID;3=file(a/b);4=res;5=rt;6=mem_cond
    %submem data structual:1=TID;2=PID;3=file(a/b);4=mem_cond;5=level of lure;6=res;7=acc;8=rt
    if ~isempty(subln) && ~isempty(submem)
        for i=1:size(subln,1)
            ix= submem(:,2)==subln(i,2);
            subln(i,6)=submem(ix,4);%add cond 0=old/target, 1=similar/lure
        end
    
        for cond=1:2
            semtrial=subln(subln(:,6)==cond,:);
            out.RT_ln(1,cond)=mean(semtrial(:,5));
        end
    else
        out.RT_ln=nan(1,2);
    end


    try
    %% memory performance and RT during memroy task
        %submem data structual:1=TID;2=PID;3=file(a/b);4=mem_cond;5=level of lure;6=res;7=acc;8=rt
        % group into 7 condition
        submem(submem(:,5)==1,9)=1;% level1 lure
        submem(submem(:,5)==2,9)=2;% level2 lure
        submem(submem(:,5)==3,9)=3;% level3 lure
        submem(submem(:,5)==4,9)=4;% level4 lure
        submem(submem(:,5)==5,9)=5;% level5 lure
        submem(submem(:,4)==1,9)=6;% old   
        submem(submem(:,4)==3,9)=7;% foil
        
        for cond=1:7 %level`5 lure; old and foil
           semtrial=submem(submem(:,9)==cond,:);

           mem(1,cond,1)=length(find(semtrial(:,6)==1))/length(semtrial); %judge as old
           mem(1,cond,2)=length(find(semtrial(:,6)==3))/length(semtrial); %judge as similar
           mem(1,cond,3)=length(find(semtrial(:,6)==2))/length(semtrial); %judge as new

           count(1,cond)=length(semtrial); %items in each cond

           out.RT_mem(1,cond)=mean(semtrial(:,8));
        end   
   
   %% false alarm
        out.FA=mem(1,7,1);
        if ~out.FA,   out.FA = 0.01;  end
        if out.FA==1, out.FA = 0.99;  end

       %% d'
        for cond=1:6 %level`5 lure; old 
            if ~mem(1,cond,1),   mem(1,cond,1) = 0.01;  end
            if mem(1,cond,1)==1, mem(1,cond,1) = 0.99;  end
           out.d(1,cond)=norminv(mem(1,cond,1))-norminv(out.FA); 
        end
    catch exception
        disp([sprintf('=======================================\n') exception.message sprintf('\nPlease check the data!\n')])
        warning('SPSTtask:FileUnknownError', 'Better check file %s, unknown error found! Exiting...', fname);
        fprintf(logfh, '%s, unknown error.\n', fname);
        out.RT_ln=nan(1,2);
        out.RT_mem=nan(1,7);
        out.FA=nan(1,1);
        out.d=nan(1,6);
        fclose(logfh);
        return
    end
    fclose(logfh);
return
%% plot: learning ACC & CR
        %ACC_ln(sub,cond)
        %RT_ln(sub,cond)
%         figure 
%         y=ACC_ln(subs,:)*100;
%         stats=do_anova1(y);
%         withsub_err=sqrt(stats/size(y,1));
%         meanmat=mean(y)';
%         stdmat=ones(size(meanmat))*withsub_err(1);
% 
%         condnames={'cons','H_s','L_s'};
%         hold on
%         subplot(1,2,1); 
%         barerror(meanmat,stdmat,0.9,'k',{'b'})
%         set(gca,'XTick',[1:3])
%         set(gca,'Xticklabel',condnames);
%         set(gca,'FontSize',50)
%         set(gca,'ylim',[50 100])  
% 
%         %ylabel('Reaction time (ms)')
%         ylabel('Percent correct %')
%         hold off
%         orient tall
%         set(gcf, 'position',[248 572 905 369]);

        % RT 
        figure
        y=RT_ln(subs,:);
        stats=do_anova1(y);
        withsub_err=sqrt(stats/size(y,1));
        meanmat=mean(y)';
        stdmat=ones(size(meanmat))*withsub_err(1);

        condnames={'Target','Lure'};
        hold on

        barerror(meanmat,stdmat,0.9,'k',{'b'})
        set(gca,'XTick',[1:2])
        set(gca,'Xticklabel',condnames);
        set(gca,'FontSize',50)

        ylabel('Reaction time (ms)')

        hold off
        orient tall
        set(gcf, 'position',[248 572 905 369]); 
        

%% plot for subjective memory
        figure
        %mem(sub,cond,1)=old mem(sub,cond,2)=similar mem(sub,cond,3)=new
        y=mem(subs,:,1)*100; %old
        y=y(:,:);
        stats=do_anova1(y);
        withsub_err1=sqrt(stats/size(y,1));
        meanmat1=mean(y);

        y=mem(subs,:,2)*100; %similar
        y=y(:,:);
        stats=do_anova1(y);
        withsub_err2=sqrt(stats/size(y,1));
        meanmat2=mean(y);

        y=mem(subs,:,3)*100; %new
        y=y(:,:);
        stats=do_anova1(y);
        withsub_err3=sqrt(stats/size(y,1));
        meanmat3=mean(y);

        meanmat=[meanmat1;meanmat2;meanmat3];
        stdmat=[withsub_err1*ones(1,size(meanmat1,2));withsub_err2*ones(1,size(meanmat2,2));withsub_err3*ones(1,size(meanmat3,2))];

        condnames={'Old','Similar','New'};
        hold on
        barerror(meanmat,stdmat,0.9,'k',{'r';'y';'b';'g';'c';'m';'k'})
        set(gca,'XTick',[1:7])
        set(gca,'Xticklabel',condnames);
        set(gca,'FontSize',20)
        set(gcf,'Color',[1 1 1]) % set background to white
        legend('L1','L2','L3','L4','L5','Target','New');
        ylabel('Percentage%')
        
        hold off
        orient tall
        set(gcf, 'position',[248 572 905 369]);

%% plot for memory performance
        %hit
        %mem(sub,cond,1)
        figure 
        y=mem(subs,[1:6],1)*100;
        y=y(:,:);
        stats=do_anova1(y);
        withsub_err=sqrt(stats/size(y,1));
        meanmat=mean(y)';
        stdmat=ones(size(meanmat))*withsub_err(1);

        condnames={'L1','L2','L3','L4','L5','Target'};
        hold on
        subplot(1,2,1); 
        barerror(meanmat,stdmat,0.9,'k',{'b'})
        set(gca,'XTick',[1:6])
        set(gca,'Xticklabel',condnames);
        set(gca,'FontSize',50)   

        %ylabel('Reaction time (ms)')
        ylabel('Percent %')
        hold off
        orient tall
        set(gcf, 'position',[248 572 905 369]);

        % d'
        %d(sub,cond)
        y=d(subs,:)*100;
        stats=do_anova1(y);
        withsub_err=sqrt(stats/size(y,1));
        meanmat=mean(y)';
        stdmat=ones(size(meanmat))*withsub_err(1);

        condnames={'L1','L2','L3','L4','L5','Target'};
        hold on
        subplot(1,2,2); 
        barerror(meanmat,stdmat,0.9,'k',{'b'})
        set(gca,'XTick',[1:6])
        set(gca,'Xticklabel',condnames);
        set(gca,'FontSize',50)

        ylabel('d"')

        hold off
        orient tall
        set(gcf, 'position',[248 572 905 369]); 
        % RT 
        figure
        y=RT_mem(subs,:);
        stats=do_anova1(y);
        withsub_err=sqrt(stats/size(y,1));
        meanmat=mean(y)';
        stdmat=ones(size(meanmat))*withsub_err(1);

        condnames={'L1','L2','L3','L4','L5','T','F'};
        hold on

        barerror(meanmat,stdmat,0.9,'k',{'b'})
        set(gca,'XTick',[1:7])
        set(gca,'Xticklabel',condnames);
        set(gca,'FontSize',50)

        ylabel('Reaction time (ms)')

        hold off
        orient tall
        set(gcf, 'position',[248 572 905 369]); 