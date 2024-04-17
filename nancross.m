% 获取第一个工作表的 LAG 数据，假设在 lag 的第一列%%%%第一行没有NAN的算MEAN condi的算法
original_lag = lag(:, 1)';

% 创建平均的 LAG，间隔为1
average_lag = original_lag(1):original_lag(end);
%%有NAN算法

% 初始化单元格数组以存储每个工作表的平均曲线、SEM、置信区间下限和置信区间上限
average_curves = cell(1, numel(sheetNames));
standard_errors = cell(1, numel(sheetNames));
confidence_lower = cell(1, numel(sheetNames));
confidence_upper = cell(1, numel(sheetNames));

% 遍历每个工作表
for sheetIndex = 1:numel(sheetNames)
    results_R = all_results_R{sheetIndex}; % 获取 result-R 数据
    
    % 初始化变量以存储平均曲线、SEM、置信区间下限和置信区间上限
    average_curve = zeros(size(average_lag));
    standard_error = zeros(size(average_lag));
    lower_bound = zeros(size(average_lag));
    upper_bound = zeros(size(average_lag));
    
    % 遍历每个 result-R 列
    for columnIndex = 1:size(results_R, 2)
        % 获取当前列的数据
        column_data = results_R(:, columnIndex);
        
        % 检查是否包含NaN或Inf
        if any(isnan(column_data)) || any(isinf(column_data))
            continue; % 跳过包含NaN或Inf的列
        end
        
        % 计算平均曲线，将每列数据相加
        average_curve = average_curve + column_data;
    end
    
    % 计算平均曲线，将总和除以有效列数
    valid_columns = sum(~isnan(results_R), 1); % 计算每列的非NaN数目
    valid_columns = valid_columns(valid_columns > 0); % 筛选出有效列
    average_curve = average_curve / numel(valid_columns); % 使用有效列数计算平均曲线
    
    % 计算每个lag值的标准误差 (SEM)，排除NaN值
    standard_error = nanstd(results_R, 0, 2) / sqrt(numel(valid_columns));
    
    % 计算每个lag值的置信区间 (95%)
    confidence_interval = 1.96 * standard_error; % 95% 置信区间
    
    % 计算置信区间下限和上限
    lower_bound = average_curve - confidence_interval;
    upper_bound = average_curve + confidence_interval;
    
    % 存储结果在相应的单元格中
    average_curves{sheetIndex} = average_curve;
    standard_errors{sheetIndex} = standard_error;
    confidence_lower{sheetIndex} = lower_bound;
    confidence_upper{sheetIndex} = upper_bound;
end

% 转换 standard_errors、confidence_lower 和 confidence_upper 到数值数组
numeric_standard_errors = cell2mat(standard_errors);
numeric_lower_bounds = cell2mat(confidence_lower);
numeric_upper_bounds = cell2mat(confidence_upper);

% 输出所有工作表的SEM
disp('All Sheets - SEM:');
disp(numeric_standard_errors);

workbook.Close(false);

% 设置输出路径和文件名
outputFilePath = 'E:\684683682dataproce11\corss\output_result'; % 修改为您希望保存的路径
outputFileName = '371g.xlsx'; % 修改为您希望的文件名

% 创建一个 Excel 文件的新副本
excelApp = actxserver('Excel.Application');
workbook = excelApp.Workbooks.Add();

% 遍历每个工作表
for sheetIndex = 1:numel(sheetNames)
    sheetName = sheetNames{sheetIndex};
    
    % 写入平均曲线数据
    xlswrite(fullfile(outputFilePath, outputFileName), average_curves{sheetIndex}, sheetName, 'B1');
    
    % 写入SEM数据
    xlswrite(fullfile(outputFilePath, outputFileName), standard_errors{sheetIndex}, sheetName, 'C1');
    
    % 写入置信区间下限数据
    xlswrite(fullfile(outputFilePath, outputFileName), confidence_lower{sheetIndex}, sheetName, 'D1');
    
    % 写入置信区间上限数据
    xlswrite(fullfile(outputFilePath, outputFileName), confidence_upper{sheetIndex}, sheetName, 'E1');
end

% 关闭 Excel 文件
workbook.Save();
excelApp.Quit();
excelApp.delete();
