clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

type = 'waldo';
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
    

RandomTimes = 30; %number of randomize times
% HumanNumFix = 6; %naturaldesign: 30; waldo/wizzard:60; array: 6
% NumStimuli = 600; %134 for waldo/wizzard; 480 for antural design; 600 for array
% type = 'array'; %waldo, wizzard, naturaldesign, array
%subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az'}; %waldo/wizzard
%subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
%subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo'}; %array
markerlist = {'r','g','b','c','k','m',     'r*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
FcTHRESHOLD = 0.9; %assume 90% recognition rate
UpToNum = 6; %waldo/wizzard/naturaldesign: 8; array: 6


%% Overall performance curves
counter = 1;
linewidth = 3;
hb = figure;
hold on;

diffMaoracleOther = [];

%human (all+target-non-identical+target-identical)
humanstore = nan(length(subjlist), HumanNumFix);
humanstorerepeat = nan(length(subjlist), HumanNumFix);
humanstorenonrepeat = nan(length(subjlist), HumanNumFix);

UnableFind = [];

for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    
    
    
    if strcmp( 'array', type)
        avg = nanmean(scoremat(1:300,:),1);
        avgnr = nanmean(scoremat(1:180,:),1);
        avgr = nanmean(scoremat(181:300,:),1);
        
        hm = [];
        for j = 1: NumStimuli/2
            tf = find(scoremat(j,:)==1);
            if isempty(tf) %consider those within HumanNumFix 
                hm = [hm nan];
            else
                hm = [hm tf];
            end
        end
        %save(['DataForPlot/human_subj' num2str(i) '_' type '.mat'],'hm');
        UnableFind = [UnableFind length(find(isnan(hm)))/length(hm)];
    else
        TargetFound = FixData.TargetFound(:,2:end);
        TargetFound = TargetFound(seqInd,:);
        TargetFound = TargetFound(1: length(seqInd)/2,:);
        scoremat = TargetFound;
        hm = [];
        for j = 1: NumStimuli/2
            tf = find(scoremat(j,:)==1);
            if isempty(tf) %consider those within HumanNumFix 
                hm = [hm nan];
            else
                hm = [hm tf];
            end
        end
        %save(['DataForPlot/human_subj' num2str(i) '_' type '.mat'],'hm');
        UnableFind = [UnableFind length(find(isnan(hm)))/length(hm)];
        
        avg = nanmean(TargetFound,1);        
    end
    
    if length(avg) > HumanNumFix
        avg = avg(1:HumanNumFix);           
    end
    humanstore(i,1:length(avg)) = avg;
    
    if strcmp(type, 'array')
        humanstorerepeat(i,1:length(avgr)) = avgr;
        humanstorenonrepeat(i,1:length(avgnr)) = avgnr;
    end
end
display(['======== unable find target proportion']);
display(['mean is: ' num2str(mean(UnableFind))]);
display(['std is: ' num2str(std(UnableFind)) ]);
display(['mse is: ' num2str(std(UnableFind)/sqrt(length(UnableFind))) ]);
display(['n is: ' num2str(length(UnableFind)) ]);

err_human = nanstd(humanstore,0,1)/sqrt(size(humanstore,1));
errorbar(1:length(err_human), cumsum(nanmean(humanstore,1)), err_human,'color',  'r', 'linewidth', linewidth);
counter = counter + 1;

%while 1 end

%machine 
%topdown30_31_croppedwaldo
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        %warning(['nan value']);
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
%save(['DataForPlot/IVSNoracle_' type '.mat'],'hm');

machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', linewidth);
counter = counter + 1;


%machine recognition
load(['DataForPlot/Dist_' type '.mat']);
FcL2 = Dist.FcL2;
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
for i = 1:NumStimuli/2
    vec = scoremat(i,:);
    ind = find(vec == 1);
    if ind<=HumanNumFix
        distfc = FcL2(i,ind);
        if distfc > FcTHRESHOLD
            scoremat(i,ind) = 0;
        end
    end
end

hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
%save(['DataForPlot/IVSNrecog_' type '.mat'],'hm');

machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)),'--', 'color',  [0 0.45 0.74], 'linewidth', linewidth);
counter = counter + 1;

%template matching
load(['DataForPlot/templatematch_cropped' type '.mat']);

hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
%save(['DataForPlot/pixelmatch_' type '.mat'],'hm');

tempstore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    tempstore = [tempstore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(tempstore,1)),nanstd(tempstore,0,1)/sqrt(size(tempstore,1)), 'color',[0.3,0.75,0.93], 'linewidth', linewidth);
counter = counter + 1;

diffMaoracleOther = [diffMaoracleOther cumsum(nanmean(machinestore,1))-cumsum(nanmean(tempstore,1))];

% %rotated templates
% load(['DataForPlot/rotatedtemplate_cropped' type '.mat']); 
% tempstore = [];
% for i = 1: RandomTimes
%     ind = randperm(NumStimuli/2, int32(NumStimuli/4));
%     prop = scoremat(ind,1:HumanNumFix);
%     tempstore = [tempstore; nanmean(prop,1)];
% end
% errorbar(1:HumanNumFix,cumsum(nanmean(tempstore,1)),nanstd(tempstore,0,1)/sqrt(size(tempstore,1)), 'm', 'linewidth', linewidth);
% counter = counter + 1;
% diffMaoracleOther = [diffMaoracleOther cumsum(nanmean(machinestore,1))-cumsum(nanmean(tempstore,1))];

%saliency ittikoch
load(['DataForPlot/saliency_cropped' type '.mat']);

hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
%save(['DataForPlot/IttiKoch_' type '.mat'],'hm');

