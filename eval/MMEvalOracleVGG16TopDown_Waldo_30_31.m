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

stimulistore = [];
patchstore = [];

FixData = [];
Fix_posx = {};
Fix_posy = {};

LayerList = [1];
%indexlist = {[4],[5], [5], [6], [6], [6]}; %best
% indexlist = {[1],[1], [1], [1], [1], [1]};
% indexlist = {[2],[2], [2], [2], [2], [2]};
% indexlist = {[3],[3], [3], [3], [3], [3]};
 %indexlist = {[4],[4], [4], [4], [4], [4]};
 %indexlist = {[5],[5], [5], [5], [5], [5]};
%indexlist = {[6],[6], [6], [6], [6], [6]};
%indexlist = {[7],[7], [7], [7], [7], [7]};
indexlist = {0,0,0,0,0,0};

receptiveSize = 100;
arraysize = 80;
w = 1024;
h = 1280;

load(['../datasets/waldo/psy/waldo.mat']);

scoremat = zeros(length(MyData), arraysize);
for i = 1:length(MyData)
    
    trial = MyData(i);
    trialname = trial.targetname;
    
    path = ['../datasets/waldo/gt/gt' trialname(8:end) ];
    gt = imread(path);
    gt = imresize(gt,[w,h]);
    gt = mat2gray(gt);
    gt = im2bw(gt,0.5);
    gt = double(gt);
    
    img = imread(['../datasets/waldo/stimuli/' trialname]);
    img = imresize(img, [w, h]);
    display(['img: ' num2str(i)]);
    size(img);
    piecedir = dir(['Datasets/Waldo/WaldoBookSeries/choppedwaldo/img_id' trialname(8:end-4)  '_*_layertopdown.mat']);
    wholeimg = zeros(length(LayerList),size(img,1), size(img,2));
    %overallimg = zeros(size(img,1),size(img,2),3);
    
    posx = [];
    posy = [];
    
    for l = 1: length(LayerList)
        for j = 1: length(piecedir)
            %j
            input = load(['choppedwaldo/' piecedir(j).name]);
            comp = imread(['choppedwaldo/' piecedir(j).name(1:end-17) '.jpg' ]);
            input = input.x;
            input = imresize(input, [size(comp,1) size(comp,2)]);
            C = strsplit(piecedir(j).name,'_');        
            startpos = str2num(C{5});
            endpos = str2num(C{6});
            wholeimg(l,startpos: startpos+size(comp,1) - 1, endpos: endpos+size(comp,2) - 1) = input;
            %overallimg(startpos: startpos+size(comp,1) - 1, endpos: endpos+size(comp,2) - 1,:) = comp;
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
    
    maskname = ['../datasets/waldo/mask/' trialname];
    if exist(maskname, 'file') == 2 
        mask = imread(maskname);
        mask = imresize(mask,[size(wholeimg,1) size(wholeimg,2)]);
        mask = rgb2gray(mask);
        mask = double(im2bw(mask,0.5));
        wholeimg = wholeimg.*mask;
    end
        
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
        
%         subplot(1,2,1);
%         imshow(salimg);
%         hold on;
%         plot(y,x,'b*','markers',20);
%         hold off;
%         drawnow;
%         subplot(1,2,2);
%         imshow(gt);
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
plot(cumsum(mean(scoremat,1)))
xlabel('fixation number');
ylabel('cummulative performance');





