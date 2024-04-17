import numpy as np
from scipy.signal import correlate
from numpy import std
import xlrd
import xlwt
wb = xlrd.open_workbook('371#_add_index(1).xlsx')
ws = wb.sheet_by_name('Sheet1')
col0 = ws.col_values(0)[1:]
col1 = ws.col_values(1)[1:]
for i in range(0,len(col0)):
    if col0[i] != '':
        col0[i] = float(col0[i])
for i in range(0,len(col1)):
    if col1[i] != '':
        col1[i] = float(col1[i])
if '' in col0:
    col0 = col0[:col0.index('')]
if '' in col1:
    col1 = col1[:col1.index('')]
# 创建两个示例信号

signal1 = np.array(col0)
signal2 = np.array(col1)
print(signal1, signal2)
# 使用SciPy的correlate函数来计算交叉相关
cross_correlation = correlate(signal1, signal2, mode='full')
wb = xlwt.Workbook(encoding='UTF-8')
ws = wb.add_sheet('Sheet1')
normalized_correlation = cross_correlation / (std(cross_correlation) * std(cross_correlation))
for i in range(0,len(normalized_correlation)):
    ws.write(i,0,normalized_correlation[i])
    ws.write(i, 1, cross_correlation [i])
wb.save('./371#_res.xlsx')
print("交叉相关结果:", normalized_correlation)
