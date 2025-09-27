function plot_task_performance_APP_mice_6_9_months

close all
clear all
clc

% Plot task performance for 6-month-old and 9-month-old APP-KI mice.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% APP.
load('behavior_APP.mat')
behavior = behavior_APP;
clear behavior_APP

animal_6_months_ID = [1, 5, 6];
animal_9_months_ID = [7, 9, 10];

% Initialize.
correct_rate_animal_session = [];

for i = 1:numel(animal_6_months_ID)
    animal_num = animal_6_months_ID(i);
    clearvars -except behavior correct_rate_animal_session animal_num animal_6_months_ID animal_9_months_ID

    % Initialize.
    correct_rate_session{animal_num} = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior correct_rate_animal_session animal_num correct_rate_session session_num animal_6_months_ID animal_9_months_ID

        % Correct rate.
        for trial_type = 1:8 % 1: control left; 2: control right; 3: distractor early left; 4: distractor early right; 5: distractor middle left; 6: distractor middle right; 7: distractor late left; 8: distractor late right
            correct_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.Outcomes(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type) == 1);
            response_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type & behavior{animal_num}{session_num}.bpod.Outcomes ~= 3);
        end

        for distractor_type = 1:4
            correct_rate_session{animal_num}(session_num,distractor_type) = (correct_trial_num(distractor_type*2 - 1) + correct_trial_num(distractor_type*2))/(response_trial_num(distractor_type*2 - 1) + response_trial_num(distractor_type*2));
        end
        correct_rate_all_distractor{animal_num}(session_num) = sum(correct_trial_num(3:8))/sum(response_trial_num(3:8));
    end

    correct_rate_animal_session = [correct_rate_animal_session;correct_rate_session{animal_num}];
end

correct_rate_animal_session_APP_6M = correct_rate_animal_session;
clearvars -except behavior correct_rate_animal_session_APP_6M animal_9_months_ID

% Initialize.
correct_rate_animal_session = [];

for i = 1:numel(animal_9_months_ID)
    animal_num = animal_9_months_ID(i);
    clearvars -except behavior correct_rate_animal_session animal_num animal_9_months_ID correct_rate_animal_session_APP_6M

    % Initialize.
    correct_rate_session{animal_num} = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior correct_rate_animal_session animal_num correct_rate_session session_num animal_9_months_ID correct_rate_animal_session_APP_6M

        % Correct rate.
        for trial_type = 1:8 % 1: control left; 2: control right; 3: distractor early left; 4: distractor early right; 5: distractor middle left; 6: distractor middle right; 7: distractor late left; 8: distractor late right
            correct_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.Outcomes(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type) == 1);
            response_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type & behavior{animal_num}{session_num}.bpod.Outcomes ~= 3);
        end

        for distractor_type = 1:4
            correct_rate_session{animal_num}(session_num,distractor_type) = (correct_trial_num(distractor_type*2 - 1) + correct_trial_num(distractor_type*2))/(response_trial_num(distractor_type*2 - 1) + response_trial_num(distractor_type*2));
        end
        correct_rate_all_distractor{animal_num}(session_num) = sum(correct_trial_num(3:8))/sum(response_trial_num(3:8));
    end

    correct_rate_animal_session = [correct_rate_animal_session;correct_rate_session{animal_num}];
end

correct_rate_animal_session_APP_9M = correct_rate_animal_session;
clearvars -except correct_rate_animal_session_APP_9M correct_rate_animal_session_APP_6M

% Plot.
mean_correct_rate_animal_session_APP_9M = 100*mean(correct_rate_animal_session_APP_9M);
mean_correct_rate_animal_session_APP_6M = 100*mean(correct_rate_animal_session_APP_6M);
se_correct_rate_animal_session_APP_9M = 100*std(correct_rate_animal_session_APP_9M)/(size(correct_rate_animal_session_APP_9M,1)^0.5);
se_correct_rate_animal_session_APP_6M = 100*std(correct_rate_animal_session_APP_6M)/(size(correct_rate_animal_session_APP_6M,1)^0.5);

figure('Position',[200,1000,300,200],'Color','w');
hold on
for trial_type = 1:4
    bar(1 + (trial_type - 1)*3, mean_correct_rate_animal_session_APP_6M(trial_type),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
    bar(2 + (trial_type - 1)*3, mean_correct_rate_animal_session_APP_9M(trial_type),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.8)
    line([1 + (trial_type - 1)*3, 1 + (trial_type - 1)*3],[mean_correct_rate_animal_session_APP_6M(trial_type) - se_correct_rate_animal_session_APP_6M(trial_type),mean_correct_rate_animal_session_APP_6M(trial_type) + se_correct_rate_animal_session_APP_6M(trial_type)],'Color',[0.64,0.08,0.18],'LineWidth',1)
    line([2 + (trial_type - 1)*3, 2 + (trial_type - 1)*3],[mean_correct_rate_animal_session_APP_9M(trial_type) - se_correct_rate_animal_session_APP_9M(trial_type),mean_correct_rate_animal_session_APP_9M(trial_type) + se_correct_rate_animal_session_APP_9M(trial_type)],'Color',[0.64,0.08,0.18],'LineWidth',1)
    plot(0.8 + (trial_type - 1)*3 + rand(size(correct_rate_animal_session_APP_6M,1),1)/2.5,100*correct_rate_animal_session_APP_6M(:,trial_type),'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
    plot(1.8 + (trial_type - 1)*3 + rand(size(correct_rate_animal_session_APP_9M,1),1)/2.5,100*correct_rate_animal_session_APP_9M(:,trial_type),'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
end
xlabel('');
ylabel('Correct rate (%)');
xlim([0,12])
ylim([0,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1.5,4.5,7.5,10.5];
ax.YTick = [0,50,100];
ax.XTickLabel = {'Ctrl','Dist1','Dist2','Dist3'};
ax.YTickLabel = {'0','50','100'};

end