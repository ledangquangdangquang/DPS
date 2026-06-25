%% Sweep number of MPCs for SoCE, exact DPS, and hybrid approximate DPS
% Based on Kaltenberger, Zemen, Ueberhuber, "Low-Complexity
% Geometry-Based MIMO Channel Simulation", EURASIP JASP, 2007.
%
% This script is a reproduction-extension experiment. It studies how the
% number of multipath components P affects runtime and approximation error.
%
% Model, Eq. (47):
%   h(m,q,s,r) = sum_p eta_p exp(j*2*pi*(nu_p*m - theta_p*q
%                         + zeta_p*s - xi_p*r)).

clear; clc; close all;

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

%% 2. Simulation size and P sweep
M = 256;
Q = 64;
N_Tx = 4;
N_Rx = 4;

P_list = [10 20 40 80 160 320].';
P_max = max(P_list);
seeds = (1:20).';
numSeeds = numel(seeds);
timingSeed = 1;
numTimingRepeats = 10;
matlabVersion = version;

%% 3. DPS dimensions and resolution factors
guard = 4;
D_t  = ceil(2*nu_Dmax*M) + 1 + guard;
D_f  = ceil(theta_max*Q) + 1 + guard;
D_tx = ceil((zeta_max-zeta_min)*N_Tx) + 1 + guard;
D_rx = ceil((xi_max-xi_min)*N_Rx) + 1 + guard;

D_t  = min(D_t, M);
D_f  = min(D_f, Q);
D_tx = min(D_tx, N_Tx);
D_rx = min(D_rx, N_Rx);

% Same resolution factors used in the approximate DPS diagnostic script.
r_t = 2;
r_f = 512;

dim_t  = make_dps_dimension(M, 0, nu_Dmax, D_t, r_t);
dim_f  = make_dps_dimension(Q, -theta_max/2, theta_max/2, D_f, r_f);
dim_tx = make_dps_dimension(N_Tx, (zeta_min+zeta_max)/2, ...
    (zeta_max-zeta_min)/2, D_tx, 1);
dim_rx = make_dps_dimension(N_Rx, -(xi_min+xi_max)/2, ...
    (xi_max-xi_min)/2, D_rx, 1);

%% 4. NMSE experiment: independent nested MPC pool for each seed
% Within one seed, the first P physical MPC parameters are reused at each
% P level. However, eta is renormalized by sqrt(2*P) at every P level.
% Therefore this is a power-normalized family of nested MPC scenarios, not
% the incremental addition of MPCs to one otherwise unchanged channel.
numP = numel(P_list);
numNmseRows = numP * numSeeds;
rawP = repelem(P_list, numSeeds);
rawSeed = repmat(seeds, numP, 1);
mseExactRaw = zeros(numNmseRows, 1);
nmseExactRaw = zeros(numNmseRows, 1);
maxAbsErrExactRaw = zeros(numNmseRows, 1);
mseHybridRaw = zeros(numNmseRows, 1);
nmseHybridRaw = zeros(numNmseRows, 1);
maxAbsErrHybridRaw = zeros(numNmseRows, 1);

fprintf('--- P sweep: SoCE vs exact DPS vs hybrid approximate DPS ---\n');
fprintf('H size: %d x %d x %d x %d\n', M, Q, N_Tx, N_Rx);
fprintf('DPS dimensions: D_t=%d, D_f=%d, D_tx=%d, D_rx=%d\n', ...
    D_t, D_f, D_tx, D_rx);
fprintf('NMSE seeds: %d | timing repeats: %d | timing seed: %d\n', ...
    numSeeds, numTimingRepeats, timingSeed);

for idxSeed = 1:numSeeds
    seed = seeds(idxSeed);
    rng(seed);
    [etaRaw, nuAll, thetaAll, zetaAll, xiAll] = generate_mpc_pool( ...
        P_max, nu_Dmax, theta_max, zeta_min, zeta_max, xi_min, xi_max);

    for idxP = 1:numP
        P = P_list(idxP);
        row = (idxP - 1) * numSeeds + idxSeed;
        eta = etaRaw(1:P) / sqrt(2*P);
        nu = nuAll(1:P);
        theta = thetaAll(1:P);
        zeta = zetaAll(1:P);
        xi = xiAll(1:P);

        caseResult = run_mimo_dps_case(eta, nu, theta, zeta, xi, ...
            M, Q, N_Tx, N_Rx, dim_t, dim_f, dim_tx, dim_rx);
        mseExactRaw(row) = caseResult.mseExact;
        nmseExactRaw(row) = caseResult.nmseExact;
        maxAbsErrExactRaw(row) = caseResult.maxAbsErrExact;
        mseHybridRaw(row) = caseResult.mseHybrid;
        nmseHybridRaw(row) = caseResult.nmseHybrid;
        maxAbsErrHybridRaw(row) = caseResult.maxAbsErrHybrid;
    end
    fprintf('Completed NMSE seed %d/%d.\n', idxSeed, numSeeds);
