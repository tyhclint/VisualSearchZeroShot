clear all; close all; clc;
%addpath('ScanMatch');
type = 'naturaldesign'; %waldo, naturaldesign

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
   
    fix1 = [490 772];
    fix2 = [340 512];
    fix3 = [490 252];
    fix4 = [790 252];
    fix5 = [940 512];
    fix6 = [790 772];
    
   FIXLIST = [fix1; fix2; fix3; fix4; fix5; fix6];
   
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    HumanNumFix = 65;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end
    
markerlist = {'r','g','b','c','k','m',     'r--','g--','b--','c--','k--','m--',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
load(['../datasets/' type '/psy/' type '.mat']);
load(['../datasets/' type '/psy/' type '_seq.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
MaxDist = sqrt(Imgw*Imgw + Imgh*Imgh); %the maximum eucli dist on stimuli of size [1024 1280]

if ~strcmp(type,'array')
    load(['DataForPlot/GTstats_' type '.mat']);
    binranges = [0:50:MaxDist]/156*5;
else
    binranges = [0:0.5:20];
end

linewidth = 2;
hb = figure;
hold on;

%lastn = 0; %starting from 0: last; 1: last-1; etc
handlesselected_median = [];
for lastn = 0:5

    totallastdist = [];
    % hold on;
    for s = 1: length(subjlist)
        
        if ~strcmp(type,'array')
            load(['../datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{s} '_oracle.mat']);
        else
            load(['../datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{s} '_saccade.mat']);
        end
        PosX = FixData.Fix_posx;
        PosY = FixData.Fix_posy;
        PosX = PosX(seqInd);
        PosY = PosY(seqInd);

        if ~strcmp(type,'array')        
            scoremat = FixData.TargetFound;    
            scoremat = scoremat(seqInd,:);
        end
        
        
        hm = [];
        for j = 1: NumStimuli/2
            
            tf = find(scoremat(j,:)==1);
            if isempty(tf) || (tf<(lastn+1)) %consider those within HumanNumFix 
                continue;
            else
                
                lastind = tf - lastn;
                posx = PosX{j};
                posy = PosY{j};
                
                if strcmp(type,'array')
                    posx = posx(2:end);
                    posy = posy(2:end);
                end
                
                posx = double(posx(lastind));
                posy = double(posy(lastind));

                if ~strcmp(type, 'array')
                    gtx = double(mean(Datastats.xstats(:,j)));
                    gty = double(mean(Datastats.ystats(:,j)));
                else
                    trial = MyData(j);
                    gt = find(trial.targetcate == trial.arraycate);
                    gtx = FIXLIST(gt,1);
                    gty = FIXLIST(gt,2);
                end


                %sanity check
    %             path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(j) '.jpg' ];
    %             gt = double(imread(path));
    %             gt = imresize(gt,[Imgw,Imgh]);
    %             gt = mat2gray(gt);
    %             gt = im2bw(gt,0.5);
    %             gt = double(gt);
    %             imshow(gt);
    %             gt = zeros(Imgw, Imgh);
    %             gt(gty(1):gty(2), gtx(1):gtx(2)) = 1;
    %             imshow(mat2gray(gt))

                dist = sqrt((gtx - posx)^2 + (gty - posy)^2);
                totallastdist = [totallastdist dist];
            end
        end  
    end
    
    totallastdist = totallastdist/156*5;
    bincounts = histc(totallastdist,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',ones(1,3)*lastn*0.85/6,'LineWidth',linewidth);
    handlesselected_median = [handlesselected_median median(totallastdist, 'omitnan')];
end

for lastn = 0:5
    plot(ones(1,length(binranges))*handlesselected_median(lastn+1), binranges,'--','color',ones(1,3)*lastn*0.85/6,'LineWidth',linewidth);
end
set(gca,'TickDir','out');
xlabel('Euclidean Distance To Target (visual degrees)','FontSize', 12);
ylabel('Proportion','FontSize', 12);

if strcmp(type,'naturaldesign')
    ylim([0 0.4]);
    xlim([0 25]);
    set(gca,'ytick',0:0.1:0.4);
    title({'Experiment 2','Humans'});
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

    %print(hb,['../Figures/fig_S11C_' type '_LastFixationToTargetDistance_human' printpostfix],printmode,printoption);

elseif strcmp(type,'waldo')
    ylim([0 0.6]);
    xlim([0 25]);
    set(gca,'ytick',0:0.1:0.6);
    title({'Experiment 3','Humans'});
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

    %print(hb,['../Figures/fig_S11E_' type '_LastFixationToTargetDistance_human' printpostfix],printmode,printoption);

else
    legend({'1st last','2nd last','3rd last','4th last','5th last','6th last'},'Location','northwest');
    legend('boxoff');
    ylim([0 1]);
    xlim([0 20]);
    set(gca,'ytick',0:0.1:1);
    title({'Experiment 1','Humans'});
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

    %print(hb,['../Figures/fig_S11A_' type '_LastFixationToTargetDistance_human' printpostfix],printmode,printoption);
end

%while 1 end
handlesselected_median = [];

hb = figure;
hold on;
for lastn = 0:5

    totallastdist = [];
    
    if strcmp(type,'array')
        load(['DataForPlot/topdown30_31_cropped' type '_saccade.mat']);
    else
        load(['DataForPlot/topdown30_31_cropped' type '.mat']);
    end
    
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    %PosX = PosX(seqInd);
    %PosY = PosY(seqInd);
        
%     if ~strcmp(type,'array')        
%         %scoremat = FixData.TargetFound;
%         scoremat = scoremat(seqInd,:);
%     end
%     
    hm = [];
    for j = 1: NumStimuli/2
        
        tf = find(scoremat(j,:)==1);
        if isempty(tf) || (tf<(lastn+1)) %consider those within HumanNumFix 
            continue;
        else
            lastind = tf - lastn;
            posx = PosX{j};
            posy = PosY{j};
            posx = double(posx(lastind));
            posy = double(posy(lastind));
            
            if ~strcmp(type, 'array')
                gtx = double(mean(Datastats.xstats(:,j)));
                gty = double(mean(Datastats.ystats(:,j)));
            else
                trial = MyData(j);
                gt = find(trial.targetcate == trial.arraycate);
                gtx = FIXLIST(gt,1);
                gty = FIXLIST(gt,2);
            end
            
            %sanity check
%             path = ['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(j) '.jpg' ];
%             gt = double(imread(path));
%             gt = imresize(gt,[Imgw,Imgh]);
%             gt = mat2gray(gt);
%             gt = im2bw(gt,0.5);
%             gt = double(gt);
%             imshow(gt);
%             gt = zeros(Imgw, Imgh);
%             gt(gty(1):gty(2), gtx(1):gtx(2)) = 1;
%             imshow(mat2gray(gt))

            dist = sqrt((gtx - posx)^2 + (gty - posy)^2);
            totallastdist = [totallastdist dist];
        end
    end  
    totallastdist = totallastdist/156*5;
    bincounts = histc(totallastdist,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',ones(1,3)*lastn*0.85/6,'LineWidth',linewidth);
    %plot(ones(1,length(binranges))*nanmedian(totallastdist), binranges,markerlist{lastn+7},'LineWidth',linewidth);
    handlesselected_median = [handlesselected_median median(totallastdist, 'omitnan')];
end

for lastn = 0:5
    plot(ones(1,length(binranges))*handlesselected_median(lastn+1), binranges,'--','color',ones(1,3)*lastn*0.85/6,'LineWidth',linewidth);
end

set(gca,'TickDir','out');
% legend({'1st last','2nd last','3rd last','4th last','5th last','6th last'});
% legend('boxoff');
xlabel('Euclidean Distance To Target (visual degrees)','FontSize', 12);
ylabel('Proportion','FontSize', 12);
xlim([0 25]);
title('IVSN model');

if strcmp(type,'naturaldesign')
    ylim([0 0.4]);
    xlim([0 25]);
    set(gca,'ytick',0:0.1:0.4);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S11D_' type '_LastFixationToTargetDistance_model' printpostfix],printmode,printoption);
elseif strcmp(type,'waldo')
    ylim([0 0.6]);
    xlim([0 25]);
    set(gca,'ytick',0:0.1:0.6);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S11F_' type '_LastFixationToTargetDistance_model' printpostfix],printmode,printoption);
else
    ylim([0 1]);
    xlim([0 20]);
    set(gca,'ytick',0:0.1:1);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S11B_' type '_LastFixationToTargetDistance_model' printpostfix],printmode,printoption);

end

display('done result analysis');






