clear all; close all; clc;
type = 'waldo'; %waldo, wizzard, naturaldesign, array

%note: three datasets have not re-sequentalized; reorder first!
% the first fixation is always the center; remove the first fix!
% the reaction time lasts from the first fix to the trial start!
if strcmp(type, 'array')
    HumanNumFix = 6;
    NumStimuli = 600;
    subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo',...
       'subj09-az','subj10-oc','subj11-lu','subj12-al','subj13-ni',...
       'subj14-ji','subj15-ma','subj17-ga','subj18-an','subj19-ni'}; %array
%   subjlist = {'subj02-el','subj03-yu','subj05-je','subj07-pr','subj08-bo'}; %array
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
    
markerlist = {'r','g','b','c','k','m',     'r*-','g*-','b*-','c*-','k*-','m*-',   'ro-','go-','bo-','co-','ko-','mo-',  'r^-','g^-','b^-','c^-','k^-','m^-'};
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '.mat']);
load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/' type '_seq.mat']);
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'
[B,seqInd] = sort(seq);
Imgw = 1024;
Imgh = 1280;
PixelToDeg = 1024/32;

linewidth = 3;
display(['Datasets: ' type]);
hb = figure;
hold on;

if strcmp(type,'array')
    binranges = [0:0.5:20];
    HumanDist = [];
    for s = 1: length(subjlist)
        load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_array/' subjlist{s} '_saccade.mat']);
        for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            %dist = dist(2:end);
            HumanDist = [HumanDist dist];
        end       
    end
    HumanDist = HumanDist/PixelToDeg;

    bincounts = histc(HumanDist,binranges);
    plot(binranges, bincounts/sum(bincounts),'r-','LineWidth',linewidth);
    %ydivision = [0:0.01:0.4];
    plot(ones(1,length(binranges))*nanmedian(HumanDist), binranges,'r--','LineWidth',linewidth);
    
    display(['median (human): ' num2str(nanmedian(HumanDist)) '; STD: ' num2str(nanstd(HumanDist))]);
    display(['mean (human): ' num2str(nanmean(HumanDist)) '; SEM: ' num2str(nanstd(HumanDist)/length(HumanDist))]);
    
    %title('ReactionTimeFirstFix');
    
    
    ModelDist = [];
    load(['DataForPlot/topdown30_31_cropped' type '_saccade.mat']);    
    for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            ModelDist = [ModelDist dist];
    end    
    ModelDist = ModelDist/PixelToDeg;
    bincounts = histc(ModelDist,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',[0 0.45 0.74],'LineWidth',linewidth);
    plot(ones(1,length(binranges))*nanmedian(ModelDist), binranges,'--','color',[0 0.45 0.74],'LineWidth',linewidth);
    
    display(['median (model): ' num2str(nanmedian(ModelDist)) '; STD: ' num2str(nanstd(ModelDist))]);
    display(['mean (model): ' num2str(nanmean(ModelDist)) '; SEM: ' num2str(nanstd(ModelDist)/length(ModelDist))]);
    
    
    xlabel('Saccade distance (degrees)','FontSize', 12);
    ylabel('Proportion','FontSize', 12);
    xlim([0 20]);
    ylim([0 1]);
    
    
    
    ModelDist = [];
    load(['DataForPlot/machine_layer30_31_cropped' type '_SC_cross1.mat']);    
    for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            ModelDist = [ModelDist dist];
    end 
    load(['DataForPlot/machine_layer30_31_cropped' type '_SC_cross2.mat']);    
    for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            ModelDist = [ModelDist dist];
    end 
    ModelDist = ModelDist/PixelToDeg;
    bincounts = histc(ModelDist,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',[0 0.45 0.74],'LineWidth',1.5);
    plot(ones(1,length(binranges))*nanmedian(ModelDist), binranges,'--','color',[0 0.45 0.74],'LineWidth',1.5);
    
    display(['median (model): ' num2str(nanmedian(ModelDist)) '; STD: ' num2str(nanstd(ModelDist))]);
    display(['mean (model): ' num2str(nanmean(ModelDist)) '; SEM: ' num2str(nanstd(ModelDist)/length(ModelDist))]);
    
    
    xlabel('Saccade distance (degrees)','FontSize', 12);
    ylabel('Proportion','FontSize', 12);
    xlim([0 20]);
    ylim([0 1]);
    
    %legend({'Human','Human-median','Model','Model-median'},'Location','northeast','FontSize',10);

    %pdf for saccade in arrays:
    %1: 0.778; 
    %2: 0.129; 
    %3: 0.04778

else
       
    binranges = [0:0.5:40];
    HumanDist = [];
    for s = 1: length(subjlist)
        load(['/home/mengmi/Proj/Proj_VS/githubVS/datasets/' type '/psy/ProcessScanpath_' type '/' subjlist{s} '_oracle.mat']);
        for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = double(Fixx);
            Fixy = double(Fixy);
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            HumanDist = [HumanDist dist];
        end       
    end
    
    HumanDistval = HumanDist';
        
    HumanDist = HumanDist/PixelToDeg;
    
    %find the best fit distribution
%     pd = fitdist(HumanDist','Gamma');
%     x_values = 0:1:45;
%     y = pdf(pd,x_values);    
%     if strcmp(type,'naturaldesign')
%         plot(x_values,y/1.8,'k-','LineWidth',2);
%     else
%         plot(x_values,y/1.55,'k-','LineWidth',2);
%     end
    
    bincounts = histc(HumanDist,binranges);
    plot(binranges, bincounts/sum(bincounts),'r-','LineWidth',linewidth);
    %ydivision = [0:0.01:0.4];
    plot(ones(1,length(binranges))*nanmedian(HumanDist), binranges,'r--','LineWidth',linewidth);
    
    %title('ReactionTimeFirstFix');
    display(['median (human): ' num2str(nanmedian(HumanDist)) '; STD: ' num2str(nanstd(HumanDist))]);
    display(['mean (human): ' num2str(nanmean(HumanDist)) '; SEM: ' num2str(nanstd(HumanDist)/length(HumanDist))]);
    
    ModelDist = [];
    load(['DataForPlot/topdown30_31_cropped' type '.mat']);    
    for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            ModelDist = [ModelDist dist];
    end    
    ModelDist = ModelDist/PixelToDeg;
    bincounts = histc(ModelDist,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',[0 0.45 0.74],'LineWidth',linewidth);
    plot(ones(1,length(binranges))*nanmedian(ModelDist), binranges,'--','color',[0 0.45 0.74],'LineWidth',linewidth);
    xlabel('Saccade distance (degrees)','FontSize', 12);
    ylabel('Proportion','FontSize', 12);
    xlim([0 40]);
    ylim([0 0.1]);
    
    
    ModelDist = [];
    load(['DataForPlot/machine_layer30_31_cropped' type '_SC_cross1.mat']);     
    for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            ModelDist = [ModelDist dist];
    end    
    load(['DataForPlot/machine_layer30_31_cropped' type '_SC_cross2.mat']);     
    for j = 1:NumStimuli/2
            Fixx = FixData.Fix_posx{j};
            Fixy = FixData.Fix_posy{j};
            Fixx = diff(Fixx);
            Fixy = diff(Fixy);
            dist = sqrt(Fixx.^2 + Fixy.^2);
            ModelDist = [ModelDist dist];
    end    
    ModelDist = ModelDist/PixelToDeg;
    bincounts = histc(ModelDist,binranges);
    plot(binranges, bincounts/sum(bincounts),'color',[0 0.45 0.74],'LineWidth',1.5);
    plot(ones(1,length(binranges))*nanmedian(ModelDist), binranges,'--','color',[0 0.45 0.74],'LineWidth',1.5);
    xlabel('Saccade distance (degrees)','FontSize', 12);
    ylabel('Proportion','FontSize', 12);
    xlim([0 40]);
    ylim([0 0.1]);
    
    
    %legend({'Human','Human-median','Model','Model-median'},'Location','northeast','FontSize',10);
    display(['median (model): ' num2str(nanmedian(ModelDist)) '; STD: ' num2str(nanstd(ModelDist))]);
    display(['mean (model): ' num2str(nanmean(ModelDist)) '; SEM: ' num2str(nanstd(ModelDist)/length(ModelDist))]);
        
end

legend({'Human','Human-median','IVSN','IVSN-median','IVSNsaccade','IVSNsaccade-median'});
legend('boxoff');
% save(['DataForPlot/saccade_human_' type '.mat'],'HumanDist');
% save(['DataForPlot/saccade_model_' type '.mat'],'ModelDist');

% [h,p,ci,stats] = ttest2(HumanDist, ModelDist, 'Tail','left');
% p
set(gca,'TickDir','out');
set(gca,'Box','Off');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

% if strcmp(type, 'array')
%     print(hb,['../Figures/fig_S18B_' type '_SaccadeStats' printpostfix],printmode,printoption);
% elseif strcmp(type, 'naturaldesign')
%     print(hb,['../Figures/fig_S18B_' type '_SaccadeStats' printpostfix],printmode,printoption);
%     
% else
%     print(hb,['../Figures/fig_S18B_' type '_SaccadeStats' printpostfix],printmode,printoption);
%     
% end

%save(['DataForPlot/saccade_IVSNdistance_' type '.mat'],'ModelDist');

display(['Dataset: ' type]);
[h,p,ci,stats]=ttest2(ModelDist(:),HumanDist(:));
display(['saccade distribution: IVSN-saccade vs Human']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);


% type1 = 'naturaldesign';
% Human = load(['DataForPlot/saccade_human_' type1 '.mat']);
% Human1 = Human.HumanDist;
% type2 = 'waldo';
% Human = load(['DataForPlot/saccade_human_' type2 '.mat']);
% Human2 = Human.HumanDist;
% [h p] = ttest2(Human1, Human2);
% display(['human (naturaldesign) vs human(waldo) : pval= ' num2str(p)]);
% 
% type1 = 'naturaldesign';
% Human = load(['DataForPlot/saccade_model_' type1 '.mat']);
% Human1 = Human.ModelDist;
% type2 = 'waldo';
% Human = load(['DataForPlot/saccade_model_' type2 '.mat']);
% Human2 = Human.ModelDist;
% [h p] = ttest2(Human1, Human2);
% display(['model (naturaldesign) vs model (waldo) : pval= ' num2str(p)]);




%p = anova1([Human1, Human2],[ones(1,length(Human1)) 2*ones(1,length(Human2))]);
% p = ranksum(Human1, Human2);
% p

























