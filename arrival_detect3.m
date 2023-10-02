function [starts, stops, envelope] = arrival_detect3(volts, N_arrivals, thresh)
    % want to make the threshold an array so I can set a different one for
    % each arrival.

    %normalise
    volts = volts/max(volts);
    
    envelope = abs(hilbert(volts));
    win_length = 2*floor(0.01*length(volts)/2)+1;
    envelope = sgolayfilt(envelope, 2, win_length);

    figure; plot(envelope);
    
    [peaks, locs] = findpeaks(envelope, 'MinPeakDistance', 0.1*length(volts));
    
    %find N_arrivals highest peaks and use those as a starting point
    [~, sort_ind] = sort(peaks, 'descend');
    locs = locs(sort_ind);
    locs = locs(1:N_arrivals);

    hold on; xline(locs, 'b-'); hold off;

    starts = zeros(1,N_arrivals);
    stops = zeros(1,N_arrivals);
 
    for ii = 1:N_arrivals
        stop = 0;
        curr_loc = locs(ii); % start in the middle
        while ~stop % scan right intil get to thresh
            if envelope(curr_loc)>thresh(ii) && envelope(curr_loc+1)<thresh(ii)
                stops(ii) = curr_loc+1;
                stop = 1;
            end
            curr_loc = curr_loc + 1;
        end

        stop = 0;
        while ~stop % scan left to find starting point
            if envelope(curr_loc)>thresh(ii) && envelope(curr_loc-1)<thresh(ii)
                starts(ii) = curr_loc-1;
                stop = 1;
            end
            curr_loc = curr_loc - 1;
        end
    end
end