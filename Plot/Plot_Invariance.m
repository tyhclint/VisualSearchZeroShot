clear all; close all; clc;
addpath('ScanMatch');

distsubj_screen = 50; % 21 inch = 50 cm
distscreen_height = 400; %mm
distscreen_width = 300; %mm
%156/1024 = 5/x;
%5/(156/1024) = 32 deg visual angle (height)
%32/1024*1280 = 40 deg visual angle (width)

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

%% rotation plot
type = 'array';
subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);

rotationangle = [];
ImgNum = 300;
for i = 1:ImgNum
    trial = MyData(i);
    imgid = trial.arrayimgnum(find(trial.arraycate == trial.targetcate));
    categ = trial.targetcate;
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/FinalSelected/cate' num2str(categ) '/infor' num2str(imgid) '.mat' ]);        
    sa = infor.angle;
    imgid = trial.targetnum;
    categ = trial.targetcate;
    load(['/media/mengmi/TOSHIBABlue1/Proj_VS/Datasets/Human/FinalSelected/cate' num2str(categ) '/infor' num2str(imgid) '.mat' ]);        
    ta = infor.angle;
    rotationangle = [rotationangle wrapTo180(ta -sa)];
end
binranges = [-202.5:45:202.5];
binnum = length(binranges);
[bincounts ind] = histc(rotationangle,binranges);

FixNumMatHuman = nan(length(subjlist), ImgNum);
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    for j = 1:ImgNum
        sc = scoremat(j,:);
        t = find(sc == 1);
        if ~isempty(t)
            FixNumMatHuman(i,j) = t;
        end
    end
end
FixNumMatHuman = nanmean(FixNumMatHuman,1);    

FixNumMatModel = nan(1, ImgNum);
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
for i = 1:ImgNum    
    sc = scoremat(i,:);
    t = find(sc == 1);
    if ~isempty(t)
        FixNumMatModel(1,i) = find(sc == 1);
    end
end

humanavg = [];
humanstd = [];

modelavg = [];
modelstd = [];

binvaluehuman = nan(length(binranges),300);
binvaluemodel = nan(length(binranges),300);

for g = 1:length(binranges)
    
    if bincounts(g) <= 5
        humanavg = [humanavg; -1];
        humanstd = [humanstd; -1];
        modelavg = [modelavg; -1];
        modelstd = [modelstd; -1];
        binranges(g) = -1;
    else
        binva = FixNumMatHuman(find(ind == g));
        binvaluehuman(g,1:length(binva)) = binva;
        
        ha = nanmean( FixNumMatHuman(find(ind == g)));
        hastd = nanstd(FixNumMatHuman(find(ind == g)),0,2)/sqrt(length(FixNumMatHuman(find(ind == g))));
        humanavg = [humanavg; ha];
        humanstd = [humanstd; hastd];

        binva = FixNumMatModel(find(ind == g));
        binvaluemodel(g,1:length(binva)) = binva;
        
        hm = nanmean( FixNumMatModel(find(ind==g)));
        hmstd = nanstd(FixNumMatModel(find(ind == g)),0,2)/sqrt(length(FixNumMatModel(find(ind == g))))
        modelavg = [modelavg; hm];
        modelstd = [modelstd; hmstd];
    end
end

save('DataForPlot/rotationbin.mat','binranges');
save('DataForPlot/rotation_binvaluehuman.mat','binvaluehuman');
save('DataForPlot/rotationbin_binvaluemodel.mat','binvaluemodel');

binranges(find(binranges == -1)) = [];
humanavg(find(humanavg == -1)) = [];
humanstd(find(humanstd == -1)) = [];
modelavg(find(modelavg == -1)) = [];
modelstd(find(modelstd == -1)) = [];

binranges = binranges+22.5;
hb = figure;

subplot(1,2,1);
hold on;
bar(binranges, humanavg,'FaceColor','r');
errorbar(binranges, humanavg,humanstd,'k.','Linewidth', 1);
plot([-360:1:360],3.5*ones(1,length([-360:1:360])),'k--');
plot(0*ones(1,16),[0:1:15],'k--');
xlabel('Rotation offset (degrees)','FontSize', 12);
xlim([-230 230]);
ylim([0 4.5]);
ylabel('Number of fixations','FontSize', 12);
set(gca,'ytick',[0:1:4]);
set(gca,'TickDir','out');
set(gca,'Box','Off');

