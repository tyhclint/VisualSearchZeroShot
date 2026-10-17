clear all; close all; clc;

printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

type = 'naturaldesign';
display(['dataset: ' type]);
if strcmp(type, 'array')
    WEIGHT = 0.105;
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    WEIGHT = 0.0085;
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
else
    WEIGHT = 0.009;
    HumanNumFix = 80;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for naturaldesign; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end
    

RandomTimes = 30; %number of randomize times
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);

%% Overall performance curves (simplified version)
linewidth = 3;
hb = figure;
hold on;

%human_recognition
%human
humanstore = nan(length(subjlist), HumanNumFix);
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '.mat']);
    
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
err_human = nanstd(humanstore,0,1)/sqrt(size(humanstore,1));
errorbar(1:length(err_human), cumsum(nanmean(humanstore,1)), err_human,'color',  'r', 'linewidth', linewidth);


%machine 
%topdown30_31_croppedwaldo
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore = scoremat(:,1:HumanNumFix);
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', linewidth);

%machine finite IOR
%topdown30_31_croppedwaldo
randmachinestore = zeros(RandomTimes,HumanNumFix);

% for r = 1: RandomTimes
%     load(['DataForPlot/topdown30_31_cropped' type '.mat']);
%     load(['DataForPlot/distributionIOR_' type '.mat']);
%     distributionIOR = sum(distributionIOR,1);
%     distributionIOR(2) = 0;
%     distributionIOR = distributionIOR/sum(distributionIOR);
%     machinestore = scoremat(:,1:HumanNumFix);
% 
%     for i = 1: size(scoremat,1)
%         ori = machinestore(i,:);
%         [nul inde] = find(ori==1);
%         if isempty(inde)
%             continue;
%         else
%             counter = 1;
%             for j = 2:inde            
%                 failp = sum(distributionIOR([2:j]));
%                 success = binornd(1,1-failp);
%                 counter = counter + 1;
%                 while ~success                
%                     success = binornd(1,1-failp);
%                     counter = counter+1;
%                     if success == 1
%                         break;
%                     end
%                 end
%             end
%             %while 1 end
%             if counter>HumanNumFix
%                 machinestore(i,:) = 0;
%             else
%                 machinestore(i,:) = 0;
%                 machinestore(i,counter) = 1;
%             end
%         end
%         %while 1 end
%     end
%     randmachinestore(r,:) = nanmean(machinestore,1);
% end
% machinestore = randmachinestore;

load(['DataForPlot/topdown30_31_cropped' type '_fior_pdf_addition_weight_' num2str(10000*WEIGHT)  '_cross1.mat']);
machinestore = scoremat(:,1:HumanNumFix);
htotal = [];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end

load(['DataForPlot/topdown30_31_cropped' type '_fior_pdf_addition_weight_' num2str(10000*WEIGHT)  '_cross2.mat']);
machinestore =[machinestore; scoremat(:,1:HumanNumFix)];
for j = 1: NumStimuli/2
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
hIVSNfior = htotal;
hm = hIVSNfior;
save(['DataForPlot/IVSNfior_' type '.mat'],'hm','scoremat');


errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0 0.45 0.74], 'linewidth', 1.5);



%random after 100 times
load(['DataForPlot/random_cropped' type '.mat']);
scoremat = scoremat(:,1:HumanNumFix);
randstore = scoremat;
err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
errorbar(1:length(err_random), cumsum(mean(scoremat,1)), err_random,'k--' , 'linewidth', linewidth);

if strcmp(type, 'array')
    legend({'Human','IVSNoracle','IVSN-FIOR','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
    set(gca,'xtick',[1:HumanNumFix]);
elseif strcmp(type, 'naturaldesign')
    legend({'Human','IVSNoracle','IVSN-FIOR','Chance'},'Location','southeast','FontSize',13); %14 for waldo; 10 for naturaldesign

    %legend({'Human','IVSNoracle','IVSNrecog','PixMatch','RotatedPixMatch','IttiKoch','RanWeight','Chance','SlideWin'},'Location','northwest','FontSize',10); %14 for waldo; 10 for naturaldesign
    xlim([0.5, HumanNumFix]);
    ylim([0 1]);
else
    legend({'Human','IVSNoracle','IVSN-FIOR','Chance'},'Location','northwest','FontSize',13); %14 for waldo; 10 for naturaldesign

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

% if strcmp(type,'array')
%     %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
%     print(hb,['../Figures/fig_S17_' type '_ModelFiniteIOR_simplified' printpostfix],printmode,printoption);
% 
% elseif strcmp(type,'naturaldesign')
%     %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
%     print(hb,['../Figures/fig_S17_' type '_ModelFiniteIOR_simplified' printpostfix],printmode,printoption);
% 
% else
%     %print(hb,['../Figures/fig_' type '_OverallPerformance_simplified.pdf'],'-dpdf','-r0');
%     print(hb,['../Figures/fig_S17_' type '_ModelFiniteIOR_simplified' printpostfix],printmode,printoption);
% 
% end