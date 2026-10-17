%% Author: Mengmi Zhang
%% Kreiman Lab
%% web: http://klab.tch.harvard.edu/
%% Date: April 5, 2018

clear all; close all; clc;

fix1 = [151 719 0]; %hB
fix2 = [164 313 0]; %dB
fix3 = [644 105 0]; %bH
fix4 = [1127 300 0]; %dL
fix5 = [1123 716 0]; %hL
fix6 = [649 914 0]; %hH

%%% use this for SS evaluation
% fix1 = [490 772];
% fix2 = [340 512];
% fix3 = [490 252];
% fix4 = [790 252];
% fix5 = [940 512];
% fix6 = [790 772];

fix1 = [365 988 0 ];
fix2 = [90 512 0];
fix3 = [365 36 0];
fix4 = [915 36 0];
fix5 = [1190 512 0];
fix6 = [915 988 0];




FIXLIST = [fix1; fix2; fix3; fix4; fix5; fix6];
FixData = [];
Fix_posx = {};
Fix_posy = {};

load(['../datasets/arrays/psy/exp.mat']);

totalmask = load(['saliencyMask/masktotal.mat']);
totalmask = totalmask.masktotal;

maskind = load(['saliencyMask/maskind.mat']);
maskind = maskind.maskind;

NumImg = length(MyData);
arraysize = 6;

ImageDir = ['../datasets/arrays/AllObjCollection/cate'];
fixmat = nan(NumImg,6);
scorematrix = zeros(NumImg,6);

% -- layers: numlayer, numtemplates, convsize
% -- layers: 5, 64, 14
% -- layers: 10, 128, 7
% -- layers: 17, 256, 4
% -- layers: 23, 512, 4
% -- layers: 24, 512, 2
% -- layers: 30, 512, 2
% -- layers: 31, 512, 1
LayerList = [5,10,17,23,24,30,31];
indexlist = {[1:7],[1:7], [1:7], [1:7], [1:7], [1:7]}; %best


stimulistore = [];
patchstore = [];

%for display: 4, 12
for i = 1: NumImg
    
    display(i);
    
    trial = MyData(i);
    [gtind num] = find(  trial.arraycate == trial.targetcate);
    posx = [];
    posy = [];
    
    for j = 1:arraysize
    
        if j == 1
            
            totalsalimg = zeros(length(LayerList), size(totalmask,1),size(totalmask,2) );
            for l = 1: length(LayerList)
                salimg = load(['/home/mengmi/Proj/Proj_VS/results/topdownHuman/result_30_31_' num2str(i) '.mat']); %from torchh7 saved mat
                salimg = salimg.x;
                salimg = mat2gray(salimg);
                salimg = double(imresize(salimg, size(totalmask)));
                salimg = salimg.*totalmask;
                totalsalimg(l, :,:) = salimg;
            end
            
            salimg = squeeze( mean(totalsalimg(indexlist{j},:,:),1));
            %salimg = squeeze( max(totalsalimg(indexlist{j},:,:),[],1));
            salimg = mat2gray(salimg);
            

            
        else
            chosenmask = load(['saliencyMask/mask' num2str(chosenfix) '.mat']);
            chosenmask = chosenmask.mask;
            
            for l = 1:length(LayerList)
                 temp = squeeze(totalsalimg(l, :,:)).*(1 - chosenmask);
                 totalsalimg(l, :,:) = temp;
            end
            salimg = squeeze( mean(totalsalimg(indexlist{j},:,:),1));
            salimg = mat2gray(salimg);
        end
        

        [Y,idx] = max(salimg(:));
        [x y]= ind2sub(size(salimg),idx);

        
        chosenfix = maskind(x,y);
        fixmat(i,j) = chosenfix;
        
       
        
        
        Eucli(i,j) = DataStats.PixelEucli(i,chosenfix);
        Corr(i,j) = DataStats.PixelCorr(i,chosenfix);
        L1(i,j) = DataStats.L1Illuminance(i,chosenfix);
        HistL1(i,j) = DataStats.CorrHist(i,chosenfix);
        FcL2(i,j) = DataStats.LayerEucliDist(i,chosenfix);
        
        posx = [posx FIXLIST(chosenfix,1)];
        posy = [posy FIXLIST(chosenfix,2)];
        
%         subplot(1,2,1);
%         imshow(uint8(salimg));
%         hold on;
%         plot(y,x,'r*');
%         hold off;
%         subplot(1,2,2);       
%         chosenmask = load(['/home/mengmi/Proj/Proj_VS/Datasets/Human/saliencyMask/mask' num2str(chosenfix) '.mat']);
%         chosenmask = chosenmask.mask;
%         imshow(chosenmask);
%         drawnow;
        
        if chosenfix == gtind
            scorematrix(i,j) = 1;
            break;
        end
          
         
        
        
    end
    Fix_posx = [Fix_posx posx];
    Fix_posy = [Fix_posy posy];    
    
end


FixData.Fix_posx = Fix_posx;
FixData.Fix_posy = Fix_posy;


scoremat = scorematrix;
cumsum(mean(scoremat,1))
%using mean
%0.4333    0.6100    0.7333    0.8133    0.9167    1.0000
%using max
%0.3500    0.6167    0.7300    0.8200    0.9200    1.0000


