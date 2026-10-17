clear all; close all; clc;
printpostfix = '.eps';
printmode = '-depsc'; %-depsc
printoption = '-r200'; %'-fillpage'

load(['DataForPlot/Dist_novel.mat'],'dist_novel');
load(['DataForPlot/Dist_old.mat'],'dist_old');

display(['Dataset: novelobj']);
display(['================================']);
[h,p,ci,stats]=ttest2(dist_old(:),dist_novel(:));
display(['known-Distri vs novel-Distri (ttest2)']);
display(['p= ' num2str(p) '; t= ' num2str(stats.tstat) '; df= ' num2str(stats.df)]);


maxdist = max(max(dist_novel),max(dist_old));

linewidth = 2;
hb=figure;
hold on;
binranges = [0:(maxdist/100):maxdist];
bincounts = histc(dist_old,binranges);
normbincounts = bincounts/sum(bincounts);
plot(binranges, normbincounts,'-','color',[0 0.45 0.74],'LineWidth',linewidth);

bincounts = histc(dist_novel,binranges);
normbincounts = bincounts/sum(bincounts);
plot(binranges, normbincounts,'-','color',[0.8706    0.4902         0],'LineWidth',linewidth);

plot(ones(1,length(binranges))*nanmedian(dist_old), binranges,'--','color',[0 0.45 0.74],'LineWidth',linewidth);
plot(ones(1,length(binranges))*nanmedian(dist_novel), binranges,'--','color',[0.8706    0.4902         0],'LineWidth',linewidth);

    
legend({'Known','Novel'},'FontSize',14,'Location','northwest');
ylim([0 0.08]);
xlabel('Euclidean distance from targets to objects on arrays (Layer 5)','FontSize',12');
ylabel('Proportion','FontSize',12');
set(gca,'ytick',[0:0.02:0.08]);
legend('boxoff');
set(hb,'Units','Inches');
pos = get(hb,'Position');
set(hb,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
set(gca,'TickDir','out');










