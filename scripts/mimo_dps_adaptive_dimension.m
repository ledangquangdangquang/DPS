%% Automatic DPS-dimension selection for the wideband MIMO GCM
% Based on Eq. (35) and Eq. (38) in Kaltenberger et al. (2007).
%
% Purpose:
%   Select the smallest DPS dimension in each of the four channel
%   dimensions from a prescribed total square-bias target, then verify the
%   selected subspace against the direct SoCE channel on one reproducible
%   MPC realization. Exact DPS projection is used to isolate truncation
%   error from the wave-function coefficient approximation error.

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

%% 1. Physical parameters and simulation size
c = 3e8;
fc = 2e9;
vmax = 100/3.6;
Ts = 1/3.84e6;
nu_Dmax = vmax * fc * Ts / c;  % Paper Eq. (48)

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

M = 256;
Q = 64;
N_Tx = 4;
N_Rx = 4;
P = 80;

%% 2. Full one-dimensional DPS eigensystems
% The shifted carrier changes the eigenvectors but not the eigenvalues.
tic;
[V_t_all, lambda_t] = shifted_dpss_full(M, 0, nu_Dmax);
[V_f_all, lambda_f] = shifted_dpss_full(Q, -theta_max/2, theta_max/2);
[V_tx_all, lambda_tx] = shifted_dpss_full(N_Tx, ...
    (zeta_min+zeta_max)/2, (zeta_max-zeta_min)/2);
[V_rx_all, lambda_rx] = shifted_dpss_full(N_Rx, ...
    -(xi_min+xi_max)/2, (xi_max-xi_min)/2);
runtimeEigensystemsS = toc;

%% 3. Automatic dimension selection
% The total design target is divided equally among the four dimensions.
% This is a conservative engineering allocation used to extend the
% one-dimensional paper criterion to the separable 4D implementation.
totalBiasTargets = [1e-2; 1e-4; 1e-6; 1e-8];
numTargets = numel(totalBiasTargets);
numDimensions = 4;

selectionMode = strings(numTargets + 1, 1);
targetBiasTotal = nan(numTargets + 1, 1);
targetBiasPerDimension = nan(numTargets + 1, 1);
D_t = zeros(numTargets + 1, 1);
D_f = zeros(numTargets + 1, 1);
D_tx = zeros(numTargets + 1, 1);
D_rx = zeros(numTargets + 1, 1);

tic;
for k = 1:numTargets
    perDimensionTarget = totalBiasTargets(k) / numDimensions;
    selectionMode(k) = "adaptive";
    targetBiasTotal(k) = totalBiasTargets(k);
    targetBiasPerDimension(k) = perDimensionTarget;
    D_t(k) = select_dps_dimension(lambda_t, M, nu_Dmax, perDimensionTarget);
    D_f(k) = select_dps_dimension(lambda_f, Q, theta_max/2, perDimensionTarget);
    D_tx(k) = select_dps_dimension(lambda_tx, N_Tx, ...
        (zeta_max-zeta_min)/2, perDimensionTarget);
    D_rx(k) = select_dps_dimension(lambda_rx, N_Rx, ...
        (xi_max-xi_min)/2, perDimensionTarget);
end

% Existing fixed guard-dimension rule for comparison.
guard = 4;
selectionMode(end) = "fixed_guard_4";
D_t(end) = min(ceil(2*nu_Dmax*M) + 1 + guard, M);
D_f(end) = min(ceil(theta_max*Q) + 1 + guard, Q);
D_tx(end) = min(ceil((zeta_max-zeta_min)*N_Tx) + 1 + guard, N_Tx);
D_rx(end) = min(ceil((xi_max-xi_min)*N_Rx) + 1 + guard, N_Rx);
runtimeDimensionSelectionS = toc;

