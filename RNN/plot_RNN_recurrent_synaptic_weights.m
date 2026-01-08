function plot_RNN_recurrent_synaptic_weights

close all
clear all
clc

% Plot RNN recurrent synaptic weights.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('RNN_recurrent_synaptic_weights.mat');

% Get mean of absolute recurrent weight matrices for control RNNs.
control_weights_mean = [];
control_positive_mean = [];
control_negative_mean = [];

for i = 1:30
    temp_weights = cell2mat(control_weights(1, i));
    exc_weights = temp_weights(temp_weights > 0);
    inh_weights = temp_weights(temp_weights < 0);
    control_weights_mean = [control_weights_mean, mean(abs(temp_weights(:)))];
    control_positive_mean = [control_positive_mean, mean(abs(exc_weights(:)))];
    control_negative_mean = [control_negative_mean, mean(abs(inh_weights(:)))];
    clear temp_weights exc_weights inh_weights
end

APP_weights_mean = [];
APP_positive_mean = [];
APP_negative_mean = [];

% Get mean of absolute recurrent weight matrices for APP-KI RNNs.
for i = 1:30
    temp_weights = cell2mat(APP_weights(1, i));
    exc_weights = temp_weights(temp_weights > 0);
    inh_weights = temp_weights(temp_weights < 0);
    APP_weights_mean = [APP_weights_mean, mean(abs(temp_weights(:)))];
    APP_positive_mean = [APP_positive_mean, mean(abs(exc_weights(:)))];
    APP_negative_mean = [APP_negative_mean, mean(abs(inh_weights(:)))];
    clear temp_weights exc_weights inh_weights
end

% Plot of all weights.
mean_all_weights_control_RNNs = mean(control_weights_mean);
mean_all_weights_APP_RNNs = mean(APP_weights_mean);
sem_all_weights_control_RNNs = std(control_weights_mean)/(numel(control_weights_mean)^0.5);
sem_all_weights_APP_RNNs = std(APP_weights_mean)/(numel(APP_weights_mean)^0.5);

figure('Position',[400,1000,200,200],'Color','w');
hold on;
bar(1,mean_all_weights_control_RNNs,0.6,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_all_weights_APP_RNNs,0.6,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_all_weights_control_RNNs - sem_all_weights_control_RNNs, mean_all_weights_control_RNNs + sem_all_weights_control_RNNs],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_all_weights_APP_RNNs - sem_all_weights_APP_RNNs, mean_all_weights_APP_RNNs + sem_all_weights_APP_RNNs],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(numel(control_weights_mean),1)/2.5,control_weights_mean,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(numel(APP_weights_mean),1)/2.5,APP_weights_mean,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Synaptic strength');
xlim([0,3])
ylim([0.055,0.065])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0.055, 0.060, 0.065];
ax.XTickLabel = {'Control','APP'};
ax.YTickLabel = {'0.055','0.060','0.065'};

% Plot of positive weights.
mean_exc_weights_control_RNNs = mean(control_positive_mean);
mean_exc_weights_APP_RNNs = mean(APP_positive_mean);
sem_exc_weights_control_RNNs = std(control_positive_mean)/(numel(control_positive_mean)^0.5);
sem_exc_weights_APP_RNNs = std(APP_positive_mean)/(numel(APP_positive_mean)^0.5);

figure('Position',[600,1000,200,200],'Color','w');
hold on;
bar(1,mean_exc_weights_control_RNNs,0.6,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_exc_weights_APP_RNNs,0.6,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_exc_weights_control_RNNs - sem_exc_weights_control_RNNs, mean_exc_weights_control_RNNs + sem_exc_weights_control_RNNs],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_exc_weights_APP_RNNs - sem_exc_weights_APP_RNNs, mean_exc_weights_APP_RNNs + sem_exc_weights_APP_RNNs],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(numel(control_positive_mean),1)/2.5,control_positive_mean,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(numel(APP_positive_mean),1)/2.5,APP_positive_mean,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Positive synaptic');
xlim([0,3])
ylim([0.055,0.065])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0.055, 0.060, 0.065];
ax.XTickLabel = {'Control','APP'};
ax.YTickLabel = {'0.055','0.060','0.065'};

% Plot of negative weights.
mean_inh_weights_control_RNNs = mean(control_negative_mean);
mean_inh_weights_APP_RNNs = mean(APP_negative_mean);
sem_inh_weights_control_RNNs = std(control_negative_mean)/(numel(control_negative_mean)^0.5);
sem_inh_weights_APP_RNNs = std(APP_negative_mean)/(numel(APP_negative_mean)^0.5);

figure('Position',[800,1000,200,200],'Color','w');
hold on;
bar(1,mean_inh_weights_control_RNNs,0.6,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_inh_weights_APP_RNNs,0.6,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_inh_weights_control_RNNs - sem_inh_weights_control_RNNs, mean_inh_weights_control_RNNs + sem_inh_weights_control_RNNs],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_inh_weights_APP_RNNs - sem_inh_weights_APP_RNNs, mean_inh_weights_APP_RNNs + sem_inh_weights_APP_RNNs],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(numel(control_negative_mean),1)/2.5,control_negative_mean,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(numel(APP_negative_mean),1)/2.5,APP_negative_mean,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Negative synaptic');
xlim([0,3])
ylim([0.055,0.065])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0.055, 0.060, 0.065];
ax.XTickLabel = {'Control','APP'};
ax.YTickLabel = {'0.055','0.060','0.065'};

end