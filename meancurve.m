
% 初始化一个空矩阵来存储每个'Sheet'的平均曲线
average_curves = [];

% 循环遍历'Sheet1'到'Sheet23'
for i = 1:23
    Sheet_name = sprintf('Sheet%d', i);
    
    % 使用evalin函数从工作区中获取对应的数据矩阵
    data = evalin('base', Sheet_name);
    
    % 计算每个'sheet'的平均曲线并将其存储在average_curves中
    average_curve = mean(data, 2);
    average_curves = [average_curves, average_curve];
end
