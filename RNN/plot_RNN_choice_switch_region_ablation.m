function plot_RNN_choice_switch_region_ablation

close all
clear all
clc

% Plot perturbation-induced choice switching in RNNs under region-specific ablations.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('RNN_choice_switch_trial_fraction_region_ablation.mat')

switch_trial_fraction_control_no_ablation = [];
switch_trial_fraction_control_ablation_10_percent = [];
switch_trial_fraction_control_ablation_20_percent = [];
switch_trial_fraction_APP_no_ablation = [];
switch_trial_fraction_APP_ablation_10_percent = [];
switch_trial_fraction_APP_ablation_20_percent = [];

for i = 1:30
    if (sum(RNN_choice_switch_trial_fraction.control.no_ablation.L_pos_mid_point{1, i}>=0.5)/length(RNN_choice_switch_trial_fraction.control.no_ablation.L_pos_mid_point{1, i})) ~= 1

        % Control no ablation.
        switch_trial_fraction_control_no_ablation = [switch_trial_fraction_control_no_ablation; sum(RNN_choice_switch_trial_fraction.control.no_ablation.L_pos_mid_point{1, i}>=0.5)/length(RNN_choice_switch_trial_fraction.control.no_ablation.L_pos_mid_point{1, i})];

        % Control 10% ablation.
        temp = [];
        for region_id = 1:8
            temp = [temp, sum(RNN_choice_switch_trial_fraction.control.ablation_entire_region_10_percent.L_pos_mid_point{1, i}{1, region_id}>=0.5)/length(RNN_choice_switch_trial_fraction.control.ablation_entire_region_10_percent.L_pos_mid_point{1, i}{1, region_id})];
        end
        switch_trial_fraction_control_ablation_10_percent = [switch_trial_fraction_control_ablation_10_percent; temp];
        clear temp

        % Control 20% ablation.
        temp = [];
        for region_id = 1:8
            temp = [temp, sum(RNN_choice_switch_trial_fraction.control.ablation_entire_region_20_percent.L_pos_mid_point{1, i}{1, region_id}>=0.5)/length(RNN_choice_switch_trial_fraction.control.ablation_entire_region_20_percent.L_pos_mid_point{1, i}{1, region_id})];
        end
        switch_trial_fraction_control_ablation_20_percent = [switch_trial_fraction_control_ablation_20_percent; temp];
        clear temp
    end

    if (sum(RNN_choice_switch_trial_fraction.APP.no_ablation.L_pos_mid_point{1, i}>=0.5)/length(RNN_choice_switch_trial_fraction.APP.no_ablation.L_pos_mid_point{1, i})) ~= 1

        % APP no ablation.
        switch_trial_fraction_APP_no_ablation = [switch_trial_fraction_APP_no_ablation; sum(RNN_choice_switch_trial_fraction.APP.no_ablation.L_pos_mid_point{1, i}>=0.5)/length(RNN_choice_switch_trial_fraction.APP.no_ablation.L_pos_mid_point{1, i})];

        % APP 10% ablation.
        temp = [];
        for region_id = 1:8
            temp = [temp, sum(RNN_choice_switch_trial_fraction.APP.ablation_entire_region_10_percent.L_pos_mid_point{1, i}{1, region_id}>=0.5)/length(RNN_choice_switch_trial_fraction.APP.ablation_entire_region_10_percent.L_pos_mid_point{1, i}{1, region_id})];
        end
        switch_trial_fraction_APP_ablation_10_percent = [switch_trial_fraction_APP_ablation_10_percent; temp];
        clear temp

        % APP 20% ablation.
        temp = [];
        for region_id = 1:8
            temp = [temp, sum(RNN_choice_switch_trial_fraction.APP.ablation_entire_region_20_percent.L_pos_mid_point{1, i}{1, region_id}>=0.5)/length(RNN_choice_switch_trial_fraction.APP.ablation_entire_region_20_percent.L_pos_mid_point{1, i}{1, region_id})];
        end
        switch_trial_fraction_APP_ablation_20_percent = [switch_trial_fraction_APP_ablation_20_percent; temp];
        clear temp
    end
