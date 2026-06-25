%% Plot one-dimensional DPS eigenvalue decay
% This independently generated plot uses M0 = 0, M = 256, and
% M*nu_Dmax = 2, following the illustrative parameter set in
% Kaltenberger et al. (2007).
%
% Paper mapping:
%   Eq. (6): DPS concentration-matrix eigenvalue problem.
%   Eq. (8): lambda_d is the energy-concentration ratio.
%   Eq. (11): essential dimension D_prime = 2*M*nu_Dmax + 1 = 5.

clear; clc; close all;
rng(1); %#ok<RNGR> % Fixed for project-wide reproducibility; no randomness is used.

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

%% Parameters adopted from the DPS eigenvalue example in the paper
M0 = 0;
M = 256;
timeBandwidthProduct = 2;       % M*nu_Dmax = 2
nu_Dmax = timeBandwidthProduct / M;
numEigenvalues = 10;
D_prime = ceil(2 * M * nu_Dmax) + 1;

%% First ten DPS eigenvalues
% MATLAB uses dpss(N, NW, K), where NW = N*W and W is the one-sided
% normalized half-bandwidth. Here NW = M*nu_Dmax = 2.
if exist('dpss', 'file') == 2
    [~, lambda] = dpss(M, timeBandwidthProduct, numEigenvalues);
    computationMethod = "MATLAB dpss";
else
    lambda = dps_eigenvalues_by_kernel(M, nu_Dmax, numEigenvalues);
    computationMethod = "Eq. (6) concentration matrix";
end

lambda = real(lambda(:));
d = (0:numEigenvalues-1).';

%% Plot in the logarithmic scale used by the paper
fig = figure('Color', 'w');
semilogy(d, lambda, 'ko-', 'LineWidth', 1.2, ...
    'MarkerFaceColor', 'k', 'MarkerSize', 4);
grid on;
xlim([0, numEigenvalues-1]);
ylim([1e-7, 1]);
xticks(d);
yticks(10.^(-7:0));
xlabel('DPS index d');
ylabel('Eigenvalue \lambda_d');
title('One-dimensional DPS eigenvalues');
legend(sprintf('M = %d, M\\nu_{D,max} = %g, D'' = %d', ...
    M, timeBandwidthProduct, D_prime), 'Location', 'southwest');

figBaseName = 'paper_figure4_dps_eigenvalues';
saveas(fig, fullfile(resultsFigDir, [figBaseName '.png']));
savefig(fig, fullfile(resultsFigDir, [figBaseName '.fig']));

%% Save numerical values for verification and thesis use
isEssential = d <= D_prime - 1;
resultTable = table(d, lambda, isEssential, ...
    repmat(M0, numEigenvalues, 1), repmat(M, numEigenvalues, 1), ...
    repmat(nu_Dmax, numEigenvalues, 1), ...
    repmat(D_prime, numEigenvalues, 1), ...
    'VariableNames', {'d', 'lambda_d', 'inside_paper_essential_subspace', ...
    'M0', 'M', 'nu_Dmax', 'D_prime'});
writetable(resultTable, fullfile(resultsTableDir, ...
    'paper_figure4_dps_eigenvalues.csv'));

fprintf('DPS eigenvalue illustration generated in MATLAB\n');
fprintf('Method: %s\n', computationMethod);
fprintf('M0 = %d, M = %d, nu_Dmax = %.8f, M*nu_Dmax = %.1f\n', ...
    M0, M, nu_Dmax, M*nu_Dmax);
fprintf('Paper essential dimension D'' = %d\n', D_prime);
disp(resultTable(:, {'d', 'lambda_d', 'inside_paper_essential_subspace'}));

function lambda = dps_eigenvalues_by_kernel(M, nu_Dmax, numEigenvalues)
    % Eq. (6): sinc concentration matrix for W = [-nu_Dmax, nu_Dmax].
    n = (0:M-1).';
    delta = n - n.';
    K = zeros(M, M);
    K(delta == 0) = 2 * nu_Dmax;
    nonzero = delta ~= 0;
    K(nonzero) = sin(2*pi*nu_Dmax*delta(nonzero)) ./ ...
        (pi*delta(nonzero));

    eigenvalues = eig((K + K') / 2, 'vector');
    eigenvalues = sort(real(eigenvalues), 'descend');
    lambda = eigenvalues(1:numEigenvalues);
end
