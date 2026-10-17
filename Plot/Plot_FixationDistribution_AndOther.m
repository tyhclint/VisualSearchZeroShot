clear all; close all; clc;
addpath('ScanMatch');

type = 'naturaldesign'; %waldo, wizzard, naturaldesign, array
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
elseif strcmp(type, 'novelobj')
    HumanNumFix = 6;
    NumStimuli = 525;
    subjlist = {'subj02-az','subj03-pl'}; %natural design;
else
    HumanNumFix = 60;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
end

RandomTimes = 10; %number of randomize times
% HumanNumFix = 6; %naturaldesign: 30; waldo/wizzard:60; array: 6
% NumStimuli = 600; %134 for waldo/wizzard; 480 for antural design; 600 for array

%subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az'}; %waldo/wizzard
%subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design
%subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo'}; %array
markerlist = {'r','g','b','c','k','m', 'r*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
FcTHRESHOLD = 0.9; %assume 90% recognition rate
UpToNum = 6; %waldo/wizzard/naturaldesign: 8; array: 6
MaxDist = sqrt(Imgw*Imgw + Imgh*Imgh); %the maximum eucli dist on stimuli of size [1024 1280]

%% For array sanity check only
if strcmp(type, 'array')
    
    %% six fixation distributions in histogram
    hb = figure;
    set(hb, 'Position', [803   740   765   234]);
    subplot(1,3,1);
    linewidth = 3;
    gt = [];
    for i = 1: NumStimuli
        gt = [gt; find(MyData(i).targetcate ==  MyData(i).arraycate)];
    end
    binranges = [1:HumanNumFix];
    bincounts = histc(gt,binranges);
    bar(binranges,bincounts/sum(bincounts),'FaceColor',[0.5 0.5 0.5], 'EdgeColor','black');
    hold on;
    plot([0:7],1/6*ones(1,8),'k--');
    set(gca,'xtick',[1:HumanNumFix]);
    xlim([0.5 HumanNumFix+0.5]);
    ylim([0 0.25]);
    title('Target positions');
    ylabel({'Experiment 1 (Object arrays)', 'Proportion'});
    xlabel(['Position in object array']);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    
    counterfix = 0;
    subplot(1,3,2);
    for s = 1: length(subjlist)
        comp2 = load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/subjects_array/' subjlist{s} '/subjperform.mat']);
        compfixmat2 = comp2.fixmat;
        temp = compfixmat2(:);
        temp(isnan(temp)) = [];        
        gt = [gt; temp];
    end
    counterfix = length(gt);
    binranges = [1:HumanNumFix];
    bincounts = histc(gt,binranges);
    bar(binranges,bincounts/sum(bincounts),'FaceColor',[0.5 0.5 0.5], 'EdgeColor','black');
    hold on;
    plot([0:7],1/6*ones(1,8),'k--');
    set(gca,'xtick',[1:HumanNumFix]);
    xlim([0.5 HumanNumFix+0.5]);
    ylim([0 0.25]);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    title('Human');
    %ylabel('Proportion');
    xlabel(['Position in object array']);
    
    subplot(1,3,3);
    comp1 = load('DataForPlot/machine_layer30_31_croppedarray.mat');
    compfixmat1 = comp1.fixmat;
    gt = compfixmat1(:);
    gt(isnan(gt)) = [];
    binranges = [1:HumanNumFix];
    bincounts = histc(gt,binranges);
    bar(binranges,bincounts/sum(bincounts),'FaceColor',[0.5 0.5 0.5], 'EdgeColor','black');
    hold on;
    plot([0:7],1/6*ones(1,8),'k--');
    set(gca,'xtick',[1:HumanNumFix]);
    xlim([0.5 HumanNumFix+0.5]);
    ylim([0 0.25]);
    title('IVSN');
    %ylabel('Proportion');
    xlabel(['Position in object array']);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    %print(hb,['../Figures/fig_S01A-C_' type '_FixationDistribution' printpostfix],printmode,printoption);
    
end

%% For fixation distribution plot
%% For non-array datasets only
if strcmp(type, 'naturaldesign') || strcmp(type,'waldo')
    hb = figure;
    hold on;
    counterfix = 0;
    fixdistri = zeros(Imgw, Imgh);
    fixdistricum = zeros(Imgw, Imgh);
    for s = 1: length(subjlist)
        load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{s} '.mat']);
        PosX = FixData.Fix_posx;
        PosY = FixData.Fix_posy;
        for i = 1: NumStimuli
            posx = PosX{i};
            posy = PosY{i};
            posy(find(posx<1)) = [];
            posx(find(posx<1)) = [];
            posx(find(posy<1)) = [];
            posy(find(posy<1)) = [];
            posy(find(posx>Imgh)) = [];
            posx(find(posx>Imgh)) = [];
            posx(find(posy>Imgw)) = [];
            posy(find(posy>Imgw)) = [];
            
            if length(posx) > 1
                posx = posx(2:end);
                posy = posy(2:end);
            end
            counterfix = length(posx) + counterfix;
            fixdistri( Imgw*(posx-1)+posy) = 1;
            fixdistricum( Imgw*(posx-1)+posy) = fixdistricum(Imgw*(posx-1)+posy) + 1;
            plot(posx, posy, 'ko','markersize',1);
        end
    end
    plot([0:Imgh],Imgw,'k-');
    plot(Imgh,[0:Imgw],'k-');
    %axis([0 Imgh 0 Imgw])
    xlim([0 Imgh]);
    ylim([0 Imgw]);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'TickDir','out');
    set(gca,'Box','Off');
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    
%     if strcmp(type,'naturaldesign')
%         print(hb,['../Figures/fig_S01E_' type '_HumanFixationDistribution' printpostfix],printmode,printoption);
%     elseif strcmp(type,'waldo')
%         print(hb,['../Figures/fig_S01H_' type '_HumanFixationDistribution' printpostfix],printmode,printoption);
%     end
    
    %fixdistri = imresize(fixdistri,[50 50]);
    %fixdistricum = imresize(fixdistricum,[50 50]);
    fixdistri = mat2gray(fixdistri);
    fixdistricum = mat2gray(fixdistricum);
    humanfixdistri = fixdistri;
    
    subplot(2,2,1);
    imshow(fixdistri);
    title('human fixation distribution');
    %imwrite(fixdistri, ['/media/mengmi/MimiDrive/Publications/NHB_CVS2018/nfigure/fig_' type '_HumanFixationDist.jpg']);
    
    subplot(2,2,2);
    imshow(fixdistricum);
    title('human cummulative distribution');
    
    hb = figure;
    hold on;
    
    fixdistri = zeros(Imgw, Imgh);
    fixdistricum = zeros(Imgw, Imgh);
    load(['DataForPlot/topdown30_31_cropped' type '.mat']);
    PosX = FixData.Fix_posx;
    PosY = FixData.Fix_posy;
    for i = 1: NumStimuli/2
        posx = PosX{i};
        posy = PosY{i};
        posy(find(posx<1)) = [];
        posx(find(posx<1)) = [];
        posx(find(posy<1)) = [];
        posy(find(posy<1)) = [];
        posy(find(posx>Imgh)) = [];
        posx(find(posx>Imgh)) = [];
        posx(find(posy>Imgw)) = [];
        posy(find(posy>Imgw)) = [];

        fixdistri( Imgw*(posx-1)+posy) = 1;
        fixdistricum( Imgw*(posx-1)+posy) = fixdistricum(Imgw*(posx-1)+posy) + 1;
        plot(posx, posy, 'ko','markersize',1);
    end
    plot([0:Imgh],Imgw,'k-');
    plot(Imgh,[0:Imgw],'k-');
    xlim([0 Imgh]);
    ylim([0 Imgw]);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(hb,'Units','Inches');
    pos = get(hb,'Position');
    set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    