end

switch_trial_fraction_control_no_ablation = switch_trial_fraction_control_no_ablation*100;
switch_trial_fraction_control_ablation_10_percent = switch_trial_fraction_control_ablation_10_percent*100;
switch_trial_fraction_control_ablation_20_percent = switch_trial_fraction_control_ablation_20_percent*100;
switch_trial_fraction_APP_no_ablation = switch_trial_fraction_APP_no_ablation*100;
switch_trial_fraction_APP_ablation_10_percent = switch_trial_fraction_APP_ablation_10_percent*100;
switch_trial_fraction_APP_ablation_20_percent = switch_trial_fraction_APP_ablation_20_percent*100;

mean_switch_trial_fraction_control_no_ablation = mean(switch_trial_fraction_control_no_ablation);
mean_switch_trial_fraction_control_ablation_10_percent = mean(switch_trial_fraction_control_ablation_10_percent);
mean_switch_trial_fraction_control_ablation_20_percent = mean(switch_trial_fraction_control_ablation_20_percent);
mean_switch_trial_fraction_APP_no_ablation = mean(switch_trial_fraction_APP_no_ablation);
mean_switch_trial_fraction_APP_ablation_10_percent = mean(switch_trial_fraction_APP_ablation_10_percent);
mean_switch_trial_fraction_APP_ablation_20_percent = mean(switch_trial_fraction_APP_ablation_20_percent);

se_switch_trial_fraction_control_no_ablation = std(switch_trial_fraction_control_no_ablation)/(numel(switch_trial_fraction_control_no_ablation)^0.5);
se_switch_trial_fraction_control_ablation_10_percent = std(switch_trial_fraction_control_ablation_10_percent)/(numel(switch_trial_fraction_control_no_ablation)^0.5);
se_switch_trial_fraction_control_ablation_20_percent = std(switch_trial_fraction_control_ablation_20_percent)/(numel(switch_trial_fraction_control_no_ablation)^0.5);
se_switch_trial_fraction_APP_no_ablation = std(switch_trial_fraction_APP_no_ablation)/(numel(switch_trial_fraction_APP_no_ablation)^0.5);
se_switch_trial_fraction_APP_ablation_10_percent = std(switch_trial_fraction_APP_ablation_10_percent)/(numel(switch_trial_fraction_APP_no_ablation)^0.5);
se_switch_trial_fraction_APP_ablation_20_percent = std(switch_trial_fraction_APP_ablation_20_percent)/(numel(switch_trial_fraction_APP_no_ablation)^0.5);

