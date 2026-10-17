function [ scoremat ] = fcn_decodeToScoremat( NumStimuli, MaxFix, hm )
%FCN_DECODETOSCOREMAT Summary of this function goes here
%   Detailed explanation goes here

scoremat = zeros(NumStimuli/2, MaxFix);
for i = 1: NumStimuli/2
    if isnan(hm(i))
        continue;
    else
        if hm(i)<=MaxFix
            scoremat(i,hm(i)) = 1;
        end
    end

end

end