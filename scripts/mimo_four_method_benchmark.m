%% Four-method benchmark and implementation-specific break-even analysis
% Compare direct SoCE, recursive SoCE, CE-BEM, and exact 4D DPS on the
% same wideband MIMO GCM realizations. Based on the sampled channel model
% in Eq. (47) of Kaltenberger et al.

clear; clc; close all;
rng(1);

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
figureDir = fullfile(projectRoot, 'results', 'figures');
tableDir = fullfile(projectRoot, 'results', 'tables');
if ~exist(figureDir, 'dir'), mkdir(figureDir); end
if ~exist(tableDir, 'dir'), mkdir(tableDir); end

%% Configuration
c = 3e8;
fc = 2e9;
vmax = 100/3.6;
Ts = 1/3.84e6;
nuMax = vmax * fc * Ts / c;
frequencySpacing = 15e3;
tauMax = 3.7e-6;
thetaMax = tauMax * frequencySpacing;
antennaSpacing = 0.5;
angleMin = -5*pi/180;
angleMax = 5*pi/180;
zetaMin = sin(angleMin) * antennaSpacing;
zetaMax = sin(angleMax) * antennaSpacing;
xiMin = zetaMin;
xiMax = zetaMax;

M = 256;
Q = 64;
Ntx = 4;
Nrx = 4;
guard = 4;
Dt = min(ceil(2*nuMax*M) + 1 + guard, M);
Df = min(ceil(thetaMax*Q) + 1 + guard, Q);
Dtx = min(ceil((zetaMax-zetaMin)*Ntx) + 1 + guard, Ntx);
Drx = min(ceil((xiMax-xiMin)*Nrx) + 1 + guard, Nrx);

Pvalues = [5, 10, 20, 40, 80, 160, 320];
numSeeds = 20;
numRuntimeRepeats = 10;
runtimeSeed = 1001;

%% One-time bases and preprocessing time
setupTimer = tic;
[Vt, ~] = shifted_dpss(M, 0, nuMax, Dt);
[Vf, ~] = shifted_dpss(Q, -thetaMax/2, thetaMax/2, Df);
[Vtx, ~] = shifted_dpss(Ntx, (zetaMin+zetaMax)/2, (zetaMax-zetaMin)/2, Dtx);
[Vrx, ~] = shifted_dpss(Nrx, -(xiMin+xiMax)/2, (xiMax-xiMin)/2, Drx);
dpsSetupTime = toc(setupTimer);

setupTimer = tic;
Bt = make_ce_basis(M, -nuMax, nuMax, Dt);
Bf = make_ce_basis(Q, -thetaMax, 0, Df);
Btx = make_ce_basis(Ntx, zetaMin, zetaMax, Dtx);
Brx = make_ce_basis(Nrx, -xiMax, -xiMin, Drx);
Pt = pinv(Bt); Pf = pinv(Bf); Ptx = pinv(Btx); Prx = pinv(Brx);
ceSetupTime = toc(setupTimer);

methodNames = ["SoCE direct", "SoCE recursive", "CE-BEM", "Exact DPS"];
numMethods = numel(methodNames);
nmseValues = zeros(numel(Pvalues), numMethods, numSeeds);

%% Accuracy over reproducible channel realizations
for seedIndex = 1:numSeeds
    rng(seedIndex);
    [etaPool, nuPool, thetaPool, zetaPool, xiPool] = generate_mpcs( ...
        max(Pvalues), nuMax, thetaMax, zetaMin, zetaMax, xiMin, xiMax);

    for pIndex = 1:numel(Pvalues)
        P = Pvalues(pIndex);
        eta = etaPool(1:P) * sqrt(max(Pvalues)/P);
        nu = nuPool(1:P); theta = thetaPool(1:P);
        zeta = zetaPool(1:P); xi = xiPool(1:P);

        Href = compute_soce_direct(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx);
        Hrecursive = compute_soce_recursive(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx);
        Hce = compute_basis_channel(eta, nu, theta, zeta, xi, ...
            Bt, Bf, Btx, Brx, Pt, Pf, Ptx, Prx);
        Hdps = compute_basis_channel(eta, nu, theta, zeta, xi, ...
            Vt, Vf, Vtx, Vrx, Vt', Vf', Vtx', Vrx');

        referencePower = mean(abs(Href(:)).^2);
        nmseValues(pIndex, 1, seedIndex) = 0;
        nmseValues(pIndex, 2, seedIndex) = mean(abs(Href(:)-Hrecursive(:)).^2) / referencePower;
        nmseValues(pIndex, 3, seedIndex) = mean(abs(Href(:)-Hce(:)).^2) / referencePower;
        nmseValues(pIndex, 4, seedIndex) = mean(abs(Href(:)-Hdps(:)).^2) / referencePower;
    end
