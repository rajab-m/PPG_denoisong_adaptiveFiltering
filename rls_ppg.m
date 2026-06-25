function [filtered_signal, est_noise_rls] = rls_ppg(noisy_signal, noise_ref, order, lambda)

N = length(noisy_signal);

w = zeros(order,1);
delta = 1000;

p = delta * eye(order);

error_signal = zeros(N,1);
est_noise_rls = zeros(N,1);

noise_ref = noise_ref(:);
noisy_signal = noisy_signal(:);

for i = order:N

    input_vec = noise_ref(i:-1:i-order+1);

    % noise estimate
    est_noise_rls(i) = input_vec' * w;

    % error (clean signal estimate)
    error_signal(i) = noisy_signal(i) - est_noise_rls(i);

    % gain
    k = (p * input_vec) / (lambda + input_vec' * p * input_vec);

    % update weights
    w = w + k * error_signal(i);

    % update inverse correlation matrix
    p = (p - k * input_vec' * p) / lambda;

    %  symmetry correction
    p = (p + p') / 2;

end

filtered_signal = error_signal;

end