end

%% 5. Runtime experiment: fixed data, warm-up, then repeated measurement
rng(timingSeed);
[etaRaw, nuAll, thetaAll, zetaAll, xiAll] = generate_mpc_pool( ...
    P_max, nu_Dmax, theta_max, zeta_min, zeta_max, xi_min, xi_max);

numTimingRows = numP * numTimingRepeats;
timingP = repelem(P_list, numTimingRepeats);
timingRepeat = repmat((1:numTimingRepeats).', numP, 1);
runtimeSoceRaw = zeros(numTimingRows, 1);
runtimeExactAlphaRaw = zeros(numTimingRows, 1);
runtimeExactReconRaw = zeros(numTimingRows, 1);
runtimeHybridAlphaRaw = zeros(numTimingRows, 1);
runtimeHybridReconRaw = zeros(numTimingRows, 1);

for idxP = 1:numP
    P = P_list(idxP);
    eta = etaRaw(1:P) / sqrt(2*P);
    nu = nuAll(1:P);
    theta = thetaAll(1:P);
    zeta = zetaAll(1:P);
    xi = xiAll(1:P);

    % Warm up each measured block. DPS basis construction is excluded.
    compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx);
    alphaExact = build_alpha_exact(eta, nu, theta, zeta, xi, ...
        dim_t, dim_f, dim_tx, dim_rx);
    reconstruct_from_alpha(alphaExact, dim_t.V, dim_f.V, dim_tx.V, dim_rx.V);
    alphaHybrid = build_alpha_approx_hybrid(eta, nu, theta, zeta, xi, ...
        dim_t, dim_f, N_Tx, N_Rx);
    reconstruct_hybrid(alphaHybrid, dim_t.V, dim_f.V);

    for k = 1:numTimingRepeats
        row = (idxP - 1) * numTimingRepeats + k;
        tic;
        compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx);
        runtimeSoceRaw(row) = toc;

        tic;
        alphaExact = build_alpha_exact(eta, nu, theta, zeta, xi, ...
            dim_t, dim_f, dim_tx, dim_rx);
        runtimeExactAlphaRaw(row) = toc;
        tic;
        reconstruct_from_alpha(alphaExact, dim_t.V, dim_f.V, dim_tx.V, dim_rx.V);
        runtimeExactReconRaw(row) = toc;

        tic;
        alphaHybrid = build_alpha_approx_hybrid(eta, nu, theta, zeta, xi, ...
            dim_t, dim_f, N_Tx, N_Rx);
        runtimeHybridAlphaRaw(row) = toc;
        tic;
        reconstruct_hybrid(alphaHybrid, dim_t.V, dim_f.V);
        runtimeHybridReconRaw(row) = toc;
    end
end
runtimeExactTotalRaw = runtimeExactAlphaRaw + runtimeExactReconRaw;
runtimeHybridTotalRaw = runtimeHybridAlphaRaw + runtimeHybridReconRaw;