%% 4. Direct SoCE reference and exact DPS verification over multiple seeds
numSeeds = 20;
numCases = numTargets + 1;
D_total = D_t .* D_f .* D_tx .* D_rx;
bias_t = zeros(numCases, 1);
bias_f = zeros(numCases, 1);
bias_tx = zeros(numCases, 1);
bias_rx = zeros(numCases, 1);
bias_sum_indicator = zeros(numCases, 1);
V_t_cases = cell(numCases, 1);
V_f_cases = cell(numCases, 1);
V_tx_cases = cell(numCases, 1);
V_rx_cases = cell(numCases, 1);

for k = 1:numCases
    bias_t(k) = paper_bias_from_eigenvalues(lambda_t, D_t(k), M, nu_Dmax);
    bias_f(k) = paper_bias_from_eigenvalues(lambda_f, D_f(k), Q, theta_max/2);
    bias_tx(k) = paper_bias_from_eigenvalues(lambda_tx, D_tx(k), N_Tx, ...
        (zeta_max-zeta_min)/2);
    bias_rx(k) = paper_bias_from_eigenvalues(lambda_rx, D_rx(k), N_Rx, ...
        (xi_max-xi_min)/2);
    bias_sum_indicator(k) = bias_t(k) + bias_f(k) + bias_tx(k) + bias_rx(k);

    V_t_cases{k} = V_t_all(:, 1:D_t(k));
    V_f_cases{k} = V_f_all(:, 1:D_f(k));
    V_tx_cases{k} = V_tx_all(:, 1:D_tx(k));
    V_rx_cases{k} = V_rx_all(:, 1:D_rx(k));
end

nmseRaw = zeros(numSeeds, numCases);
maxAbsErrorRaw = zeros(numSeeds, numCases);
runtimeAlphaRaw = zeros(numSeeds, numCases);
runtimeReconstructionRaw = zeros(numSeeds, numCases);

for seed = 1:numSeeds
    rng(seed);
    eta = (randn(P,1) + 1j*randn(P,1)) / sqrt(2*P);
    nu = (2*rand(P,1)-1) * nu_Dmax;
    theta = rand(P,1) * theta_max;
    zeta = zeta_min + (zeta_max-zeta_min) * rand(P,1);
    xi = xi_min + (xi_max-xi_min) * rand(P,1);

    H_soce = compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx);
    referencePower = mean(abs(H_soce(:)).^2);

    for k = 1:numCases
        tic;
        alpha = build_alpha_exact(eta, nu, theta, zeta, xi, ...
            V_t_cases{k}, V_f_cases{k}, V_tx_cases{k}, V_rx_cases{k});
        runtimeAlphaRaw(seed, k) = toc;

        tic;
        H_exact = reconstruct_from_alpha(alpha, V_t_cases{k}, ...
            V_f_cases{k}, V_tx_cases{k}, V_rx_cases{k});
        runtimeReconstructionRaw(seed, k) = toc;

        errorTensor = H_soce - H_exact;
        nmseRaw(seed, k) = mean(abs(errorTensor(:)).^2) / referencePower;
        maxAbsErrorRaw(seed, k) = max(abs(errorTensor(:)));
    end
end

nmse_exact_q1 = row_quantile(nmseRaw, 0.25).';
nmse_exact_median = row_quantile(nmseRaw, 0.50).';
nmse_exact_q3 = row_quantile(nmseRaw, 0.75).';
max_abs_err_exact_median = row_quantile(maxAbsErrorRaw, 0.50).';
runtime_alpha_median_s = row_quantile(runtimeAlphaRaw, 0.50).';
runtime_reconstruction_median_s = row_quantile(runtimeReconstructionRaw, 0.50).';

