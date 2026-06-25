function [hr] = adapive_filtering_and_HR_detection(ppg, fs,noises,axis,adaptive_algorithm, filter_order)
% calculate the heart rate after using the adaptive filtering

% ppg : the corrupted ppg signal
% noises : N*4 array of all possible noise references (x,y,z,resultant)
% axis : the desired noise reference (x,y,z, resultant or successive filtering)
% adaptive_algorithm : the desired adaptive filter to use
% corruptedSignal_HR : the corrupted ppg heart rate without filtering to compare it with the filtered one
% hr : Heart rate estimated after filtering the signal with the adaptive filter

    index=1;
    N=length(ppg);
    time_seconds = floor(N/fs);
    window_size = 8;
    hr = zeros(length(window_size:2:time_seconds), 1);


    switch axis
        case 'x-axis'
            noise=noises(1,:);
        case 'y-axis'
            noise=noises(2,:);
        case 'z-axis'
            noise=noises(3,:);
        case 'resultant'
            noise=noises(4,:);
        otherwise
            noise=noises(4,:);
    end
    for k = window_size:2:time_seconds
        if strcmpi(axis, 'successive')==0      % if not successive filtering
        noise_reference= noise(((k-window_size)*fs+1):(k*fs));
        else
           x=noises(1,:); x=x(((k-window_size)*fs+1):(k*fs));
           y=noises(2,:); y=y(((k-window_size)*fs+1):(k*fs));
           z=noises(3,:); z=z(((k-window_size)*fs+1):(k*fs));
        end
        eight_seconds_sample=ppg(((k-window_size)*fs+1):(k*fs));  % we take a time window of 8-seconds (online filtering)

        scores = zeros(1,4);
           xx=noises(1,:); xx=xx(((k-window_size)*fs+1):(k*fs));
           yy=noises(2,:); yy=yy(((k-window_size)*fs+1):(k*fs));
           zz=noises(3,:); zz=zz(((k-window_size)*fs+1):(k*fs));
           res = noises(4,:); res=res(((k-window_size)*fs+1):(k*fs));

        %scores(1) = abs(corr(eight_seconds_sample(:), xx(:)));
        %scores(2) = abs(corr(eight_seconds_sample(:), yy(:)));
        %scores(3) = abs(corr(eight_seconds_sample(:), zz(:)));
        %scores(4) = abs(corr(eight_seconds_sample(:), res(:)));

        %[~, best_idx] = max(scores);
        %dlmwrite('scores.txt', scores, 'delimiter', '\t', '-append');


        switch adaptive_algorithm
            case 'lms'
                if strcmpi(axis, 'successive')
                    [filtered_sample]=lms_filtering(eight_seconds_sample,x,filter_order,0.005);  % filter order, step_size : must be too small if not normalized
                    [filtered_sample]=lms_filtering(filtered_sample,y,filter_order,0.005);
                    [filtered_sample]=lms_filtering(filtered_sample,z,filter_order,0.005);
                else
            [filtered_sample]=lms_filtering(eight_seconds_sample,noise_reference,filter_order,0.005);
                end
            case 'Normalized_lms'
                if strcmpi(axis, 'successive')
                    [filtered_sample]=NLMS(eight_seconds_sample',x',filter_order,0.05);             % filter order, step_size
                    [filtered_sample]=NLMS(filtered_sample',y',filter_order,0.05);
                    [filtered_sample]=NLMS(filtered_sample',z',filter_order,0.05);
                else
                [filtered_sample]=NLMS(eight_seconds_sample',noise_reference',filter_order,0.05);
                end
            case 'rls'
                if strcmpi(axis, 'successive')
                    [filtered_sample]=rls_ppg(eight_seconds_sample',x',filter_order,0.99);     % filter order,forgetting factor
                    [filtered_sample]=rls_ppg(filtered_sample',y',filter_order,0.99);
                    [filtered_sample]=rls_ppg(filtered_sample',z',filter_order,0.99);
                else
                [filtered_sample]=rls_ppg(eight_seconds_sample',noise_reference',filter_order,0.99);
                end
            case 'kalman'
                if strcmpi(axis, 'successive')
                    [filtered_sample]=kalman_ppg(eight_seconds_sample,x,0.0001);   %measurement noise
                    [filtered_sample]=kalman_ppg(filtered_sample,y,0.0001);
                    [filtered_sample]=kalman_ppg(filtered_sample,z,0.0001);
                else
                [filtered_sample]=kalman_ppg(eight_seconds_sample,noise_reference,0.0001);
                end
            case 'None'    % here we calcultate HR of the corrupted PPG, No filtering needed
                filtered_sample=eight_seconds_sample;
            otherwise
                warning('Unexpected algorithm')
        end
        points = 2*2^nextpow2(length(filtered_sample)); resol=fs/points; y1=ceil(0.65/resol); y2=ceil(3.9/resol);  % FFT points  (range in hz 0.65 to 3.9)
        signal_spectrum = abs(fft(filtered_sample, points));  % Magnitudes
        signal_spectrum=signal_spectrum(y1:y2);
        min_sep_bpm = 4;   % must consider the freq. resolution
        min_sep_hz = min_sep_bpm / 60;
        minpeakdistance = round(min_sep_hz / (fs/points));
        %for matlab use this
        %[~, locs] = findpeaks(signal_spectrum, 'minpeakdistance', minpeakdistance,'sortstr', 'descend');
        %locs = (locs+y1-1)/points*fs*60;  % return the starting index and convert to Hz then convert to BPM
        %------------

        % for Octave use this ----
        freqs = (0:points-1) * fs / points;
        band_freqs = freqs(y1:y2);
        [pks, locs] = findpeaks(signal_spectrum, 'minpeakdistance', minpeakdistance);
        % convert index → frequency FIRST
        locs_hz = band_freqs(locs);

        % sort by amplitude
        [pks_sorted, idx] = sort(pks, 'descend');
        locs_hz = locs_hz(idx);
        locs_bpm = locs_hz * 60;

        %peak_power = pks_sorted(1);
        %total_power = sum(signal_spectrum);
        %score_peak = peak_power / total_power;

        %filename = ['power_' axis '.txt'];
        %dlmwrite(filename, score_peak, 'delimiter', '\t', '-append');

        %filename = ['peaks_' axis '.txt'];
        %dlmwrite(filename, locs_bpm(1:min(5, length(locs_bpm))), 'delimiter', '\t', '-append');




        %-------------------

    if isempty(locs_bpm)==0
        hr(index,:) = locs_bpm(1);
    else
        hr(index,:) = 0;
    end
      index=index+1;

    end