%     if strcmp(type,'naturaldesign')
%         print(hb,['../Figures/fig_S01F_' type '_ModelFixationDistribution' printpostfix],printmode,printoption);
%     elseif strcmp(type,'waldo')
%         print(hb,['../Figures/fig_S01I_' type '_ModelFixationDistribution' printpostfix],printmode,printoption);
%     end
    
    fixdistri = mat2gray(fixdistri);
    fixdistricum = mat2gray(fixdistricum);
    modelfixdistri = fixdistri;
    
    corr2(modelfixdistri, humanfixdistri)
%     fixdistri = imresize(fixdistri,[50 50]);
%     fixdistricum = imresize(fixdistricum,[50 50]);
    
    subplot(2,2,3);
    imshow(fixdistri);
    %imwrite(fixdistri, ['/media/mengmi/MimiDrive/Publications/NHB_CVS2018/nfigure/fig_' type '_MachineFixationDist.jpg']);
    title('machine fixation distribution');
    
    subplot(2,2,4);
    imshow(fixdistricum);
    title('machine cummulative distribution');
    
end

display(['Dataset: ' type]);
display(['TotalNumberFixations: ' num2str(counterfix) ]);
display(['========================']);

%while 1 end

% %% Comparing memory effect in natural design
% type = 'array';
% 
% HumanNumFix = 6; %65 for waldo/wizzard/naturaldesign; 6 for array
% NumStimuli = 600;
% subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
%        'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
%        'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
% load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
% load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
% [B,seqInd] = sort(seq);
% Imgw = 1024;
% Imgh = 1280;
% 
% %human (all+target-non-identical+target-identical)
% humanstore = nan(length(subjlist), HumanNumFix);
% humanstorefirst = nan(length(subjlist), HumanNumFix);
% humanstoresecond = nan(length(subjlist), HumanNumFix);
% 
% for i = 1: length(subjlist)
%     load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);    
%     TargetFound = scoremat;
%     TargetFound1 = TargetFound(1: length(seqInd)/2,:);
%     hm = [];
%     for j = 1: NumStimuli/2
%         tf = find(TargetFound1(j,:)==1);
%         if isempty(tf) %consider those within HumanNumFix 
%             hm = [hm nan];
%         else
%             hm = [hm tf];
%         end
%     end
%     save(['DataForPlot/memoryFirst_subj_' num2str(i) '_' type '.mat'],'hm');
%     
%     TargetFound2 = TargetFound(length(seqInd)/2+1:end,:);
%     hm = [];
%     for j = 1: NumStimuli/2
%         tf = find(TargetFound2(j,:)==1);
%         if isempty(tf) %consider those within HumanNumFix 
%             hm = [hm nan];
%         else
%             hm = [hm tf];
%         end
%     end
%     save(['DataForPlot/memorySecond_subj_' num2str(i) '_' type '.mat'],'hm');
%     
%     humanfirst = nanmean(TargetFound1,1);        
%     humansecond = nanmean(TargetFound2,1);
%     
%     humanfirst = humanfirst(1:HumanNumFix);
%     humansecond = humansecond(1:HumanNumFix);
%     
%     
%     humanstorefirst(i,1:length(humanfirst)) = humanfirst;
%     humanstoresecond(i,1:length(humansecond)) = humansecond;
%     
%     
% end
% hb = figure;
% hold on;
% linewidth = 3;
% err_human = nanstd(humanstorefirst,0,1)/sqrt(size(humanstorefirst,1));
% errorbar(1:length(err_human), cumsum(nanmean(humanstorefirst,1)), err_human,'color',  'k', 'linewidth', 3);
% 
% err_human = nanstd(humanstoresecond,0,1)/sqrt(size(humanstoresecond,1));
% errorbar(1:length(err_human), cumsum(nanmean(humanstoresecond,1)), err_human,'color',  'k', 'linewidth', 1.5);
% 
% % mask = meshgrid([1:size(humanstorefirst,2)],[1:size(humanstorefirst,1)]);
% % avgx = nanmean((humanstorefirst.*mask),2);
% % 
% % mask = meshgrid([1:size(humanstoresecond,2)],[1:size(humanstoresecond,1)]);
% % avgy = nanmean((humanstoresecond.*mask),2);
% % 
% % [h,p] = ttest2(avgx, avgy);
% % p
% 
% 
% type = 'naturaldesign';
% 
% HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
% NumStimuli = 480;
% subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
%         'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
%         'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
% load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
% load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
% [B,seqInd] = sort(seq);
% Imgw = 1024;
% Imgh = 1280;
% 
% %human (all+target-non-identical+target-identical)
% humanstore = nan(length(subjlist), HumanNumFix);
% humanstorefirst = nan(length(subjlist), HumanNumFix);
% humanstoresecond = nan(length(subjlist), HumanNumFix);
% 
% for i = 1: length(subjlist)
%     load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
%     
%     
%     TargetFound = FixData.TargetFound(:,2:end);
%     TargetFound = TargetFound(seqInd,:);
%     TargetFound1 = TargetFound(1: length(seqInd)/2,:);
%     TargetFound2 = TargetFound(length(seqInd)/2+1:end,:);
%     
%     
%     hm = [];
%     for j = 1: NumStimuli/2
%         tf = find(TargetFound1(j,:)==1);
%         if isempty(tf) %consider those within HumanNumFix 
%             hm = [hm nan];
%         else
%             hm = [hm tf];
%         end
%     end
%     save(['DataForPlot/memoryFirst_subj_' num2str(i) '_' type '.mat'],'hm');
%     hm = [];
%     for j = 1: NumStimuli/2
%         tf = find(TargetFound2(j,:)==1);
%         if isempty(tf) %consider those within HumanNumFix 
%             hm = [hm nan];
%         else
%             hm = [hm tf];
%         end
%     end
%     save(['DataForPlot/memorySecond_subj_' num2str(i) '_' type '.mat'],'hm');
%     
%     humanfirst = nanmean(TargetFound1,1);        
%     humansecond = nanmean(TargetFound2,1);
%     
%     humanfirst = humanfirst(1:HumanNumFix);
%     humansecond = humansecond(1:HumanNumFix);
%     
%     
%     humanstorefirst(i,1:length(humanfirst)) = humanfirst;
%     humanstoresecond(i,1:length(humansecond)) = humansecond;
%     
%     
% end
% 
% err_human = nanstd(humanstorefirst,0,1)/sqrt(size(humanstorefirst,1));
% errorbar(1:length(err_human), cumsum(nanmean(humanstorefirst,1)), err_human,'color',  [0.5020    0.5020    0.5020], 'linewidth', linewidth);
% 
% err_human = nanstd(humanstoresecond,0,1)/sqrt(size(humanstoresecond,1));
% errorbar(1:length(err_human), cumsum(nanmean(humanstoresecond,1)), err_human,'color',  [0.5020    0.5020    0.5020], 'linewidth', 1.5);
% 
% % mask = meshgrid([1:size(humanstorefirst,2)],[1:size(humanstorefirst,1)]);
% % avgx = nanmean((humanstorefirst.*mask),2);
% % 
% % mask = meshgrid([1:size(humanstoresecond,2)],[1:size(humanstoresecond,1)]);
% % avgy = nanmean((humanstoresecond.*mask),2);
% % 
% % [h,p] = ttest2(avgx, avgy);
% % p
% 
% 
% type = 'waldo';
% 
% HumanNumFix = 60;
% NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
% subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
%         'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
%         'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard
% load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
% load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
% [B,seqInd] = sort(seq);
% Imgw = 1024;
% Imgh = 1280;
% 
% %human (all+target-non-identical+target-identical)
% humanstore = nan(length(subjlist), HumanNumFix);
% humanstorefirst = nan(length(subjlist), HumanNumFix);
% humanstoresecond = nan(length(subjlist), HumanNumFix);
% 
% for i = 1: length(subjlist)
%     load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
%     
%     
%     TargetFound = FixData.TargetFound(:,2:end);
%     TargetFound = TargetFound(seqInd,:);
%     TargetFound1 = TargetFound(1: length(seqInd)/2,:);
%     TargetFound2 = TargetFound(length(seqInd)/2+1:end,:);
%     
%     hm = [];
%     for j = 1: NumStimuli/2
%         tf = find(TargetFound1(j,:)==1);
%         if isempty(tf) %consider those within HumanNumFix 
%             hm = [hm nan];
%         else
%             hm = [hm tf];
%         end
%     end
%     save(['DataForPlot/memoryFirst_subj_' num2str(i) '_' type '.mat'],'hm');
%     hm = [];
%     for j = 1: NumStimuli/2
%         tf = find(TargetFound2(j,:)==1);
%         if isempty(tf) %consider those within HumanNumFix 
%             hm = [hm nan];
%         else
%             hm = [hm tf];
%         end
%     end
%     save(['DataForPlot/memorySecond_subj_' num2str(i) '_' type '.mat'],'hm');
%     
%     
%     humanfirst = nanmean(TargetFound1,1);        
%     humansecond = nanmean(TargetFound2,1);
%     
%     humanfirst = humanfirst(1:HumanNumFix);
%     humansecond = humansecond(1:HumanNumFix);
%     
%     
%     humanstorefirst(i,1:length(humanfirst)) = humanfirst;
%     humanstoresecond(i,1:length(humansecond)) = humansecond;
%     
%     
% end
% % hb = figure;
% % hold on;
% % linewidth = 3;
% err_human = nanstd(humanstorefirst,0,1)/sqrt(size(humanstorefirst,1));
% errorbar(1:length(err_human), cumsum(nanmean(humanstorefirst,1)), err_human,'color',  [0.8314    0.8157    0.7843], 'linewidth', linewidth);
% 
% err_human = nanstd(humanstoresecond,0,1)/sqrt(size(humanstoresecond,1));
% errorbar(1:length(err_human), cumsum(nanmean(humanstoresecond,1)), err_human,'color',  [0.8314    0.8157    0.7843], 'linewidth', 1.5);
% 
% % mask = meshgrid([1:size(humanstorefirst,2)],[1:size(humanstorefirst,1)]);
% % avgx = nanmean((humanstorefirst.*mask),2);
% % 
% % mask = meshgrid([1:size(humanstoresecond,2)],[1:size(humanstoresecond,1)]);
% % avgy = nanmean((humanstoresecond.*mask),2);
% % 
% % [h,p] = ttest2(avgx, avgy);
% % p
% 
% 
% 
% legend({'Experiment 1, first instance','Experiment 1, repeated instance','Experiment 2, first instance','Experiment 2, repeated instance','Experiment 3, first instance','Experiment 3, repeated instance'},'Location','southeast','FontSize',8.1); %14 for waldo; 10 for naturaldesign
% legend('boxoff');        
% xlim([0.5 30.5]);
% ylim([0 1]);
% xlabel('Fixation number','FontSize', 13);
% ylabel('Cummulative performance','FontSize', 13);
% set(gca,'TickDir','out');
% set(gca,'Box','Off');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% %print(hb,['../Figures/fig_' type '_MemoryEffect.pdf'],'-dpdf','-r0');
% %print(hb,['../Figures/fig_S07_' type '_MemoryEffect' printpostfix],printmode,printoption);
%     