%% 6. Summarize and save raw/summary tables
nmseExactQ1 = zeros(numP, 1);
nmseExactMedian = zeros(numP, 1);
nmseExactQ3 = zeros(numP, 1);
nmseHybridQ1 = zeros(numP, 1);
nmseHybridMedian = zeros(numP, 1);
nmseHybridQ3 = zeros(numP, 1);
runtimeSoceQ1 = zeros(numP, 1);
runtimeSoceMedian = zeros(numP, 1);
runtimeSoceQ3 = zeros(numP, 1);
runtimeExactAlphaMedian = zeros(numP, 1);
runtimeExactReconMedian = zeros(numP, 1);
runtimeExactTotalQ1 = zeros(numP, 1);
runtimeExactTotalMedian = zeros(numP, 1);
runtimeExactTotalQ3 = zeros(numP, 1);
runtimeHybridAlphaMedian = zeros(numP, 1);
runtimeHybridReconMedian = zeros(numP, 1);
runtimeHybridTotalQ1 = zeros(numP, 1);
runtimeHybridTotalMedian = zeros(numP, 1);
runtimeHybridTotalQ3 = zeros(numP, 1);
for idxP = 1:numP
    idxNmse = rawP == P_list(idxP);
    idxTiming = timingP == P_list(idxP);
    exactNmseQuartiles = quantile(nmseExactRaw(idxNmse), [0.25 0.50 0.75]);
    hybridNmseQuartiles = quantile(nmseHybridRaw(idxNmse), [0.25 0.50 0.75]);
    soceRuntimeQuartiles = quantile(runtimeSoceRaw(idxTiming), [0.25 0.50 0.75]);
    exactRuntimeQuartiles = quantile(runtimeExactTotalRaw(idxTiming), [0.25 0.50 0.75]);
    hybridRuntimeQuartiles = quantile(runtimeHybridTotalRaw(idxTiming), [0.25 0.50 0.75]);

    nmseExactQ1(idxP) = exactNmseQuartiles(1);
    nmseExactMedian(idxP) = exactNmseQuartiles(2);
    nmseExactQ3(idxP) = exactNmseQuartiles(3);
    nmseHybridQ1(idxP) = hybridNmseQuartiles(1);
    nmseHybridMedian(idxP) = hybridNmseQuartiles(2);
    nmseHybridQ3(idxP) = hybridNmseQuartiles(3);
    runtimeSoceQ1(idxP) = soceRuntimeQuartiles(1);
    runtimeSoceMedian(idxP) = soceRuntimeQuartiles(2);
    runtimeSoceQ3(idxP) = soceRuntimeQuartiles(3);
    runtimeExactAlphaMedian(idxP) = median(runtimeExactAlphaRaw(idxTiming));
    runtimeExactReconMedian(idxP) = median(runtimeExactReconRaw(idxTiming));
    runtimeExactTotalQ1(idxP) = exactRuntimeQuartiles(1);
    runtimeExactTotalMedian(idxP) = exactRuntimeQuartiles(2);
    runtimeExactTotalQ3(idxP) = exactRuntimeQuartiles(3);
    runtimeHybridAlphaMedian(idxP) = median(runtimeHybridAlphaRaw(idxTiming));
    runtimeHybridReconMedian(idxP) = median(runtimeHybridReconRaw(idxTiming));
    runtimeHybridTotalQ1(idxP) = hybridRuntimeQuartiles(1);
    runtimeHybridTotalMedian(idxP) = hybridRuntimeQuartiles(2);
    runtimeHybridTotalQ3(idxP) = hybridRuntimeQuartiles(3);
end

nmseRaw = table(repmat({'nmse'},numNmseRows,1), rawP, rawSeed, ...
    nan(numNmseRows,1), mseExactRaw, nmseExactRaw, maxAbsErrExactRaw, ...
    mseHybridRaw, nmseHybridRaw, maxAbsErrHybridRaw, ...
    nan(numNmseRows,1), nan(numNmseRows,1), nan(numNmseRows,1), ...
    nan(numNmseRows,1), nan(numNmseRows,1), nan(numNmseRows,1), ...
    'VariableNames', {'experiment','P','seed','timing_repeat','mse_exact', ...
    'nmse_exact','max_abs_err_exact','mse_hybrid','nmse_hybrid', ...
    'max_abs_err_hybrid','runtime_soce_s','runtime_exact_alpha_s', ...
    'runtime_exact_recon_s','runtime_exact_total_s', ...
    'runtime_hybrid_alpha_s','runtime_hybrid_recon_s'});
nmseRaw.runtime_hybrid_total_s = nan(numNmseRows,1);

timingRaw = table(repmat({'runtime'},numTimingRows,1), timingP, ...
    timingSeed*ones(numTimingRows,1), timingRepeat, ...
    nan(numTimingRows,1), nan(numTimingRows,1), nan(numTimingRows,1), ...
    nan(numTimingRows,1), nan(numTimingRows,1), nan(numTimingRows,1), ...
    runtimeSoceRaw, runtimeExactAlphaRaw, runtimeExactReconRaw, ...
    runtimeExactTotalRaw, runtimeHybridAlphaRaw, runtimeHybridReconRaw, ...
    'VariableNames', nmseRaw.Properties.VariableNames(1:end-1));
