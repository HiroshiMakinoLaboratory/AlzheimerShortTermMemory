function plot_RNN_choice_switch_11sample

close all
clear all
clc

% Plot perturbation-induced choice switching with 11 RNNs.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('RNN_choice_switch_trial_fraction.mat')

% Sample number.
RNN_num = 11;

switch_trial_fraction_control_no_ablation = RNN_choice_switch_trial_fraction.control.no_ablation(1:RNN_num,1);
switch_trial_fraction_control_ablation_10_percent = RNN_choice_switch_trial_fraction.control.ablation_10_percent(1:RNN_num,1);
switch_trial_fraction_control_ablation_20_percent = RNN_choice_switch_trial_fraction.control.ablation_20_percent(1:RNN_num,1);
switch_trial_fraction_APP_no_ablation = RNN_choice_switch_trial_fraction.APP.no_ablation(1:RNN_num,1);
mean_switch_trial_fraction_control_no_ablation = mean(switch_trial_fraction_control_no_ablation);
mean_switch_trial_fraction_control_ablation_10_percent = mean(switch_trial_fraction_control_ablation_10_percent);
mean_switch_trial_fraction_control_ablation_20_percent = mean(switch_trial_fraction_control_ablation_20_percent);
mean_switch_trial_fraction_APP_no_ablation = mean(switch_trial_fraction_APP_no_ablation);
se_switch_trial_fraction_control_no_ablation = std(switch_trial_fraction_control_no_ablation)/(numel(switch_trial_fraction_control_no_ablation)^0.5);
se_switch_trial_fraction_control_ablation_10_percent = std(switch_trial_fraction_control_ablation_10_percent)/(numel(switch_trial_fraction_control_ablation_10_percent)^0.5);
se_switch_trial_fraction_control_ablation_20_percent = std(switch_trial_fraction_control_ablation_20_percent)/(numel(switch_trial_fraction_control_ablation_20_percent)^0.5);
se_switch_trial_fraction_APP_no_ablation = std(switch_trial_fraction_APP_no_ablation)/(numel(switch_trial_fraction_APP_no_ablation)^0.5);

% Plot.
figure('Position',[200,1000,200,200],'Color','w')
hold on;
bar(1,mean_switch_trial_fraction_control_no_ablation,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_switch_trial_fraction_control_ablation_10_percent,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(3,mean_switch_trial_fraction_control_ablation_20_percent,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(4,mean_switch_trial_fraction_APP_no_ablation,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_switch_trial_fraction_control_no_ablation - se_switch_trial_fraction_control_no_ablation,mean_switch_trial_fraction_control_no_ablation + se_switch_trial_fraction_control_no_ablation],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_switch_trial_fraction_control_ablation_10_percent - se_switch_trial_fraction_control_ablation_10_percent,mean_switch_trial_fraction_control_ablation_10_percent + se_switch_trial_fraction_control_ablation_10_percent],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([3,3],[mean_switch_trial_fraction_control_ablation_20_percent - se_switch_trial_fraction_control_ablation_20_percent,mean_switch_trial_fraction_control_ablation_20_percent + se_switch_trial_fraction_control_ablation_20_percent],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([4,4],[mean_switch_trial_fraction_APP_no_ablation - se_switch_trial_fraction_APP_no_ablation,mean_switch_trial_fraction_APP_no_ablation + se_switch_trial_fraction_APP_no_ablation],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(numel(switch_trial_fraction_control_no_ablation),1)/2.5,switch_trial_fraction_control_no_ablation,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(numel(switch_trial_fraction_control_ablation_10_percent),1)/2.5,switch_trial_fraction_control_ablation_10_percent,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(2.8 + rand(numel(switch_trial_fraction_control_ablation_20_percent),1)/2.5,switch_trial_fraction_control_ablation_20_percent,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(3.8 + rand(numel(switch_trial_fraction_APP_no_ablation),1)/2.5,switch_trial_fraction_APP_no_ablation,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Trials switched (%)');
xlim([0,5])
ylim([-5,105])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4];
ax.YTick = [0,50,100];
ax.XTickLabel = {'0','10','20','0'};
ax.YTickLabel = {'0','50','100'};

end