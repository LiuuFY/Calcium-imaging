% 读取Excel文件
data = xlsread('E:\684683682dataproce11\2023 review back\ranksumtest.xlsx'); % 用你的实际文件名替换 'E:\684683682dataproce11\2023 review back\dffexact\data base\frame 1515 test\372# 1515frame\372#1515 rank.xlsx'

% 获取数据的列数%%%改写所有列都和最后一列对比输出p
num_columns = size(data, 2);

% 提取最后一列数据
last_column_data = data(:, end);

% 初始化存储P值的数组
p_values = zeros(1, num_columns - 1); % 减去最后一列

% 进行秩和检验
for i = 1:num_columns - 1 % 减去最后一列
    column_data = data(:, i);
    [p_value, ~] = ranksum(column_data, last_column_data);
    p_values(i) = p_value;
end

% 输出每列与最后一列的P值
for i = 1:num_columns - 1 % 减去最后一列
    fprintf('列 %d 与最后一列的P值为：%f\n', i, p_values(i));
end