saliencystore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    saliencystore = [saliencystore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(saliencystore,1)),nanstd(saliencystore,0,1)/sqrt(size(saliencystore,1)), 'color',[.47, .67,.19], 'linewidth', linewidth);
counter = counter + 1;

%randomweights %randweights_topdown30_31_croppednaturaldesign
load(['DataForPlot/randweights_topdown30_31_cropped' type '.mat']);
hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
%save(['DataForPlot/randweights_' type '.mat'],'hm');

randweightstore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    randweightstore = [randweightstore; nanmean(prop,1)];
end
%%load(['DataForPlot/randweightstore_' type '.mat']);
errorbar(1:HumanNumFix,cumsum(nanmean(randweightstore,1)),nanstd(randweightstore,0,1)/sqrt(size(randweightstore,1)),  'color',[1 1 0], 'linewidth', linewidth);
counter = counter + 1;
diffMaoracleOther = [diffMaoracleOther cumsum(nanmean(machinestore,1))-cumsum(nanmean(randweightstore,1))];

%random after 100 times
load(['DataForPlot/random_cropped' type '.mat']);
% hm = [];
% for j = 1: size(scoremat,1)
%     tf = find(scoremat(j,:)==1);
%     if isempty(tf) %consider those within HumanNumFix 
%         hm = [hm nan];
%     else
%         hm = [hm tf];
%     end
% end
% save(['DataForPlot/chance_' type '.mat'],'hm');

scoremat = scoremat(:,1:HumanNumFix);


randstore = scoremat;
err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
errorbar(1:length(err_random), cumsum(mean(scoremat,1)), err_random,'k--', 'linewidth', linewidth);
counter = counter + 1;
diffMaoracleOther = [diffMaoracleOther cumsum(nanmean(machinestore,1))-cumsum(mean(randstore,1))];

%sliding window
load(['DataForPlot/slidingwindow_cropped' type '.mat']);
hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
%save(['DataForPlot/slidingwin_' type '.mat'],'hm');

tempstore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    tempstore = [tempstore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(tempstore,1)),nanstd(tempstore,0,1)/sqrt(size(tempstore,1)), 'color',[0.8706    0.4902         0], 'linewidth', linewidth);
counter = counter + 1;
diffMaoracleOther = [diffMaoracleOther cumsum(nanmean(machinestore,1))-cumsum(mean(tempstore,1))];
%display(['pvalue for model against other null models:']);
diffMaoracleOther(6:6:end) = [];
%display(num2str(ranksum(diffMaoracleOther, zeros(1,length(diffMaoracleOther))   )));    
hold off;