subplot(1,2,2);
hold on;
bar(binranges, modelavg,'FaceColor',[0 0.45 0.74]);
errorbar(binranges, modelavg,modelstd,'k.','Linewidth', 1);
plot([-360:1:360],3.5*ones(1,length([-360:1:360])),'k--');
plot(0*ones(1,16),[0:1:15],'k--');
%xlabel('Rotation offset (degrees)','FontSize', 12);
xlim([-230 230]);
ylim([0 4.5]);
set(gca,'ytick',[0:1:4]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
%ylabel('Number of fixations','FontSize', 12);
%legend({'Human','IVSN'},'Location','northwest','FontSize',10);
%legend('boxoff');
hold off;
    
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_OVERALL_CombinedSS.pdf'],'-dpdf','-r200');
%print(hb,['../Figures/fig_S03B_' type '_rotationchange' printpostfix],printmode,printoption);



%% scale plot
type = 'naturaldesign';
subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; 
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);

ImgNum = 240;

load(['DataForPlot/GTstats_naturaldesign.mat']);
wvec = Datastats.wstats;
hvec = Datastats.hstats;
areavec = wvec.*hvec/(28.5*28.5);

%hist(areavec);
binranges = [0.5:5:60];
binnum = length(binranges);
[bincounts ind] = histc(areavec,binranges);
ind(ind>9) = 9;
binranges = binranges(1:9);
bincounts = [bincounts(1:8) sum(bincounts(9:end))];
FixNumMatHuman = nan(length(subjlist), ImgNum);

binvaluehuman = nan(length(binranges),300);
binvaluemodel = nan(length(binranges),300);

for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    TargetFound = FixData.TargetFound(:,2:end);
    TargetFound = TargetFound(seqInd,:);
    scoremat = TargetFound;
    for j = 1:ImgNum
        sc = scoremat(j,:);
        t = find(sc == 1);
        if ~isempty(t)
            FixNumMatHuman(i,j) = t;
        end
    end
end
FixNumMatHuman = nanmean(FixNumMatHuman,1);    

FixNumMatModel = nan(1, ImgNum);
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
for i = 1:ImgNum    
    sc = scoremat(i,:);
    t = find(sc == 1);
    if ~isempty(t)
        FixNumMatModel(1,i) = find(sc == 1);
    end
end

humanavg = [];
humanstd = [];

modelavg = [];
modelstd = [];

binvaluehuman = nan(length(binranges),300);
binvaluemodel = nan(length(binranges),300);

for g = 1:length(binranges)
    
    if bincounts(g) <= 5
        humanavg = [humanavg; -1];
        humanstd = [humanstd; -1];
        modelavg = [modelavg; -1];
        modelstd = [modelstd; -1];
        binranges(g) = -1;
    else
    
        binva = FixNumMatHuman(find(ind == g));
        binvaluehuman(g,1:length(binva)) = binva;
        
        ha = nanmean( FixNumMatHuman(find(ind == g)));
        hastd = nanstd(FixNumMatHuman(find(ind == g)),0,2)/sqrt(length(FixNumMatHuman(find(ind == g))));
        humanavg = [humanavg; ha];
        humanstd = [humanstd; hastd];

        binva = FixNumMatModel(find(ind == g));
        binvaluemodel(g,1:length(binva)) = binva;
        
        hm = nanmean( FixNumMatModel(find(ind==g)));
        hmstd = nanstd(FixNumMatModel(find(ind == g)),0,2)/sqrt(length(FixNumMatModel(find(ind == g))))
        modelavg = [modelavg; hm];
        modelstd = [modelstd; hmstd];
    end
end

% save('DataForPlot/scale_bin.mat','binranges');
% save('DataForPlot/scale_binvaluehuman.mat','binvaluehuman');
% save('DataForPlot/scale_binvaluemodel.mat','binvaluemodel');


binranges(find(binranges == -1)) = [];
humanavg(find(humanavg == -1)) = [];
humanstd(find(humanstd == -1)) = [];
modelavg(find(modelavg == -1)) = [];
modelstd(find(modelstd == -1)) = [];

