function plot_communication_subspace_similarity_epoch

close all
clear all
clc

% Plot communication subspace similarity in each epoch.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('population_regression_control.mat')
load('population_regression_APP.mat')

% Stimulus.
% Control.
mean_similarity_animal_session_control = population_regression_control.stim_similarity.q3.mean_similarity_animal_session;
clearvars -except population_regression_control population_regression_APP epoch mean_similarity_animal_session_control

% APP.
mean_similarity_animal_session_APP = population_regression_APP.stim_similarity.q3.mean_similarity_animal_session;
clearvars -except population_regression_control population_regression_APP epoch mean_similarity_animal_session_control mean_similarity_animal_session_APP

for source = 1:8
    mean_mean_similarity_animal_session_control{source} = nanmean(mean_similarity_animal_session_control{source},3);
    mean_mean_similarity_animal_session_APP{source} = nanmean(mean_similarity_animal_session_APP{source},3);
    mean_mean_similarity_animal_session_diff{source} = mean_mean_similarity_animal_session_control{source} - mean_mean_similarity_animal_session_APP{source};
end

% Plot.
for source = 1:8
    figure('Position',[100*source,900,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_control{source},[0.15,0.2])
    colormap('viridis')
    axis square
    axis off

    figure('Position',[100*source,900,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_APP{source},[0.15,0.2])
    colormap('viridis')
    axis square
    axis off
end

% Two-way ANOVA.
inter_idx = [2:8,11:16,20:24,29:32,38:40,47:48,56];
reshaped_mean_similarity_animal_session_control_all = [];
group_source_control = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_control{source} = reshape(mean_similarity_animal_session_control{source},[64,size(mean_similarity_animal_session_control{source},3)]);
    inter_reshaped_mean_similarity_animal_session_control_temp{source} = reshaped_mean_similarity_animal_session_control{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_control{source} = inter_reshaped_mean_similarity_animal_session_control_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_control_temp{source})));

    reshaped_mean_similarity_animal_session_control_all = [reshaped_mean_similarity_animal_session_control_all;inter_reshaped_mean_similarity_animal_session_control{source}];
    switch source
        case 1
            group_source_control = [group_source_control;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 2
            group_source_control = [group_source_control;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 3
            group_source_control = [group_source_control;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 4
            group_source_control = [group_source_control;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 5
            group_source_control = [group_source_control;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 6
            group_source_control = [group_source_control;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 7
            group_source_control = [group_source_control;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 8
            group_source_control = [group_source_control;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
    end
end

reshaped_mean_similarity_animal_session_APP_all = [];
group_source_APP = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_APP{source} = reshape(mean_similarity_animal_session_APP{source},[64,size(mean_similarity_animal_session_APP{source},3)]);
    inter_reshaped_mean_similarity_animal_session_APP_temp{source} = reshaped_mean_similarity_animal_session_APP{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_APP{source} = inter_reshaped_mean_similarity_animal_session_APP_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_APP_temp{source})));

    reshaped_mean_similarity_animal_session_APP_all = [reshaped_mean_similarity_animal_session_APP_all;inter_reshaped_mean_similarity_animal_session_APP{source}];
    switch source
        case 1
            group_source_APP = [group_source_APP;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 2
            group_source_APP = [group_source_APP;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 3
            group_source_APP = [group_source_APP;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 4
            group_source_APP = [group_source_APP;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 5
            group_source_APP = [group_source_APP;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 6
            group_source_APP = [group_source_APP;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 7
            group_source_APP = [group_source_APP;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 8
            group_source_APP = [group_source_APP;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
    end
end

data_all = [reshaped_mean_similarity_animal_session_control_all;reshaped_mean_similarity_animal_session_APP_all];
group_genotype_all = [repmat({'control'},numel(reshaped_mean_similarity_animal_session_control_all),1);repmat({'APP'},numel(reshaped_mean_similarity_animal_session_APP_all),1)];
group_source_all = [group_source_control;group_source_APP];
[p_stim,tbl_stim,stats_stim,terms_stim] = anovan(data_all,{group_genotype_all,group_source_all},"Model","interaction","Varnames",["genotype","source"]);
figure('Position',[1000,900,300,200],'Color','w')
[results_stim,~,~,~] = multcompare(stats_stim,"Alpha",0.001,"Dimension",[1,2]);

% Statistics.
rng(0)
source = 8; % PPC.
clearvars -except population_regression_control population_regression_APP mean_similarity_animal_session_control mean_similarity_animal_session_APP source
for region_num1 = 1:8
    for region_num2 = 1:8
        mean_similarity_control_temp{region_num1}{region_num2} = squeeze(mean_similarity_animal_session_control{source}(region_num1,region_num2,:));
        mean_similarity_control{region_num1}{region_num2} = mean_similarity_control_temp{region_num1}{region_num2}(~isnan(mean_similarity_control_temp{region_num1}{region_num2}));

        mean_similarity_APP_temp{region_num1}{region_num2} = squeeze(mean_similarity_animal_session_APP{source}(region_num1,region_num2,:));
        mean_similarity_APP{region_num1}{region_num2} = mean_similarity_APP_temp{region_num1}{region_num2}(~isnan(mean_similarity_APP_temp{region_num1}{region_num2}));

        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(mean_similarity_control{region_num1}{region_num2})
                sampled_mean_similarity_control{region_num1}{region_num2}(shuffle_num,session_num) = mean_similarity_control{region_num1}{region_num2}(randi(numel(mean_similarity_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(mean_similarity_APP{region_num1}{region_num2})
                sampled_mean_similarity_APP{region_num1}{region_num2}(shuffle_num,session_num) = mean_similarity_APP{region_num1}{region_num2}(randi(numel(mean_similarity_APP{region_num1}{region_num2})));
            end
        end
        p_value(region_num1,region_num2) = sum(mean(sampled_mean_similarity_control{region_num1}{region_num2},2) < mean(sampled_mean_similarity_APP{region_num1}{region_num2},2))/1000;
    end
end

% Make it symmetrical.
for region_num = 1:7
    p_value(region_num,(region_num + 1):8) = nan;
end
p_value = p_value(~isnan(p_value));

% False discovery rate.
[val,idx] = sort(p_value);
adjusted_p_value_005 = ((1:numel(p_value))*0.05)/numel(p_value);
adjusted_p_value_001 = ((1:numel(p_value))*0.01)/numel(p_value);
adjusted_p_value_0001 = ((1:numel(p_value))*0.001)/numel(p_value);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix = zeros(8,8);
p_value_matrix(1:8,1) = vector(1:8);
p_value_matrix(2:8,2) = vector(9:15);
p_value_matrix(3:8,3) = vector(16:21);
p_value_matrix(4:8,4) = vector(22:26);
p_value_matrix(5:8,5) = vector(27:30);
p_value_matrix(6:8,6) = vector(31:33);
p_value_matrix(7:8,7) = vector(34:35);
p_value_matrix(8,8) = vector(36);
p_value_matrix(1,1:8) = vector(1:8);
p_value_matrix(2,2:8) = vector(9:15);
p_value_matrix(3,3:8) = vector(16:21);
p_value_matrix(4,4:8) = vector(22:26);
p_value_matrix(5,5:8) = vector(27:30);
p_value_matrix(6,6:8) = vector(31:33);
p_value_matrix(7,7:8) = vector(34:35);
p_value_matrix(8,8) = vector(36);

% Plot.
figure('Position',[900,900,100,100],'Color','w')
imagesc(p_value_matrix,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

region_num1 = 1; % ALM.
region_num2 = 8; % PPC.
mean_mean_similarity_control = nanmean(mean_similarity_control{region_num1}{region_num2});
mean_mean_similarity_APP = nanmean(mean_similarity_APP{region_num1}{region_num2});
se_mean_similarity_control = nanstd(mean_similarity_control{region_num1}{region_num2})/(sum(~isnan(mean_similarity_control{region_num1}{region_num2}))^0.5);
se_mean_similarity_APP = nanstd(mean_similarity_APP{region_num1}{region_num2})/(sum(~isnan(mean_similarity_APP{region_num1}{region_num2}))^0.5);

figure('Position',[1000,900,150,100],'Color','w')
hold on
bar(1,mean_mean_similarity_control,0.8,'FaceColor',[0.47,0.67,0.19],'EdgeColor','None','FaceAlpha',0.8)
bar(2,mean_mean_similarity_APP,0.8,'FaceColor',[0.47,0.67,0.19],'EdgeColor','None','FaceAlpha',0.4)
line([1,1],[mean_mean_similarity_control - se_mean_similarity_control,mean_mean_similarity_control + se_mean_similarity_control],'Color',[0.47,0.67,0.19],'LineWidth',1)
line([2,2],[mean_mean_similarity_APP - se_mean_similarity_APP,mean_mean_similarity_APP + se_mean_similarity_APP],'Color',[0.47,0.67,0.19],'LineWidth',1)
xlabel('');
ylabel('Similarity');
xlim([0,3])
ylim([0,0.25])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0,0.1,0.2];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0','0.1','0.2'};

clearvars -except population_regression_control population_regression_APP p_stim results_stim

% Delay.
% Control.
mean_similarity_animal_session_control = population_regression_control.delay_similarity.q3.mean_similarity_animal_session;
clearvars -except population_regression_control population_regression_APP p_stim results_stim ...
    epoch mean_similarity_animal_session_control

% APP.
mean_similarity_animal_session_APP = population_regression_APP.delay_similarity.q3.mean_similarity_animal_session;
clearvars -except population_regression_control population_regression_APP p_stim results_stim ...
    epoch mean_similarity_animal_session_control mean_similarity_animal_session_APP

for source = 1:8
    mean_mean_similarity_animal_session_control{source} = nanmean(mean_similarity_animal_session_control{source},3);
    mean_mean_similarity_animal_session_APP{source} = nanmean(mean_similarity_animal_session_APP{source},3);
    mean_mean_similarity_animal_session_diff{source} = mean_mean_similarity_animal_session_control{source} - mean_mean_similarity_animal_session_APP{source};
end

% Plot.
for source = 1:8
    figure('Position',[100*source,700,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_control{source},[0.15,0.2])
    colormap('viridis')
    axis square
    axis off

    figure('Position',[100*source,700,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_APP{source},[0.15,0.2])
    colormap('viridis')
    axis square
    axis off
end

% Two-way ANOVA.
inter_idx = [2:8,11:16,20:24,29:32,38:40,47:48,56];
reshaped_mean_similarity_animal_session_control_all = [];
group_source_control = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_control{source} = reshape(mean_similarity_animal_session_control{source},[64,size(mean_similarity_animal_session_control{source},3)]);
    inter_reshaped_mean_similarity_animal_session_control_temp{source} = reshaped_mean_similarity_animal_session_control{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_control{source} = inter_reshaped_mean_similarity_animal_session_control_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_control_temp{source})));

    reshaped_mean_similarity_animal_session_control_all = [reshaped_mean_similarity_animal_session_control_all;inter_reshaped_mean_similarity_animal_session_control{source}];
    switch source
        case 1
            group_source_control = [group_source_control;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 2
            group_source_control = [group_source_control;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 3
            group_source_control = [group_source_control;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 4
            group_source_control = [group_source_control;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 5
            group_source_control = [group_source_control;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 6
            group_source_control = [group_source_control;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 7
            group_source_control = [group_source_control;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 8
            group_source_control = [group_source_control;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
    end
end

reshaped_mean_similarity_animal_session_APP_all = [];
group_source_APP = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_APP{source} = reshape(mean_similarity_animal_session_APP{source},[64,size(mean_similarity_animal_session_APP{source},3)]);
    inter_reshaped_mean_similarity_animal_session_APP_temp{source} = reshaped_mean_similarity_animal_session_APP{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_APP{source} = inter_reshaped_mean_similarity_animal_session_APP_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_APP_temp{source})));

    reshaped_mean_similarity_animal_session_APP_all = [reshaped_mean_similarity_animal_session_APP_all;inter_reshaped_mean_similarity_animal_session_APP{source}];
    switch source
        case 1
            group_source_APP = [group_source_APP;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 2
            group_source_APP = [group_source_APP;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 3
            group_source_APP = [group_source_APP;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 4
            group_source_APP = [group_source_APP;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 5
            group_source_APP = [group_source_APP;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 6
            group_source_APP = [group_source_APP;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 7
            group_source_APP = [group_source_APP;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 8
            group_source_APP = [group_source_APP;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
    end
end

data_all = [reshaped_mean_similarity_animal_session_control_all;reshaped_mean_similarity_animal_session_APP_all];
group_genotype_all = [repmat({'control'},numel(reshaped_mean_similarity_animal_session_control_all),1);repmat({'APP'},numel(reshaped_mean_similarity_animal_session_APP_all),1)];
group_source_all = [group_source_control;group_source_APP];
[p_delay,tbl_delay,stats_delay,terms_delay] = anovan(data_all,{group_genotype_all,group_source_all},"Model","interaction","Varnames",["genotype","source"]);
figure('Position',[1000,600,300,200],'Color','w')
[results_delay,~,~,~] = multcompare(stats_delay,"Alpha",0.001,"Dimension",[1,2]);

% Statistics.
rng(0)
source = 8; % PPC.
clearvars -except population_regression_control population_regression_APP mean_similarity_animal_session_control mean_similarity_animal_session_APP source
for region_num1 = 1:8
    for region_num2 = 1:8
        mean_similarity_control_temp{region_num1}{region_num2} = squeeze(mean_similarity_animal_session_control{source}(region_num1,region_num2,:));
        mean_similarity_control{region_num1}{region_num2} = mean_similarity_control_temp{region_num1}{region_num2}(~isnan(mean_similarity_control_temp{region_num1}{region_num2}));

        mean_similarity_APP_temp{region_num1}{region_num2} = squeeze(mean_similarity_animal_session_APP{source}(region_num1,region_num2,:));
        mean_similarity_APP{region_num1}{region_num2} = mean_similarity_APP_temp{region_num1}{region_num2}(~isnan(mean_similarity_APP_temp{region_num1}{region_num2}));

        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(mean_similarity_control{region_num1}{region_num2})
                sampled_mean_similarity_control{region_num1}{region_num2}(shuffle_num,session_num) = mean_similarity_control{region_num1}{region_num2}(randi(numel(mean_similarity_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(mean_similarity_APP{region_num1}{region_num2})
                sampled_mean_similarity_APP{region_num1}{region_num2}(shuffle_num,session_num) = mean_similarity_APP{region_num1}{region_num2}(randi(numel(mean_similarity_APP{region_num1}{region_num2})));
            end
        end
        p_value(region_num1,region_num2) = sum(mean(sampled_mean_similarity_control{region_num1}{region_num2},2) < mean(sampled_mean_similarity_APP{region_num1}{region_num2},2))/1000;
    end
end

% Make it symmetrical.
for region_num = 1:7
    p_value(region_num,(region_num + 1):8) = nan;
end
p_value = p_value(~isnan(p_value));

% False discovery rate.
[val,idx] = sort(p_value);
adjusted_p_value_005 = ((1:numel(p_value))*0.05)/numel(p_value);
adjusted_p_value_001 = ((1:numel(p_value))*0.01)/numel(p_value);
adjusted_p_value_0001 = ((1:numel(p_value))*0.001)/numel(p_value);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix = zeros(8,8);
p_value_matrix(1:8,1) = vector(1:8);
p_value_matrix(2:8,2) = vector(9:15);
p_value_matrix(3:8,3) = vector(16:21);
p_value_matrix(4:8,4) = vector(22:26);
p_value_matrix(5:8,5) = vector(27:30);
p_value_matrix(6:8,6) = vector(31:33);
p_value_matrix(7:8,7) = vector(34:35);
p_value_matrix(8,8) = vector(36);
p_value_matrix(1,1:8) = vector(1:8);
p_value_matrix(2,2:8) = vector(9:15);
p_value_matrix(3,3:8) = vector(16:21);
p_value_matrix(4,4:8) = vector(22:26);
p_value_matrix(5,5:8) = vector(27:30);
p_value_matrix(6,6:8) = vector(31:33);
p_value_matrix(7,7:8) = vector(34:35);
p_value_matrix(8,8) = vector(36);

% Plot.
figure('Position',[900,700,100,100],'Color','w')
imagesc(p_value_matrix,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

region_num1 = 1; % ALM.
region_num2 = 8; % PPC.
mean_mean_similarity_control = nanmean(mean_similarity_control{region_num1}{region_num2});
mean_mean_similarity_APP = nanmean(mean_similarity_APP{region_num1}{region_num2});
se_mean_similarity_control = nanstd(mean_similarity_control{region_num1}{region_num2})/(sum(~isnan(mean_similarity_control{region_num1}{region_num2}))^0.5);
se_mean_similarity_APP = nanstd(mean_similarity_APP{region_num1}{region_num2})/(sum(~isnan(mean_similarity_APP{region_num1}{region_num2}))^0.5);

figure('Position',[1000,700,150,100],'Color','w')
hold on
bar(1,mean_mean_similarity_control,0.8,'FaceColor',[0.00,0.45,0.74],'EdgeColor','None','FaceAlpha',0.8)
bar(2,mean_mean_similarity_APP,0.8,'FaceColor',[0.00,0.45,0.74],'EdgeColor','None','FaceAlpha',0.4)
line([1,1],[mean_mean_similarity_control - se_mean_similarity_control,mean_mean_similarity_control + se_mean_similarity_control],'Color',[0.00,0.45,0.74],'LineWidth',1)
line([2,2],[mean_mean_similarity_APP - se_mean_similarity_APP,mean_mean_similarity_APP + se_mean_similarity_APP],'Color',[0.00,0.45,0.74],'LineWidth',1)
xlabel('');
ylabel('Similarity');
xlim([0,3])
ylim([0,0.25])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0,0.1,0.2];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0','0.1','0.2'};

clearvars -except population_regression_control population_regression_APP p_stim results_stim p_delay results_delay

% Action.
% Control.
mean_similarity_animal_session_control = population_regression_control.action_similarity.q3.mean_similarity_animal_session;
clearvars -except population_regression_control population_regression_APP p_stim results_stim p_delay results_delay ...
    epoch mean_similarity_animal_session_control

% APP.
mean_similarity_animal_session_APP = population_regression_APP.action_similarity.q3.mean_similarity_animal_session;
clearvars -except population_regression_control population_regression_APP p_stim results_stim p_delay results_delay ...
    epoch mean_similarity_animal_session_control mean_similarity_animal_session_APP

for source = 1:8
    mean_mean_similarity_animal_session_control{source} = nanmean(mean_similarity_animal_session_control{source},3);
    mean_mean_similarity_animal_session_APP{source} = nanmean(mean_similarity_animal_session_APP{source},3);
    mean_mean_similarity_animal_session_diff{source} = mean_mean_similarity_animal_session_control{source} - mean_mean_similarity_animal_session_APP{source};
end

% Plot.
for source = 1:8
    figure('Position',[100*source,500,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_control{source},[0.15,0.2])
    colormap('viridis')
    axis square
    axis off

    figure('Position',[100*source,500,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_APP{source},[0.15,0.2])
    colormap('viridis')
    axis square
    axis off
end

% Two-way ANOVA.
inter_idx = [2:8,11:16,20:24,29:32,38:40,47:48,56];
reshaped_mean_similarity_animal_session_control_all = [];
group_source_control = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_control{source} = reshape(mean_similarity_animal_session_control{source},[64,size(mean_similarity_animal_session_control{source},3)]);
    inter_reshaped_mean_similarity_animal_session_control_temp{source} = reshaped_mean_similarity_animal_session_control{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_control{source} = inter_reshaped_mean_similarity_animal_session_control_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_control_temp{source})));

    reshaped_mean_similarity_animal_session_control_all = [reshaped_mean_similarity_animal_session_control_all;inter_reshaped_mean_similarity_animal_session_control{source}];
    switch source
        case 1
            group_source_control = [group_source_control;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 2
            group_source_control = [group_source_control;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 3
            group_source_control = [group_source_control;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 4
            group_source_control = [group_source_control;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 5
            group_source_control = [group_source_control;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 6
            group_source_control = [group_source_control;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 7
            group_source_control = [group_source_control;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 8
            group_source_control = [group_source_control;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
    end
end

reshaped_mean_similarity_animal_session_APP_all = [];
group_source_APP = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_APP{source} = reshape(mean_similarity_animal_session_APP{source},[64,size(mean_similarity_animal_session_APP{source},3)]);
    inter_reshaped_mean_similarity_animal_session_APP_temp{source} = reshaped_mean_similarity_animal_session_APP{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_APP{source} = inter_reshaped_mean_similarity_animal_session_APP_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_APP_temp{source})));

    reshaped_mean_similarity_animal_session_APP_all = [reshaped_mean_similarity_animal_session_APP_all;inter_reshaped_mean_similarity_animal_session_APP{source}];
    switch source
        case 1
            group_source_APP = [group_source_APP;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 2
            group_source_APP = [group_source_APP;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 3
            group_source_APP = [group_source_APP;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 4
            group_source_APP = [group_source_APP;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 5
            group_source_APP = [group_source_APP;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 6
            group_source_APP = [group_source_APP;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 7
            group_source_APP = [group_source_APP;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 8
            group_source_APP = [group_source_APP;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
    end
end

data_all = [reshaped_mean_similarity_animal_session_control_all;reshaped_mean_similarity_animal_session_APP_all];
group_genotype_all = [repmat({'control'},numel(reshaped_mean_similarity_animal_session_control_all),1);repmat({'APP'},numel(reshaped_mean_similarity_animal_session_APP_all),1)];
group_source_all = [group_source_control;group_source_APP];
[p_action,tbl_action,stats_action,terms_action] = anovan(data_all,{group_genotype_all,group_source_all},"Model","interaction","Varnames",["genotype","source"]);
figure('Position',[1000,300,300,200],'Color','w')
[results_action,~,~,~] = multcompare(stats_action,"Alpha",0.001,"Dimension",[1,2]);

% Statistics.
rng(0)
source = 8; % PPC.
clearvars -except population_regression_control population_regression_APP mean_similarity_animal_session_control mean_similarity_animal_session_APP source
for region_num1 = 1:8
    for region_num2 = 1:8
        mean_similarity_control_temp{region_num1}{region_num2} = squeeze(mean_similarity_animal_session_control{source}(region_num1,region_num2,:));
        mean_similarity_control{region_num1}{region_num2} = mean_similarity_control_temp{region_num1}{region_num2}(~isnan(mean_similarity_control_temp{region_num1}{region_num2}));

        mean_similarity_APP_temp{region_num1}{region_num2} = squeeze(mean_similarity_animal_session_APP{source}(region_num1,region_num2,:));
        mean_similarity_APP{region_num1}{region_num2} = mean_similarity_APP_temp{region_num1}{region_num2}(~isnan(mean_similarity_APP_temp{region_num1}{region_num2}));

        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(mean_similarity_control{region_num1}{region_num2})
                sampled_mean_similarity_control{region_num1}{region_num2}(shuffle_num,session_num) = mean_similarity_control{region_num1}{region_num2}(randi(numel(mean_similarity_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(mean_similarity_APP{region_num1}{region_num2})
                sampled_mean_similarity_APP{region_num1}{region_num2}(shuffle_num,session_num) = mean_similarity_APP{region_num1}{region_num2}(randi(numel(mean_similarity_APP{region_num1}{region_num2})));
            end
        end
        p_value(region_num1,region_num2) = sum(mean(sampled_mean_similarity_control{region_num1}{region_num2},2) < mean(sampled_mean_similarity_APP{region_num1}{region_num2},2))/1000;
    end
end

% Make it symmetrical.
for region_num = 1:7
    p_value(region_num,(region_num + 1):8) = nan;
end
p_value = p_value(~isnan(p_value));

% False discovery rate.
[val,idx] = sort(p_value);
adjusted_p_value_005 = ((1:numel(p_value))*0.05)/numel(p_value);
adjusted_p_value_001 = ((1:numel(p_value))*0.01)/numel(p_value);
adjusted_p_value_0001 = ((1:numel(p_value))*0.001)/numel(p_value);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix = zeros(8,8);
p_value_matrix(1:8,1) = vector(1:8);
p_value_matrix(2:8,2) = vector(9:15);
p_value_matrix(3:8,3) = vector(16:21);
p_value_matrix(4:8,4) = vector(22:26);
p_value_matrix(5:8,5) = vector(27:30);
p_value_matrix(6:8,6) = vector(31:33);
p_value_matrix(7:8,7) = vector(34:35);
p_value_matrix(8,8) = vector(36);
p_value_matrix(1,1:8) = vector(1:8);
p_value_matrix(2,2:8) = vector(9:15);
p_value_matrix(3,3:8) = vector(16:21);
p_value_matrix(4,4:8) = vector(22:26);
p_value_matrix(5,5:8) = vector(27:30);
p_value_matrix(6,6:8) = vector(31:33);
p_value_matrix(7,7:8) = vector(34:35);
p_value_matrix(8,8) = vector(36);

% Plot.
figure('Position',[900,500,100,100],'Color','w')
imagesc(p_value_matrix,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

region_num1 = 1; % ALM.
region_num2 = 8; % PPC.
mean_mean_similarity_control = nanmean(mean_similarity_control{region_num1}{region_num2});
mean_mean_similarity_APP = nanmean(mean_similarity_APP{region_num1}{region_num2});
se_mean_similarity_control = nanstd(mean_similarity_control{region_num1}{region_num2})/(sum(~isnan(mean_similarity_control{region_num1}{region_num2}))^0.5);
se_mean_similarity_APP = nanstd(mean_similarity_APP{region_num1}{region_num2})/(sum(~isnan(mean_similarity_APP{region_num1}{region_num2}))^0.5);

figure('Position',[1000,500,150,100],'Color','w')
hold on
bar(1,mean_mean_similarity_control,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.8)
bar(2,mean_mean_similarity_APP,0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.4)
line([1,1],[mean_mean_similarity_control - se_mean_similarity_control,mean_mean_similarity_control + se_mean_similarity_control],'Color',[0.64,0.08,0.18],'LineWidth',1)
line([2,2],[mean_mean_similarity_APP - se_mean_similarity_APP,mean_mean_similarity_APP + se_mean_similarity_APP],'Color',[0.64,0.08,0.18],'LineWidth',1)
xlabel('');
ylabel('Similarity');
xlim([0,3])
ylim([0,0.25])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0,0.1,0.2];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0','0.1','0.2'};

end