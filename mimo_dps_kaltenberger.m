%% MIMO wideband channel simulation using DPS/DPSS subspace
% Dua tren bai bao:
% Kaltenberger, Zemen, Ueberhuber, "Low-Complexity Geometry-Based MIMO
% Channel Simulation", EURASIP JASP, 2007.
%
% Mo hinh kenh 4D:
% h(m,q,s,r) = sum_p eta_p * exp(j*2*pi*(nu_p*m - theta_p*q
%                         + zeta_p*s - xi_p*r))
%
% Trong do:
%   m: chi so thoi gian, q: chi so tan so
%   s: anten phat Tx, r: anten thu Rx
%
% File nay so sanh:
%   1) SoCE: tinh truc tiep tong cac exponential
%   2) DPS: chieu kenh vao khong gian con DPSS 4 chieu va tai tao lai

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

%% 1. Tham so vat ly theo vi du trong bai bao
c = 3e8;
fc = 2e9;
vmax = 100/3.6;
Ts = 1/3.84e6;
nu_Dmax = vmax * fc * Ts / c;

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

%% 2. Kich thuoc mo phong
% Co the tang M, Q, N_Tx, N_Rx sau khi kiem tra may du bo nho.
M = 256;
Q = 64;
N_Tx = 4;
N_Rx = 4;
P = 80;

%% 3. Sinh tham so MPC nam trong mien bang gioi han
eta = (randn(P,1) + 1j*randn(P,1)) / sqrt(2*P);
nu = (2*rand(P,1)-1) * nu_Dmax;
theta = rand(P,1) * theta_max;
zeta = zeta_min + (zeta_max-zeta_min) * rand(P,1);
xi = xi_min + (xi_max-xi_min) * rand(P,1);

%% 4. Chon so vector DPS cho tung chieu
% Essential dimension xap xi: ceil(|W|*|I|)+1 = ceil(2*Wmax*N)+1.
% Lay them "guard" vectors de giam sai so cat khong gian con.
guard = 4;
D_t  = ceil(2*nu_Dmax*M) + 1 + guard;
D_f  = ceil(theta_max*Q) + 1 + guard;
D_tx = ceil((zeta_max-zeta_min)*N_Tx) + 1 + guard;
D_rx = ceil((xi_max-xi_min)*N_Rx) + 1 + guard;

D_t  = min(D_t, M);
D_f  = min(D_f, Q);
D_tx = min(D_tx, N_Tx);
D_rx = min(D_rx, N_Rx);

%% 5. Tao co so DPS/DPSS mot chieu
% dpss(N,NW,K) tao co so cho bang doi xung [-Wmax,Wmax], NW=N*Wmax.
% Neu bang co tam W0 khac 0 thi nhan them exp(j*2*pi*W0*n).
V_t  = shifted_dpss(M,    0,                         nu_Dmax,                  D_t);
V_f  = shifted_dpss(Q,   -theta_max/2,               theta_max/2,              D_f);
V_tx = shifted_dpss(N_Tx,(zeta_min+zeta_max)/2,      (zeta_max-zeta_min)/2,    D_tx);
V_rx = shifted_dpss(N_Rx,-(xi_min+xi_max)/2,         (xi_max-xi_min)/2,        D_rx);

%% 6. Tinh kenh SoCE tham chieu
tic;
H_soce = compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx);
t_soce = toc;

%% 7. Tinh he so DPS bang tich cac phep chieu 1D
% Gamma cua moi MPC:
% gamma_t  = V_t'  * exp(j*2*pi*nu*m)
% gamma_f  = V_f'  * exp(-j*2*pi*theta*q)
% gamma_tx = V_tx' * exp(j*2*pi*zeta*s)
% gamma_rx = V_rx' * exp(-j*2*pi*xi*r)
alpha = zeros(D_t, D_f, D_tx, D_rx);

m = (0:M-1).';
q = (0:Q-1).';
s = (0:N_Tx-1).';
r = (0:N_Rx-1).';