binranges = binranges + 2.5;
hb = figure;

subplot(1,2,1);
hold on;
bar(binranges, humanavg,'FaceColor','r');
errorbar(binranges, humanavg,humanstd,'k.','Linewidth', 1);
plot([0:1:47],13.2*ones(1,length([0:1:47])),'k--');
plot(25*ones(1,16),[0:1:15],'k--');
xlabel('Ground truth areas (degrees squared)','FontSize', 12);
ylabel('Number of fixations','FontSize', 12);
xlim([0 47]);
ylim([0 15]);
set(gca,'TickDir','out');
set(gca,'Box','Off');

subplot(1,2,2);
hold on;
bar(binranges, modelavg,'FaceColor',[0 0.45 0.74]);
errorbar(binranges, modelavg,modelstd,'k.','Linewidth', 1);
plot([0:1:47],13.2*ones(1,length([0:1:47])),'k--');
plot(25*ones(1,16),[0:1:15],'k--');
%xlabel('Ground truth areas (degrees squared)','FontSize', 12);
%ylabel('Number of fixations','FontSize', 12);
xlim([0 47]);
ylim([0 15]);
set(gca,'ytick',[0:5:15]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
%ylabel('Number of fixations','FontSize', 12);
%legend({'Human','IVSN'},'Location','northwest','FontSize',10);
%legend('boxoff');
hold off;

set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_OVERALL_CombinedSS.pdf'],'-dpdf','-r200');
%print(hb,['../Figures/fig_S03D_' type '_scalechange' printpostfix],printmode,printoption);



%% euclidean plot

%%array
type = 'array';
load('DataForPlot/TTEucliDist_array.mat');
subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array 
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);

ImgNum = 300;

areavec = euclidist;
%hist(areavec);
binranges = [0 0.135:0.01:0.19 0.31]; %[0.4:0.05:0.7]
binnum = length(binranges);
[bincounts ind] = histc(areavec,binranges);
ind(ind>7) = 7;
binranges = binranges(1:7);
bincounts = [bincounts(1:7)];

FixNumMatHuman = nan(length(subjlist), ImgNum);
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);    
    for j = 1:ImgNum
        sc = scoremat(j,:);
        t = find(sc == 1);
        if ~isempty(t)
            FixNumMatHuman(i,j) = t;
        end
    end
end
FixNumMatHuman = nanmean(FixNumMatHuman,1);    

FixNumMatModel = nan(1, ImgNum);
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
for i = 1:ImgNum    
    sc = scoremat(i,:);
    t = find(sc == 1);
    if ~isempty(t)
        FixNumMatModel(1,i) = find(sc == 1);
    end
end

humanavg = [];
humanstd = [];

modelavg = [];
modelstd = [];

binvaluehuman = nan(length(binranges),300);
binvaluemodel = nan(length(binranges),300);

for g = 1:length(binranges)
    
    if bincounts(g) <= 5
        humanavg = [humanavg; -1];
        humanstd = [humanstd; -1];
        modelavg = [modelavg; -1];
        modelstd = [modelstd; -1];
        binranges(g) = -1;
    else
    
        binva = FixNumMatHuman(find(ind == g));
        binvaluehuman(g,1:length(binva)) = binva;
        
        ha = nanmean( FixNumMatHuman(find(ind == g)));
        hastd = nanstd(FixNumMatHuman(find(ind == g)),0,2)/sqrt(length(FixNumMatHuman(find(ind == g))));
        humanavg = [humanavg; ha];
        humanstd = [humanstd; hastd];

        binva = FixNumMatModel(find(ind == g));
        binvaluemodel(g,1:length(binva)) = binva;
        
        hm = nanmean( FixNumMatModel(find(ind==g)));
        hmstd = nanstd(FixNumMatModel(find(ind == g)),0,2)/sqrt(length(FixNumMatModel(find(ind == g))))
        modelavg = [modelavg; hm];
        modelstd = [modelstd; hmstd];
    end
end

% save(['DataForPlot/eucli_bin_' type '.mat'],'binranges');
% save(['DataForPlot/eucli_binvaluehuman_' type '.mat'],'binvaluehuman');
% save(['DataForPlot/eucli_binvaluemodel_' type '.mat'],'binvaluemodel');


