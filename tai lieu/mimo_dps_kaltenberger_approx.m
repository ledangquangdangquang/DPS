%% Approximate DPS wave-function projection for wideband MIMO GCM
% Based on Kaltenberger, Zemen, Ueberhuber, "Low-Complexity
% Geometry-Based MIMO Channel Simulation", EURASIP JASP, 2007.
%
% Purpose:
%   Compare the current exact DPS projection with the paper-style
%   approximate DPS wave-function coefficient calculation.
%
% Model, Eq. (47):
%   h(m,q,s,r) = sum_p eta_p exp(j*2*pi*(nu_p*m - theta_p*q
%                         + zeta_p*s - xi_p*r)).

clear; clc; close all;
rng(1);

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
resultsFigDir = fullfile(projectRoot, 'results', 'figures');
resultsTableDir = fullfile(projectRoot, 'results', 'tables');
if ~exist(resultsFigDir, 'dir')
    mkdir(resultsFigDir);
end
if ~exist(resultsTableDir, 'dir')
    mkdir(resultsTableDir);
end

%% 1. Physical parameters
c = 3e8;
fc = 2e9;
vmax = 100/3.6;
Ts = 1/3.84e6;
nu_Dmax = vmax * fc * Ts / c;         % Eq. (48)

Fbin = 15e3;
tau_max = 3.7e-6;
theta_max = tau_max * Fbin;

d_over_lambda = 0.5;
phi_min = -5*pi/180;
phi_max =  5*pi/180;
psi_min = -5*pi/180;
psi_max =  5*pi/180;

zeta_min = sin(phi_min) * d_over_lambda;
zeta_max = sin(phi_max) * d_over_lambda;
xi_min = sin(psi_min) * d_over_lambda;
xi_max = sin(psi_max) * d_over_lambda;

%% 2. Simulation size
M = 256;
Q = 64;
N_Tx = 4;
N_Rx = 4;
P = 80;

%% 3. MPC parameters inside the band-limiting region
eta = (randn(P,1) + 1j*randn(P,1)) / sqrt(2*P);
nu = (2*rand(P,1)-1) * nu_Dmax;
theta = rand(P,1) * theta_max;
zeta = zeta_min + (zeta_max-zeta_min) * rand(P,1);
xi = xi_min + (xi_max-xi_min) * rand(P,1);

%% 4. DPS dimensions and resolution factors
guard = 4;
D_t  = ceil(2*nu_Dmax*M) + 1 + guard;
D_f  = ceil(theta_max*Q) + 1 + guard;
D_tx = ceil((zeta_max-zeta_min)*N_Tx) + 1 + guard;
D_rx = ceil((xi_max-xi_min)*N_Rx) + 1 + guard;

D_t  = min(D_t, M);
D_f  = min(D_f, Q);
D_tx = min(D_tx, N_Tx);
D_rx = min(D_rx, N_Rx);

% The paper uses a resolution factor to improve the wave-function
% approximation. These values are modest for time and high for dimensions
% with wider normalized bandwidth.
r_t = 2;
r_f = 512;
r_tx = 512;
r_rx = 512;

%% 5. Original DPS bases and high-resolution bases for approximation
dim_t  = make_dps_dimension(M,    0,                         nu_Dmax,               D_t,  r_t);
dim_f  = make_dps_dimension(Q,   -theta_max/2,               theta_max/2,           D_f,  r_f);
dim_tx = make_dps_dimension(N_Tx,(zeta_min+zeta_max)/2,      (zeta_max-zeta_min)/2, D_tx, r_tx);
dim_rx = make_dps_dimension(N_Rx,-(xi_min+xi_max)/2,         (xi_max-xi_min)/2,     D_rx, r_rx);

%% 6. Reference SoCE channel
tic;
H_soce = compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx);
t_soce = toc;

%% 7. Exact DPS coefficients for comparison
tic;
alpha_exact = build_alpha_exact(eta, nu, theta, zeta, xi, dim_t, dim_f, dim_tx, dim_rx);
t_alpha_exact = toc;

tic;
H_exact = reconstruct_from_alpha(alpha_exact, dim_t.V, dim_f.V, dim_tx.V, dim_rx.V);
t_recon_exact = toc;

