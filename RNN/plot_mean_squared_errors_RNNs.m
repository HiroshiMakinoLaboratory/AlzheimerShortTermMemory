function plot_mean_squared_errors_RNNs

close all
clear all
clc

% Plot mean squared errors (MSE) of RNN models trained using control or APP-KI mice data.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Load data.
load('RNN_mean_squared_error.mat')
control_MSE = MSE.control;
APP_MSE = MSE.APP;
clear MSE

control_MSE_mean = mean(control_MSE);
control_MSE_sem = std(control_MSE)/(length(control_MSE)^0.5);
APP_MSE_mean = mean(APP_MSE);
APP_MSE_sem = std(APP_MSE)/(length(APP_MSE)^0.5);

% Plot MSE.
figure('Position',[200,1000,150,200],'Color','w');
hold on
bar(1,control_MSE_mean,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,APP_MSE_mean,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[control_MSE_mean - control_MSE_sem,control_MSE_mean + control_MSE_sem],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[APP_MSE_mean - APP_MSE_sem,APP_MSE_mean + APP_MSE_sem],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(length(control_MSE),1)/2.5,control_MSE,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(length(APP_MSE),1)/2.5,APP_MSE,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Mean squared error');
xlim([0,3])
ylim([0,0.1])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0, 0.05, 0.1];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0', '0.05', '0.1'};

end