if strcmp(type, 'array')
    legend({'Human','IVSNoracle','IVSNrecog','TemplateMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
    set(gca,'xtick',[1:HumanNumFix]);
elseif strcmp(type, 'naturaldesign')
    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
else
    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
end
set(gca,'TickDir','out');
set(gca,'Box','Off');
%uisetcolor

% xlabel('Fixation number','FontSize', 16, 'Fontweight', 'bold');
% ylabel('Cummulative performance','FontSize', 16, 'Fontweight', 'bold');
xlabel('Fixation number','FontSize', 12);
ylabel('Cummulative performance','FontSize', 12);
legend('boxoff');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

if strcmp(type,'array')
    %print(hb,['../Figures/fig_4A_' type '_OverallPerformance.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S04A_' type '_OverallPerformance' printpostfix],printmode,printoption);

elseif strcmp(type,'naturaldesign')
    %print(hb,['../Figures/fig_4B_' type '_OverallPerformance.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S04B_' type '_OverallPerformance' printpostfix],printmode,printoption);
else
    %print(hb,['../Figures/fig_4B_' type '_OverallPerformance.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S04C_' type '_OverallPerformance' printpostfix],printmode,printoption);
end

% display(['Dataset ' type ' p-value analysis: ']);
% display(['human-machine: ' num2str(ranksum( cumsum(mean(humanstore(:,1:UpToNum))), cumsum(mean(machinestore(:,1:UpToNum)))))]);
% display(['template-machine: ' num2str(ranksum( cumsum(mean(tempstore(:,1:UpToNum))), cumsum(mean(machinestore(:,1:UpToNum)))))]);
% display(['random-machine: ' num2str(ranksum( cumsum(mean(randstore(:,1:UpToNum))), cumsum(mean(machinestore(:,1:UpToNum)))))]);
% display(['randweights-machine: ' num2str(ranksum( cumsum(mean(randweightstore(:,1:UpToNum))), cumsum(mean(machinestore(:,1:UpToNum)))))]);


%% Overall performance curves (simplified version)
counter = 1;
linewidth = 3;
hb = figure;
hold on;

%human
humanstore = nan(length(subjlist), HumanNumFix);
humanstorerepeat = nan(length(subjlist), HumanNumFix);
humanstorenonrepeat = nan(length(subjlist), HumanNumFix);
ALLHuman = [];

for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    
    if strcmp( 'array', type)
        avg = nanmean(scoremat(1:300,:),1);
        avgnr = nanmean(scoremat(1:180,:),1);
        avgr = nanmean(scoremat(181:300,:),1);
    else
        TargetFound = FixData.TargetFound(:,2:end);
        TargetFound = TargetFound(seqInd,:);
        TargetFound = TargetFound(1: length(seqInd)/2,:);
        avg = nanmean(TargetFound,1);        
    end
    tempALL = cumsum(avg);
    ALLHuman = [ALLHuman tempALL(end)];
    if length(avg) > HumanNumFix
        avg = avg(1:HumanNumFix);           
    end
    humanstore(i,1:length(avg)) = avg;
    
    if strcmp(type, 'array')
        humanstorerepeat(i,1:length(avgr)) = avgr;
        humanstorenonrepeat(i,1:length(avgnr)) = avgnr;
    end
end
err_human = nanstd(humanstore,0,1)/sqrt(size(humanstore,1));
errorbar(1:length(err_human), cumsum(nanmean(humanstore,1)), err_human,'color',  'r', 'linewidth', linewidth);

tempfirst=nanmean(humanstore,1);
display(['====== first fixation cummul sear perf']);
display(['mean =: ' num2str(tempfirst(1))]);
tempfirst=nanstd(humanstore,1);
display(['std =: ' num2str(tempfirst(1))]);

if strcmp(type, 'array')
    tempfirst=cumsum(nanmean(humanstore,1));
    display(['====== last fixation cummul sear perf']);
    display(['mean =: ' num2str(tempfirst(end))]);
    tempfirst=nanstd(humanstore,1);
    display(['std =: ' num2str(tempfirst(end))]);
end


%err_human = nanstd(humanstorerepeat,0,1)/sqrt(size(humanstorerepeat,1));
%errorbar(1:length(err_human), cumsum(nanmean(humanstorerepeat,1)), err_human,'color',  [0.85,0.33,0.1], 'linewidth', linewidth);

%err_human = nanstd(humanstorenonrepeat,0,1)/sqrt(size(humanstorenonrepeat,1));
%errorbar(1:length(err_human), cumsum(nanmean(humanstorenonrepeat,1)), err_human,'color',  'k', 'linewidth', linewidth);
counter = counter + 1;

if strcmp(type,'array')
    for f = 1: HumanNumFix
        pval = ranksum(humanstorerepeat(:,f), humanstore(:,f));
        %display(['repeat: fix' num2str(f) ' : ' num2str(pval)]);
        pval = ranksum(humanstorenonrepeat(:,f), humanstore(:,f));
        %display(['non-repeat: fix' num2str(f) ' : ' num2str(pval)]);
    end
end

%machine 
%topdown30_31_croppedwaldo
%ALLModel = [];
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(NumStimuli/2, int32(NumStimuli/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
%     tempALL = cumsum(nanmean(scoremat,1));
%     ALLModel = [ALLModel tempALL(end)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', linewidth);
counter = counter + 1;

mask = meshgrid([1:size(machinestore,2)],[1:size(machinestore,1)]);
avgz = nanmean((machinestore.*mask),2);

%random after 100 times
load(['DataForPlot/random_cropped' type '.mat']);
scoremat = scoremat(:,1:HumanNumFix);
randstore = scoremat;
err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
errorbar(1:length(err_random), cumsum(mean(scoremat,1)), err_random,'k--' , 'linewidth', linewidth);
counter = counter + 1;


mask = meshgrid([1:size(randstore,2)],[1:size(randstore,1)]);
avgy = nanmean((randstore.*mask),2);


if strcmp(type, 'array')
    legend({'Human','IVSNoracle','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
    set(gca,'xtick',[1:HumanNumFix]);
elseif strcmp(type, 'naturaldesign')
    legend({'Human','IVSNoracle','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign
    plot(HumanNumFix+5, mean(ALLHuman),'ro','MarkerFaceColor', 'r');
    plot(HumanNumFix+5, 1,'bo','MarkerFaceColor',[0 0.45 0.74]);
    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix+6]);
    ylim([0 1]);
else
    legend({'Human','IVSNoracle','Chance'},'Location','northwest','FontSize',13); %14 for waldo; 10 for naturaldesign
    plot(HumanNumFix+5, mean(ALLHuman),'ro','MarkerFaceColor', 'r');
    plot(HumanNumFix+5, 1,'bo','MarkerFaceColor', [0 0.45 0.74]);
    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix+6]);
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

% if strcmp(type,'array')
%     %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
%     print(hb,['../Figures/fig_3E_' type '_OverallPerformance_simplified' printpostfix],printmode,printoption);
% 
% elseif strcmp(type,'naturaldesign')
%     %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
%     print(hb,['../Figures/fig_4E_' type '_OverallPerformance_simplified' printpostfix],printmode,printoption);
% 
% else
%     %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
%     print(hb,['../Figures/fig_5E_' type '_OverallPerformance_simplified' printpostfix],printmode,printoption);
% 
% end
% 
% % while 1
% end
%% Overall performance curves (for array identical study)

if strcmp(type, 'array') 
    counter = 1;
    linewidth = 3;
    

    %human
    humanstore = nan(length(subjlist), HumanNumFix);
    humanstorerepeat = nan(length(subjlist), HumanNumFix);
    humanstorenonrepeat = nan(length(subjlist), HumanNumFix);

    for i = 1: length(subjlist)
        load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);

        if strcmp( 'array', type)
            avg = nanmean(scoremat(1:300,:),1);
            avgnr = nanmean(scoremat(1:180,:),1);
            avgr = nanmean(scoremat(181:300,:),1);
        else
            TargetFound = FixData.TargetFound(:,2:end);
            TargetFound = TargetFound(seqInd,:);
            TargetFound = TargetFound(1: length(seqInd)/2,:);
            avg = nanmean(TargetFound,1);        
        end

        if length(avg) > HumanNumFix
            avg = avg(1:HumanNumFix);           
        end
        humanstore(i,1:length(avg)) = avg;

        if strcmp(type, 'array')
            humanstorerepeat(i,1:length(avgr)) = avgr;
            humanstorenonrepeat(i,1:length(avgnr)) = avgnr;
        end
    end
    %err_human = nanstd(humanstore,0,1)/sqrt(size(humanstore,1));
    %errorbar(1:length(err_human), cumsum(nanmean(humanstore,1)), err_human,'color',  'r', 'linewidth', linewidth);
    
    hb = figure;
    hold on;
    
    err_human = nanstd(humanstorerepeat,0,1)/sqrt(size(humanstorerepeat,1));
    errorbar(1:length(err_human), cumsum(nanmean(humanstorerepeat,1)), err_human,'color',  [0.8706    0.4902         0], 'linewidth', 1.5);
    
    err_human = nanstd(humanstorenonrepeat,0,1)/sqrt(size(humanstorenonrepeat,1));
    errorbar(1:length(err_human), cumsum(nanmean(humanstorenonrepeat,1)), err_human,'color',  [0.8706    0.4902         0], 'linewidth', 3);
    counter = counter + 1;
    
    %machine 
    %topdown30_31_croppedwaldo
    load(['DataForPlot/topdown30_31_cropped' type '.mat']);
    %load(['DataForPlot/machine_L10.mat']);
    %load(['DataForPlot/machine_cropped' type '.mat']);

    machinestore = scoremat(181:300,:);
    errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',[0 0.45 0.74], 'linewidth', 1.5);
    counter = counter + 1;
    
    machinestore = scoremat(1:180,:);
    errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',[0 0.45 0.74], 'linewidth', 3);
    counter = counter + 1;
    
    %random after 100 times
    load(['DataForPlot/random_cropped' type '.mat']);
    scoremat = scoremat(:,1:HumanNumFix);
    randstore = scoremat;
    err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
    errorbar(1:length(err_random), cumsum(mean(scoremat,1)), err_random,'k--' , 'linewidth', 2);
    counter = counter + 1;
    
    legend({'Human-Identical (Mixed)','Human-Different (Mixed)','IVSN-Identical','IVSN-Different','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
    set(gca,'xtick',[1:HumanNumFix]);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    legend('boxoff');    
    xlabel('Fixation number','FontSize', 12);
    ylabel('Cummulative performance','FontSize', 12);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

    %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S10C_' type '_repeat-nonrepeated' printpostfix],printmode,printoption);

    
    hb = figure;
    hold on;
    
    err_human = nanstd(humanstorerepeat,0,1)/sqrt(size(humanstorerepeat,1));
    errorbar(1:length(err_human), cumsum(nanmean(humanstorerepeat,1)), err_human,'color',  [0.8706    0.4902         0], 'linewidth', 1.5);
    
    err_human = nanstd(humanstorenonrepeat,0,1)/sqrt(size(humanstorenonrepeat,1));
    errorbar(1:length(err_human), cumsum(nanmean(humanstorenonrepeat,1)), err_human,'color',  [0.8706    0.4902         0], 'linewidth', 3);
    counter = counter + 1;
    

    % human identical
    identicalsubjlist = {'subj02-ni','subj03-st','subj04-yu','subj05-ma','subj06-mt'}; %array
    humanstore = nan(length(identicalsubjlist), HumanNumFix);    
    humanstorerepeat = nan(length(identicalsubjlist), HumanNumFix);
    humanstorenonrepeat = nan(length(identicalsubjlist), HumanNumFix);
    for s = 1: length(identicalsubjlist)
        load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/array/psy/subjects_blocking/' identicalsubjlist{s} '/subjperform.mat']);
        avg = nanmean(scoremat(1:300,:),1);
        avgnr = nanmean(scoremat(1:180,:),1);
        avgr = nanmean(scoremat(181:300,:),1);
        
        hm = [];
        for j = 1: NumStimuli/2
            tf = find(scoremat(j,:)==1);
            if isempty(tf) %consider those within HumanNumFix 
                hm = [hm nan];
            else
                hm = [hm tf];
            end
        end
        save(['DataForPlot/blocekdtril_subj' num2str(s) '.mat'],'hm');
            
        humanstore = [humanstore; nanmean(scoremat,1)];
        humanstorerepeat(s,1:length(avgr)) = avgr;
        humanstorenonrepeat(s,1:length(avgnr)) = avgnr;
    end
    
    err_human = nanstd(humanstorerepeat,0,1)/sqrt(size(humanstorerepeat,1));
    errorbar(1:length(err_human), cumsum(nanmean(humanstorerepeat,1)), err_human,'k', 'linewidth', 1.5);
    
    
    
    err_human = nanstd(humanstorenonrepeat,0,1)/sqrt(size(humanstorenonrepeat,1));
    errorbar(1:length(err_human), cumsum(nanmean(humanstorenonrepeat,1)), err_human,'color',  'k', 'linewidth', 3);
    %counter = counter + 1;
    
       
    %random after 100 times
    load(['DataForPlot/random_cropped' type '.mat']);
    scoremat = scoremat(:,1:HumanNumFix);
    randstore = scoremat;
    err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
    errorbar(1:length(err_random), cumsum(mean(scoremat,1)), err_random,'k--', 'linewidth', 2);

    
    legend({'Human-Identical (Mixed)','Human-Different (Mixed)','Human-Identical (Blocked)','Human-Different (Blocked)','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
    set(gca,'xtick',[1:HumanNumFix]);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    legend('boxoff');    
    xlabel('Fixation number','FontSize', 12);
    ylabel('Cummulative performance','FontSize', 12);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

    %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
    %print(hb,['../Figures/fig_S10D_' type '_blockedtrials' printpostfix],printmode,printoption);

end
% while 1
% end

%% Success Image Consistency
if strcmp(type, 'array')
    HumanNumFix = 6;    
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 10; %65 for waldo/wizzard/naturaldesign; 6 for array    
else
    HumanNumFix = 30;    
end
cumCModelHuman = zeros(length(subjlist),HumanNumFix, HumanNumFix);
cumCHumanItself = zeros(length(subjlist),HumanNumFix, HumanNumFix);
cumCHumanHuman = zeros(length(subjlist)*(length(subjlist)-1)/2, HumanNumFix, HumanNumFix);
cumRModelHuman = [];
cumRHumanItself = [];
cumRHumanHuman = [];
cumDiagModelHuman = [];
cumDiagHumanHuman = [];

hb = figure;
%get(hb,'Position')
%set(hb,'Position',[833     1   989   973]);
hold on;
counter = 1;

%machine %topdown30_31_croppedwaldo
%load(['DataForPlot/machine_cropped' type '.mat']);
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
%scoremat = scoremat(1:NumStimuli/2,1:HumanNumFix);
hm = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        hm = [hm nan];
    else
        hm = [hm tf];
    end
end
display(['============= model found target at fixation numbers']);
display(['model mean: ' num2str(nanmean(hm)) ]);
display(['model std: ' num2str(nanstd(hm)) ]);
display(['model mse: ' num2str(nanstd(hm)/sqrt(length(hm)))]);
display(['model n: ' num2str(length(hm))]);

cumhf = [];
%model-human
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    if ~strcmp( 'array', type)
        TargetFound = FixData.TargetFound(:,:);
        TargetFound = TargetFound(seqInd,:);
    else
        TargetFound = scoremat;
    end
    
    hf = [];
    for j = 1: NumStimuli/2
        tf = find(TargetFound(j,:)==1);
        if isempty(tf) %consider those within HumanNumFix
            hf = [hf nan];
        else
            hf = [hf tf];
        end
    end
    cumhf = [cumhf nanmean(hf)];
    hmcopy = hm;
    hf(find(isnan(hmcopy))) = [];
    hmcopy(find(isnan(hmcopy))) = [];
    hmcopy(find(isnan(hf))) = [];
    hf(find(isnan(hf))) = [];
    
    subplot(length(subjlist)+1,length(subjlist)+1,1+i);    
    hold on;
    R = corr2(hmcopy',hf');
    R = round(R*100)/100;
    cumRModelHuman= [cumRModelHuman R];
    title(['r= ' num2str( R    ) ]);
    
    [C,order] = confusionmat(hmcopy,hf,'order',[1:1:max(nanmax(hmcopy),nanmax(hf))]);
    C = C';
    cumCModelHuman(i,1:HumanNumFix,1:HumanNumFix) = C(1:HumanNumFix,1:HumanNumFix);
    C = squeeze(cumCModelHuman(i,:,:));
    diagval = diag(C);
    cumDiagModelHuman = [cumDiagModelHuman; diagval'];
    idx = eye(size(C));
    nondiagval = C(~idx);
    pvalue = ranksum(diagval, nondiagval);
    %title(['pval= ' num2str( pvalue    ) ]);
    
    if strcmp( 'waldo', type) || strcmp( 'wizzard', type)
                
        plot(hmcopy, hf, 'ko');    
        plot([0:HumanNumFix],[0:HumanNumFix],'k--');
        xlim([0 HumanNumFix]);
        ylim([0 HumanNumFix]);
        set(gca,'xtick',10:20:HumanNumFix);
        set(gca,'ytick',10:20:HumanNumFix);
        %xlabel('Model (IVSN)');
        %ylabel(['Subj' num2str(i) '']);
        axis square;
    else
        
        if strcmp('array',type)
            C = mat2gray(C);
            imagesc(C);cmapgreen=colormap(gray); %colorbar;        
            xlim([0.5 6]);
            ylim([0.5 6]);
            %xlabel('Model (IVSN)');
            %ylabel(['Subj' num2str(i)]);
            set(gca,'ytick',1:HumanNumFix);
            set(gca,'xtick',1:HumanNumFix);
            axis square;
        else
            C = mat2gray(C);
            imagesc(C);cmapgreen=colormap(gray);%colorbar;         
            xlim([0.5 HumanNumFix+0.5]);
            ylim([0.5 HumanNumFix+0.5]);
            %xlabel('Model (IVSN)');
            %ylabel(['Subj' num2str(i)]);
            %set(gca,'ytick',1:HumanNumFix);
            %set(gca,'xtick',1:HumanNumFix);
            axis square;
        end
        
    end
    
    %title(['IVSN vs subj' num2str(i) ]);
    hold off;
    counter = counter+1;    
end

display(['============= human target found fixation numbers']);
display(['human mean: ' num2str(nanmean(cumhf)) ]);
display(['human std: ' num2str(nanstd(cumhf))]);
display(['human mse: ' num2str(nanstd(cumhf)/sqrt(length(cumhf)))]);
display(['human n: ' num2str(length(cumhf))]);

%%human-human itself
temp = [];
for i = 1:length(subjlist)
    
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    if ~strcmp( 'array', type)
        TargetFound = FixData.TargetFound(:,:);
        TargetFound = TargetFound(seqInd,:);
    else
        TargetFound = scoremat;
    end
    
    hf = [];
    for j = 1: NumStimuli/2
        tf = find(TargetFound(j,:)==1);
        if isempty(tf)   %consider those within HumanNumFix
            hf = [hf nan];
        else
            hf = [hf tf];
        end
    end

    hfsecond = [];
    for j = 1+NumStimuli/2: NumStimuli
        tf = find(TargetFound(j,:)==1);
        if isempty(tf)  %consider those within HumanNumFix
            hfsecond = [hfsecond nan];
        else
            hfsecond = [hfsecond tf];
        end
    end
    
    hfsecond(find(isnan(hf))) = [];
    hf(find(isnan(hf))) = [];
    hf(find(isnan(hfsecond))) = [];
    hfsecond(find(isnan(hfsecond))) = [];

    subplot(length(subjlist)+1,length(subjlist)+1,(i)*(length(subjlist)+1)+i+1);
    hold on;
    temp = [temp nanmean(hf - hfsecond)];
    R = corr2(hf',hfsecond');
    R = round(R*100)/100;
    cumRHumanItself = [cumRHumanItself R];
    title(['r= ' num2str( R ) ]);

    [C,order] = confusionmat(hf,hfsecond,'order',[1:1:max(nanmax(hf),nanmax(hfsecond))]);  
    C = C';
    cumCHumanItself(i,:,:) = C(1:HumanNumFix,1:HumanNumFix);
    
    if  strcmp( 'waldo', type) || strcmp( 'wizzard', type)

        plot(hf, hfsecond, 'ko');
        plot([0:HumanNumFix],[0:HumanNumFix],'k--');
        xlim([0 HumanNumFix]);
        ylim([0 HumanNumFix]);
        xlabel(['Subj' num2str(i) ', first']);
        ylabel(['Subj' num2str(i) ', repeated']);
        set(gca,'xtick',10:20:HumanNumFix);
        set(gca,'ytick',10:20:HumanNumFix);
        axis square;
    else

        if strcmp('naturaldesign',type)
            C = mat2gray(C);
            %ranksum(diagval, nondiagval)
            imagesc(C);cmapgreen=colormap(gray); %colorbar;
            xlim([0.5 HumanNumFix+0.5]);
            ylim([0.5 HumanNumFix+0.5]);
            xlabel(['Subj' num2str(i) ', first']);
            ylabel(['Subj' num2str(i) ', repeated']);
            set(gca,'ytick',2:2:HumanNumFix);
            set(gca,'xtick',2:2:HumanNumFix);
            axis square;
        else
            C = mat2gray(C);
            %[C,order] = confusionmat(hf2,hmcopy);
            imagesc(C);cmapgreen=colormap(gray); %colorbar;
            xlim([0.5 6]);
            ylim([0.5 6]);
            xlabel(['Subj' num2str(i) ', first']);
            ylabel(['Subj' num2str(i) ', repeated']);
            set(gca,'ytick',1:HumanNumFix);
            set(gca,'xtick',1:HumanNumFix);
            axis square;
        end

    end
end
% mean(temp);
% std(temp)/length(temp);
% ranksum(temp, zeros(1,length(temp)));

%human-other-human plot
CountConfusion = 1;
for i = 1: length(subjlist)-1
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    if ~strcmp( 'array', type)
        TargetFound = FixData.TargetFound(:,:);
        TargetFound = TargetFound(seqInd,:);
    else
        TargetFound = scoremat;
    end
        
    %human-other-human     
    hf = [];
    for j = 1: NumStimuli/2
        tf = find(TargetFound(j,:)==1);
        if isempty(tf)   %consider those within HumanNumFix
            hf = [hf nan];
        else
            hf = [hf tf];
        end
    end
    for k = (i+1) : length(subjlist)
        load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{k} '_oracle.mat']);
        if ~strcmp( 'array', type)
            TargetFound = FixData.TargetFound(:,2:HumanNumFix);
            TargetFound = TargetFound(seqInd,:);
        else
            TargetFound = scoremat;
        end
        hf2 = [];
        for j = 1: NumStimuli/2
            tf = find(TargetFound(j,:)==1);
            if isempty(tf)   %consider those within HumanNumFix
                hf2 = [hf2 nan];
            else
                hf2 = [hf2 tf];
            end
        end
        
        hmcopy = hf;
        hf2(find(isnan(hmcopy))) = [];
        hmcopy(find(isnan(hmcopy))) = [];
        hmcopy(find(isnan(hf2))) = [];
        hf2(find(isnan(hf2))) = [];
        
        subplot(length(subjlist)+1,length(subjlist)+1, (i)*(length(subjlist)+1)+k+1);
        hold on;
        R = corr2(hmcopy',hf2');
        R = round(R*100)/100;
        cumRHumanHuman= [cumRHumanHuman R];
        title(['r= ' num2str( R ) ]);
        
        [C,order] = confusionmat(hf2,hmcopy,'order',[1:1:max(nanmax(hf2),nanmax(hmcopy))]);
        C = C';
        cumCHumanHuman(CountConfusion,1:HumanNumFix,1:HumanNumFix) = C(1:HumanNumFix,1:HumanNumFix);
        C = squeeze(cumCHumanHuman(CountConfusion,:,:));
        CountConfusion = CountConfusion+1;
        diagval = diag(C);
        cumDiagHumanHuman = [cumDiagHumanHuman; diagval'];
        idx = eye(size(C));
        nondiagval = C(~idx);
        pvalue = ranksum(diagval, nondiagval);
        %title(['pval= ' num2str( pvalue ) ]);
        
        if  strcmp( 'waldo', type) || strcmp( 'wizzard', type)
            
            plot(hf2, hmcopy, 'ko');
            plot([0:HumanNumFix],[0:HumanNumFix],'k--');
            %xlabel(['Subj' num2str(i) '']);
            %ylabel(['Subj' num2str(k) '']);
            set(gca,'xtick',10:20:HumanNumFix);
            set(gca,'ytick',10:20:HumanNumFix);
            xlim([0 HumanNumFix]);
            ylim([0 HumanNumFix]);
            axis square;
        else
            
            if strcmp('naturaldesign',type)
                C = mat2gray(C);
                %ranksum(diagval, nondiagval);
                imagesc(C);cmapgreen=colormap(gray); %colorbar;
                xlim([0.5 HumanNumFix+0.5]);
                ylim([0.5 HumanNumFix+0.5]);
                %xlabel(['Subj' num2str(i)]);
                %ylabel(['Subj' num2str(k)]);
                set(gca,'ytick',2:2:HumanNumFix);
                set(gca,'xtick',2:2:HumanNumFix);
                axis square;
            else
                C = mat2gray(C);
                %[C,order] = confusionmat(hf2,hmcopy);
                imagesc(C);cmapgreen=colormap(gray); %colorbar;
                xlim([0.5 6]);
                ylim([0.5 6]);
                %xlabel(['Subj' num2str(i)]);
                %ylabel(['Subj' num2str(k)]);
                set(gca,'ytick',1:HumanNumFix);
                set(gca,'xtick',1:HumanNumFix);
                axis square;
            end
           
        end
        
        %title(['subj' num2str(i) ' vs ' num2str(k) ]);
        hold off;
        counter = counter+1;
    end    
end

%% time to draw their distribution since subject num =  15
% cumRModelHuman = [];
% cumRHumanItself = [];
% cumRHumanHuman = [];
linewidth = 3;
hb = figure;
hold on;
left = min([cumRHumanItself cumRHumanHuman cumRModelHuman]);
right = max([cumRHumanItself cumRHumanHuman cumRModelHuman]);

if strcmp(type,'array')
    binranges = [-0.2:0.8/20:0.6];%[left: (right-left)/50: right ];
elseif strcmp(type,'naturaldesign')
    binranges = [-0.3:0.9/20:0.6];%[left: (right-left)/50: right ];
else
    binranges = [-0.3:1/20:0.7];%[left: (right-left)/50: right ];
end
bincounts = histc(cumRHumanItself,binranges);
plot(binranges, bincounts/sum(bincounts),'k-','LineWidth',linewidth);

bincounts = histc(cumRHumanHuman,binranges);
plot(binranges, bincounts/sum(bincounts),'color',[0.5020    0.5020    0.5020],'LineWidth',linewidth);

bincounts = histc(cumRModelHuman,binranges);
plot(binranges, bincounts/sum(bincounts),'color',[0.8314    0.8157    0.7843],'LineWidth',linewidth);

plot(ones(1,length(binranges))*nanmean(cumRHumanItself), binranges,'k--','LineWidth',linewidth);
plot(ones(1,length(binranges))*nanmean(cumRHumanHuman), binranges,'--','color',[0.5020    0.5020    0.5020],'LineWidth',linewidth);
plot(ones(1,length(binranges))*nanmean(cumRModelHuman), binranges,'--','color',[0.8314    0.8157    0.7843],'LineWidth',linewidth);

xlabel('Correlation','FontSize', 12);
ylabel('Proportion','FontSize', 12);
set(gca,'TickDir','out');
set(gca,'Box','Off');
if strcmp(type,'array')
    legend({'Within-subject','Between-subject','IVSN-subjects'},'Location','northeast');
    legend('boxoff');
    xlim([-0.2 0.6]);
    ylim([0 0.4]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S08D_' type '_FixatioNumberConsistency' printpostfix],printmode,printoption);
elseif strcmp(type,'naturaldesign')
    xlim([-0.3 0.6]);
    ylim([0 0.4]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S08E_' type '_FixatioNumberConsistency' printpostfix],printmode,printoption);    
else
    xlim([-0.3 0.7]);
    ylim([0 0.35]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S08F_' type '_FixatioNumberConsistency' printpostfix],printmode,printoption);
end

%while 1 end

%% plot overall Success Fixation Numbers in Confusion 
hb = figure;
set(hb,'Position',[680   265   295   628]);
hold on;

subplot(3,1,1);
hold on;
set(gca,'TickDir','out');
set(gca,'Box','Off');
imagesc(mat2gray(squeeze(mean(cumCHumanItself,1))));cmapgreen=colormap(gray); %colorbar;
if strcmp(type,'waldo') || strcmp(type,'wizzard')
    xlim([0.5 30.5]);
    ylim([0.5 30.5]);
    set(gca,'ytick',1:4:HumanNumFix);
    set(gca,'xtick',1:4:HumanNumFix);
    axis square;
else
    
    if strcmp(type, 'naturaldesign')
        xlim([0.5 HumanNumFix+0.5]);
        ylim([0.5 HumanNumFix+0.5]);
        set(gca,'ytick',2:2:HumanNumFix);
        set(gca,'xtick',2:2:HumanNumFix);
        axis square;
    else
    
        xlim([0.5 HumanNumFix+0.5]);
        ylim([0.5 HumanNumFix+0.5]);
        set(gca,'xtick',1:HumanNumFix);
        set(gca,'ytick',1:HumanNumFix);
        axis square;
    end
end
xlabel('Subject, first instance');
ylabel(['Subject, repeated']);
%plot([0:HumanNumFix],[0:HumanNumFix],'b-','linewidth',3);
cr = mean(cumRHumanItself); %corr2(squeeze(mean(cumCHumanHuman,1)), squeeze(mean(cumCModelHuman,1)));
%save(['DataForPlot/corrscore_HumanItself_' type '.mat'],'cumRHumanItself');
display('========correlation Human Itself');
display(['mse: ' num2str(std(cumRHumanItself)/sqrt(length(cumRHumanItself)))]);
display(['n=: ' num2str(length(cumRHumanItself)) ]);
display(['mean= ' num2str(cr)]);
display(['std= ' num2str(std(cumRHumanItself))]);
display(['max= ' num2str(max(cumRHumanItself))]);
display(['min= ' num2str(min(cumRHumanItself))]);

cr = round(cr*100)/100;
title(['r= ' num2str(cr)]);
% for i = 1:HumanNumFix
%     pval = ranksum( cumDiagHumanHuman(:,i), cumDiagModelHuman(:,i) );
%     
%     if pval > 0.05
%         plot(i,i,'r+');
%     end
%     
% end
hold off;

subplot(3,1,3);
set(gca,'TickDir','out');
set(gca,'Box','Off');
hold on;
imagesc(mat2gray(squeeze(mean(cumCModelHuman,1))));cmapgreen=colormap(gray); %colorbar;
if strcmp(type,'waldo') || strcmp(type,'wizzard')
    xlim([0.5 30.5]);
    ylim([0.5 30.5]);
    set(gca,'ytick',1:4:HumanNumFix);
    set(gca,'xtick',1:4:HumanNumFix);
    axis square;
else
    
    if strcmp(type, 'naturaldesign')
        xlim([0.5 HumanNumFix+0.5]);
        ylim([0.5 HumanNumFix+0.5]);
        set(gca,'ytick',2:2:HumanNumFix);
        set(gca,'xtick',2:2:HumanNumFix);
        axis square;
    else
    
        xlim([0.5 HumanNumFix+0.5]);
        ylim([0.5 HumanNumFix+0.5]);
        set(gca,'xtick',1:HumanNumFix);
        set(gca,'ytick',1:HumanNumFix);
        axis square;
    end
end
xlabel('IVSN');
ylabel(['Subjects']);
%plot([0:HumanNumFix],[0:HumanNumFix],'b-','linewidth',3);
cr = mean(cumRModelHuman); %corr2(squeeze(mean(cumCHumanHuman,1)), squeeze(mean(cumCModelHuman,1)));
%save(['DataForPlot/corrscore_ModelHuman_' type '.mat'],'cumRModelHuman');

display('========correlation Model Human');
display(['mse: ' num2str(std(cumRModelHuman)/sqrt(length(cumRModelHuman)))]);
display(['n=: ' num2str(length(cumRModelHuman)) ]);
display(['mean= ' num2str(cr)]);
display(['std= ' num2str(std(cumRModelHuman))]);
display(['max= ' num2str(max(cumRModelHuman))]);
display(['min= ' num2str(min(cumRModelHuman))]);

cr = round(cr*100)/100;
title(['r= ' num2str(cr)]);
% for i = 1:HumanNumFix
%     pval = ranksum( cumDiagHumanHuman(:,i), cumDiagModelHuman(:,i) );
%     
%     if pval > 0.05
%         plot(i,i,'r+');
%     end
%     
% end
hold off;

Q = squeeze(mean(cumCHumanHuman,1));
if strcmp(type, 'array')
    NumFixDiag = 3;
elseif strcmp(type, 'naturaldesign')
    NumFixDiag = 10;
else
    NumFixDiag = 30;
end
diagval = diag(Q);
diagval = diagval(1:NumFixDiag);
idx = eye(size(Q));
nondiagval = Q(~idx);
ranksum(diagval, nondiagval);

subplot(3,1,2);
hold on;
set(gca,'TickDir','out');
set(gca,'Box','Off');
imagesc(mat2gray(squeeze(mean(cumCHumanHuman,1))));cmapgreen=colormap(gray);%colorbar; 
if strcmp(type,'waldo') || strcmp(type,'wizzard')
    xlim([0.5 30.5]);
    ylim([0.5 30.5]);   
    set(gca,'ytick',1:4:HumanNumFix);
    set(gca,'xtick',1:4:HumanNumFix);
    axis square;
else
    
    if strcmp(type, 'naturaldesign')
        xlim([0.5 HumanNumFix+0.5]);
        ylim([0.5 HumanNumFix+0.5]);
        set(gca,'ytick',2:2:HumanNumFix);
        set(gca,'xtick',2:2:HumanNumFix);
        axis square;
    else
        
        xlim([0.5 HumanNumFix+0.5]);
        ylim([0.5 HumanNumFix+0.5]);
        set(gca,'ytick',1:HumanNumFix);
        set(gca,'xtick',1:HumanNumFix);
        axis square;
    end
end
%plot([0:HumanNumFix],[0:HumanNumFix],'b-','linewidth',3);
xlabel('Subject i');
ylabel(['Subject j']);
cr = mean(cumRHumanHuman); %corr2(squeeze(mean(cumCHumanHuman,1)), squeeze(mean(cumCModelHuman,1)));
cr = round(cr*100)/100;
%save(['DataForPlot/corrscore_HumanHuman_' type '.mat'],'cumRHumanHuman');

title(['r= ' num2str(cr)]);

display('========correlation Human Human');
display(['mse: ' num2str(std(cumRHumanHuman)/sqrt(length(cumRHumanHuman)))]);
display(['n=: ' num2str(length(cumRHumanHuman)) ]);
display(['mean= ' num2str(cr)]);
display(['std= ' num2str(std(cumRHumanHuman))]);
display(['max= ' num2str(max(cumRHumanHuman))]);
display(['min= ' num2str(min(cumRHumanHuman))]);

% if strcmp(type,'waldo')
%     CB=colorbar;
%     set(CB,'Position',[0.92 0.2 0.012 0.67]);
% end

set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_' type '_AverageFixatioNumberConsistency.pdf'],'-dpdf','-r0');
% if strcmp(type,'array')
%     print(hb,['../Figures/fig_S08A_' type '_AverageFixatioNumberConsistency' printpostfix],printmode,printoption);
% elseif strcmp(type,'naturaldesign')
%     print(hb,['../Figures/fig_S08B_' type '_AverageFixatioNumberConsistency' printpostfix],printmode,printoption);
% else
%     print(hb,['../Figures/fig_S08C_' type '_AverageFixatioNumberConsistency' printpostfix],printmode,printoption);
% end
        


if strcmp(type, 'array')
    HumanNumFix = 6;    
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array    
else
    HumanNumFix = 80;    
end