%% 8. Approximate DPS coefficients using Eq. (23)-(29)
tic;
alpha_approx_4d = build_alpha_approx_4d(eta, nu, theta, zeta, xi, dim_t, dim_f, dim_tx, dim_rx);
t_alpha_approx_4d = toc;

tic;
H_approx_4d = reconstruct_from_alpha(alpha_approx_4d, dim_t.V, dim_f.V, dim_tx.V, dim_rx.V);
t_recon_approx_4d = toc;

%% 9. Hybrid approximation recommended for wideband MIMO
% The paper notes that spatial DPS often gives little complexity reduction.
% This variant uses approximate DPS only in time/frequency and evaluates
% the spatial exponentials directly.
tic;
alpha_hybrid = build_alpha_approx_hybrid(eta, nu, theta, zeta, xi, dim_t, dim_f, N_Tx, N_Rx);
t_alpha_hybrid = toc;

tic;
H_hybrid = reconstruct_hybrid(alpha_hybrid, dim_t.V, dim_f.V);
t_recon_hybrid = toc;

%% 10. Metrics
err_exact = H_soce - H_exact;
err_approx_4d = H_soce - H_approx_4d;
err_hybrid = H_soce - H_hybrid;
err_hybrid_vs_exact = H_exact - H_hybrid;

mse_exact = mean(abs(err_exact(:)).^2);
nmse_exact = mse_exact / mean(abs(H_soce(:)).^2);
max_abs_err_exact = max(abs(err_exact(:)));

mse_approx_4d = mean(abs(err_approx_4d(:)).^2);
nmse_approx_4d = mse_approx_4d / mean(abs(H_soce(:)).^2);
max_abs_err_approx_4d = max(abs(err_approx_4d(:)));

mse_hybrid = mean(abs(err_hybrid(:)).^2);
nmse_hybrid = mse_hybrid / mean(abs(H_soce(:)).^2);
max_abs_err_hybrid = max(abs(err_hybrid(:)));

mse_hybrid_vs_exact = mean(abs(err_hybrid_vs_exact(:)).^2);
nmse_hybrid_vs_exact = mse_hybrid_vs_exact / mean(abs(H_exact(:)).^2);
max_abs_err_hybrid_vs_exact = max(abs(err_hybrid_vs_exact(:)));

fprintf('--- Approximate DPS wave-function projection ---\n');
fprintf('Kich thuoc H: %d x %d x %d x %d, P = %d MPC\n', M, Q, N_Tx, N_Rx, P);
fprintf('DPS dimensions: D_t=%d, D_f=%d, D_tx=%d, D_rx=%d, D_total=%d\n', ...
    D_t, D_f, D_tx, D_rx, D_t*D_f*D_tx*D_rx);
fprintf('Resolution factors: r_t=%d, r_f=%d, r_tx=%d, r_rx=%d\n', r_t, r_f, r_tx, r_rx);
fprintf('Exact DPS:  MSE=%.4e, NMSE=%.4e, Max |error|=%.4e\n', ...
    mse_exact, nmse_exact, max_abs_err_exact);
fprintf('Approx DPS 4D diagnostic: MSE=%.4e, NMSE=%.4e, Max |error|=%.4e\n', ...
    mse_approx_4d, nmse_approx_4d, max_abs_err_approx_4d);
fprintf('Hybrid approx TF + exact spatial: MSE=%.4e, NMSE=%.4e, Max |error|=%.4e\n', ...
    mse_hybrid, nmse_hybrid, max_abs_err_hybrid);
fprintf('Hybrid approx vs exact DPS: MSE=%.4e, NMSE=%.4e, Max |error|=%.4e\n', ...
    mse_hybrid_vs_exact, nmse_hybrid_vs_exact, max_abs_err_hybrid_vs_exact);
fprintf('Runtime SoCE                : %.4f s\n', t_soce);
fprintf('Runtime exact DPS alpha     : %.4f s\n', t_alpha_exact);
fprintf('Runtime exact DPS recon     : %.4f s\n', t_recon_exact);
fprintf('Runtime approx 4D alpha     : %.4f s\n', t_alpha_approx_4d);
fprintf('Runtime approx 4D recon     : %.4f s\n', t_recon_approx_4d);
fprintf('Runtime hybrid approx alpha : %.4f s\n', t_alpha_hybrid);
fprintf('Runtime hybrid approx recon : %.4f s\n', t_recon_hybrid);

