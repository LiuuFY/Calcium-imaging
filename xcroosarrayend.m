
% 假设您的数据存储在一个Excel文件中，包含多列钙信号和一列行为二进制数据
% 使用xlsread函数加载数据
data = xlsread('E:\684683682dataproce11\2023 review back\371.xlsx');

% 假设钙信号存储在data的前几列，而行为数据存储在最后一列
calcium_signals = data(:, 1:end-1); % 钙信号列
behavior_data = data(:, end); % 行为数据列


% 计算每个钙信号列与行为数据的交叉相关性
num_signals = size(calcium_signals, 2); % 钙信号的列数
lags = -(length(behavior_data)-1):(length(behavior_data)-1); % 设置滞后范围


% 存储每个信号与行为数据的交叉相关性结果
correlation_values = zeros(num_signals, 2*length(behavior_data)-1);

for i = 1:num_signals
    [C, lags] = xcov(calcium_signals(:,i), behavior_data, 'coeff');
    correlation_values(i, :) = C;
end

% 显示结果或进一步分析
% correlation_values 中的每一行对应一个钙信号列与行为数据的交叉相关性
% lags 变量包含滞后值的范围
% 显示结果
fprintf('最大交叉相关性值: %.4f\n', max_correlation);