%% Create a P = 80 runtime/NMSE trade-off plot from saved metrics
% This script does not rerun the channel simulation. It reads the verified
% P = 80 metrics and creates a runtime-versus-NMSE diagnostic plot for
% Chapter 4.

clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
resultsFigDir = fullfile(projectRoot, 'results', 'figures');
resultsTableDir = fullfile(projectRoot, 'results', 'tables');

metricsPath = fullfile(resultsTableDir, 'mimo_dps_kaltenberger_approx_metrics.csv');
metrics = readtable(metricsPath);

if height(metrics) ~= 1
    error('Expected exactly one row in %s.', metricsPath);
end

methodNames = {'SoCE', 'DPS chinh xac', 'Hybrid', 'DPS xap xi 4D'};
runtimeValues = [ ...
    metrics.runtime_soce_s, ...
    metrics.runtime_exact_dps_alpha_s + metrics.runtime_exact_dps_recon_s, ...
    metrics.runtime_hybrid_approx_alpha_s + metrics.runtime_hybrid_approx_recon_s, ...
    metrics.runtime_approx_4d_alpha_s + metrics.runtime_approx_4d_recon_s];
nmseValues = [ ...
    0, ...
    metrics.nmse_exact, ...
    metrics.nmse_hybrid, ...
    metrics.nmse_approx_4d];

summary = table(methodNames.', runtimeValues.', nmseValues.', ...
    'VariableNames', {'method', 'runtime_s', 'nmse'});
writetable(summary, fullfile(resultsTableDir, 'mimo_dps_kaltenberger_p80_runtime_nmse.csv'));

fig = figure('Color', 'w');
colors = [ ...
    0.25 0.25 0.25; ... % SoCE: dark gray
    0.00 0.45 0.74; ... % Exact DPS: blue
    0.47 0.67 0.19; ... % Hybrid: green
    0.93 0.69 0.13];    % Approximate 4D DPS: orange

nmsePlotValues = nmseValues;
nmseFloor = 1e-9;
nmsePlotValues(1) = nmseFloor; % SoCE is the reference; its actual NMSE is zero.
markerSize = 190;

hold on;
for k = 1:numel(methodNames)
    scatter(runtimeValues(k), nmsePlotValues(k), markerSize, colors(k, :), 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.6);
    if k > 1
        text(runtimeValues(k) * 1.04, nmsePlotValues(k), methodNames{k}, ...
            'FontSize', 9, 'VerticalAlignment', 'middle');
    end
end
hold off;

ax = gca;
set(ax, 'YScale', 'log');
grid on;
title(sprintf('Doi chieu runtime va NMSE tai P = %d', metrics.P));
xlabel('Thoi gian chay [s]');
ylabel('NMSE so voi SoCE');
xlim([0, max(runtimeValues) * 1.25]);
ylim([nmseFloor, 1e-3]);
text(runtimeValues(1) * 1.04, nmseFloor * 1.35, ...
    'SoCE: NMSE = 0 (tham chieu)', ...
    'FontSize', 9, 'Color', colors(1, :), ...
    'VerticalAlignment', 'bottom');
disable_axes_toolbar(ax);
drawnow;

saveas(fig, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_p80_runtime_nmse.png'));
savefig(fig, fullfile(resultsFigDir, 'mimo_dps_kaltenberger_p80_runtime_nmse.fig'));

fprintf('Saved P=80 runtime/NMSE plot and summary table.\n');

function disable_axes_toolbar(ax)
    if isprop(ax, 'Toolbar') && ~isempty(ax.Toolbar)
        ax.Toolbar.Visible = 'off';
    end
end
