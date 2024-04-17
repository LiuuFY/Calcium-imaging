% 读取.xlsx文件
data = xlsread('E:\684683682dataproce11\2023 review back\allfreeze372.xlsx');

% 初始化两个空数组用于存储值为0和1的行的数值
values_for_0 = [];
values_for_1 = [];

% 遍历第一列数据
for i = 1:size(data, 1)
    if data(i, 1) == 0
        % 如果值为0，将该行数值添加到values_for_0数组中
        values_for_0 = [values_for_0; data(i, :)];
    elseif data(i, 1) == 1
        % 如果值为1，将该行数值添加到values_for_1数组中
        values_for_1 = [values_for_1; data(i, :)];
    end
end

% 初始化数组用于存储p值
p_values = zeros(1, size(data, 2) - 1); % 减去1是因为第1列是0和1的标识

% 对每一列进行秩和检验并存储p值
for col = 2:size(data, 2) % 从第2列开始，因为第1列是0和1的标识
    p_value = ranksum(values_for_0(:, col), values_for_1(:, col));
    p_values(col - 1) = p_value;
end

% 将p值输出到工作区
disp('各列的秩和检验p值:');
disp(p_values);
