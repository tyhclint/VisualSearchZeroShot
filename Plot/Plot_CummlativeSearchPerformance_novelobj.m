clear all; close all; clc;
type = 'novelobj'; %waldo, wizzard, naturaldesign, array
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
elseif strcmp(type, 'naturaldesign')
    HumanNumFix = 30; %65 for waldo/wizzard/naturaldesign; 6 for array
    NumStimuli = 480;
    subjlist = {'subj02-az','subj03-el','subj04-ni','subj05-mi','subj06-st'}; %natural design; 
elseif strcmp(type, 'novelobj')
    HumanNumFix = 6;
    NumStimuli = 525;    
    %subjlist = {'subj02-az','subj04-th','subj05-ma'}; %novelobj;
    subjlist = {'subj02-az','subj03-pl','subj04-th','subj05-ma','subj06-ak',...
        'subj07-su','subj08-an','subj09-jo','subj10-ta','subj11-sw',...
        'subj12-mi','subj13-ji','subj14-ra','subj15-an','subj16-is'}; %novelobj;
    %subjid = 6;
    %subjlist = subjlist(subjid);
else
    
    HumanNumFix = 60;
    NumStimuli = 134; %134 for waldo/wizzard; 480 for antural design; 600 for array
    subjlist = {'subj02-ni','subj03-al','subj04-vi','subj05-lq','subj06-az'}; %waldo/wizzard; 1 female
end

RandomTimes = 10; %number of randomize times
% HumanNumFix = 6; %naturaldesign: 30; waldo/wizzard:60; array: 6
% NumStimuli = 600; %134 for waldo/wizzard; 480 for antural design; 600 for array
linewidth = 2;
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

%% For novel search effect (novelobj)
hb = figure;
hold on;

humanstore = nan(length(subjlist), HumanNumFix);

humansold = nan(length(subjlist), HumanNumFix);
humansnovel = nan(length(subjlist), HumanNumFix);

humansold_td = nan(length(subjlist), HumanNumFix);
humansold_ts = nan(length(subjlist), HumanNumFix);

humansnovel_td = nan(length(subjlist), HumanNumFix);
humansnovel_ts = nan(length(subjlist), HumanNumFix);

UnableFind = [];

hs = [];
hn = [];
ho = [];
ho_td = [];
ho_ts = [];
hn_td = [];
hn_ts = [];

for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/novelobj/psy/subjects_' type  '/' subjlist{i} '/subjperform' '.mat']);
      
    htotal = [];
    for j = 1: NumStimuli
        tf = find(scoremat(j,:)==1);
        if isempty(tf) %consider those within HumanNumFix 
            htotal = [htotal nan];
        else
            htotal = [htotal tf];
        end
    end
    
    hs = [hs; htotal];
    hn = [hn; htotal(65:225)];
    ho = [ho; htotal([226:345 406:end])];
    ho_td = [ho_td; htotal(256:345)];
    ho_ts = [ho_ts; htotal(406:end)];
    hn_td = [hn_td; htotal([66:145])];
    hn_ts = [hn_ts; htotal(146:225)];
    
    
    humanstore(i,:) = nanmean(scoremat,1);
    humansnovel(i,:) = nanmean(scoremat([65:225],:),1);
    humansold(i,:) = nanmean(scoremat([226:345 406:end],:),1);
     
    humansold_td(i,:) = nanmean(scoremat(256:345,:),1);
    humansold_ts(i,:) = nanmean(scoremat(406:end,:),1);

    humansnovel_td(i,:) = nanmean(scoremat([66:145],:),1);
    humansnovel_ts(i,:) = nanmean(scoremat(146:225,:),1);
    
end


subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
type = 'array';
humansarray = nan(length(subjlist), HumanNumFix);
hexp1 = [];
for i = 1: length(subjlist)
    load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/array/psy/ProcessScanpath_' type  '/' subjlist{i} '.mat']);
    humansarray = nanmean(scoremat([1:120 181:300],:),1);
    
    htotal = [];
    for j = 1: 300
        tf = find(scoremat(j,:)==1);
        if isempty(tf) %consider those within HumanNumFix 
            htotal = [htotal nan];
        else
            htotal = [htotal tf];
        end
    end
    hexp1 = [hexp1; htotal];