%% Ground truth Plot
% hb=figure;
% type = 'waldo';
% load(['/home/mengmi/Proj/Proj_VS/HumanExp/githuman/SubjectArray/waldo.mat']);
% NumImg = length(MyData);
% w = 1024;
% h = 1280;
% gtblank = zeros(w,h);
% hb=figure;
% for i = 1: NumImg
% 
%         %display(i);
% 
%         trial = MyData(i);
%         gtimg = imread(['/home/mengmi/Proj/Proj_VS/Datasets/Waldo/WaldoBookSeries/CroppedJPEG/gt' trial.targetname(8:end)]); 
%         gtimg = imresize(gtimg, [w h]);
%         gtimg = double(gtimg)/255;
%         gtimg = im2bw(gtimg,0.1);
%         H = fspecial('prewitt');
%         H1 = -H;
%         H2 = H';
%         H3 = -H2;
%         
%         Hgtimg = imfilter(gtimg,H,'replicate');
%         H1gtimg = imfilter(gtimg,H1,'replicate');
%         H2gtimg = imfilter(gtimg,H2,'replicate');
%         H3gtimg = imfilter(gtimg,H3,'replicate');
%         
%         gtblank = gtblank | Hgtimg | H1gtimg | H2gtimg | H3gtimg;
%         imshow(gtblank);
%         %pause(0.01);
% end
% %imwrite(gtblank, ['../Figures/fig_' type '_groundtruth.jpg']);
% gtblank= bwmorph(gtblank,'thicken');
% gtblank= bwmorph(gtblank,'thicken');
% gtblank = ~gtblank;
% imshow(gtblank);
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['../Figures/fig_' type '_GroundTruth.pdf'],'-dpdf','-r0');
% print(hb,['../Figures/fig_' type '_GroundTruth' printpostfix],printmode,printoption);
%     
% 
% type = 'naturaldesign';
% NumImg = 240;
% w = 1024;
% h = 1280;
% gtblank = zeros(w,h);
% hb=figure;
% for i = 1: NumImg      
%     
%     path = ['/home/mengmi/Proj/Proj_VS/Datasets/NaturalDataset/filtered/gt' num2str(i) '.jpg' ];
%     gt = imread(path);
%     gt = imresize(gt,[w,h]);
%     gt = mat2gray(gt);
%     gtimg = im2bw(gt,0.5);
%     
%     H = fspecial('prewitt');
%     H1 = -H;
%     H2 = H';
%     H3 = -H2;
% 
%     Hgtimg = imfilter(gtimg,H,'replicate');
%     H1gtimg = imfilter(gtimg,H1,'replicate');
%     H2gtimg = imfilter(gtimg,H2,'replicate');
%     H3gtimg = imfilter(gtimg,H3,'replicate');
% 
%     gtblank = gtblank | Hgtimg | H1gtimg | H2gtimg | H3gtimg;
%     imshow(gtblank);
%     %pause(0.01);
% end
% %imwrite(gtblank, ['../Figures/fig_' type '_groundtruth.jpg']);
% gtblank= bwmorph(gtblank,'thicken');
% gtblank= bwmorph(gtblank,'thicken');
% gtblank = ~gtblank;
% imshow(gtblank);
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% print(hb,['../Figures/fig_' type '_GroundTruth.pdf'],'-dpdf','-r0');
% print(hb,['../Figures/fig_' type '_GroundTruth' printpostfix],printmode,printoption);
    