binranges(find(binranges == -1)) = [];
humanavg(find(humanavg == -1)) = [];
humanstd(find(humanstd == -1)) = [];
modelavg(find(modelavg == -1)) = [];
modelstd(find(modelstd == -1)) = [];

%binranges = binranges + 0.05/2;

binranges(1) = 0.115;

hb = figure;
subplot(1,2,1);
hold on;
bar(binranges, humanavg,'FaceColor','r');
errorbar(binranges, humanavg,humanstd,'k.','Linewidth', 1);
plot([0:0.005:0.19],3.5*ones(1,length([0:0.005:0.19])),'k--');
xlabel('Euclidean distance for target object','FontSize', 11);
ylabel('Number of fixations','FontSize', 11);
legend({'Human'},'Location','northwest','FontSize',10);
legend('boxoff');
xlim([0.1 0.19]);
ylim([0 4.5]);
%breakxaxis([0.005 0.12]);
set(gca,'ytick',[0:1:4.5]);
set(gca,'xtick',[0.13:0.02:0.19]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
hold off;
title('Experiment 1');
subplot(1,2,2);
hold on;
bar(binranges, modelavg,'FaceColor',[0 0.45 0.74]);
errorbar(binranges, modelavg,modelstd,'k.','Linewidth', 1);
plot([0:0.005:0.19],3.5*ones(1,length([0:0.005:0.19])),'k--');
%xlabel('Normalized pixelwise Euclidean distance for target object','FontSize', 11);
%ylabel('Number of fixations','FontSize', 11);
legend({'IVSN'},'Location','northwest','FontSize',10);
legend('boxoff');
xlim([0.1 0.19]);
ylim([0 4.5]);
%breakxaxis([0.005 0.12]);
set(gca,'ytick',[0:1:4]);
set(gca,'xtick',[0.13:0.02:0.19]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
hold off;



set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S03A_' type '_euclidchange' printpostfix],printmode,printoption);



%%naturaldesign
type = 'naturaldesign';
load('DataForPlot/TTEucliDist_naturaldesign.mat');
subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st',...
        'subj07-pl','subj09-an','subj10-ni','subj11-ta','subj12-mi',...
        'subj13-zw','subj14-ji','subj15-ra','subj16-kr','subj17-ke'}; %natural design
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);

ImgNum = 240;

areavec = euclidist;
%hist(areavec);
binranges = [0.1:0.05:0.8]; %[0.4:0.05:0.7]
binnum = length(binranges);
[bincounts ind] = histc(areavec,binranges);
ind(ind<3) = 3;
binranges = binranges(3:end);
bincounts = [6 bincounts(4:end)];
ind(ind>10) = 10;
binranges = binranges(1:10);
bincounts = [bincounts(1:9) 11];

FixNumMatHuman = nan(length(subjlist), ImgNum);
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    TargetFound = FixData.TargetFound(:,2:end);
    TargetFound = TargetFound(seqInd,:);
    scoremat = TargetFound;
    for j = 1:ImgNum
        sc = scoremat(j,:);
        t = find(sc == 1);
        if ~isempty(t)
            FixNumMatHuman(i,j) = t;
        end
    end
end
FixNumMatHuman = nanmean(FixNumMatHuman,1);    

FixNumMatModel = nan(1, ImgNum);
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
for i = 1:ImgNum    
    sc = scoremat(i,:);
    t = find(sc == 1);
    if ~isempty(t)
        FixNumMatModel(1,i) = find(sc == 1);
    end
end

humanavg = [];
humanstd = [];

modelavg = [];
modelstd = [];

binvaluehuman = nan(length(binranges),300);
binvaluemodel = nan(length(binranges),300);