end

%% Runtime on fixed data after warm-up
rng(runtimeSeed);
[etaPool, nuPool, thetaPool, zetaPool, xiPool] = generate_mpcs( ...
    max(Pvalues), nuMax, thetaMax, zetaMin, zetaMax, xiMin, xiMax);
runtimeValues = zeros(numel(Pvalues), numMethods, numRuntimeRepeats);

for pIndex = 1:numel(Pvalues)
    P = Pvalues(pIndex);
    eta = etaPool(1:P) * sqrt(max(Pvalues)/P);
    nu = nuPool(1:P); theta = thetaPool(1:P);
    zeta = zetaPool(1:P); xi = xiPool(1:P);

    % Warm up JIT and allocated code paths.
    compute_soce_direct(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx);
    compute_soce_recursive(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx);
    compute_basis_channel(eta, nu, theta, zeta, xi, Bt, Bf, Btx, Brx, Pt, Pf, Ptx, Prx);
    compute_basis_channel(eta, nu, theta, zeta, xi, Vt, Vf, Vtx, Vrx, Vt', Vf', Vtx', Vrx');

    for repeatIndex = 1:numRuntimeRepeats
        timer = tic;
        compute_soce_direct(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx);
        runtimeValues(pIndex, 1, repeatIndex) = toc(timer);

        timer = tic;
        compute_soce_recursive(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx);
        runtimeValues(pIndex, 2, repeatIndex) = toc(timer);

        timer = tic;
        compute_basis_channel(eta, nu, theta, zeta, xi, Bt, Bf, Btx, Brx, Pt, Pf, Ptx, Prx);
        runtimeValues(pIndex, 3, repeatIndex) = toc(timer);

        timer = tic;
        compute_basis_channel(eta, nu, theta, zeta, xi, Vt, Vf, Vtx, Vrx, Vt', Vf', Vtx', Vrx');
        runtimeValues(pIndex, 4, repeatIndex) = toc(timer);
    end
end

%% Summaries and break-even quantities
runtimeMedian = median(runtimeValues, 3);
runtimeQ1 = prctile(runtimeValues, 25, 3);
runtimeQ3 = prctile(runtimeValues, 75, 3);
nmseMedian = median(nmseValues, 3);
nmseQ1 = prctile(nmseValues, 25, 3);
nmseQ3 = prctile(nmseValues, 75, 3);
setupTimes = [0, 0, ceSetupTime, dpsSetupTime];

breakEvenBlocks = inf(size(runtimeMedian));
for pIndex = 1:numel(Pvalues)
    for methodIndex = 2:numMethods
        savingPerBlock = runtimeMedian(pIndex, 1) - runtimeMedian(pIndex, methodIndex);
        if savingPerBlock > 0
            breakEvenBlocks(pIndex, methodIndex) = max(1, ceil(setupTimes(methodIndex) / savingPerBlock));
        end
    end
end

crossOverP = nan(1, numMethods);
for methodIndex = 2:numMethods
    difference = runtimeMedian(:, methodIndex) - runtimeMedian(:, 1);
    crossingIndex = find(difference(1:end-1) > 0 & difference(2:end) <= 0, 1);
    if ~isempty(crossingIndex)
        p1 = Pvalues(crossingIndex); p2 = Pvalues(crossingIndex+1);
        d1 = difference(crossingIndex); d2 = difference(crossingIndex+1);
        crossOverP(methodIndex) = p1 + (p2-p1) * d1 / (d1-d2);
    elseif difference(1) <= 0
        crossOverP(methodIndex) = Pvalues(1);
    end
end

%% Save raw and summary tables
[pGrid, methodGrid, repeatGrid] = ndgrid(Pvalues, 1:numMethods, 1:numRuntimeRepeats);
runtimeRaw = table(pGrid(:), methodNames(methodGrid(:)).', repeatGrid(:), runtimeValues(:), ...
    'VariableNames', {'P','method','repeat','runtime_s'});
writetable(runtimeRaw, fullfile(tableDir, 'mimo_four_method_benchmark_runtime_raw.csv'));

[pGrid, methodGrid, seedGrid] = ndgrid(Pvalues, 1:numMethods, 1:numSeeds);
nmseRaw = table(pGrid(:), methodNames(methodGrid(:)).', seedGrid(:), nmseValues(:), ...
    'VariableNames', {'P','method','seed','nmse'});