metrics = table(M, Q, N_Tx, N_Rx, P, D_t, D_f, D_tx, D_rx, ...
    D_t*D_f*D_tx*D_rx, r_t, r_f, r_tx, r_rx, nu_Dmax, theta_max, ...
    mse_exact, nmse_exact, max_abs_err_exact, ...
    mse_approx_4d, nmse_approx_4d, max_abs_err_approx_4d, ...
    mse_hybrid, nmse_hybrid, max_abs_err_hybrid, ...
    mse_hybrid_vs_exact, nmse_hybrid_vs_exact, max_abs_err_hybrid_vs_exact, ...
    t_soce, t_alpha_exact, t_recon_exact, t_alpha_approx_4d, t_recon_approx_4d, ...
    t_alpha_hybrid, t_recon_hybrid, ...
    'VariableNames', {'M','Q','N_Tx','N_Rx','P','D_t','D_f','D_tx','D_rx', ...
    'D_total','r_t','r_f','r_tx','r_rx','nu_Dmax','theta_max', ...
    'mse_exact','nmse_exact','max_abs_err_exact', ...
    'mse_approx_4d','nmse_approx_4d','max_abs_err_approx_4d', ...
    'mse_hybrid','nmse_hybrid','max_abs_err_hybrid', ...
    'mse_hybrid_vs_exact','nmse_hybrid_vs_exact','max_abs_err_hybrid_vs_exact', ...
    'runtime_soce_s','runtime_exact_dps_alpha_s','runtime_exact_dps_recon_s', ...
    'runtime_approx_4d_alpha_s','runtime_approx_4d_recon_s', ...
    'runtime_hybrid_approx_alpha_s','runtime_hybrid_approx_recon_s'});
writetable(metrics, fullfile(resultsTableDir, 'mimo_dps_kaltenberger_approx_metrics.csv'));

%% 11. Diagnostic plot for Tx=1, Rx=1
fig = figure;
xSamples = 0:Q-1;
ySamples = 0:M-1;
responseMagnitude = cat(3, abs(H_soce(:,:,1,1)), ...
    abs(H_exact(:,:,1,1)), abs(H_hybrid(:,:,1,1)));
responseColorLimits = [min(responseMagnitude(:)), max(responseMagnitude(:))];

ax1 = subplot(2,2,1);
imagesc(xSamples, ySamples, abs(H_soce(:,:,1,1)));
axis xy; colorbar; grid on;
clim(responseColorLimits);
title('Biên độ SoCE');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax1);

ax2 = subplot(2,2,2);
imagesc(xSamples, ySamples, abs(H_exact(:,:,1,1)));
axis xy; colorbar; grid on;
clim(responseColorLimits);
title('Biên độ DPS chính xác');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax2);

ax3 = subplot(2,2,3);
imagesc(xSamples, ySamples, abs(H_hybrid(:,:,1,1)));
axis xy; colorbar; grid on;
clim(responseColorLimits);
title('Biên độ hybrid');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax3);

ax4 = subplot(2,2,4);
imagesc(xSamples, ySamples, abs(err_hybrid(:,:,1,1)));
axis xy; colorbar; grid on;
title('Sai số tuyệt đối SoCE - hybrid');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax4);