for g = 1:length(binranges)
    
    if bincounts(g) <= 5
        humanavg = [humanavg; -1];
        humanstd = [humanstd; -1];
        modelavg = [modelavg; -1];
        modelstd = [modelstd; -1];
        binranges(g) = -1;
    else
    
        binva = FixNumMatHuman(find(ind == g));
        binvaluehuman(g,1:length(binva)) = binva;
        
        ha = nanmean( FixNumMatHuman(find(ind == g)));
        hastd = nanstd(FixNumMatHuman(find(ind == g)),0,2)/sqrt(length(FixNumMatHuman(find(ind == g))));
        humanavg = [humanavg; ha];
        humanstd = [humanstd; hastd];

        binva = FixNumMatModel(find(ind == g));
        binvaluemodel(g,1:length(binva)) = binva;
        
        hm = nanmean( FixNumMatModel(find(ind==g)));
        hmstd = nanstd(FixNumMatModel(find(ind == g)),0,2)/sqrt(length(FixNumMatModel(find(ind == g))))
        modelavg = [modelavg; hm];
        modelstd = [modelstd; hmstd];
    end
end

% save(['DataForPlot/eucli_bin_' type '.mat'],'binranges');
% save(['DataForPlot/eucli_binvaluehuman_' type '.mat'],'binvaluehuman');
% save(['DataForPlot/eucli_binvaluemodel_' type '.mat'],'binvaluemodel');


binranges(find(binranges == -1)) = [];
humanavg(find(humanavg == -1)) = [];
humanstd(find(humanstd == -1)) = [];
modelavg(find(modelavg == -1)) = [];
modelstd(find(modelstd == -1)) = [];

binranges = binranges + 0.05/2;

hb = figure;
subplot(1,2,1);
hold on;
bar(binranges, humanavg,'FaceColor','r');
errorbar(binranges, humanavg,humanstd,'k.','Linewidth', 1);
plot([0:1:45],13.2*ones(1,length([0:1:45])),'k--');
xlabel('Euclidean distance for target object','FontSize', 11);
ylabel('Number of fixations','FontSize', 11);
%legend({'Human'},'Location','northwest','FontSize',10);
%legend('boxoff');
xlim([0.3 0.7]);
ylim([0 15]);
set(gca,'xtick',[0.3:0.1:0.7]);
set(gca,'ytick',[0:5:15]);
%breakxaxis([0.005 0.12]);
%set(gca,'ytick',[0:2:14]);

set(gca,'TickDir','out');
set(gca,'Box','Off');
hold off;
title('Experiment 2');

subplot(1,2,2);
hold on;
bar(binranges, modelavg,'FaceColor',[0 0.45 0.74]);
errorbar(binranges, modelavg,modelstd,'k.','Linewidth', 1);
plot([0:1:45],13.2*ones(1,length([0:1:45])),'k--');
%xlabel('Normalized pixelwise Euclidean distance for target object','FontSize', 11);
%ylabel('Number of fixations','FontSize', 11);
%legend({'IVSN'},'Location','northwest','FontSize',10);
%legend('boxoff');
xlim([0.3 0.7]);
ylim([0 15]);
set(gca,'ytick',[0:5:15]);
%breakxaxis([0.005 0.12]);
%set(gca,'ytick',[0:2:14]);
set(gca,'xtick',[0.3:0.1:0.7]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
hold off;



set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S03C_' type '_euclidchange' printpostfix],printmode,printoption);

%%
type = 'waldo';
load('DataForPlot/TTEucliDist_waldo.mat');
subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az',...
        'subj07-ak','subj08-an','subj09-jo','subj10-ni','subj11-ji',...
        'subj12-ws','subj13-ma','subj14-mi','subj15-an','subj16-ga'}; %waldo/wizzard 
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
[B,seqInd] = sort(seq);

ImgNum = 67;

areavec = euclidist;
%hist(areavec);
binranges = [0.5:0.02:0.7]
binnum = length(binranges);
[bincounts ind] = histc(areavec,binranges);
ind(ind>6) = 6;
binranges = binranges(1:6);
bincounts = [bincounts(1:5) 6];

FixNumMatHuman = nan(length(subjlist), ImgNum);
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type  '/' subjlist{i} '_oracle.mat']);
    TargetFound = FixData.TargetFound(:,2:end);
    TargetFound = TargetFound(seqInd,:);
    scoremat = TargetFound;
    for j = 1:ImgNum
        sc = scoremat(j,:);
        t = find(sc == 1);
        if ~isempty(t)
            FixNumMatHuman(i,j) = t;
        end
    end
end
FixNumMatHuman = nanmean(FixNumMatHuman,1);    