end



subjlist = {'subj02-az','subj03-pl','subj04-th','subj05-ma','subj06-ak',...
        'subj07-su','subj08-an','subj09-jo','subj10-ta','subj11-sw',...
        'subj12-mi','subj13-ji','subj14-ra','subj15-an','subj16-is'}; %novelobj;
type = 'novelobj';
errorbar(1:HumanNumFix,cumsum(nanmean(humansarray,1)),nanstd(humansarray,0,1)/sqrt(size(humansarray,1)), 'color',  'r', 'linewidth', linewidth);

errorbar(1:HumanNumFix,cumsum(nanmean(humansnovel,1)),nanstd(humansnovel,0,1)/sqrt(size(humansnovel,1)), 'color',  [0.8706    0.4902         0], 'linewidth', linewidth);
errorbar(1:HumanNumFix,cumsum(nanmean(humansold,1)),nanstd(humansold,0,1)/sqrt(size(humansold,1)), 'color',  [0 0.45 0.74], 'linewidth', linewidth);

%random after 100 times
load(['DataForPlot/random_cropped' type '.mat']);
scoremat = scoremat(:,1:HumanNumFix);
randstore = scoremat;
err_random = nanstd(scoremat,0,1)/sqrt(size(scoremat,1));
errorbar(1:length(err_random), cumsum(mean(scoremat,1)),nanstd(scoremat,0,1)/sqrt(size(scoremat,1)),'k--' , 'linewidth', linewidth);

load(['DataForPlot/RandomFixGK_array.mat']);
hc = RandomFixGK(:);

save(['DataForPlot/humanExperiment1.mat'],'hexp1');
save(['DataForPlot/humanknown.mat'],'ho');
save(['DataForPlot/humannovel.mat'],'hn');

display(['Dataset: ' type]);
display(['================================']);
[h,p,ci,stats]=ttest2(hexp1(:),ho(:));
display(['experiment 1 vs known (ttest2)']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['novel vs known (ttest2)']);
[h,p,ci,stats]=ttest2(hn(:),ho(:));
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['novel vs chance (ttest2)']);
[h,p,ci,stats]=ttest2(hn(:),hc(:));
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['known vs chance (ttest2)']);
[h,p,ci,stats]=ttest2(ho(:),hc(:));
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);

legend({'Experiment 1','Novel objects','Known objects','Chance'},'Location','southeast','FontSize',10); %14 for waldo; 10 for naturaldesign
%legend({'Human-Array','Human-novel','Human-old','IVSN-novel','IVSN-old','Chance'},'Location','southeast','FontSize',10); %14 for waldo; 10 for naturaldesign
%title(['subj: ' num2str(subjid)]);
legend('boxoff');
xlabel('Fixation number');
ylabel('Cummulative performance');
xlim([1, HumanNumFix]);
ylim([0 1]);
set(gca,'TickDir','out');
set(gca,'xtick',[1:HumanNumFix]);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S12A_' type '_overallperformance' printpostfix],printmode,printoption);