timingRaw.runtime_hybrid_total_s = runtimeHybridTotalRaw;
rawTable = [nmseRaw; timingRaw];
rawTable.num_seeds = repmat(numSeeds,height(rawTable),1);
rawTable.num_timing_repeats = repmat(numTimingRepeats,height(rawTable),1);
rawTable.basis_runtime_included = false(height(rawTable),1);
rawTable.matlab_version = repmat({matlabVersion},height(rawTable),1);
writetable(rawTable, fullfile(resultsTableDir, ...
    'mimo_dps_kaltenberger_p_sweep_raw.csv'));

summaryTable = table(P_list, repmat(M,numP,1), repmat(Q,numP,1), ...
    repmat(N_Tx,numP,1), repmat(N_Rx,numP,1), repmat(D_t,numP,1), ...
    repmat(D_f,numP,1), repmat(D_tx,numP,1), repmat(D_rx,numP,1), ...
    repmat(D_t*D_f*D_tx*D_rx,numP,1), repmat(r_t,numP,1), ...
    repmat(r_f,numP,1), repmat(nu_Dmax,numP,1), ...
    repmat(theta_max,numP,1), nmseExactQ1, nmseExactMedian, ...
    nmseExactQ3, nmseHybridQ1, nmseHybridMedian, nmseHybridQ3, ...
    runtimeSoceQ1, runtimeSoceMedian, runtimeSoceQ3, ...
    runtimeExactAlphaMedian, runtimeExactReconMedian, ...
    runtimeExactTotalQ1, runtimeExactTotalMedian, runtimeExactTotalQ3, ...
    runtimeHybridAlphaMedian, runtimeHybridReconMedian, ...
    runtimeHybridTotalQ1, runtimeHybridTotalMedian, runtimeHybridTotalQ3, ...
    'VariableNames', {'P','M','Q','N_Tx','N_Rx','D_t','D_f','D_tx', ...
    'D_rx','D_total','r_t','r_f','nu_Dmax','theta_max', ...
    'nmse_exact_q1','nmse_exact_median','nmse_exact_q3', ...
    'nmse_hybrid_q1','nmse_hybrid_median','nmse_hybrid_q3', ...
    'runtime_soce_q1_s','runtime_soce_median_s','runtime_soce_q3_s', ...
    'runtime_exact_alpha_median_s','runtime_exact_recon_median_s', ...
    'runtime_exact_total_q1_s','runtime_exact_total_median_s', ...
    'runtime_exact_total_q3_s','runtime_hybrid_alpha_median_s', ...
    'runtime_hybrid_recon_median_s','runtime_hybrid_total_q1_s', ...
    'runtime_hybrid_total_median_s','runtime_hybrid_total_q3_s'});
summaryTable.num_seeds = repmat(numSeeds,numP,1);
summaryTable.num_timing_repeats = repmat(numTimingRepeats,numP,1);
summaryTable.seed = timingSeed*ones(numP,1);
summaryTable.basis_runtime_included = false(numP,1);
summaryTable.matlab_version = repmat({matlabVersion},numP,1);
writetable(summaryTable, fullfile(resultsTableDir, ...
    'mimo_dps_kaltenberger_p_sweep_summary.csv'));

%% 7. Save figures
% Median and interquartile range are used because NMSE is positive and its
% distribution can be skewed across random channel realizations.
nmseExactLowerError = nmseExactMedian - nmseExactQ1;
nmseExactUpperError = nmseExactQ3 - nmseExactMedian;
nmseHybridLowerError = nmseHybridMedian - nmseHybridQ1;
nmseHybridUpperError = nmseHybridQ3 - nmseHybridMedian;
figNmse = figure;
errorbar(P_list, nmseExactMedian, nmseExactLowerError, nmseExactUpperError, ...
    '-o', 'LineWidth', 1.5);
hold on;
errorbar(P_list, nmseHybridMedian, nmseHybridLowerError, nmseHybridUpperError, ...
    '-s', 'LineWidth', 1.5);
