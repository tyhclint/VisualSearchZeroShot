clear all; close all; clc;
addpath('ScanMatch');
type = 'naturaldesign'; %waldo, wizzard, naturaldesign, array

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 65; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end
    
markerlist = {'r','g','b','c','k','m',     'r*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
MaxDist = sqrt(Imgw*Imgw + Imgh*Imgh); %the maximum eucli dist on stimuli of size [1024 1280]
PermMax = 5;
% load('rSS.mat'); %random SS score
% load('RvalueMat.mat'); %random eucli dist

load(['DataForPlot/RvalueMat_' type '.mat']);
load(['DataForPlot/rSSHuman_' type '.mat']);
load(['DataForPlot/RvalueMatPerm_' type '.mat']);

RvalueMat = 1- RvalueMat/MaxDist;
RvalueMatPerm = 1-RvalueMatPerm/MaxDist;

FirstRvalueMat = nanmean(RvalueMat,1);
RvalueMat = nanmean(RvalueMat,2);
ExpRvalueMat = nanmean(RvalueMat);
ExpRvalueMatPerm = nanmean(RvalueMatPerm);
ExpSS = nanmean(rSS);

% display(['Random eculi dist: ' num2str(ExpRvalueMat) ]);
% display(['Random perm eucli dist: ' num2str(ExpRvalueMatPerm) ]);
% display(['Random ss dist: ' num2str(ExpSS) ]);


%% Reaction Time (1st fixation)
RTstore = nan(NumStimuli*length(subjlist), HumanNumFix);
binranges = [0:0.05:1];
linewidth = 3;
hb = figure;
hold on;
set(gca,'TickDir','out');
set(gca,'Box','Off');
for s = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{s} '_oracle.mat']);
    RTmat = FixData.Fix_time;
    
    for i = 1:NumStimuli
        rt = RTmat{i};
        if length(rt) > HumanNumFix
            rt = rt(1:HumanNumFix);
        end
        %rtdiff = [0 rt(1:end-1)];
        %rt =rt - rtdiff;
        RTstore( (s-1)*NumStimuli + i, 1: length(rt) ) = rt;
    end
    
    firstRT = RTstore( (s-1)*NumStimuli + 1 : (s)*NumStimuli, 1)/1000; %convert to seconds from ms
    
    bincounts = histc(firstRT,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',[0.75    0.75    0.75],'LineWidth',1.5);
end

firstRT = RTstore(:, 1)/1000; %convert to seconds from ms
%save(['DataForPlot/firstRT_' type '.mat'],'firstRT');
bincounts = histc(firstRT,binranges);
plot(binranges, bincounts/sum(bincounts),'k-','LineWidth',linewidth);
%ydivision = [0:0.01:0.4];
plot(ones(1,length(binranges))*nanmedian(RTstore(:,1))/1000, binranges,'k--','LineWidth',linewidth);
%title('ReactionTimeFirstFix');
xlabel('Time (s)','FontSize', 11);
ylabel('Proportion','FontSize', 11);
xlim([0 1]);
if strcmp(type, 'array')
    ylim([0 0.4]);
    
elseif strcmp(type, 'waldo')
    ylim([0 0.45]);
elseif strcmp(type, 'wizzard')
    ylim([0 0.4]);
else
    ylim([0 0.45]);
end
set(gca,'ytick',[0:0.1:0.4]);
%ylim([0 max(bincounts)/sum(bincounts)+0.1]);
%legend({'Subj1', 'Subj2', 'Subj3', 'Subj4', 'Subj5','All'},'Location','northeast','FontSize',10); %14 for waldo; 10 for naturaldesign

set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

% if strcmp(type,'array')
%     print(hb,['../Figures/fig_3D_' type '_ReactionTime_FirstFix' printpostfix],printmode,printoption);
% elseif strcmp(type,'naturaldesign')
%     print(hb,['../Figures/fig_4D_' type '_ReactionTime_FirstFix' printpostfix],printmode,printoption);
% else
%     print(hb,['../Figures/fig_5D_' type '_ReactionTime_FirstFix' printpostfix],printmode,printoption);
% end

display(['dataset: ' type ]);
display('===============first fixation:');
display(['median of reaction time: ' num2str(nanmedian(RTstore(:,1))) ]);
display(['mean of reaction time: ' num2str(nanmean(RTstore(:,1))) ]);
display(['STD of reaction time: ' num2str( nanstd(RTstore(:,1)) )]);
display(['MSE of reaction time: ' num2str( nanstd(RTstore(:,1))/sqrt(length(RTstore(:,1))) )]);
display(['n for MSE: ' num2str( length(RTstore(:,1)) )]);
% am = [nanmean(a(1:600)) nanmean(a(601:1200)) nanmean(a(1201:1800)) nanmean(a(1801:2400)) nanmean(a(2401:3000))];
% bm = [nanmean(b(1:480)) nanmean(b(481:960)) nanmean(b(961:961+480-1)) nanmean(b(960+480: 960+480*2)) nanmean(b(960+480*2:end))];
% cm = [nanmean(c(1:134)) nanmean(c(135:134*2)) nanmean(c(134*2:134*3)) nanmean(c(134*3:134*4)) nanmean(c(134*4:end))];


% while 1
% end

%% Reaction Time (all fixations)
RTstore = nan(NumStimuli*length(subjlist), HumanNumFix);
binranges = [0:0.05:6];
linewidth = 3;

for s = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{s} '_oracle.mat']);
    RTmat = FixData.Fix_time;

    for i = 1:NumStimuli
        rt = RTmat{i};
        if length(rt) > HumanNumFix
            rt = rt(1:HumanNumFix);
        end
        
