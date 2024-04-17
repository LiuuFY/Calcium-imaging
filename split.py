import os
import xlrd
import xlwt
for file in os.listdir('./'):
    path = os.path.join('./',file)
    if 'xlsx' in file:
        workbook_rd = xlrd.open_workbook(path)
        sheets = workbook_rd.sheets()
        for i in range(0,len(sheets)):
            num_rows = sheets[i].nrows
            num_cols = sheets[i].ncols
            workbook_wt = xlwt.Workbook(encoding='UTF-8')
            worksheet = workbook_wt.add_sheet('Sheet1')
            for j in range(0,num_rows):
                for k in range(0,num_cols):
                    worksheet.write(j,k,sheets[i].row_values(j)[k])
            workbook_wt.save('./'+file.split('.')[0]+'-sheet-'+str(i+1)+'.xlsx')
