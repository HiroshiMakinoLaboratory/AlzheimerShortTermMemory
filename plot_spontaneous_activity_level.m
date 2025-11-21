function plot_spontaneous_activity_level

close all
clear all
clc

% Analyze spontaneous activity levels of individual neurons.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

low_thresh = -0.0275;

% Control.
load('activity_iti_control.mat')

% Initialize.
mean_mean_activity_iti_control_animal_session = [];
mean_mean_activity_iti_control_animal_session_all_region = [];

for animal_num = 1:numel(activity_iti_control)
    for session_num = 1:numel(activity_iti_control{animal_num})

        % Initialize.
        mean_activity_iti_control_all_region{animal_num}{session_num} = [];

        for region_num = 1:8
            if ~isnan(activity_iti_control{animal_num}{session_num}.region_cell_idx{region_num})
                mean_activity_iti_control{animal_num}{session_num}{region_num} = mean(activity_iti_control{animal_num}{session_num}.activity_iti_all_regions(activity_iti_control{animal_num}{session_num}.region_cell_idx{region_num},:),2);
            else
                mean_activity_iti_control{animal_num}{session_num}{region_num} = [];
            end
            mean_activity_iti_control{animal_num}{session_num}{region_num}(mean_activity_iti_control{animal_num}{session_num}{region_num} <= low_thresh) = nan;

            mean_activity_iti_control_all_region{animal_num}{session_num} = [mean_activity_iti_control_all_region{animal_num}{session_num};mean_activity_iti_control{animal_num}{session_num}{region_num}];
        end

        for region_num = 1:8
            mean_mean_activity_iti_control_session{animal_num}(session_num,region_num) = nanmean(mean_activity_iti_control{animal_num}{session_num}{region_num});
        end
        mean_mean_activity_iti_control_session_all_region{animal_num}(session_num) = nanmean(mean_activity_iti_control_all_region{animal_num}{session_num});
    end

    mean_mean_activity_iti_control_animal_session = [mean_mean_activity_iti_control_animal_session;mean_mean_activity_iti_control_session{animal_num}];
    mean_mean_activity_iti_control_animal_session_all_region = [mean_mean_activity_iti_control_animal_session_all_region,mean_mean_activity_iti_control_session_all_region{animal_num}];
end

% APP.
load('activity_iti_APP.mat')

% Initialize.
mean_mean_activity_iti_APP_animal_session = [];
mean_mean_activity_iti_APP_animal_session_all_region = [];

for animal_num = 1:numel(activity_iti_APP)
    for session_num = 1:numel(activity_iti_APP{animal_num})

        % Initialize.
        mean_activity_iti_APP_all_region{animal_num}{session_num} = [];

        for region_num = 1:8
            if ~isnan(activity_iti_APP{animal_num}{session_num}.region_cell_idx{region_num})
                mean_activity_iti_APP{animal_num}{session_num}{region_num} = mean(activity_iti_APP{animal_num}{session_num}.activity_iti_all_regions(activity_iti_APP{animal_num}{session_num}.region_cell_idx{region_num},:),2);
            else
                mean_activity_iti_APP{animal_num}{session_num}{region_num} = [];
            end
            mean_activity_iti_APP{animal_num}{session_num}{region_num}(mean_activity_iti_APP{animal_num}{session_num}{region_num} <= low_thresh) = nan;

            mean_activity_iti_APP_all_region{animal_num}{session_num} = [mean_activity_iti_APP_all_region{animal_num}{session_num};mean_activity_iti_APP{animal_num}{session_num}{region_num}];
        end

        for region_num = 1:8
            mean_mean_activity_iti_APP_session{animal_num}(session_num,region_num) = nanmean(mean_activity_iti_APP{animal_num}{session_num}{region_num});
        end
        mean_mean_activity_iti_APP_session_all_region{animal_num}(session_num) = nanmean(mean_activity_iti_APP_all_region{animal_num}{session_num});
    end

    mean_mean_activity_iti_APP_animal_session = [mean_mean_activity_iti_APP_animal_session;mean_mean_activity_iti_APP_session{animal_num}];
    mean_mean_activity_iti_APP_animal_session_all_region = [mean_mean_activity_iti_APP_animal_session_all_region,mean_mean_activity_iti_APP_session_all_region{animal_num}];
end

% Plot.
figure('Position',[200,800,150,150],'Color','w')
edges = [-0.02:0.002:0.06];
hold on
histogram(mean_mean_activity_iti_control_animal_session_all_region,edges,'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6);
histogram(mean_mean_activity_iti_APP_animal_session_all_region,edges,'Normalization','probability','FaceColor',[0.64 0.08 0.18],'EdgeColor','none','FaceAlpha',0.6);
xlabel('Activity');
ylabel('Probability');
xlim([-0.02,0.06])
ylim([0,0.4])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.02,0.04,0.06];
ax.YTick = [0,0.2,0.4];
ax.XTickLabel = {'0','0.02','0.04','0.06'};
ax.YTickLabel = {'0','0.2','0.4'};

for region_num = 1:8
    figure('Position',[200 + 150*(region_num - 1),550,150,150],'Color','w')
    edges = [-0.02:0.002:0.06];
    hold on
    histogram(mean_mean_activity_iti_control_animal_session(:,region_num),edges,'Normalization','probability','FaceColor',[0.25,0.25,0.25],'EdgeColor','none','FaceAlpha',0.6);
    histogram(mean_mean_activity_iti_APP_animal_session(:,region_num),edges,'Normalization','probability','FaceColor',[0.64 0.08 0.18],'EdgeColor','none','FaceAlpha',0.6);
    xlabel('Activity');
    ylabel('Probability');
    xlim([-0.02,0.06])
    ylim([0,0.4])
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [0,0.04];
    ax.YTick = [0,0.2,0.4];
    ax.XTickLabel = {'0','0.04'};
    ax.YTickLabel = {'0','0.2','0.4'};
end

end