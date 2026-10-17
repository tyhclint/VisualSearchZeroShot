clear all; close all; clc;
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
%markerlist = {'r','g','b','c','c','c',     'c*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
markerlist = {'r','g','k','c','c','c',     'c','c','b','b','b','b',   'b','b','b','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};

hb = figure;
set(hb,'Position',[680   244   475   674]);

%% array 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
type = 'array';
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    %subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
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


compnamelist = {'templatematch','saliency','randweights_topdown30_31','chance','slidingwindow', 'IVSNrecog','IVSNsacad' ...
    'IVSNfior','machine_alexnet','machine_resnet','machine_fastrcnnvgg'};

subplot(3,1,1); hold on;
avgFix = [];
stdFix = [];

%% humans
scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: length(subjlist)
    
    load(['DataForPlot/SS_withinsubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_withinsubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];

scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: 105
    
    load(['DataForPlot/SS_betweensubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_betweensubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];

scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: length(subjlist)
    
    load(['DataForPlot/SS_modelsubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_modelsubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];


%% Baselines
for m = 1:length(compnamelist)
    
    if m == 4
        load(['DataForPlot/rSSHuman_totalscore_' type '.mat']);
    else    
        filename=['DataForPlot/ScanScore_' compnamelist{m} '_' type '.mat'];
        load(filename);
    end
    scoretotal = scoretotal(:,1:HumanNumFix);
    avgFix = [avgFix; nanmean(scoretotal,1)];
    stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];
end

%% Plot ALL
avgFix = avgFix(:,1:HumanNumFix);
stdFix = stdFix(:, 1:HumanNumFix);

linewidth = 2; 
plot([1:HumanNumFix],avgFix(1,:),'color','r','linewidth',linewidth+2);
plot([1:HumanNumFix],avgFix(2,:),'color','r','linewidth',linewidth);
plot([1:HumanNumFix],avgFix(3,:),'color',[0 0.45 0.74],'linewidth',linewidth);
plot([1:HumanNumFix],avgFix(7,:),'k--','linewidth',linewidth);

legend({'Within-subject','Between-subject','IVSN-subject','Chance'},'Location','southeast');
legend('boxoff');  

set(gca,'xtick',[1:1:HumanNumFix]);
set(gca,'ytick',[0:0.1:0.6]);

errorbar([1:HumanNumFix],avgFix(1,:), stdFix(1,:),'color','r', 'Linewidth', linewidth);
errorbar([1:HumanNumFix],avgFix(2,:), stdFix(2,:),'color','r', 'Linewidth', linewidth);
errorbar([1:HumanNumFix],avgFix(3,:), stdFix(3,:),'color',[0 0.45 0.74], 'Linewidth', linewidth);
errorbar([1:HumanNumFix],avgFix(7,:), stdFix(7,:),'k--', 'Linewidth', linewidth);
xlabel('Fixation number');

xlim([0.8 HumanNumFix+0.2]);
ylabel({'Experiment 1' '(Object arrays)' 'Scanpath similarity score'});
set(gca,'TickDir','out');
ylim([0 0.6]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Natural design
type = 'naturaldesign';
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    %subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
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


compnamelist = {'templatematch','saliency','randweights_topdown30_31','chance','slidingwindow', 'IVSNrecog','IVSNsacad' ...
    'IVSNfior','machine_alexnet','machine_resnet','machine_fastrcnnvgg'};

subplot(3,1,2); hold on;
avgFix = [];
stdFix = [];

%% humans
scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: length(subjlist)
    
    load(['DataForPlot/SS_withinsubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_withinsubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];

scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: 105
    
    load(['DataForPlot/SS_betweensubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_betweensubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];

scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: length(subjlist)
    
    load(['DataForPlot/SS_modelsubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_modelsubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];


%% Baselines
for m = 1:4%length(compnamelist)
    
    if m == 4
        load(['DataForPlot/rSSHuman_totalscore_' type '.mat']);
    else    
        filename=['DataForPlot/ScanScore_' compnamelist{m} '_' type '.mat'];
        load(filename);
    end
    scoretotal = scoretotal(:,1:HumanNumFix);
    avgFix = [avgFix; nanmean(scoretotal,1)];
    stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];
end

%% Plot ALL
avgFix = avgFix(:,1:HumanNumFix);
stdFix = stdFix(:, 1:HumanNumFix);

linewidth = 2; 
plot([5:5:HumanNumFix],avgFix(1,[5:5:HumanNumFix]),'color','r','linewidth',linewidth+2);
plot([5:5:HumanNumFix],avgFix(2,[5:5:HumanNumFix]),'color','r','linewidth',linewidth);
plot([5:5:HumanNumFix],avgFix(3,[5:5:HumanNumFix]),'color',[0 0.45 0.74],'linewidth',linewidth);
plot([5:5:HumanNumFix],avgFix(7,[5:5:HumanNumFix]),'k--','linewidth',linewidth);

% legend({'Within-subject','Between-subject','IVSN-subject','Chance'},'Location','northwest');
% legend('boxoff');  

errorbar([5:5:HumanNumFix],avgFix(1,[5:5:HumanNumFix]), stdFix(1,[5:5:HumanNumFix]),'color','r', 'Linewidth', linewidth);
errorbar([5:5:HumanNumFix],avgFix(2,[5:5:HumanNumFix]), stdFix(2,[5:5:HumanNumFix]),'color','r', 'Linewidth', linewidth);
errorbar([5:5:HumanNumFix],avgFix(3,[5:5:HumanNumFix]), stdFix(3,[5:5:HumanNumFix]),'color',[0 0.45 0.74], 'Linewidth', linewidth);
errorbar([5:5:HumanNumFix],avgFix(7,[5:5:HumanNumFix]), stdFix(7,[5:5:HumanNumFix]),'k--', 'Linewidth', linewidth);

xlabel('Fixation number');

xlim([4.5 HumanNumFix+0.5]);
set(gca,'xtick',[5:5:HumanNumFix]);
set(gca,'ytick',[0:0.1:0.6]);

ylabel({'Experiment 2' '(Natural images)' 'Scanpath similarity score'});
set(gca,'TickDir','out');
ylim([0 0.6]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Waldo
type = 'waldo';
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    %subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
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


compnamelist = {'templatematch','saliency','randweights_topdown30_31','chance','slidingwindow', 'IVSNrecog','IVSNsacad' ...
    'IVSNfior','machine_alexnet','machine_resnet','machine_fastrcnnvgg'};

subplot(3,1,3); hold on;
avgFix = [];
stdFix = [];

%% humans
scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: length(subjlist)
    
    load(['DataForPlot/SS_withinsubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_withinsubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];

scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: 105
    
    load(['DataForPlot/SS_betweensubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_betweensubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];

scoretotal = nan(length(subjlist),NumStimuli/2, HumanNumFix);
for i=1: length(subjlist)
    
    load(['DataForPlot/SS_modelsubj_subj' num2str(i) '_' type '.mat']);
    scores = scores(:,1:HumanNumFix);
    scoretotal(i,:,:) = scores;
end
scoretotal = squeeze(nanmean(scoretotal,1));
save(['DataForPlot/SSAcrossTime_modelsubj_' type '.mat'],'scoretotal');
avgFix = [avgFix; nanmean(scoretotal,1)];
stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];


%% Baselines
for m = 1:4%length(compnamelist)
    
    if m == 4
        load(['DataForPlot/rSSHuman_totalscore_' type '.mat']);
    else    
        filename=['DataForPlot/ScanScore_' compnamelist{m} '_' type '.mat'];
        load(filename);
    end
    scoretotal = scoretotal(:,1:HumanNumFix);
    avgFix = [avgFix; nanmean(scoretotal,1)];
    stdFix = [stdFix; nanstd(scoretotal,0,1)/sqrt(size(scoretotal,1))];
end

%% Plot ALL
avgFix = avgFix(:,1:HumanNumFix);
stdFix = stdFix(:, 1:HumanNumFix);
avgFix(2,79:end) = avgFix(2,77);
stdFix(2,79:end) = stdFix(2,77);

linewidth = 2; 
plot([10:10:HumanNumFix],avgFix(1,[10:10:HumanNumFix]),'color','r','linewidth',linewidth+2);
plot([10:10:HumanNumFix],avgFix(2,[10:10:HumanNumFix]),'color','r','linewidth',linewidth);
plot([10:10:HumanNumFix],avgFix(3,[10:10:HumanNumFix]),'color',[0 0.45 0.74],'linewidth',linewidth);
plot([10:10:HumanNumFix],avgFix(7,[10:10:HumanNumFix]),'k--','linewidth',linewidth);

% legend({'Within-subject','Between-subject','IVSN-subject','Chance'},'Location','northwest');
% legend('boxoff');  

errorbar([10:10:HumanNumFix],avgFix(1,[10:10:HumanNumFix]), stdFix(1,[10:10:HumanNumFix]),'color','r', 'Linewidth', linewidth);
errorbar([10:10:HumanNumFix],avgFix(2,[10:10:HumanNumFix]), stdFix(2,[10:10:HumanNumFix]),'color','r', 'Linewidth', linewidth);
errorbar([10:10:HumanNumFix],avgFix(3,[10:10:HumanNumFix]), stdFix(3,[10:10:HumanNumFix]),'color',[0 0.45 0.74], 'Linewidth', linewidth);
errorbar([10:10:HumanNumFix],avgFix(7,[10:10:HumanNumFix]), stdFix(7,[10:10:HumanNumFix]),'k--', 'Linewidth', linewidth);

xlim([9.5 HumanNumFix+0.5]);
set(gca,'xtick',[10:10:HumanNumFix]);
set(gca,'ytick',[0:0.1:0.6]);

xlabel('Fixation number');
ylabel({'Experiment 3' '(Waldo images)' 'Scanpath similarity score'});
set(gca,'TickDir','out');
ylim([0 0.6]);

set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S23_ALL_ScanScoreALL' printpostfix],printmode,printoption);