writetable(nmseRaw, fullfile(tableDir, 'mimo_four_method_benchmark_nmse_raw.csv'));

summaryRows = numel(Pvalues) * numMethods;
summary = table('Size', [summaryRows, 13], ...
    'VariableTypes', {'double','string','double','double','double','double','double','double', ...
                      'double','double','double','double','double'}, ...
    'VariableNames', {'P','method','setup_s','runtime_median_s','runtime_q1_s','runtime_q3_s', ...
                      'nmse_median','nmse_q1','nmse_q3','speedup_vs_direct', ...
                      'break_even_blocks','M','Q'});
row = 0;
for pIndex = 1:numel(Pvalues)
    for methodIndex = 1:numMethods
        row = row + 1;
        summary.P(row) = Pvalues(pIndex);
        summary.method(row) = methodNames(methodIndex);
        summary.setup_s(row) = setupTimes(methodIndex);
        summary.runtime_median_s(row) = runtimeMedian(pIndex, methodIndex);
        summary.runtime_q1_s(row) = runtimeQ1(pIndex, methodIndex);
        summary.runtime_q3_s(row) = runtimeQ3(pIndex, methodIndex);
        summary.nmse_median(row) = nmseMedian(pIndex, methodIndex);
        summary.nmse_q1(row) = nmseQ1(pIndex, methodIndex);
        summary.nmse_q3(row) = nmseQ3(pIndex, methodIndex);
        summary.speedup_vs_direct(row) = runtimeMedian(pIndex, 1) / runtimeMedian(pIndex, methodIndex);
        summary.break_even_blocks(row) = breakEvenBlocks(pIndex, methodIndex);
        summary.M(row) = M;
        summary.Q(row) = Q;
    end
end
writetable(summary, fullfile(tableDir, 'mimo_four_method_benchmark_summary.csv'));

breakEven = table(methodNames.', setupTimes.', crossOverP.', ...
    'VariableNames', {'method','setup_s','stable_cross_over_P'});
writetable(breakEven, fullfile(tableDir, 'mimo_four_method_benchmark_break_even.csv'));

%% Figures
colors = lines(numMethods);
figRuntime = figure;
hold on;
for methodIndex = 1:numMethods
    lowerError = runtimeMedian(:,methodIndex) - runtimeQ1(:,methodIndex);
    upperError = runtimeQ3(:,methodIndex) - runtimeMedian(:,methodIndex);
    errorbar(Pvalues, runtimeMedian(:,methodIndex), lowerError, upperError, '-o', ...
        'LineWidth', 1.2, 'Color', colors(methodIndex,:));
end
set(gca, 'XScale', 'log', 'YScale', 'log');
grid on;
xlabel('Number of MPCs, P'); ylabel('Runtime per channel block [s]');
title('Four-method runtime benchmark');
legend(methodNames, 'Location', 'northwest');
disable_axes_toolbar(gca);
saveas(figRuntime, fullfile(figureDir, 'mimo_four_method_benchmark_runtime.png'));
savefig(figRuntime, fullfile(figureDir, 'mimo_four_method_benchmark_runtime.fig'));

figNmse = figure;
hold on;
for methodIndex = 2:numMethods
    safeNmse = max(nmseMedian(:,methodIndex), realmin);
    plot(Pvalues, safeNmse, '-o', 'LineWidth', 1.2, 'Color', colors(methodIndex,:));
end
set(gca, 'XScale', 'log', 'YScale', 'log');
grid on;
xlabel('Number of MPCs, P'); ylabel('NMSE relative to direct SoCE');
title('Four-method accuracy benchmark');
legend(methodNames(2:end), 'Location', 'best');
disable_axes_toolbar(gca);
saveas(figNmse, fullfile(figureDir, 'mimo_four_method_benchmark_nmse.png'));
savefig(figNmse, fullfile(figureDir, 'mimo_four_method_benchmark_nmse.fig'));

fprintf('DPS setup: %.6f s; CE-BEM setup: %.6f s\n', dpsSetupTime, ceSetupTime);
disp(breakEven);
disp(summary(summary.P == 80, :));

%% Local functions
function [eta, nu, theta, zeta, xi] = generate_mpcs(P, nuMax, thetaMax, zetaMin, zetaMax, xiMin, xiMax)
    eta = (randn(P,1) + 1j*randn(P,1)) / sqrt(2*P);
    nu = (2*rand(P,1)-1) * nuMax;
    theta = rand(P,1) * thetaMax;
    zeta = zetaMin + (zetaMax-zetaMin) * rand(P,1);
    xi = xiMin + (xiMax-xiMin) * rand(P,1);
end