%% Performance of 140 images not within ImageNet in Natural Design
type = 'naturaldesign';
load('DataForPlot/notImageNetNaturaldesign.mat');
linewidth = 3;
HumanNumFix = 30;
%machine 
%topdown30_31_croppedwaldo
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
%load(['DataForPlot/machine_cropped' type '.mat']);
machinestore140 = [];
machinestore100 = [];
machinestoreall = [];

machinestoreall = scoremat(:,1:HumanNumFix);

machinestore140 = scoremat(notImageNetNaturaldesign,1:HumanNumFix);
%machinestore140 = nanmean(scoremat,1);
scoremat(notImageNetNaturaldesign,:) = [];
machinestore100 = scoremat(:,1:HumanNumFix);

hb = figure;
hold on;

errorbar(1:HumanNumFix,cumsum(nanmean(machinestoreall,1)),nanstd(machinestoreall,0,1)/sqrt(size(machinestoreall,1)), 'color',[0 0.45 0.74], 'linewidth', linewidth);
s100 = nanmean(machinestore100,1);
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore100,1)),nanstd(machinestore100,0,1)/sqrt(size(machinestore100,1)), 'color',[0.5020    0.5020    0.5020], 'linewidth', linewidth);
s140 = nanmean(machinestore140,1);
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore140,1)),nanstd(machinestore140,0,1)/sqrt(size(machinestore140,1)), 'color',[0.8314    0.8157    0.7843], 'linewidth', linewidth);

% mask = meshgrid([1:size(machinestore140,2)],[1:size(machinestore140,1)]);
% f = nanmean((machinestore140.*mask),2);
% avgx = [];
% for RandomTimes = 1:30
%     ind = randperm(length(f),int32(0.5*length(f)));
%     x = f(ind);
%     avgx = [avgx nanmean(x)];
% end

% mask = meshgrid([1:size(machinestore100,2)],[1:size(machinestore100,1)]);
% f = nanmean((machinestore100.*mask),2);
% avgy = [];
% for RandomTimes = 1:30
%     ind = randperm(length(f),int32(0.5*length(f)));
%     y = f(ind);
%     avgy = [avgy nanmean(y)];
% end
% [h,p] = ttest2(avgx, avgy);
% p

xlim([0.5, HumanNumFix]);
ylim([0 1]);
legend({'Overall','ImageNet categories','Not ImageNet categories'},'Location','southeast','FontSize',14); %14 for waldo; 10 for naturaldesign
legend('boxoff');        
set(gca,'TickDir','out');
set(gca,'Box','Off');    
xlabel('Fixation number','FontSize', 13);
ylabel('Cummulative performance','FontSize', 13);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S05_' type '_140_100' printpostfix],printmode,printoption);






