%         if ~strcmp(type,'array')
%             rt = cumsum(rt);
%         end
        
        %rtdiff = [0 rt(1:end-1)];
        %rt =rt - rtdiff;
        RTstore( (s-1)*NumStimuli + i, 1: length(rt) ) = rt;
    end

    
end

hb = figure;
hold on;
set(gca,'TickDir','out');
set(gca,'Box','Off');
s =  1;
cummuRT = [];
for f = 2:6
    cummuRT = [cummuRT; (RTstore(:,f) - RTstore(:,f-1))];
end

display('==================fixation interval');
display(['median of reaction time: ' num2str(nanmedian(cummuRT)) ]);
display(['mean of reaction time: ' num2str(nanmean(cummuRT)) ]);
display(['STD of reaction time: ' num2str( nanstd(cummuRT,0,1) )]);
display(['MSE of reaction time: ' num2str( nanstd(cummuRT,0,1)/sqrt(length(cummuRT)) )]);
display(['n for MSE: ' num2str( length(cummuRT) )]);

offsetcolor = 0.7/6;

for f = 1: 6
   
    firstRT = RTstore(:, f)/1000; %convert to seconds from ms
    bincounts = histc(firstRT,binranges);
    cvec = zeros(1,3) + (f-1)*offsetcolor*ones(1,3);
    plot(binranges, bincounts/sum(bincounts)','color',cvec,'LineWidth',linewidth);
    s= s+1;
    %ydivision = [0:0.01:0.4];
    %plot(ones(1,length(binranges))*nanmedian(RTstore(:,f))/1000, binranges,'k--','LineWidth',linewidth);
end

%title('ReactionTimeFirstFix');
xlabel('Time (s)','FontSize', 11);
ylabel('Proportion','FontSize', 11);

if strcmp(type, 'array')
    xlim([0 3]);
    ylim([0 0.3]);
elseif strcmp(type, 'waldo')
    xlim([0 3]);
    ylim([0 0.45]);
elseif strcmp(type, 'wizzard')
    xlim([0 3]);
    ylim([0 0.4]);
else
    xlim([0 3]);
    ylim([0 0.4]);
end
ylim([0 0.31]);
set(gca,'ytick',[0:0.1:0.3]);
%ylim([0 max(bincounts)/sum(bincounts)+0.1]);
if strcmp(type,'array')
    legend({'Fixation1', 'Fixation2', 'Fixation3', 'Fixation4', 'Fixation5','Fixation6'},'Location','northeast','FontSize',13); %14 for waldo; 10 for naturaldesign
end
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_' type '_ReactionTime_AllFix' printpostfix],printmode,printoption);
% if strcmp(type,'array')
%     print(hb,['../Figures/fig_S02A_' type '_ReactionTime_AllFix' printpostfix],printmode,printoption);
% elseif strcmp(type,'naturaldesign')
%     print(hb,['../Figures/fig_S02C_' type '_ReactionTime_AllFix' printpostfix],printmode,printoption);
% else
%     print(hb,['../Figures/fig_S02E_' type '_ReactionTime_AllFix' printpostfix],printmode,printoption);
% end

%% Reaction Time (Target Found)
RTstore = nan(NumStimuli*length(subjlist),1);
binranges = [0:0.05:20];
linewidth = 3;

for s = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{s} '_oracle.mat']);
    RTmat = FixData.Fix_time;
    RTmat = RTmat(seqInd);
    if strcmp(type, 'array')
        Myscoremat = scoremat;
    else
        Myscoremat = FixData.TargetFound;
    end
    Myscoremat = Myscoremat(seqInd,:);

    for i = [1:NumStimuli]
        %i
        rt = RTmat{i};
        scorevec = Myscoremat(i,:);
