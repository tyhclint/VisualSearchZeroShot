%% Author: Mengmi Zhang
%% Kreiman Lab
%% web: http://klab.tch.harvard.edu/
%% Date: April 5, 2018

clear all;
close all;
clc;

% -- layers: numlayer, numtemplates, convsize
% -- layers: 5, 64, 14
% -- layers: 10, 128, 7
% -- layers: 17, 256, 4
% -- layers: 23, 512, 4
% -- layers: 24, 512, 2
% -- layers: 30, 512, 2
% -- layers: 31, 512, 1
LayerList = [1];
FixData = [];
Fix_posx = {};
Fix_posy = {};

receptiveSize = 200;
arraysize = 80;
w = 1024;
h = 1280;

scoremat = zeros(240, arraysize);
for i = 1:240
    
    %trial = MyData(i);
    %trialname = trial.targetname;
    
    path = ['../datasets/naturaldesign/gt/gt' num2str(i) '.jpg' ];
    gt = imread(path);
    gt = imresize(gt,[w,h]);
    gt = mat2gray(gt);
    gt = im2bw(gt,0.5);
    gt = double(gt);
    
    img = imread(['../datasets/naturaldesign/stimuli/img' sprintf('%03d',i) '.jpg']);
    img = imresize(img, [w, h]);
    display(['img: ' num2str(i)]);
    size(img);
    piecedir = dir(['croppednaturaldesign/img_id_' sprintf('%03d',i)  '_*_layertopdown.mat']);
    wholeimg = zeros(length(LayerList),size(img,1), size(img,2));
    %overallimg = zeros(size(img,1),size(img,2),3);
    
    posx = [];
    posy = [];
    
    for l = 1: length(LayerList)
        for j = 1: length(piecedir)
            %j
            input = load(['croppednaturaldesign/' piecedir(j).name]);
            comp = imread(['croppednaturaldesign/' piecedir(j).name(1:end-17) '.jpg']);
            input = input.x;
            input = imresize(input, [size(comp,1) size(comp,2)]);
            C = strsplit(piecedir(j).name,'_');        
            startpos = str2num(C{4});
            endpos = str2num(C{5});
            wholeimg(l,startpos: startpos+size(comp,1) - 1, endpos: endpos+size(comp,2) - 1) = input;
            overallimg(startpos: startpos+size(comp,1) - 1, endpos: endpos+size(comp,2) - 1,:) = comp;
            %wholeimg1 = squeeze(mat2gray( wholeimg(l,:,:)));
            
%             subplot(1,2,1);
%             imshow(wholeimg1);
%             subplot(1,2,2);
%             imshow(uint8(overallimg));
%             pause;
%             imshow(heatmap_overlay(img,wholeimg1));
%             pause(0.05);
        end
        wholeimg(l,:,:) = mat2gray(wholeimg(l,:,:));
    end
    
    wholeimg = squeeze(mean(wholeimg,1));
    
    
        
    %subplot(1,2,1);
    %imshow(heatmap_overlay(gt,wholeimg));
    %subplot(1,2,2);
    %imshow(gt);
    %pause(0.010);
    
    %apply IOR
    found = 0;
    fixtime = 1;
    salimg = wholeimg;
    for f = 1: arraysize

        [Y,idx] = max(salimg(:));
        [x y]= ind2sub(size(salimg),idx);
        
        posx = [posx; x];
        posy = [posy; y];
        
%         subplot(2,2,1);
%         imshow(salimg);
%         hold on;
%         plot(y,x,'b*','markers',20);
%         hold off;
%         drawnow;
%         subplot(2,2,2);
%         imshow(gt);
%         subplot(2,2,3);
%         imshow(img);
%         pause(0.2);
        
        fixatedPlace_leftx = x - receptiveSize/2 + 1;
        fixatedPlace_rightx = x + receptiveSize/2;
        fixatedPlace_lefty = y - receptiveSize/2 + 1;
        fixatedPlace_righty = y + receptiveSize/2;
        
        if fixatedPlace_leftx < 1
            fixatedPlace_leftx = 1;
        end
        if fixatedPlace_lefty < 1
            fixatedPlace_lefty = 1;
        end
        if fixatedPlace_rightx > size(gt,1)
            fixatedPlace_rightx = size(gt,1);
        end
        if fixatedPlace_righty > size(gt,2)
            fixatedPlace_righty = size(gt,2);
        end
        fixatedPlace = gt(fixatedPlace_leftx:fixatedPlace_rightx, fixatedPlace_lefty:fixatedPlace_righty);
        grayii = rgb2gray(img);
        savefixatedPlace = grayii(fixatedPlace_leftx:fixatedPlace_rightx, fixatedPlace_lefty:fixatedPlace_righty);
        %imwrite(savefixatedPlace, ['/home/mengmi/Proj/Proj_VS/Datasets/NaturalDataset/fixatedplaces_naturaldesign/c' num2str(i) '_' num2str(fixtime) '.jpg']);
        
        
        if sum(sum(fixatedPlace)) > 0 
            found = 1;
            break;
        else
            found = 0;
                        
            fixtime = fixtime + 1;
            salimg(fixatedPlace_leftx:fixatedPlace_rightx, fixatedPlace_lefty:fixatedPlace_righty) = 0;
            salimg = mat2gray(salimg);
        end
        
    end
    
    Fix_posx = [Fix_posx posy'];
    Fix_posy = [Fix_posy posx'];
    
    display(['img id: '  num2str(i) '; fix found at time step: ' num2str(fixtime) ]);
    if fixtime <= arraysize
        scoremat(i,fixtime) = 1;
    end
    
end

FixData.Fix_posx = Fix_posx;
FixData.Fix_posy = Fix_posy;
%save(['/home/mengmi/Proj/Proj_VS/HumanExp/githuman/Code/DataForPlot/topdown30_31_croppednaturaldesign.mat'],'scoremat','FixData');
plot(cumsum(mean(scoremat,1)))
xlabel('fixation number');
ylabel('cummulative performance');