drawnow;
saveas(fig, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_approx_tx1_rx1.png'));
savefig(fig, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_approx_tx1_rx1.fig'));

%% 12. Bar charts for NMSE and runtime
figNmse = figure;
nmseValues = [nmse_exact, nmse_approx_4d, nmse_hybrid];
nmseBars = bar(nmseValues, 'FaceColor', 'flat');
nmseBars.CData = [0.00 0.45 0.74; 0.93 0.69 0.13; 0.47 0.67 0.19];
axNmse = gca;
set(axNmse, 'XTickLabel', {'Exact DPS', 'Approx 4D', 'Hybrid'});
set(axNmse, 'YScale', 'log');
grid on;
title('NMSE Comparison');
xlabel('Method');
ylabel('NMSE relative to SoCE');
legend('NMSE', 'Location', 'best');
disable_axes_toolbar(axNmse);
drawnow;
saveas(figNmse, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_approx_nmse_bar.png'));
savefig(figNmse, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_approx_nmse_bar.fig'));

figRuntime = figure;
runtimeValues = [t_soce, ...
    t_alpha_exact + t_recon_exact, ...
    t_alpha_approx_4d + t_recon_approx_4d, ...
    t_alpha_hybrid + t_recon_hybrid];
runtimeBars = bar(runtimeValues, 'FaceColor', 'flat');
runtimeBars.CData = [0.25 0.25 0.25; 0.00 0.45 0.74; ...
    0.93 0.69 0.13; 0.47 0.67 0.19];
axRuntime = gca;
set(axRuntime, 'XTickLabel', {'SoCE', 'Exact DPS', 'Approx 4D', 'Hybrid'});
grid on;
title('Runtime Comparison');
xlabel('Method');
ylabel('Runtime [s]');
legend('Runtime', 'Location', 'best');
disable_axes_toolbar(axRuntime);
drawnow;
saveas(figRuntime, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_approx_runtime_bar.png'));
savefig(figRuntime, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_approx_runtime_bar.fig'));

%% Local functions
function dim = make_dps_dimension(N, W0, Wmax, D, rFactor)
    [V, lambda] = shifted_dpss(N, W0, Wmax, D);
    [V_r, lambda_r] = shifted_dpss(rFactor*N, W0, Wmax/rFactor, D);
    V_r = align_highres_dps_signs(V, V_r, lambda_r, N, W0, Wmax, D, rFactor);

    dim.N = N;
    dim.W0 = W0;
    dim.Wmax = Wmax;
    dim.D = D;
    dim.r = rFactor;
    dim.V = V;
    dim.lambda = lambda;
    dim.V_r = V_r;
    dim.lambda_r = lambda_r;
end

function V_r = align_highres_dps_signs(V, V_r, lambda_r, N, W0, Wmax, D, rFactor)
    if Wmax <= 0
        return;
    end

    n = (0:N-1).';
    calibrationOffsets = [-0.8, -0.4, 0, 0.4, 0.8] * Wmax;
    for k = 1:D
        correlation = 0;
        for offset = calibrationOffsets
            frequency = W0 + offset;
            exactValue = V(:, k)' * exp(1j*2*pi*frequency*n);
            approxValue = approximate_gamma_column(frequency, k, N, W0, Wmax, ...
                rFactor, V_r, lambda_r);
            correlation = correlation + conj(approxValue) * exactValue;
        end

        if real(correlation) < 0
            V_r(:, k) = -V_r(:, k);
        end
    end
end

function gammaValue = approximate_gamma_column(frequency, columnIndex, N, W0, Wmax, rFactor, V_r, lambda_r)
    centeredFrequency = frequency - W0;
    N_r = rFactor * N;
    Wmax_r = Wmax / rFactor;
    f_query = centeredFrequency / rFactor;
    mp = floor((1 + f_query / Wmax_r) * N_r / 2);
    mp = max(0, min(mp, N_r - 1));

    d = columnIndex - 1;
    if mod(d, 2) == 0
        epsilon = 1;
    else
        epsilon = 1j;
    end

    v_mp = V_r(mp + 1, columnIndex) * exp(-1j*2*pi*W0*mp);
    scale = sqrt(real(lambda_r(columnIndex)) * N / (2*Wmax_r));
    phase = exp(1j*pi*(N - 1) * centeredFrequency);
    gammaValue = phase * scale * v_mp / epsilon;
end

function alpha = build_alpha_exact(eta, nu, theta, zeta, xi, dim_t, dim_f, dim_tx, dim_rx)
    P = numel(eta);
    alpha = zeros(dim_t.D, dim_f.D, dim_tx.D, dim_rx.D);

    m = (0:dim_t.N-1).';
    q = (0:dim_f.N-1).';
    s = (0:dim_tx.N-1).';
    r = (0:dim_rx.N-1).';

    E_t  = exp( 1j*2*pi * (m * nu.'));
    E_f  = exp(-1j*2*pi * (q * theta.'));
    E_tx = exp( 1j*2*pi * (s * zeta.'));
    E_rx = exp(-1j*2*pi * (r * xi.'));

    Gamma_t  = dim_t.V'  * E_t;
    Gamma_f  = dim_f.V'  * E_f;
    Gamma_tx = dim_tx.V' * E_tx;
    Gamma_rx = dim_rx.V' * E_rx;

    for p = 1:P
        alpha = alpha + eta(p) .* outer4(Gamma_t(:,p), Gamma_f(:,p), ...
            Gamma_tx(:,p), Gamma_rx(:,p));
    end
end

function alpha = build_alpha_approx_4d(eta, nu, theta, zeta, xi, dim_t, dim_f, dim_tx, dim_rx)
    P = numel(eta);
    alpha = zeros(dim_t.D, dim_f.D, dim_tx.D, dim_rx.D);

    for p = 1:P
        % Effective frequencies must follow the signs in Eq. (47).
        gamma_t  = approximate_gamma_1d(nu(p),     dim_t);
        gamma_f  = approximate_gamma_1d(-theta(p), dim_f);
        gamma_tx = approximate_gamma_1d(zeta(p),   dim_tx);
        gamma_rx = approximate_gamma_1d(-xi(p),    dim_rx);

        alpha = alpha + eta(p) .* outer4(gamma_t, gamma_f, gamma_tx, gamma_rx);
    end
end

function alpha = build_alpha_approx_hybrid(eta, nu, theta, zeta, xi, dim_t, dim_f, N_Tx, N_Rx)
    P = numel(eta);
    alpha = zeros(dim_t.D, dim_f.D, N_Tx, N_Rx);
    s = (0:N_Tx-1).';
    r = (0:N_Rx-1).';

    for p = 1:P
        gamma_t = approximate_gamma_1d(nu(p), dim_t);
        gamma_f = approximate_gamma_1d(-theta(p), dim_f);
        e_tx = exp(1j*2*pi*zeta(p) * s);
        e_rx = exp(-1j*2*pi*xi(p) * r);

        alpha = alpha + eta(p) .* outer4(gamma_t, gamma_f, e_tx, e_rx);
    end
end

function H = reconstruct_hybrid(alpha, V_t, V_f)
    H = mode_product(alpha, V_t, 1);
    H = mode_product(H, V_f, 2);
end

function gamma = approximate_gamma_1d(frequency, dim)
    % Eq. (23): evaluate the approximate wave function on a higher
    % resolution grid while preserving the relative position in the band.
    centeredFrequency = frequency - dim.W0;
    f_query = centeredFrequency / dim.r;
    N_r = dim.r * dim.N;
    Wmax_r = dim.Wmax / dim.r;

    if Wmax_r <= 0
        gamma = sqrt(dim.N);
        return;
    end

    relativePosition = f_query / Wmax_r;
    mp = floor((1 + relativePosition) * N_r / 2);
    mp = max(0, min(mp, N_r - 1));

    d = (0:dim.D-1).';
    epsilon = ones(dim.D, 1);
    epsilon(mod(d, 2) == 1) = 1j;

    % Eq. (24) and Eq. (29), adapted to MATLAB's unit-energy DPSS vectors.
    % The shifted carrier is removed because V' * exp(j2*pi*f*n) equals
    % the centered DPSS projection at f-W0.
    v_mp = (dim.V_r(mp + 1, :) .* exp(-1j*2*pi*dim.W0*mp)).';
    scale = sqrt(real(dim.lambda_r(:)) * dim.N / (2*Wmax_r));
    phase = exp(1j*pi*(dim.N - 1) * centeredFrequency);

    gamma = phase .* scale .* v_mp ./ epsilon;
end

function gamma_tensor = outer4(gamma_t, gamma_f, gamma_tx, gamma_rx)
    gamma_tensor = bsxfun(@times, reshape(gamma_t,  [], 1,  1,  1), ...
                                  reshape(gamma_f,  1, [], 1,  1));
    gamma_tensor = bsxfun(@times, gamma_tensor, reshape(gamma_tx, 1, 1, [], 1));
    gamma_tensor = bsxfun(@times, gamma_tensor, reshape(gamma_rx, 1, 1, 1, []));
end

function H = reconstruct_from_alpha(alpha, V_t, V_f, V_tx, V_rx)
    H = mode_product(alpha, V_t, 1);
    H = mode_product(H, V_f, 2);
    H = mode_product(H, V_tx, 3);
    H = mode_product(H, V_rx, 4);
end

function [V, lambda] = shifted_dpss(N, W0, Wmax, D)
    if Wmax <= 0
        V = ones(N,1) / sqrt(N);
        V = V(:,1:min(D,1));
        lambda = 1;
        return;
    end

    NW = N * Wmax;
    if NW >= N/2
        error('Wmax must be smaller than 0.5 for discrete-time sampling.');
    end

    if exist('dpss', 'file') == 2
        try
            [V_sym, lambda] = dpss(N, NW, D);
        catch
            [V_sym, lambda] = dpss_by_eig(N, Wmax, D);
        end
    else
        [V_sym, lambda] = dpss_by_eig(N, Wmax, D);
    end

    V_sym = normalize_dpss_wave_signs(V_sym);

    n = (0:N-1).';
    V = V_sym .* exp(1j*2*pi*W0*n);
end

function V = normalize_dpss_wave_signs(V)
    % Match the wave-function sign convention in Eq. (25).
    N = size(V, 1);
    D = size(V, 2);
    center = floor(N/2) + 1;

    for k = 1:D
        d = k - 1;
        if mod(d, 2) == 0
            signRef = real(V(center, k));
        elseif center > 1 && center < N
            signRef = real(V(center + 1, k) - V(center - 1, k));
        else
            signRef = real(V(min(center + 1, N), k));
        end

        if signRef < 0
            V(:, k) = -V(:, k);
        end
    end
end

function [V, lambda] = dpss_by_eig(N, Wmax, D)
    n = (0:N-1).';
    delta = n - n.';
    K = zeros(N, N);
    K(delta == 0) = 2 * Wmax;
    idx = delta ~= 0;
    K(idx) = sin(2*pi*Wmax*delta(idx)) ./ (pi*delta(idx));

    [U, Lambda] = eig((K + K')/2, 'vector');
    [lambda, order] = sort(real(Lambda), 'descend');
    V = U(:, order(1:D));
    lambda = lambda(1:D);

    for k = 1:D
        [~, imax] = max(abs(V(:,k)));
        if real(V(imax,k)) < 0
            V(:,k) = -V(:,k);
        end
    end
end

function Y = mode_product(X, A, mode)
    % Multiply tensor X by matrix A along the selected mode.
    sz = size(X);
    order = [mode, 1:mode-1, mode+1:ndims(X)];
    X_perm = permute(X, order);
    X_mat = reshape(X_perm, sz(mode), []);

    Y_mat = A * X_mat;
    new_sz = sz;
    new_sz(mode) = size(A, 1);
    Y_perm = reshape(Y_mat, new_sz(order));
    Y = ipermute(Y_perm, order);
end

function disable_axes_toolbar(ax)
    % Hide interactive axes toolbar before exporting figures.
    if isprop(ax, 'Toolbar') && ~isempty(ax.Toolbar)
        ax.Toolbar.Visible = 'off';
    end
end

function H = compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx)
    P = numel(eta);
    m = (0:M-1).';
    q = (0:Q-1).';
    s = (0:N_Tx-1).';
    r = (0:N_Rx-1).';

    H = zeros(M, Q, N_Tx, N_Rx);
    for p = 1:P
        e_t  = reshape(exp( 1j*2*pi*nu(p)    * m), M, 1, 1, 1);
        e_f  = reshape(exp(-1j*2*pi*theta(p) * q), 1, Q, 1, 1);
        e_tx = reshape(exp( 1j*2*pi*zeta(p)  * s), 1, 1, N_Tx, 1);
        e_rx = reshape(exp(-1j*2*pi*xi(p)    * r), 1, 1, 1, N_Rx);

        term = bsxfun(@times, e_t, e_f);
        term = bsxfun(@times, term, e_tx);
        term = bsxfun(@times, term, e_rx);
        H = H + eta(p) .* term;
    end
end
