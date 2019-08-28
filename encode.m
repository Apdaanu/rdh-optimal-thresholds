%read the image and convert ot gray image
rgbi = imread('lenna.png');
gi = rgb2gray(rgbi);
gi = double(gi);
wi = gi;

%Defining four variables
Tf = 14;
T = -4;
Tl = 0;
Tr = 0;
Lp = 2621;
w = 2;
lastEmbedded = double.empty;

%Shifting of histogram
LocationMap = zeros(512, 512);
for i = 2:511
    for j = 2:511
        if wi(i, j) < Tl
            wi(i, j) = wi(i, j) + Tl;
            LocationMap(i, j) = 1;
        elseif wi(i, j) > 255 - Tr
            wi(i, j) = wi(i, j) - Tr;
            LocationMap(i, j) = 1;
        end
    end
end

%determine the playload
payload = (randi([0 1],Lp,1))';

%determine the tp and tn
if T>=0
    tp = T;
    tn = 0-T;
else
    tp = 0-T-1;
    tn = T;
end

%start embedding process
payloadCounter = 1;
S = double.empty;

while payloadCounter < Lp
    for i = 2:511
        for j = 2:511
            g = predict(wi, w, i, j);
            x = wi(i, j) - g;
            fluctuationVal = fluctuation(wi, g, i, j);
            if fluctuationVal < Tf
                if x > tp
                    x = x + 1;
                elseif x == tp
                    x = x + payload(payloadCounter);
                    payloadCounter = payloadCounter + 1;
                elseif x < tp && x > tn
                    ;
                elseif x == tn
                    x = x - payload(payloadCounter);
                    payloadCounter = payloadCounter + 1;
                elseif x < tn
                    x = x - 1;
                end
            end

            wi(i, j) = g + x;

            if payloadCounter == Lp
                if x > 0
                    S = tp;
                else
                    S = tn;
                end
                lastEmbedded = [i j];
                break;
            end
        end
        if payloadCounter == Lp
            break;
        end
    end

    tn = tn + 1;
    tp = tp - 1;
end

%Forming the watermarked image
% for i = 2:511
%     for j = 2:511
%         g = predict(wi, w, i, j);
%         wi(i, j) = newPredictionError(i, j) + g;
%     end
% end

gi = uint8(gi);
wi = uint8(wi);
psnrResult = psnr(wi, gi);
%Display of results
subplot(2,2,1);
imshow(gi); title('original image');
subplot(2,2,2);
imshow(wi);title('watermaked image');