% 1. 获取所有工作表的名称
[~, sheetNames] = xlsfinfo('E:\684683682dataproce11\2023 review back\dffexact\data base\673#001\result\673test001_add_index.xlsx');

% 2. 初始化结果存储单元格数组
all_results_R = cell(1, numel(sheetNames));
all_results_LAG = cell(1, numel(sheetNames));

% 3. 循环遍历不同的工作表
for sheetIndex = 1:numel(sheetNames)
    % 4. 读取当前工作表的数据
    sheetName = sheetNames{sheetIndex};
    data = xlsread('E:\684683682dataproce11\2023 review back\dffexact\data base\673#001\result\673test001_add_index.xlsx', sheetName);
    
    % 5. 获取数据列的数量
    num_columns = size(data, 2);
    
    % 6. 初始化当前工作表的结果存储变量
    results_R = [];
    results_LAG = [];    
    
    % 7. 循环计算交叉相关性
    for i = 1:2:num_columns
        calcium_signal = data(:, i);
                % 确保行为信号列存在
        if (i + 1) <= num_columns
            behavior_signal = data(:, i + 1);

            [r, lag] = xcorr(calcium_signal, behavior_signal, 'coeff');

            % 存储结果
            results_R = [results_R, r];
            results_LAG = [results_LAG, lag];
        end
    end
    
    % 8. 存储当前工作表的结果
    all_results_R{sheetIndex} = results_R;
    all_results_LAG{sheetIndex} = results_LAG;
end

% 9. 输出所有工作表和pair的最大R值
for sheetIndex = 1:numel(sheetNames)
    sheetName = sheetNames{sheetIndex};
    fprintf('Sheet: %s\n', sheetName);
    
    for i = 1:size(all_results_R{sheetIndex}, 2)
        fprintf('Pair %d - R:\n', i);
        disp(all_results_R{sheetIndex}(:, i));
        fprintf('Pair %d - LAG:\n', i);
        disp(all_results_LAG{sheetIndex}(:, i));
        
        % 查找并存储最大R值
        maxR = max(all_results_R{sheetIndex}(:, i));
        max_R_values(sheetIndex, i) = maxR;
    end
end

% 10. 输出所有工作表和pair的最大R值
fprintf('All Sheets and Pairs - MAX R:\n');
disp(max_R_values);

% 11. 自定义保存路径和文件名
outputFilePath = 'E:\684683682dataproce11\corss'; % 修改为您希望保存的路径
outputFileName = '673test001-1_add_index.xlsx'; % 修改为您希望的文件名

% 12. 导出结果到自定义路径和文件名的Excel工作簿的不同工作表
for sheetIndex = 1:numel(sheetNames)
    sheetName = sheetNames{sheetIndex};
    results = all_results_R{sheetIndex};
    
    % 使用xlswrite将结果写入Excel工作簿的不同工作表
    xlswrite(fullfile(outputFilePath, outputFileName), results, sheetName);
end