% Least Mean squares algorithm
function [filtered_signal,est_noise_lms,w] =lms_filtering(noisy_signal,noise_ref,order,step_size)
% Least Mean Squares Algorithm

% noisy_signal : the corrupted signal
% noise_ref :the input of the adaptive filter (noise reference)
% order : filter order
% step_size : the step size
% filtered_signal : the recovered signal
% est_noise_lms : the estimated noise 
% w : weights of the filter in each iteration

    N=length(noisy_signal);
    w = zeros (order,N);   % all weights if you want to see the convergence process
    w1=zeros(order,1);
    est_noise_lms= zeros(1,N);   
    desired=zeros(1,N);
    mu= step_size;
    for i = order:N-1
    input_vector = noise_ref (i-order+1:i) ; 
    predicted_value=dot(input_vector,w1);
    est_noise_lms(i)=predicted_value;
    desired (i) = noisy_signal (i)-predicted_value;
    w1 = w1+(mu*desired (i)*transpose(input_vector));     
    w(:,i)=w1;
    end
    filtered_signal=desired;