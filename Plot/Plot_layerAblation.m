clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

type = 'naturaldesign';
display(['dataset: ' type]);
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
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
    

RandomTimes = 30; %number of randomize times
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);

%% Overall performance curves (simplified version)
counter = 1;
linewidth = 3;
hb = figure;
hold on;

%machine 
%topdown30_31_croppedwaldo
load(['DataForPlot/machine_layer30_31_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', 4.5);

htotal = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
h31 = htotal;

%topdown23_24_croppedwaldo
load(['DataForPlot/machine_layer23_24_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', 3.5);

htotal = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
h24 = htotal;



%topdown16_17_croppedwaldo
load(['DataForPlot/machine_layer16_17_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', 2.5);

htotal = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
h17 = htotal;



%topdown9_10_croppedwaldo
load(['DataForPlot/machine_layer9_10_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', 2.0);

htotal = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
h10 = htotal;


%topdown4_5_croppedwaldo
load(['DataForPlot/machine_layer4_5_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', 1.5);

htotal = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
h5 = htotal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%random after 100 times
load(['DataForPlot/random_cropped' type '.mat']);
scoremat = scoremat(:,1:HumanNumFix);
randstore = scoremat;
err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
errorbar(1:length(err_random), cumsum(mean(scoremat,1)), err_random,'k--' , 'linewidth', linewidth);

% hm = [];
% for j = 1: size(scoremat,1)
%     tf = find(scoremat(j,:)==1);
%     if isempty(tf) %consider those within HumanNumFix 
%         hm = [hm nan];
%     else
%         hm = [hm tf];
%     end
% end
load(['DataForPlot/RandomFixGK_' type '.mat']);
hchance = RandomFixGK(:);

if strcmp(type, 'array')
    legend({'TopDown-31-30','TopDown-24-23','TopDown-17-16','TopDown-10-9','TopDown-5-4','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
    set(gca,'xtick',[1:HumanNumFix]);
elseif strcmp(type, 'naturaldesign')
    legend({'TopDown-31-30','TopDown-24-23','TopDown-17-16','TopDown-10-9','TopDown-5-4','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
else
    legend({'TopDown-31-30','TopDown-24-23','TopDown-17-16','TopDown-10-9','TopDown-5-4','Chance'},'Location','northwest','FontSize',13); %14 for waldo; 10 for naturaldesign

    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix]);
    %ylim([0 0.8]);
    ylim([0 1]);
end
legend('boxoff');    
xlabel('Fixation number','FontSize', 12);
ylabel('Cummulative performance','FontSize', 12);
set(gca,'TickDir','out');
set(gca,'Box','Off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

if strcmp(type,'array')
    %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S15_' type '_LayerAblation' printpostfix],printmode,printoption);

elseif strcmp(type,'naturaldesign')
    %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S15_' type '_LayerAblation' printpostfix],printmode,printoption);

else
    %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S15_' type '_LayerAblation' printpostfix],printmode,printoption);

end

%display(['Dataset: ' type]);
[h,p,ci,stats]=ttest2(h31(:),hchance(:));
display(['Layer31-30 vs Chance']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h24(:),hchance(:));
display(['Layer24-23 vs Chance']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h17(:),hchance(:));
display(['Layer17-16 vs Chance']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h10(:),hchance(:));
display(['Layer10-9 vs Chance']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h5(:),hchance(:));
display(['Layer5-4 vs Chance']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);

[h,p,ci,stats]=ttest2(h31(:),h31(:));
display(['Layer31-30 vs Layer31-30 (model itself']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h24(:),h31(:));
display(['Layer24-23 vs Layer31-30']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h17(:),h31(:));
display(['Layer17-16 vs Layer31-30']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h10(:),h31(:));
display(['Layer10-9 vs Layer31-30']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
[h,p,ci,stats]=ttest2(h5(:),h31(:));
display(['Layer5-4 vs Layer31-30']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['============================']);

% save(['DataForPlot/h31_30_' type '.mat'],'h31');
% save(['DataForPlot/h24_23_' type '.mat'],'h24');
% save(['DataForPlot/h17_16_' type '.mat'],'h17');
% save(['DataForPlot/h10_9_' type '.mat'],'h10');
% save(['DataForPlot/h5_4_' type '.mat'],'h5');

expdata=cell(5,1);
expdata{1}=h31;
expdata{2}=h24;
expdata{3}=h17;
expdata{4}=h10;
expdata{5}=h5;
anovadata=[expdata{1}',expdata{2}',expdata{3}',expdata{4}',expdata{5}'];
[P,ANOVATAB,STATS] = anova1(anovadata,[],'off');
F=ANOVATAB{2,5};
df = ANOVATAB{2,3};
display(['One-ANOVA five ablation layers']);
display(['P= ' num2str(P) '; F= ' num2str(F) ';df= ' num2str(df) ]);