function H = compute_soce_direct(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx)
    P = numel(eta);
    m = (0:M-1).'; q = (0:Q-1).'; s = (0:Ntx-1).'; r = (0:Nrx-1).';
    H = zeros(M,Q,Ntx,Nrx);
    for p = 1:P
        et = reshape(exp(1j*2*pi*nu(p)*m), M,1,1,1);
        ef = reshape(exp(-1j*2*pi*theta(p)*q), 1,Q,1,1);
        ex = reshape(exp(1j*2*pi*zeta(p)*s), 1,1,Ntx,1);
        er = reshape(exp(-1j*2*pi*xi(p)*r), 1,1,1,Nrx);
        H = H + eta(p) .* et .* ef .* ex .* er;
    end
end

function H = compute_soce_recursive(eta, nu, theta, zeta, xi, M, Q, Ntx, Nrx)
    P = numel(eta);
    H = zeros(M,Q,Ntx,Nrx);
    for p = 1:P
        et = reshape(recursive_phasor(exp(1j*2*pi*nu(p)), M), M,1,1,1);
        ef = reshape(recursive_phasor(exp(-1j*2*pi*theta(p)), Q), 1,Q,1,1);
        ex = reshape(recursive_phasor(exp(1j*2*pi*zeta(p)), Ntx), 1,1,Ntx,1);
        er = reshape(recursive_phasor(exp(-1j*2*pi*xi(p)), Nrx), 1,1,1,Nrx);
        H = H + eta(p) .* et .* ef .* ex .* er;
    end
end

function v = recursive_phasor(step, N)
    v = ones(N,1);
    for index = 2:N
        v(index) = v(index-1) * step;
    end
end

function H = compute_basis_channel(eta, nu, theta, zeta, xi, ...
        At, Af, Atx, Arx, Pt, Pf, Ptx, Prx)
    m = (0:size(At,1)-1).'; q = (0:size(Af,1)-1).';
    s = (0:size(Atx,1)-1).'; r = (0:size(Arx,1)-1).';
    Gt = Pt * exp(1j*2*pi*m*nu.');
    Gf = Pf * exp(-1j*2*pi*q*theta.');
    Gtx = Ptx * exp(1j*2*pi*s*zeta.');
    Grx = Prx * exp(-1j*2*pi*r*xi.');
    alpha = zeros(size(At,2),size(Af,2),size(Atx,2),size(Arx,2));
    for p = 1:numel(eta)
        alpha = alpha + eta(p) .* outer4(Gt(:,p),Gf(:,p),Gtx(:,p),Grx(:,p));
    end
    H = mode_product(alpha, At, 1);
    H = mode_product(H, Af, 2);
    H = mode_product(H, Atx, 3);
    H = mode_product(H, Arx, 4);
end

function B = make_ce_basis(N, frequencyMin, frequencyMax, K)
    n = (0:N-1).';
    if K == 1
        frequencies = (frequencyMin + frequencyMax)/2;
    else
        frequencies = linspace(frequencyMin, frequencyMax, K);
    end
    B = exp(1j*2*pi*n*frequencies);
    B = B ./ vecnorm(B);
end

function tensor = outer4(a,b,c,d)
    tensor = reshape(a,[],1,1,1) .* reshape(b,1,[],1,1) .* ...
             reshape(c,1,1,[],1) .* reshape(d,1,1,1,[]);
end

function Y = mode_product(X,A,mode)
    sz = size(X);
    order = [mode,1:mode-1,mode+1:ndims(X)];
    Xp = permute(X,order);
    Xm = reshape(Xp,sz(mode),[]);
    newSize = sz; newSize(mode) = size(A,1);
    Yp = reshape(A*Xm,newSize(order));
    Y = ipermute(Yp,order);
end

function [V,lambda] = shifted_dpss(N,W0,Wmax,D)
    if exist('dpss','file') == 2
        [V0,lambda] = dpss(N,N*Wmax,D);
    else
        n = (0:N-1).'; delta = n-n.'; K = zeros(N,N);
        K(delta==0) = 2*Wmax;
        idx = delta~=0;
        K(idx) = sin(2*pi*Wmax*delta(idx))./(pi*delta(idx));
        [U,L] = eig((K+K')/2,'vector');
        [lambda,order] = sort(real(L),'descend');
        V0 = U(:,order(1:D)); lambda = lambda(1:D);
    end
    V = V0 .* exp(1j*2*pi*W0*(0:N-1).');
end

function disable_axes_toolbar(ax)
    if isprop(ax,'Toolbar') && ~isempty(ax.Toolbar), ax.Toolbar.Visible = 'off'; end
end
