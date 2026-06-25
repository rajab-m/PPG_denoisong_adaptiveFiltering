function [filtered_signal,est_noise_NLMS] =NLMS(noisy_signal,noise_ref,order,step_size)
% Normalized Least Mean Squares Algorithm

% noisy_signal : the corrupted signal
% noise_ref :the input of the adaptive filter (noise reference)
% step_size : the step size
% filtered_signal : the recovered signal
% est_noise_NLMS : the estimated noise 
w = zeros (order,1);
N=length(noisy_signal);
desired=zeros(1,N);
est_noise_NLMS=zeros(1,N);
mu=step_size;
for i = order:N-1
    input_vector = noise_ref (i-order+1:i) ;  
    est_noise_NLMS(i)=w'*input_vector;
    desired (i) = noisy_signal (i)-w'*input_vector;
    denomenator=input_vector'*input_vector+.0001;   % small value to solve division by zero issue
    w=w+(mu*desired(i)*input_vector)/denomenator; 
end
filtered_signal=desired;