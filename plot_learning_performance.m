function plot_learning_performance

close all
clear all
clc

% Plot the learning performance of control and APP-KI mice.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('behavior_learning_performance.mat');
correct_rate_control = learning_performance.control.learning_curve;
correct_rate_APP = learning_performance.APP.learning_curve;

% Plot learning curves.
figure('Position',[200,1000,225,200],'Color','w');
hold on
max_session_num = size(correct_rate_control, 2);
for i = 1:size(correct_rate_control, 1)
    plot(1:max_session_num,correct_rate_control(i,:),'Color',[0.25,0.25,0.25])
end
clear max_session_num
max_session_num = size(correct_rate_APP, 2);
for i = 1:size(correct_rate_APP, 1)
    plot(1:max_session_num,correct_rate_APP(i,:),'Color',[0.64,0.08,0.18])
end
xlabel('Session');
ylabel('Correct (%)');
xlim([0, 25])
ylim([0, 100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0, 5, 10, 15, 20, 25];
ax.YTick = [0, 20, 40, 60, 80, 100];
ax.XTickLabel = {'1', '5', '10', '15', '20', '25'};
ax.YTickLabel = {'0','20','40','60','80', '100'};

% Plot session numbers.
session_num_control = learning_performance.control.session_number;
session_num_APP = learning_performance.APP.session_number;

mean_session_num_control = mean(session_num_control);
mean_session_num_APP = mean(session_num_APP);
se_session_num_control = std(session_num_control)/(length(session_num_control)^0.5);
se_session_num_APP = std(session_num_APP)/(length(session_num_APP)^0.5);

figure('Position',[500,1000,150,200],'Color','w');
hold on
bar(1,mean_session_num_control,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_session_num_APP,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_session_num_control - se_session_num_control,mean_session_num_control + se_session_num_control],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_session_num_APP - se_session_num_APP,mean_session_num_APP + se_session_num_APP],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(length(session_num_control),1)/2.5,session_num_control,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(length(session_num_APP),1)/2.5,session_num_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Session number to expert');
xlim([0,3])
ylim([0,25])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0,5,10, 15, 20, 25];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0','5','10', '15', '20', '25'};

% Plot learning rates.
clear correct_rate_control correct_rate_APP
correct_rate_control = learning_performance.control.learning_curve;
correct_rate_APP = learning_performance.APP.learning_curve;

learning_rate_control = [];
for i = 1:size(correct_rate_control, 1)
    temp = correct_rate_control(i,:);
    temp = temp(~isnan(temp));
    [L, k, t0, y_fit] = fitSigmoidLearningCurve(temp);
    learning_rate_control = [learning_rate_control, k];
    clear temp y_fit L t0
end

learning_rate_APP = [];
for i = 1:size(correct_rate_APP, 1)
    temp = correct_rate_APP(i,:);
    temp = temp(~isnan(temp));
    [L, k, t0, y_fit] = fitSigmoidLearningCurve(temp);
    learning_rate_APP = [learning_rate_APP, k];
    clear temp y_fit  L t0
end

mean_learning_rate_control = mean(learning_rate_control);
mean_learning_rate_APP = mean(learning_rate_APP);
se_learning_rate_control = std(learning_rate_control)/(length(learning_rate_control)^0.5);
se_learning_rate_APP = std(learning_rate_APP)/(length(learning_rate_APP)^0.5);

figure('Position',[500,1000,150,200],'Color','w');
hold on
bar(1,mean_learning_rate_control,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_learning_rate_APP,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_learning_rate_control - se_learning_rate_control,mean_learning_rate_control + se_learning_rate_control],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_learning_rate_APP - se_learning_rate_APP,mean_learning_rate_APP + se_learning_rate_APP],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(length(learning_rate_control),1)/2.5,learning_rate_control,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(length(learning_rate_APP),1)/2.5,learning_rate_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Learning rate');
xlim([0,3])
ylim([0,2])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0, 1, 2];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0','1','2'};

end

function [L, k, t0, y_fit] = fitSigmoidLearningCurve(y)
if isempty(y)
    error('Input "y" cannot be empty.');
end

t = 1:length(y);

% Improved initial guesses.
L0 = max(y) * 1.05;
half_max = max(y) / 2;
t0_0 = find(y >= half_max, 1, 'first');
if isempty(t0_0), t0_0 = median(t); end
k0 = 0.3;
params0 = [L0, k0, t0_0];

% Bounds.
lb = [0, 0, 0];
ub = [1.5 * max(y), 5, length(y)];

% Define sigmoid model.
sigmoid_fun = @(p, t) p(1) ./ (1 + exp(-p(2) * (t - p(3))));

% Fit using nonlinear least squares.
options = optimset('Display','off');
params_fit = lsqcurvefit(sigmoid_fun, params0, t, y, lb, ub, options);

% Extract parameters and fitted values.
L = params_fit(1);
k = params_fit(2);
t0 = params_fit(3);
y_fit = sigmoid_fun(params_fit, t);

end