% hb = figure;
% hold on;
% errorbar(1:HumanNumFix,cumsum(nanmean(humansnovel_td,1)),nanstd(humansnovel_td,0,1)/sqrt(size(humansnovel_td,1)), 'color',  [0.8706    0.4902         0], 'linewidth', 3);
% errorbar(1:HumanNumFix,cumsum(nanmean(humansold_td,1)),nanstd(humansold_td,0,1)/sqrt(size(humansold_td,1)), 'color',  [0 0.45 0.74], 'linewidth', 3);
% errorbar(1:HumanNumFix,cumsum(nanmean(humansnovel_ts,1)),nanstd(humansnovel_ts,0,1)/sqrt(size(humansnovel_ts,1)), 'color',  [0.8706    0.4902         0], 'linewidth', 1.5);
% errorbar(1:HumanNumFix,cumsum(nanmean(humansold_ts,1)),nanstd(humansold_ts,0,1)/sqrt(size(humansold_ts,1)), 'color',  [0 0.45 0.74], 'linewidth', 1.5);
% errorbar(1:length(err_random), cumsum(mean(scoremat,1)),nanstd(scoremat,0,1)/sqrt(size(scoremat,1)),'k--' , 'linewidth', linewidth);
% 
% 
% legend({'Human-Different (Novel)','Human-Different (Known)','Human-Identical (Novel)','Human-Identical (Known)','Chance'},'Location','southeast','FontSize',10); %14 for waldo; 10 for naturaldesign
% %title(['subj: ' num2str(subjid)]);
% legend('boxoff');
% xlabel('Fixation number');
% ylabel('Cummulative performance');
% xlim([1, HumanNumFix]);
% ylim([0 1]);
% set(gca,'xtick',[1:HumanNumFix]);
% set(gca,'TickDir','out');
% set(hb,'Units','Inches');
% pos = get(hb,'Position');
% set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S12B_' type '_subperformance' printpostfix],printmode,printoption);


%% IVSN on known and novel objects
hb = figure;
hold on;

errorbar(1:HumanNumFix,cumsum(nanmean(humansnovel,1)),nanstd(humansnovel,0,1)/sqrt(size(humansnovel,1)), 'color',  [0.8706    0.4902         0], 'linewidth', linewidth);
errorbar(1:HumanNumFix,cumsum(nanmean(humansold,1)),nanstd(humansold,0,1)/sqrt(size(humansold,1)), 'color',  [0 0.45 0.74], 'linewidth', linewidth);


load(['DataForPlot/topdown30_31_cropped' type '.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(225, int32(225/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0.4941    0.1843    0.5569], 'linewidth', linewidth);
htotal = [];
for j = 1: 225
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
hmodel_novel = htotal;

load(['DataForPlot/topdown30_31_croppedarray.mat']);
machinestore = [];
for i = 1: RandomTimes
    ind = randperm(600, int32(600/4));
    prop = scoremat(ind,1:HumanNumFix);
    machinestore = [machinestore; nanmean(prop,1)];
end
errorbar(1:HumanNumFix,cumsum(nanmean(machinestore,1)),nanstd(machinestore,0,1)/sqrt(size(machinestore,1)), 'color',  [0.8549    0.7020    1.0000], 'linewidth', linewidth);
htotal = [];
for j = 1: 300
    tf = find(scoremat(j,:)==1);
    if isempty(tf) %consider those within HumanNumFix 
        htotal = [htotal nan];
    else
        htotal = [htotal tf];
    end
end
hmodel_known = htotal;

save(['DataForPlot/IVSNnovel.mat'],'hmodel_novel');
save(['DataForPlot/IVSNknown.mat'],'hmodel_known');

display(['================================']);
[h,p,ci,stats]=ttest2(hmodel_known(:),ho(:));
display(['known-IVSN vs known (ttest2)']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['novel-IVSN vs novel (ttest2)']);
[h,p,ci,stats]=ttest2(hmodel_novel(:),hn(:));
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['known-IVSN vs chance (ttest2)']);
[h,p,ci,stats]=ttest2(hmodel_known(:),hc(:));
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);
display(['novel-IVSN vs chance (ttest2)']);
[h,p,ci,stats]=ttest2(hmodel_novel(:),hc(:));
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);


legend({'Novel objects','Known objects','IVSN-novel','IVSN-known'},'Location','southeast','FontSize',10); %14 for waldo; 10 for naturaldesign
%legend({'Human-Array','Human-novel','Human-old','IVSN-novel','IVSN-old','Chance'},'Location','southeast','FontSize',10); %14 for waldo; 10 for naturaldesign
%title(['subj: ' num2str(subjid)]);
legend('boxoff');
xlabel('Fixation number');
ylabel('Cummulative performance');
xlim([1, HumanNumFix]);
ylim([0 1]);
set(gca,'TickDir','out');
set(gca,'xtick',[1:HumanNumFix]);
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%print(hb,['../Figures/fig_S12C_' type '_modelperformance' printpostfix],printmode,printoption);