%% 5. Save reproducible numerical results
metrics = table(selectionMode, targetBiasTotal, targetBiasPerDimension, ...
    D_t, D_f, D_tx, D_rx, D_total, ...
    bias_t, bias_f, bias_tx, bias_rx, bias_sum_indicator, ...
    nmse_exact_q1, nmse_exact_median, nmse_exact_q3, ...
    max_abs_err_exact_median, runtime_alpha_median_s, ...
    runtime_reconstruction_median_s, ...
    repmat(runtimeEigensystemsS, numCases, 1), ...
    repmat(runtimeDimensionSelectionS, numCases, 1), ...
    repmat(numSeeds, numCases, 1), ...
    repmat(M, numCases, 1), repmat(Q, numCases, 1), ...
    repmat(N_Tx, numCases, 1), repmat(N_Rx, numCases, 1), ...
    repmat(P, numCases, 1), repmat(nu_Dmax, numCases, 1), ...
    repmat(theta_max, numCases, 1), ...
    'VariableNames', {'selection_mode','target_bias_total', ...
    'target_bias_per_dimension','D_t','D_f','D_tx','D_rx','D_total', ...
    'paper_bias_t','paper_bias_f','paper_bias_tx','paper_bias_rx', ...
    'paper_bias_sum_indicator','nmse_exact_q1','nmse_exact_median', ...
    'nmse_exact_q3','max_abs_err_exact_median','runtime_alpha_median_s', ...
    'runtime_reconstruction_median_s','runtime_eigensystems_s', ...
    'runtime_dimension_selection_s','num_seeds','M','Q','N_Tx','N_Rx', ...
    'P','nu_Dmax','theta_max'});

outputTable = fullfile(resultsTableDir, ...
    'mimo_dps_kaltenberger_adaptive_dimension_metrics.csv');
writetable(metrics, outputTable);
disp(metrics);

%% 6. Verification figure
adaptiveRows = 1:numTargets;
fig = figure;
errorbar(targetBiasTotal(adaptiveRows), nmse_exact_median(adaptiveRows), ...
    nmse_exact_median(adaptiveRows)-nmse_exact_q1(adaptiveRows), ...
    nmse_exact_q3(adaptiveRows)-nmse_exact_median(adaptiveRows), ...
    'o-', 'LineWidth', 1.5, 'MarkerSize', 7);
hold on;
loglog(targetBiasTotal(adaptiveRows), targetBiasTotal(adaptiveRows), ...
    '--', 'LineWidth', 1.2);
grid on;
set(gca, 'XScale', 'log', 'YScale', 'log');
xlabel('Total design square-bias target');
ylabel('Exact-DPS NMSE relative to SoCE');
title('Automatic DPS-dimension verification');
legend('Median NMSE and interquartile range', 'Target reference', ...
    'Location', 'best');
set(gca, 'XDir', 'reverse');
disable_axes_toolbar(gca);
drawnow;
saveas(fig, fullfile(resultsFigDir, ...
    'mimo_dps_kaltenberger_adaptive_dimension_nmse.png'));
savefig(fig, fullfile(resultsFigDir, ...
    'mimo_dps_kaltenberger_adaptive_dimension_nmse.fig'));

fprintf('Saved metrics: %s\n', outputTable);

%% Local functions
function D = select_dps_dimension(lambda, N, Wmax, targetBias)
    % Paper Eq. (35) and Eq. (38): retain the smallest number of DPS
    % vectors whose omitted-eigenvalue bias is below the target.
    for candidate = 1:N
        if paper_bias_from_eigenvalues(lambda, candidate, N, Wmax) <= targetBias
            D = candidate;
            return;
        end
    end
    D = N;
end

function biasSquared = paper_bias_from_eigenvalues(lambda, D, N, Wmax)
    if D >= N || Wmax <= 0
        biasSquared = 0;
        return;
    end
    omittedEigenvalueSum = sum(max(real(lambda(D+1:end)), 0));
    biasSquared = omittedEigenvalueSum / (N * Wmax);
end