% Plot control 10% ablation.
n = length(switch_trial_fraction_control_no_ablation);
figure('Position',[600,1000,300,300],'Color','w');
set(gcf,'renderer','Painters')
hold on;
bar(1,mean_switch_trial_fraction_control_no_ablation,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None', 'FaceAlpha',0.6)
for i = 2:9
    bar(i,mean_switch_trial_fraction_control_ablation_10_percent(i-1),0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None', 'FaceAlpha',0.6)
end
line([1,1],[mean_switch_trial_fraction_control_no_ablation - se_switch_trial_fraction_control_no_ablation,mean_switch_trial_fraction_control_no_ablation + se_switch_trial_fraction_control_no_ablation],'Color',[0.25,0.25,0.25],'LineWidth',1)
for i = 2:9
    line([i,i],[mean_switch_trial_fraction_control_ablation_10_percent(i-1) - se_switch_trial_fraction_control_ablation_10_percent(i-1), mean_switch_trial_fraction_control_ablation_10_percent(i-1) + se_switch_trial_fraction_control_ablation_10_percent(i-1)],'Color',[0.25,0.25,0.25],'LineWidth',1)
end

xlabel('');
ylabel('Trials switched (%)');
xlim([0,10])
ylim([0,105])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6,7,8,9];
ax.YTick = [0,50,100];
ax.XTickLabel = {'None','ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','50','100'};

% Plot control 20% ablation.
n = length(switch_trial_fraction_control_no_ablation);
figure('Position',[600,1000,300,300],'Color','w');
set(gcf,'renderer','Painters')
hold on;
bar(1,mean_switch_trial_fraction_control_no_ablation,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None', 'FaceAlpha',0.6)
for i = 2:9
    bar(i,mean_switch_trial_fraction_control_ablation_20_percent(i-1),0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None', 'FaceAlpha',0.6)
end
line([1,1],[mean_switch_trial_fraction_control_no_ablation - se_switch_trial_fraction_control_no_ablation,mean_switch_trial_fraction_control_no_ablation + se_switch_trial_fraction_control_no_ablation],'Color',[0.25,0.25,0.25],'LineWidth',1)
for i = 2:9
    line([i,i],[mean_switch_trial_fraction_control_ablation_20_percent(i-1) - se_switch_trial_fraction_control_ablation_20_percent(i-1), mean_switch_trial_fraction_control_ablation_20_percent(i-1) + se_switch_trial_fraction_control_ablation_20_percent(i-1)],'Color',[0.25,0.25,0.25],'LineWidth',1)
end

xlabel('');
ylabel('Trials switched (%)');
xlim([0,10])
ylim([0,105])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6,7,8,9];
ax.YTick = [0,50,100];
ax.XTickLabel = {'None','ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','50','100'};

% Plot APP 10% ablation.
n = length(switch_trial_fraction_APP_no_ablation);
figure('Position',[600,1000,300,300],'Color','w');
set(gcf,'renderer','Painters')
hold on;
bar(1,mean_switch_trial_fraction_APP_no_ablation,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None', 'FaceAlpha',0.6)
for i = 2:9
    bar(i,mean_switch_trial_fraction_APP_ablation_10_percent(i-1),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None', 'FaceAlpha',0.6)
end
line([1,1],[mean_switch_trial_fraction_APP_no_ablation - se_switch_trial_fraction_APP_no_ablation,mean_switch_trial_fraction_APP_no_ablation + se_switch_trial_fraction_APP_no_ablation],'Color',[0.64,0.08,0.18],'LineWidth',1)
for i = 2:9
    line([i,i],[mean_switch_trial_fraction_APP_ablation_10_percent(i-1) - se_switch_trial_fraction_APP_ablation_10_percent(i-1), mean_switch_trial_fraction_APP_ablation_10_percent(i-1) + se_switch_trial_fraction_APP_ablation_10_percent(i-1)],'Color',[0.64,0.08,0.18],'LineWidth',1)
end

xlabel('');
ylabel('Trials switched (%)');
xlim([0,10])
ylim([0,105])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6,7,8,9];
ax.YTick = [0,50,100];
ax.XTickLabel = {'None','ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','50','100'};

% Plot APP 20% ablation.
n = length(switch_trial_fraction_APP_no_ablation);
figure('Position',[600,1000,300,300],'Color','w');
set(gcf,'renderer','Painters')
hold on;
bar(1,mean_switch_trial_fraction_APP_no_ablation,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None', 'FaceAlpha',0.6)
for i = 2:9
    bar(i,mean_switch_trial_fraction_APP_ablation_20_percent(i-1),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None', 'FaceAlpha',0.6)
end
line([1,1],[mean_switch_trial_fraction_APP_no_ablation - se_switch_trial_fraction_APP_no_ablation,mean_switch_trial_fraction_APP_no_ablation + se_switch_trial_fraction_APP_no_ablation],'Color',[0.64,0.08,0.18],'LineWidth',1)
for i = 2:9
    line([i,i],[mean_switch_trial_fraction_APP_ablation_20_percent(i-1) - se_switch_trial_fraction_APP_ablation_20_percent(i-1), mean_switch_trial_fraction_APP_ablation_20_percent(i-1) + se_switch_trial_fraction_APP_ablation_20_percent(i-1)],'Color',[0.64,0.08,0.18],'LineWidth',1)
end

xlabel('');
ylabel('Trials switched (%)');
xlim([0,10])
ylim([0,105])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4,5,6,7,8,9];
ax.YTick = [0,50,100];
ax.XTickLabel = {'None','ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','50','100'};

end