FixNumMatModel = nan(1, ImgNum);
load(['DataForPlot/topdown30_31_cropped' type '.mat']);
for i = 1:ImgNum    
    sc = scoremat(i,:);
    t = find(sc == 1);
    if ~isempty(t)
        FixNumMatModel(1,i) = find(sc == 1);
    end
end

humanavg = [];
humanstd = [];

modelavg = [];
modelstd = [];

binvaluehuman = nan(length(binranges),300);
binvaluemodel = nan(length(binranges),300);

for g = 1:length(binranges)
    
    if bincounts(g) <= 5
        humanavg = [humanavg; -1];
        humanstd = [humanstd; -1];
        modelavg = [modelavg; -1];
        modelstd = [modelstd; -1];
        binranges(g) = -1;
    else
    
        binva = FixNumMatHuman(find(ind == g));
        binvaluehuman(g,1:length(binva)) = binva;
        
        ha = nanmean( FixNumMatHuman(find(ind == g)));
        hastd = nanstd(FixNumMatHuman(find(ind == g)),0,2)/sqrt(length(FixNumMatHuman(find(ind == g))));
        humanavg = [humanavg; ha];
        humanstd = [humanstd; hastd];

        binva = FixNumMatModel(find(ind == g));
        binvaluemodel(g,1:length(binva)) = binva;
        
        hm = nanmean( FixNumMatModel(find(ind==g)));
        hmstd = nanstd(FixNumMatModel(find(ind == g)),0,2)/sqrt(length(FixNumMatModel(find(ind == g))))
        modelavg = [modelavg; hm];
        modelstd = [modelstd; hmstd];
    end
end

% save(['DataForPlot/eucli_bin_' type '.mat'],'binranges');
% save(['DataForPlot/eucli_binvaluehuman_' type '.mat'],'binvaluehuman');
% save(['DataForPlot/eucli_binvaluemodel_' type '.mat'],'binvaluemodel');

binranges(find(binranges == -1)) = [];
humanavg(find(humanavg == -1)) = [];
humanstd(find(humanstd == -1)) = [];
modelavg(find(modelavg == -1)) = [];
modelstd(find(modelstd == -1)) = [];

binranges = binranges + 0.02/2;


hb = figure;
subplot(1,2,1);
hold on;
bar(binranges, humanavg,'FaceColor','r');
errorbar(binranges, humanavg,humanstd,'k.','Linewidth', 1);
xlabel('Euclidean distance for target object','FontSize', 11);
ylabel('Number of fixations','FontSize', 11);
%legend({'Human'},'Location','northwest','FontSize',10);
%legend('boxoff');
xlim([0.5 0.62]);
ylim([0 50]);
%breakxaxis([0.005 0.12]);
set(gca,'ytick',[0:10:50]);
set(gca,'xtick',[0.5:0.04:0.62]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
hold off;
title('Experiment 3');
subplot(1,2,2);
hold on;
bar(binranges, modelavg,'FaceColor',[0 0.45 0.74]);
errorbar(binranges, modelavg,modelstd,'k.','Linewidth', 1);
xlim([0.5 0.62]);
ylim([0 50]);
%breakxaxis([0.005 0.12]);
set(gca,'ytick',[0:10:50]);
set(gca,'xtick',[0.5:0.04:0.62]);
set(gca,'TickDir','out');
set(gca,'Box','Off');
hold off;



set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S03E_' type '_euclidchange' printpostfix],printmode,printoption);


%% size on stats for displays and reporting purpose
type = 'waldo';
load(['DataForPlot/GTstats_' type '.mat']);
w = Datastats.wstats;
h = Datastats.hstats;
area = w.*h;
display(['Dataset: ' type]);
display(['w_mean: ' num2str((mean(w)))]);
display(['w_SD: ' num2str(std(w))]);
display(['h_mean: ' num2str((mean(h)))]);
display(['h_SD: ' num2str(std(h))]);


type = 'naturaldesign';
load(['DataForPlot/GTstats_' type '.mat']);
w = Datastats.wstats;
h = Datastats.hstats;
area = w.*h;
display(['Dataset: ' type]);
display(['w_mean: ' num2str((mean(w)))]);
display(['w_SD: ' num2str(std(w))]);
display(['h_mean: ' num2str((mean(h)))]);
display(['h_SD: ' num2str(std(h))]);









