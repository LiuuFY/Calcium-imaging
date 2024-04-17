% 假设 N 是您选择的行索引
N = 15; % 例如，N = 15 表示选择前10行和后面的行

% 提取1-N行的数据
data_first_N_rows = average_curves(1:N, :);

% 提取N-end行的数据
data_last_rows = average_curves(N+1:end, :);

% 提取(N-END)这行的数据
data_N_minus_end_row = average_curves(end-N+1:end, :);

% 计算每一列的和
sum_first_N_columns = sum(data_first_N_rows, 1);
sum_last_columns = sum(data_last_rows, 1);
sum_N_minus_end_columns = sum(data_N_minus_end_row, 1);

% 计算每一列的(N-END)这行的和减去1-N行的和
difference = sum_N_minus_end_columns - sum_first_N_columns;

