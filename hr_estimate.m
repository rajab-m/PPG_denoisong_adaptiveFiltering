%%
%Implementation of adaptive filters-based algorithm For Heart rate estimation
%%
function [hr,corruptedSignal_HR] = hr_estimate(data,GT,fs,type,algorithm, filter_order)
% Heart rate estimation using the proposed algorithm

% data : a data structure contains (ppg channel,ppg channe2, and 3 Acceleration signals x,y,z)
% fs : sampling rate
% type : Type of data (training or testing)
% algorithm : the desired adaptive filter to use in the algorithm
% hr : Heart rate estimated from the proposed algorithm
% corruptedSignal_HR : the corrupted ppg heart rate without filtering

    % load the data, note that training data has different structure than testing data
    if strcmpi(type, 'test')
        ppg=data(1,:);
        acc_x=data(3,:);
        acc_y=data(4,:);
        acc_z=data(5,:);
    else                        %FOR TRAINING DATA
        ppg=data(2,:);
        acc_x=data(4,:);
        acc_y=data(5,:);
        acc_z=data(6,:);
    end
    N=length(ppg);  % no. of samples
    time_seconds = floor(N/fs);
    window_size = 8;     % time window of 8-seconds
    hr = zeros(length(window_size:2:time_seconds), 1);  % heart rate valuse based on 8-seconds time window indexing
    %% filter the signals
    h = fir1(64, [0.7 4.0] / (fs/2));

    ppg   = filtfilt(h,1,ppg);
    acc_y = filtfilt(h,1,acc_y);
    acc_x = filtfilt(h,1,acc_x);
    acc_z = filtfilt(h,1,acc_z);
    %% find the resultant
    for index=1:N
        resultant(index)=sqrt(acc_x(index).^2+acc_y(index).^2+acc_z(index).^2);
    end
    % all possible noise references
    noises=[acc_x;acc_y;acc_z;resultant];
    %% apply the adaptive filtering, FFT and heart rate peak detection
    [corruptedSignal_HR] = adapive_filtering_and_HR_detection(ppg, fs,noises,'None','None', filter_order); % HR of corrupted signal
    [hrx] = adapive_filtering_and_HR_detection(ppg, fs,noises,'x-axis',algorithm, filter_order); % HR using x-axis noise rerfernce
    [hry] = adapive_filtering_and_HR_detection(ppg, fs,noises,'y-axis',algorithm, filter_order);
    [hrz] = adapive_filtering_and_HR_detection(ppg, fs,noises,'z-axis',algorithm, filter_order);
    [hr_res] = adapive_filtering_and_HR_detection(ppg, fs,noises,'resultant',algorithm, filter_order);
    [hr_successive]= adapive_filtering_and_HR_detection(ppg, fs,noises,'successive',algorithm, filter_order);
    %% eliminate all HR satisfy 55<HR<210
    hrx(hrx>210)=nan;hrx(hrx<55)=nan;  %we avoided to use [] because of array indexing error
    hry(hry>210)=nan;hry(hry<55)=nan;
    hrz(hrz>210)=nan;hrz(hrz<55)=nan;
    hr_res(hr_res>210)=nan;hr_res(hr_res<55)=nan;
    hr_successive(hr_successive>210)=nan;hr_successive(hr_successive<55)=nan;
    %% HR detections validation process

    for index=1:length(hr)
        hr_all = [hrx(index), hry(index), hrz(index), hr_res(index), hr_successive(index)];
        tol = 7;  % allowable difference for "agreement"


tol = 7;
minPts = 2;

hr_sorted = sort(hr_all);

n = length(hr_sorted);
visited = false(n,1);

clusters = {};

% =========================
%clustering
% =========================
for i = 1:n

    if visited(i)
        continue;
    end

    neighbors = find(abs(hr_sorted - hr_sorted(i)) <= tol);

    if length(neighbors) >= minPts

        cluster = hr_sorted(neighbors);
        visited(neighbors) = true;

        clusters{end+1} = cluster;

    else
        visited(i) = true; % noise
    end
end

% =========================
% Choose best cluster
% =========================
if isempty(clusters)

    hr_optimal = NaN;

else


    if length(clusters) == 1

    best_cluster = clusters{1};
    hr_optimal = median(best_cluster);

    else
    clusters_medians = zeros(1, length(clusters));

    for i = 1:length(clusters)
        clusters_medians(i) = median(clusters{i});
    endfor
      if index==1
        hr_optimal = clusters_medians(1);

      else

      [~, idx] = min(abs(clusters_medians - hr(index-1)));
      hr_optimal = clusters_medians(idx);
      end
    end


end


if ~isnan(hr_optimal)

    if index == 1
        hr(index) = hr_optimal;
        counter = 0;

    else
        diff = abs(hr_optimal - hr(index-1));

        if diff < 10
            hr(index) = hr_optimal;

        else

                hr(index) = 0.7 * hr(index-1) + 0.3 * hr_optimal ;
        end
    end

else
    if index == 1
        hr(index) = median(hr_all);
    else
        hr(index) = hr(index-1);
    end
end
%stats = [index,hr_all,hr_optimal,hr(index),GT(index)];
%dlmwrite('stats.txt', stats, 'delimiter', '\t', '-append');

            end
end