%         if length(rt) > HumanNumFix
%             rt = rt(1:HumanNumFix);
%         end
        %rtdiff = [0 rt(1:end-1)];
        %rt =rt - rtdiff;
        indwin = find(scorevec ==1);
        if ~isempty(indwin)
            RTstore( (s-1)*NumStimuli + i) = rt(indwin);
        end
    end

    
end

hb = figure;
hold on;
set(gca,'TickDir','out');
set(gca,'Box','Off');
%s=  1;
%for f = 1: HumanNumFix
for s = 1: length(subjlist)   
    firstRT = RTstore((s-1)*NumStimuli +1: s*NumStimuli)/1000; %convert to seconds from ms
    %bincounts = histc(firstRT,binranges);
    %plot(binranges, bincounts/sum(bincounts),markerlist{s},'LineWidth',linewidth);
end
firstRT = RTstore/1000; %convert to seconds from ms


display('============time when target found');
display(['median of reaction time: ' num2str(nanmedian(RTstore,1)) ]);
display(['mean of reaction time: ' num2str(nanmean(RTstore,1)) ]);
display(['STD of reaction time: ' num2str( nanstd(RTstore,0,1) )]);
display(['MSE of reaction time: ' num2str( nanstd(RTstore,0,1)/sqrt(length(RTstore)) )]);
display(['n for MSE: ' num2str( length(RTstore) )]);



save(['DataForPlot/targetfoundRT_' type '.mat'],'firstRT');
bincounts = histc(firstRT,binranges);
plot(binranges, bincounts/sum(bincounts),'k','LineWidth',linewidth);
%ydivision = [0:0.01:0.4];
plot(ones(1,length(binranges))*nanmedian(RTstore(:,1))/1000, binranges,'k--','LineWidth',linewidth);
%title('ReactionTimeFirstFix');
xlabel('Time (s)','FontSize', 11);
ylabel('Proportion','FontSize', 11);
%nanmedian(RTstore(:,1))/1000;
if strcmp(type, 'array')
    %xlim([0 nanmedian(RTstore(:,1))/1000*2]);
    xlim([0 3]);
    ylim([0 0.15]);
    set(gca,'ytick',[0:0.05:0.15]);
elseif strcmp(type, 'waldo')
    %xlim([0 nanmedian(RTstore(:,1))/1000*2]);
    xlim([0 10]);
    ylim([0 0.041]);
    set(gca,'ytick',[0:0.01:0.04]);
elseif strcmp(type, 'wizzard')
    %xlim([0 nanmedian(RTstore(:,1))/1000*2]);
    xlim([0 10]);
    ylim([0 0.04]);
else
    %xlim([0 nanmedian(RTstore(:,1))/1000*2]);
    xlim([0 3]);
    ylim([0 0.081]);    
    set(gca,'ytick',[0:0.02:0.08]);
end
%ylim([0 max(bincounts)/sum(bincounts)+0.1]);
%legend({'Subj1', 'Subj2', 'Subj3', 'Subj4', 'Subj5','All'},'Location','northeast','FontSize',10); %14 for waldo; 10 for naturaldesign


set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_' type '_ReactionTime_TargetFound' printpostfix],printmode,printoption);
% if strcmp(type,'array')
%     print(hb,['../Figures/fig_S02B_' type '_ReactionTime_TargetFound' printpostfix],printmode,printoption);
% elseif strcmp(type,'naturaldesign')
%     print(hb,['../Figures/fig_S02D_' type '_ReactionTime_TargetFound' printpostfix],printmode,printoption);
% else
%     print(hb,['../Figures/fig_S02F_' type '_ReactionTime_TargetFound' printpostfix],printmode,printoption);
% end

% display(['dataset: ' type ]);
% display(['median of reaction time: ' num2str(nanmedian(RTstore(:,1))) ]);
% display(['mean of reaction time: ' num2str(nanmean(RTstore(:,1))) ]);
% display(['MSE of reaction time: ' num2str(nanstd(RTstore(:,1))/sqrt(length(RTstore(:,1)) ))]);
% display(['mode of reaction time: ' num2str(250) ]);
















