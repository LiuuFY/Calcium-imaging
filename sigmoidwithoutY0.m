%%%E:\684683682dataproce11\wave R SLOP\wave databasse
%%%%
% 指定Excel文件的文件名
filename = 'E:\684683682dataproce11\wave R SLOP\wave databasse\684freeze.xlsx';

% 从Excel文件中读取数据
data = xlsread(filename);

% 提取x数据（第一列）
x_data = data(:, 1);

% 提取y数据（从第二列开始）
y_data_matrix = data(:, 2:end);

% 初始化参数数组以存储每条曲线的参数
num_curves = size(y_data_matrix, 2);
parameters = zeros(num_curves, 3); % 每行包含L、k和x0

% 定义S型曲线模型函数
sigmoid = @(params, x) params(1) ./ (1 + exp(-params(2)*(x - params(3))));

% 循环拟合每条曲线并提取参数
for i = 1:num_curves
    % 提取当前曲线的y数据
    y_data_current = y_data_matrix(:, i);
    
    % 初始参数估计
    initial_guess = [1, 1, 1];
    
    % 使用lsqcurvefit拟合当前曲线的数据
    params = lsqcurvefit(sigmoid, initial_guess, x_data, y_data_current);
    
    % 存储参数值
    parameters(i, :) = params;
    
    % 打印参数值
    fprintf('Curve %d:\n', i);
    fprintf('L: %f\n', params(1));
    fprintf('k: %f\n', params(2));
    fprintf('x0: %f\n', params(3));
end
