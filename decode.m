function [ gi, payload ] = decode( wi, T, Tf, S, Tl, Tr, w, lastEmbedded )
%DECODE Summary of this function goes here
%   Detailed explanation goes here

wi=double(wi);
gi = wi;
payload = double.empty;
predictionError = zeros(512,512);

if T > 0
    if S > 0
        tp= S;
        tn = -S;
    else
        tp = -S;
        tn = S;
    end
else
    if S > 0
        tp = S;
        tn = -S-1;
    else
        tp = -S-1;
        tn = S;
    end
end

while true
    for i = 2:511
        i = 513 - i;
        if i <= lastEmbedded(1, 1)
            for j = 2:511
                j = 513 - j;
                if j <= lastEmbedded(1, 2)
                    g = predict(gi, w, i, j);
                    x = gi(i, j) - g;
                    fluctuationVal = fluctuation(gi, g, i, j);
                    if fluctuationVal < Tf
                        if x > tp + 1
                            x = x - 1;
                        elseif x == tp + 1
                            x = x - 1;
                            payload = [payload 1];
                        elseif x == tp
                            payload = [payload 0];
                        elseif x > tn && x > tp
                        elseif x == tn
                            payload = [payload 0];
                        elseif x == tn - 1
                            x = x + 1;
                            payload = [payload 1];
                        elseif x < tn - 1
                            x = x + 1;
                        end

                        predictionError(i, j) = x;
                    end
                end
            end
        end
    end
    for i = 2:511
        i = 513 - i;
        for j = 2:511
            j = 513 - j;
            g = predict(gi, w, i ,j);
            gi(i, j) = g + predictionError(i, j);
        end
    end
    

    if T > 0
        if tp == T
            break;
        elseif tp < T
            tp = tp + 1;
        end
    elseif T < 0
        if tn == T
            break;
        elseif tn > T
            tn = tn - 1;
        end
    end
end

gi = uint8(gi);
payload = flip(payload);

end

