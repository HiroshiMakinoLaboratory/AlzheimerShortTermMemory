function plot_histograms_mean_neural_activity_ITI_epoch

close all
clear all
clc

% Plot histograms of mean neural activity during the ITI period for control and APP-KI mice.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('activity_iti_control.mat')
activity_iti = activity_iti_control;
clear activity_iti_control

% Initialize.
control_mean_neural_cativity_animal_session_region = [];

for animal_num = 1:numel(activity_iti)
    clearvars -except activity_iti mean_region_by_region_functional_connectivity_animal_session animal_num control_mean_neural_cativity_animal_session_region

    % Initialize.
    mean_region_by_region_functional_connectivity_session = [];
    for session_num = 1:numel(activity_iti{animal_num})
        clearvars -except activity_iti mean_region_by_region_functional_connectivity_animal_session animal_num mean_region_by_region_functional_connectivity_session session_num control_mean_neural_cativity_animal_session_region
        for region_num = 1:8
            if isnan(activity_iti{animal_num}{session_num}.region_cell_idx{region_num}) == 1 | numel(activity_iti{animal_num}{session_num}.region_cell_idx{region_num}) < 10 % The cell number has to be at least 10 in each region.
                activity_iti{animal_num}{session_num}.region_cell_idx{region_num} = [];
            end
        end

        for region_num = 1:8
            if ~isnan(activity_iti{animal_num}{session_num}.region_cell_idx{region_num})
                mean_activity_iti{region_num} = mean(activity_iti{animal_num}{session_num}.activity_iti_all_regions(activity_iti{animal_num}{session_num}.region_cell_idx{region_num},:),2);
            else
                mean_activity_iti{region_num} = [];
            end
            cell_idx{region_num} = find(mean_activity_iti{region_num} > -0.0275);
            control_mean_neural_cativity_animal_session_region = [control_mean_neural_cativity_animal_session_region; mean_activity_iti{region_num}(cell_idx{region_num})];
        end
    end

end
clearvars -except control_mean_neural_cativity_animal_session_region

% APP.
load('activity_iti_APP.mat')
activity_iti = activity_iti_APP;
clear activity_iti_APP

% Initialize.
APP_mean_neural_cativity_animal_session_region = [];

for animal_num = 1:numel(activity_iti)
    clearvars -except mean_region_by_region_fc_animal_session_control activity_iti mean_region_by_region_functional_connectivity_animal_session animal_num control_mean_neural_cativity_animal_session_region APP_mean_neural_cativity_animal_session_region

    % Initialize.
    mean_region_by_region_functional_connectivity_session = [];
    for session_num = 1:numel(activity_iti{animal_num})
        clearvars -except mean_region_by_region_fc_animal_session_control activity_iti mean_region_by_region_functional_connectivity_animal_session animal_num mean_region_by_region_functional_connectivity_session session_num control_mean_neural_cativity_animal_session_region APP_mean_neural_cativity_animal_session_region
        for region_num = 1:8
            if isnan(activity_iti{animal_num}{session_num}.region_cell_idx{region_num}) == 1 | numel(activity_iti{animal_num}{session_num}.region_cell_idx{region_num}) < 10 % The cell number has to be at least 10 in each region.
                activity_iti{animal_num}{session_num}.region_cell_idx{region_num} = [];
            end
        end

        for region_num = 1:8
            if ~isnan(activity_iti{animal_num}{session_num}.region_cell_idx{region_num})
                mean_activity_iti{region_num} = mean(activity_iti{animal_num}{session_num}.activity_iti_all_regions(activity_iti{animal_num}{session_num}.region_cell_idx{region_num},:),2);
            else
                mean_activity_iti{region_num} = [];
            end
            cell_idx{region_num} = find(mean_activity_iti{region_num} > -0.0275);
            APP_mean_neural_cativity_animal_session_region = [APP_mean_neural_cativity_animal_session_region; mean_activity_iti{region_num}(cell_idx{region_num})];
        end
    end
end

% Plot histogram.
figure('Position',[200,1000,250,250],'Color','w');
hold on
edges = linspace(-0.1, 0.4, 200);
color1 = [0.25,0.25,0.25];
color2 = [0.64,0.08,0.18];
histogram(control_mean_neural_cativity_animal_session_region, edges, 'Normalization', 'pdf', ...
    'FaceColor', color1, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.5);
hold on;
histogram(APP_mean_neural_cativity_animal_session_region, edges, 'Normalization', 'pdf', ...
    'FaceColor', color2, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.5);
xlabel('Mean z-scored neural activity');
ylabel('Probability density');
xlim([-0.1,0.4])
ylim([0,30])
ax = gca;
ax.FontSize = 14;
ax.XTick = [-0.1, 0, 0.1, 0.2, 0.3, 0.4];
ax.YTick = [0,15,30];
ax.XTickLabel = {'-0.1','0','0.1','0.2','0.3', '0.4'};
ax.YTickLabel = {'0','15','30'};
title(ax, 'ITI', 'FontSize', 14);

% Compute overlap coefficient.
[counts_control, ~] = histcounts(control_mean_neural_cativity_animal_session_region, edges, 'Normalization', 'pdf');
[counts_APP, ~] = histcounts(APP_mean_neural_cativity_animal_session_region, edges, 'Normalization', 'pdf');
bin_width = edges(2) - edges(1);
overlap_area = sum(min(counts_control, counts_APP)) * bin_width;
fprintf('Overlap Coefficient: %.4f\n', overlap_area);

end