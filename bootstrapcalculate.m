
% 从Excel文件中读取数据
data = xlsread('E:\684683682dataproce11\2023 review back\wave R SLOP\slope\FREEZECELLR.xlsx'); % 替换为你的文件路径

% 从第一列和第二列获取数据
data1 = data(~isnan(data(:, 1)), 1); % 第一列数据，跳过空值
data2 = data(~isnan(data(:, 2)), 2); % 第二列数据，跳过空值


% 定义Bootstrap样本数量和直方图的箱数
num_samples = 1000;
num_bins = 30;

% 初始化存储Bootstrap均值和标准差的数组
bootstrap_means1 = zeros(num_samples, 1);
bootstrap_means2 = zeros(num_samples, 1);
bootstrap_std1 = zeros(num_samples, 1);
bootstrap_std2 = zeros(num_samples, 1);

for i = 1:num_samples
    % 针对 data1 抽取 Bootstrap 样本
    bootstrap_indices1 = randi(length(data1), length(data1), 1);
    bootstrap_sample1 = data1(bootstrap_indices1);
    
    % 针对 data2 抽取 Bootstrap 样本
    bootstrap_indices2 = randi(length(data2), length(data2), 1);
    bootstrap_sample2 = data2(bootstrap_indices2);
    
    % 计算每个 Bootstrap 样本的均值和标准差
    bootstrap_means1(i) = mean(bootstrap_sample1);
    bootstrap_means2(i) = mean(bootstrap_sample2);
    bootstrap_std1(i) = std(bootstrap_sample1);
    bootstrap_std2(i) = std(bootstrap_sample2);
end

% 计算均值和标准差的95%置信区间
conf_interval_means1 = prctile(bootstrap_means1, [2.5, 97.5]);
conf_interval_std1 = prctile(bootstrap_std1, [2.5, 97.5]);
conf_interval_means2 = prctile(bootstrap_means2, [2.5, 97.5]);
conf_interval_std2 = prctile(bootstrap_std2, [2.5, 97.5]);

% 输出第一列的均值、标准差和置信区间
fprintf('Column 1 Mean: %.4f\n', mean(data1));
fprintf('Column 1 Standard Deviation: %.4f\n', std(data1));
fprintf('Column 1 95%% Confidence Interval (Mean): [%.4f, %.4f]\n', conf_interval_means1(1), conf_interval_means1(2));
fprintf('Column 1 95%% Confidence Interval (Standard Deviation): [%.4f, %.4f]\n', conf_interval_std1(1), conf_interval_std1(2));

% 输出第一列的均值、标准差和置信区间
fprintf('Column 1 Mean: %.4f\n', mean(data1));
fprintf('Column 1 Standard Deviation: %.4f\n', std(data1));
fprintf('Column 1 95%% Confidence Interval (Mean): [%.4f, %.4f]\n', conf_interval_means1(1), conf_interval_means1(2));
fprintf('Column 1 95%% Confidence Interval (Standard Deviation): [%.4f, %.4f]\n', conf_interval_std1(1), conf_interval_std1(2));

% 输出第二列的均值、标准差和置信区间
fprintf('Column 2 Mean: %.4f\n', mean(data2));
fprintf('Column 2 Standard Deviation: %.4f\n', std(data2));
fprintf('Column 2 95%% Confidence Interval (Mean): [%.4f, %.4f]\n', conf_interval_means2(1), conf_interval_means2(2));
fprintf('Column 2 95%% Confidence Interval (Standard Deviation): [%.4f, %.4f]\n', conf_interval_std2(1), conf_interval_std2(2));
% 绘制两个均值分布的直方图，手动设置柱子宽度，没有边缘线
figure;

% 计算直方图的边缘
bin_edges = linspace(min([bootstrap_means1; bootstrap_means2]), max([bootstrap_means1; bootstrap_means2]), num_bins+1);

% 绘制第一个样本的直方图
counts1 = histcounts(bootstrap_means1, bin_edges);
bar(bin_edges(1:end-1), counts1 / sum(counts1), 'FaceColor', 'blue', 'EdgeColor', 'none', 'BarWidth', 0.9);
hold on;

% 绘制第二个样本的直方图
counts2 = histcounts(bootstrap_means2, bin_edges);
bar(bin_edges(1:end-1), counts2 / sum(counts2), 'FaceColor', 'red', 'EdgeColor', 'none', 'BarWidth', 0.9);

% 绘制第一列均值的置信区间
line([conf_interval_means1(1), conf_interval_means1(1)], [0, max(counts1 / sum(counts1))], 'Color', 'green', 'LineWidth', 2);
line([conf_interval_means1(2), conf_interval_means1(2)], [0, max(counts1 / sum(counts1))], 'Color', 'green', 'LineWidth', 2);

% 添加标题和标签
title('Bootstrap Mean Distribution');
xlabel('Mean Value');
ylabel('Probability');

% 添加图例
legend('Sample 1', 'Sample 2', 'Column 1 95% CI', 'Location', 'NorthEast');

% 显示图形
grid on;
