function plot_histograms_mean_neural_activity_trial_epoch

close all
clear all
clc

% Plot histograms of mean neural activity during the trial period for control and APP-KI mice.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('behavior_control.mat')
load('activity_control.mat')
load('activity_iti_control.mat')
behavior = behavior_control;
activity = activity_control;
activity_iti = activity_iti_control;
clear behavior_control activity_control activity_iti_control

% Re-order activity based on the trial number.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for trial_type = 1:8
            trial_idx{animal_num}{session_num}{trial_type} = find(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type);
        end

        for region_num = 1:8
            for trial_type = 1:8
                if ~isempty(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}) == 1 % If there are cells.
                    for trial_num = 1:numel(trial_idx{animal_num}{session_num}{trial_type})
                        if size(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:),1) == 1 % If there is only 1 cell.
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(1,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        else
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        end
                    end
                else
                    trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
                end
            end

            concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
            for trial_num = 1:size(trial_by_trial_activity{animal_num}{session_num}{region_num},2)
                if size(trial_by_trial_activity{animal_num}{session_num}{region_num},1) == 1 % If there is only 1 cell.
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))'];
                else
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))];
                end
            end
        end
    end
end

% Pick cells with similar activity levels.
for animal_num = 1:numel(behavior)
    clearvars -except behavior activity_iti concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior activity_iti concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx

        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > 0.024;
            region_cell_idx{animal_num}{session_num}{region_num} = activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(cell_idx{animal_num}{session_num}{region_num});
        end
    end
end

control_neuron_mean_activity_animal_session_region = [];

for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for region_num = 1:8
            if numel(region_cell_idx{animal_num}{session_num}{region_num}) >= 10
                control_neuron_mean_activity_animal_session_region = [control_neuron_mean_activity_animal_session_region; mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num})];
            end
        end
    end
end

clearvars -except control_neuron_mean_activity_animal_session_region

% APP.
load('behavior_APP.mat')
load('activity_APP.mat')
load('activity_iti_APP.mat')
behavior = behavior_APP;
activity = activity_APP;
activity_iti = activity_iti_APP;
clear behavior_APP activity_APP activity_iti_APP

% Re-order activity based on the trial number.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for trial_type = 1:8
            trial_idx{animal_num}{session_num}{trial_type} = find(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type);
        end

        for region_num = 1:8
            for trial_type = 1:8
                if ~isempty(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}) == 1 % If there are cells.
                    for trial_num = 1:numel(trial_idx{animal_num}{session_num}{trial_type})
                        if size(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:),1) == 1 % If there is only 1 cell.
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(1,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        else
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        end
                    end
                else
                    trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
                end
            end

            concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
            for trial_num = 1:size(trial_by_trial_activity{animal_num}{session_num}{region_num},2)
                if size(trial_by_trial_activity{animal_num}{session_num}{region_num},1) == 1 % If there is only 1 cell.
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))'];
                else
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))];
                end
            end
        end
    end
end

% Pick cells with similar activity levels.
for animal_num = 1:numel(behavior)
    clearvars -except mean_region_by_region_corr_animal_session_control behavior activity_iti concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx control_neuron_mean_activity_animal_session_region

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except mean_region_by_region_corr_animal_session_control behavior activity_iti concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx control_neuron_mean_activity_animal_session_region

        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > 0.024;
            region_cell_idx{animal_num}{session_num}{region_num} = activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(cell_idx{animal_num}{session_num}{region_num});
        end
    end
end

APP_neuron_mean_activity_animal_session_region = [];

for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for region_num = 1:8
            if numel(region_cell_idx{animal_num}{session_num}{region_num}) >= 10
                APP_neuron_mean_activity_animal_session_region = [APP_neuron_mean_activity_animal_session_region; mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num})];
            end
        end
    end
end

% Plot histogram.
figure('Position',[200,1000,250,250],'Color','w');
hold on
edges = linspace(0, 0.3, 200);
color1 = [0.25,0.25,0.25];
color2 = [0.64,0.08,0.18];
histogram(control_neuron_mean_activity_animal_session_region, edges, 'Normalization', 'pdf', ...
    'FaceColor', color1, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.5);
hold on;
histogram(APP_neuron_mean_activity_animal_session_region, edges, 'Normalization', 'pdf', ...
    'FaceColor', color2, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.5);
xlabel('Mean z-scored neural activity');
ylabel('Probability density');
xlim([0,0.3])
ylim([0,50])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0, 0.1, 0.2, 0.3];
ax.YTick = [0,25,50];
ax.XTickLabel = {'0','0.1','0.2','0.3'};
ax.YTickLabel = {'0','25','50'};
title(ax, 'Trial', 'FontSize', 14);

% Compute overlap coefficient.
[counts_control, ~] = histcounts(control_neuron_mean_activity_animal_session_region, edges, 'Normalization', 'pdf');
[counts_APP, ~] = histcounts(APP_neuron_mean_activity_animal_session_region, edges, 'Normalization', 'pdf');
bin_width = edges(2) - edges(1);
overlap_area = sum(min(counts_control, counts_APP)) * bin_width;
fprintf('Overlap Coefficient: %.4f\n', overlap_area);

end