function plot_activity_level

close all
clear all
clc

% Analyze activity levels of individual neurons.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

low_thresh = 0.024;

% Control.
load('behavior_control.mat')
load('activity_control.mat')
behavior = behavior_control;
activity = activity_control;
clear behavior_control
clear activity_control

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
    clearvars -except low_thresh behavior concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except low_thresh behavior concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity

        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > low_thresh;
            adj_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = concat_trial_by_trial_activity{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num},:);
        end
    end
end
clear concat_trial_by_trial_activity
concat_trial_by_trial_activity = adj_concat_trial_by_trial_activity;

% Initialize.
mean_activity_animal_session = [];
region_spec_mean_activity_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except low_thresh behavior concat_trial_by_trial_activity mean_activity_animal_session region_spec_mean_activity_animal_session animal_num

    % Initialize.
    mean_activity_session = [];
    region_spec_mean_activity_session = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except low_thresh behavior concat_trial_by_trial_activity mean_activity_animal_session region_spec_mean_activity_animal_session animal_num mean_activity_session region_spec_mean_activity_session session_num

        % Initialize.
        mean_activity_all_regions = [];

        for region_num = 1:8
            mean_activity_all_regions = [mean_activity_all_regions;mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2)];
            mean_concat_trial_by_trial_activity{animal_num}{session_num}(region_num) = mean(mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2));
        end

        % Concatenate.
        mean_activity_session = [mean_activity_session;mean(mean_activity_all_regions)];
        region_spec_mean_activity_session = [region_spec_mean_activity_session;mean_concat_trial_by_trial_activity{animal_num}{session_num}];
    end

    % Concatenate.
    mean_activity_animal_session = [mean_activity_animal_session;mean_activity_session];
    region_spec_mean_activity_animal_session = [region_spec_mean_activity_animal_session;region_spec_mean_activity_session];
end

mean_activity_animal_session_control_all_region = mean_activity_animal_session;
mean_activity_animal_session_control = region_spec_mean_activity_animal_session;

clearvars -except low_thresh mean_activity_animal_session_control_all_region mean_activity_animal_session_control

% APP.
load('behavior_APP.mat')
load('activity_APP.mat')
behavior = behavior_APP;
activity = activity_APP;
clear behavior_APP
clear activity_APP

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
    clearvars -except low_thresh mean_activity_animal_session_control_all_region mean_activity_animal_session_control ...
        behavior concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except low_thresh mean_activity_animal_session_control_all_region mean_activity_animal_session_control ...
            behavior concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity

        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > low_thresh;
            adj_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = concat_trial_by_trial_activity{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num},:);
        end
    end
end
clear concat_trial_by_trial_activity
concat_trial_by_trial_activity = adj_concat_trial_by_trial_activity;

% Initialize.
mean_activity_animal_session = [];
region_spec_mean_activity_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except low_thresh mean_activity_animal_session_control_all_region mean_activity_animal_session_control ...
        behavior concat_trial_by_trial_activity mean_activity_animal_session region_spec_mean_activity_animal_session animal_num

    % Initialize.
    mean_activity_session = [];
    region_spec_mean_activity_session = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except low_thresh mean_activity_animal_session_control_all_region mean_activity_animal_session_control ...
            behavior concat_trial_by_trial_activity mean_activity_animal_session region_spec_mean_activity_animal_session animal_num mean_activity_session region_spec_mean_activity_session session_num

        % Initialize.
        mean_activity_all_regions = [];

        for region_num = 1:8
            mean_activity_all_regions = [mean_activity_all_regions;mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2)];
            mean_concat_trial_by_trial_activity{animal_num}{session_num}(region_num) = mean(mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2));
        end

        % Concatenate.
        mean_activity_session = [mean_activity_session;mean(mean_activity_all_regions)];
        region_spec_mean_activity_session = [region_spec_mean_activity_session;mean_concat_trial_by_trial_activity{animal_num}{session_num}];
    end

    % Concatenate.
    mean_activity_animal_session = [mean_activity_animal_session;mean_activity_session];
    region_spec_mean_activity_animal_session = [region_spec_mean_activity_animal_session;region_spec_mean_activity_session];
end

mean_activity_animal_session_APP_all_region = mean_activity_animal_session;
mean_activity_animal_session_APP = region_spec_mean_activity_animal_session;

clearvars -except low_thresh mean_activity_animal_session_control_all_region mean_activity_animal_session_control mean_activity_animal_session_APP_all_region mean_activity_animal_session_APP

% Plot.
figure('Position',[200,800,150,150],'Color','w')
edges = [0.02:0.002:0.12];
hold on
histogram(mean_activity_animal_session_control_all_region,edges,'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6);
histogram(mean_activity_animal_session_APP_all_region,edges,'Normalization','probability','FaceColor',[0.64 0.08 0.18],'EdgeColor','none','FaceAlpha',0.6);
xlabel('Activity');
ylabel('Probability');
xlim([0,0.12])
ylim([0,0.25])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.05,0.1];
ax.YTick = [0,0.1,0.2];
ax.XTickLabel = {'0','0.05','0.1'};
ax.YTickLabel = {'0','0.1','0.2'};

for region_num = 1:8
    figure('Position',[200 + 150*(region_num - 1),550,150,150],'Color','w')
    edges = [0.02:0.002:0.12];
    hold on
    histogram(mean_activity_animal_session_control(:,region_num),edges,'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6);
    histogram(mean_activity_animal_session_APP(:,region_num),edges,'Normalization','probability','FaceColor',[0.64 0.08 0.18],'EdgeColor','none','FaceAlpha',0.6);
    xlabel('Activity');
    ylabel('Probability');
    xlim([0,0.12])
    ylim([0,0.25])
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [0,0.05,0.1];
    ax.YTick = [0,0.1,0.2];
    ax.XTickLabel = {'0','0.05','0.1'};
    ax.YTickLabel = {'0','0.1','0.2'};
end

end