function [V, lambda] = shifted_dpss_full(N, W0, Wmax)
    if Wmax <= 0
        V = eye(N);
        lambda = [1; zeros(N-1, 1)];
        return;
    end
    if Wmax >= 0.5
        error('Wmax must be smaller than 0.5 for discrete-time sampling.');
    end

    n = (0:N-1).';
    delta = n - n.';
    concentrationMatrix = zeros(N, N);
    concentrationMatrix(delta == 0) = 2 * Wmax;
    nonzero = delta ~= 0;
    concentrationMatrix(nonzero) = ...
        sin(2*pi*Wmax*delta(nonzero)) ./ (pi*delta(nonzero));

    [Vcentered, eigenvalueMatrix] = eig( ...
        (concentrationMatrix + concentrationMatrix')/2, 'vector');
    [lambda, order] = sort(real(eigenvalueMatrix), 'descend');
    Vcentered = Vcentered(:, order);

    for k = 1:N
        [~, maximumIndex] = max(abs(Vcentered(:, k)));
        if real(Vcentered(maximumIndex, k)) < 0
            Vcentered(:, k) = -Vcentered(:, k);
        end
    end

    V = Vcentered .* exp(1j*2*pi*W0*n);
end

function alpha = build_alpha_exact(eta, nu, theta, zeta, xi, V_t, V_f, V_tx, V_rx)
    P = numel(eta);
    alpha = zeros(size(V_t,2), size(V_f,2), size(V_tx,2), size(V_rx,2));

    m = (0:size(V_t,1)-1).';
    q = (0:size(V_f,1)-1).';
    s = (0:size(V_tx,1)-1).';
    r = (0:size(V_rx,1)-1).';

    Gamma_t = V_t' * exp(1j*2*pi * (m * nu.'));
    Gamma_f = V_f' * exp(-1j*2*pi * (q * theta.'));
    Gamma_tx = V_tx' * exp(1j*2*pi * (s * zeta.'));
    Gamma_rx = V_rx' * exp(-1j*2*pi * (r * xi.'));

    for p = 1:P
        alpha = alpha + eta(p) .* outer4(Gamma_t(:,p), Gamma_f(:,p), ...
            Gamma_tx(:,p), Gamma_rx(:,p));
    end
end

function tensor = outer4(a, b, c, d)
    tensor = bsxfun(@times, reshape(a, [], 1, 1, 1), reshape(b, 1, [], 1, 1));
    tensor = bsxfun(@times, tensor, reshape(c, 1, 1, [], 1));
    tensor = bsxfun(@times, tensor, reshape(d, 1, 1, 1, []));
end

function H = reconstruct_from_alpha(alpha, V_t, V_f, V_tx, V_rx)
    H = mode_product(alpha, V_t, 1);
    H = mode_product(H, V_f, 2);
    H = mode_product(H, V_tx, 3);
    H = mode_product(H, V_rx, 4);
end

function Y = mode_product(X, A, mode)
    sz = size(X);
    order = [mode, 1:mode-1, mode+1:ndims(X)];
    Xpermuted = permute(X, order);
    Xmatrix = reshape(Xpermuted, sz(mode), []);
    Ymatrix = A * Xmatrix;
    newSize = sz;
    newSize(mode) = size(A, 1);
    Ypermuted = reshape(Ymatrix, newSize(order));
    Y = ipermute(Ypermuted, order);
end

function H = compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx)
    P = numel(eta);
    m = (0:M-1).';
    q = (0:Q-1).';
    s = (0:N_Tx-1).';
    r = (0:N_Rx-1).';

    E_t = exp(1j*2*pi * (m * nu.'));
    E_f = exp(-1j*2*pi * (q * theta.'));
    E_tx = exp(1j*2*pi * (s * zeta.'));
    E_rx = exp(-1j*2*pi * (r * xi.'));

    H = zeros(M, Q, N_Tx, N_Rx);
    for p = 1:P
        H = H + eta(p) .* outer4(E_t(:,p), E_f(:,p), E_tx(:,p), E_rx(:,p));
    end
end

function disable_axes_toolbar(ax)
    if isprop(ax, 'Toolbar') && ~isempty(ax.Toolbar)
        ax.Toolbar.Visible = 'off';
    end
end

function values = row_quantile(X, probability)
    % Toolbox-independent quantile along the first dimension.
    sortedValues = sort(X, 1);
    sampleCount = size(sortedValues, 1);
    position = 1 + (sampleCount - 1) * probability;
    lowerIndex = floor(position);
    upperIndex = ceil(position);
    weight = position - lowerIndex;
    values = (1-weight) .* sortedValues(lowerIndex, :) + ...
        weight .* sortedValues(upperIndex, :);
end
