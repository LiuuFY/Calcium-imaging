% 指定Excel文件路径
excelFilePath = 'E:\684683682dataproce11\2023 review back\dffexact\data base\frame 1515 test\673#0011515frame\result\673#0011515_begin_14_17_add_index_nohat.xlsx';

% 获取Excel文件的sheet名称
[~, sheetNames] = xlsfinfo(excelFilePath);

% 遍历每个sheet
for sheetIndex = 1:length(sheetNames)
    % 获取当前sheet名称
    sheetName = sheetNames{sheetIndex};
    
    % 读取当前sheet的数据
    sheetData = xlsread(excelFilePath, sheetIndex);
    
    % 提取所有的奇数列数据并转置
    odd_columns_data = sheetData(:, 1:2:end);
    
    % 将数据转置后输出到工作区，以sheet名称为变量名
    assignin('base', sheetName, odd_columns_data');
end