tic;
E_t  = exp( 1j*2*pi * (m * nu.'));
E_f  = exp(-1j*2*pi * (q * theta.'));
E_tx = exp( 1j*2*pi * (s * zeta.'));
E_rx = exp(-1j*2*pi * (r * xi.'));

Gamma_t  = V_t'  * E_t;
Gamma_f  = V_f'  * E_f;
Gamma_tx = V_tx' * E_tx;
Gamma_rx = V_rx' * E_rx;

for p = 1:P
    % Theorem 3: multidimensional coefficients are products of 1-D projections.
    gamma_tensor = bsxfun(@times, reshape(Gamma_t(:,p),  D_t, 1,   1,    1), ...
                                  reshape(Gamma_f(:,p),  1,   D_f, 1,    1));
    gamma_tensor = bsxfun(@times, gamma_tensor, reshape(Gamma_tx(:,p), 1, 1, D_tx, 1));
    gamma_tensor = bsxfun(@times, gamma_tensor, reshape(Gamma_rx(:,p), 1, 1, 1, D_rx));
    alpha = alpha + eta(p) .* gamma_tensor;
end
t_alpha = toc;

%% 8. Tai tao kenh tu khong gian con DPS
tic;
H_dps = mode_product(alpha, V_t, 1);
H_dps = mode_product(H_dps, V_f, 2);
H_dps = mode_product(H_dps, V_tx, 3);
H_dps = mode_product(H_dps, V_rx, 4);
t_recon = toc;

%% 9. Danh gia sai so
err = H_soce - H_dps;
mse = mean(abs(err(:)).^2);
nmse = mse / mean(abs(H_soce(:)).^2);
max_abs_err = max(abs(err(:)));

fprintf('--- MIMO bang DPS/DPSS theo Kaltenberger 2007 ---\n');
fprintf('Kich thuoc H: %d x %d x %d x %d, P = %d MPC\n', M, Q, N_Tx, N_Rx, P);
fprintf('DPS dimensions: D_t=%d, D_f=%d, D_tx=%d, D_rx=%d, D_total=%d\n', ...
    D_t, D_f, D_tx, D_rx, D_t*D_f*D_tx*D_rx);
fprintf('nu_Dmax = %.4g, theta_max = %.4g\n', nu_Dmax, theta_max);
fprintf('MSE  = %.4e\n', mse);
fprintf('NMSE = %.4e\n', nmse);
fprintf('Max |error| = %.4e\n', max_abs_err);
fprintf('Runtime SoCE      : %.4f s\n', t_soce);
fprintf('Runtime DPS alpha : %.4f s\n', t_alpha);
fprintf('Runtime DPS recon : %.4f s\n', t_recon);

metrics = table(M, Q, N_Tx, N_Rx, P, D_t, D_f, D_tx, D_rx, ...
    D_t*D_f*D_tx*D_rx, nu_Dmax, theta_max, mse, nmse, max_abs_err, ...
    t_soce, t_alpha, t_recon, ...
    'VariableNames', {'M','Q','N_Tx','N_Rx','P','D_t','D_f','D_tx','D_rx', ...
    'D_total','nu_Dmax','theta_max','mse','nmse','max_abs_err', ...
    'runtime_soce_s','runtime_dps_alpha_s','runtime_dps_recon_s'});
writetable(metrics, fullfile(resultsTableDir, 'mimo_dps_kaltenberger_metrics.csv'));

%% 10. Ve minh hoa tai cap anten Tx=1, Rx=1
fig = figure;
ax1 = subplot(1,3,1);
imagesc(abs(H_soce(:,:,1,1)));
axis xy; colorbar; grid on;
title('|H_{SoCE}|');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax1);

ax2 = subplot(1,3,2);
imagesc(abs(H_dps(:,:,1,1)));
axis xy; colorbar; grid on;
title('|H_{DPS}|');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax2);

ax3 = subplot(1,3,3);
imagesc(abs(err(:,:,1,1)));
axis xy; colorbar; grid on;
title('|Error|');
xlabel('q'); ylabel('m');
disable_axes_toolbar(ax3);

drawnow;
saveas(fig, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_tx1_rx1.png'));
savefig(fig, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_tx1_rx1.fig'));

%% Local functions
function V = shifted_dpss(N, W0, Wmax, D)
    if Wmax <= 0
        V = ones(N,1) / sqrt(N);
        V = V(:,1:min(D,1));
        return;
    end

    NW = N * Wmax;
    if NW >= N/2
        error('Wmax phai nho hon 0.5 de thoa dieu kien lay mau roi rac.');
    end

    if exist('dpss', 'file') == 2
        try
            [V_sym, ~] = dpss(N, NW, D);
        catch
            V_sym = dpss_by_eig(N, Wmax, D);
        end
    else
        V_sym = dpss_by_eig(N, Wmax, D);
    end

    n = (0:N-1).';
    V = V_sym .* exp(1j*2*pi*W0*n);
end

function V = dpss_by_eig(N, Wmax, D)
    n = (0:N-1).';
    delta = n - n.';
    K = zeros(N, N);
    K(delta == 0) = 2 * Wmax;
    idx = delta ~= 0;
    K(idx) = sin(2*pi*Wmax*delta(idx)) ./ (pi*delta(idx));

    [U, Lambda] = eig((K + K')/2, 'vector');
    [~, order] = sort(real(Lambda), 'descend');
    V = U(:, order(1:D));

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