set(gca, 'YScale', 'log');
grid on;
title('NMSE versus Number of MPCs');
xlabel('Number of MPCs P');
ylabel('NMSE relative to SoCE');
legend({'Exact DPS', 'Hybrid approximate DPS'}, 'Location', 'best');
axNmse = gca;
disable_axes_toolbar(axNmse);
drawnow;
saveas(figNmse, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_p_sweep_nmse.png'));
savefig(figNmse, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_p_sweep_nmse.fig'));

runtimeSoceLowerError = runtimeSoceMedian - runtimeSoceQ1;
runtimeSoceUpperError = runtimeSoceQ3 - runtimeSoceMedian;
runtimeExactLowerError = runtimeExactTotalMedian - runtimeExactTotalQ1;
runtimeExactUpperError = runtimeExactTotalQ3 - runtimeExactTotalMedian;
runtimeHybridLowerError = runtimeHybridTotalMedian - runtimeHybridTotalQ1;
runtimeHybridUpperError = runtimeHybridTotalQ3 - runtimeHybridTotalMedian;
figRuntime = figure;
errorbar(P_list, runtimeSoceMedian, runtimeSoceLowerError, ...
    runtimeSoceUpperError, '-o', 'LineWidth', 1.5);
hold on;
errorbar(P_list, runtimeExactTotalMedian, runtimeExactLowerError, ...
    runtimeExactUpperError, '-s', 'LineWidth', 1.5);
errorbar(P_list, runtimeHybridTotalMedian, runtimeHybridLowerError, ...
    runtimeHybridUpperError, '-^', 'LineWidth', 1.5);
grid on;
title('Runtime versus Number of MPCs');
xlabel('Number of MPCs P');
ylabel('Runtime [s]');
legend({'SoCE', 'Exact DPS', 'Hybrid approximate DPS'}, 'Location', 'best');
axRuntime = gca;
disable_axes_toolbar(axRuntime);
drawnow;
saveas(figRuntime, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_p_sweep_runtime.png'));
savefig(figRuntime, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_p_sweep_runtime.fig'));

fprintf('Saved raw data, summary statistics, and figures under results/.\n');

%% Local functions
function [etaRaw, nuAll, thetaAll, zetaAll, xiAll] = generate_mpc_pool( ...
        Pmax, nuDmax, thetaMax, zetaMin, zetaMax, xiMin, xiMax)
    etaRaw = randn(Pmax,1) + 1j*randn(Pmax,1);
    nuAll = (2*rand(Pmax,1)-1) * nuDmax;
    thetaAll = rand(Pmax,1) * thetaMax;
    zetaAll = zetaMin + (zetaMax-zetaMin) * rand(Pmax,1);
    xiAll = xiMin + (xiMax-xiMin) * rand(Pmax,1);
end

function result = run_mimo_dps_case(eta, nu, theta, zeta, xi, ...
        M, Q, N_Tx, N_Rx, dim_t, dim_f, dim_tx, dim_rx)
    HSoce = compute_mimo_soce(eta, nu, theta, zeta, xi, ...
        M, Q, N_Tx, N_Rx);
    alphaExact = build_alpha_exact(eta, nu, theta, zeta, xi, ...
        dim_t, dim_f, dim_tx, dim_rx);
    HExact = reconstruct_from_alpha(alphaExact, dim_t.V, dim_f.V, ...
        dim_tx.V, dim_rx.V);
    alphaHybrid = build_alpha_approx_hybrid(eta, nu, theta, zeta, xi, ...
        dim_t, dim_f, N_Tx, N_Rx);
    HHybrid = reconstruct_hybrid(alphaHybrid, dim_t.V, dim_f.V);

    errorExact = HSoce - HExact;
    errorHybrid = HSoce - HHybrid;
    referencePower = mean(abs(HSoce(:)).^2);
    result.mseExact = mean(abs(errorExact(:)).^2);
    result.nmseExact = result.mseExact / referencePower;
    result.maxAbsErrExact = max(abs(errorExact(:)));
    result.mseHybrid = mean(abs(errorHybrid(:)).^2);
    result.nmseHybrid = result.mseHybrid / referencePower;
    result.maxAbsErrHybrid = max(abs(errorHybrid(:)));
end

function dim = make_dps_dimension(N, W0, Wmax, D, rFactor)
    [V, lambda] = shifted_dpss(N, W0, Wmax, D);
    if rFactor > 1
        [V_r, lambda_r] = shifted_dpss(rFactor*N, W0, Wmax/rFactor, D);
        V_r = align_highres_dps_signs(V, V_r, lambda_r, N, W0, Wmax, D, rFactor);
    else
        V_r = V;
        lambda_r = lambda;
    end

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

function gamma = approximate_gamma_1d(frequency, dim)
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

function H = reconstruct_hybrid(alpha, V_t, V_f)
    H = mode_product(alpha, V_t, 1);
    H = mode_product(H, V_f, 2);
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
