import xlrd


import xlwt
import os

filenames = os.listdir(r'./')
resultpath = r'./result'
if not os.path.isdir(resultpath):
    os.mkdir(resultpath)

def time2sec(str):
    if type(str)== int or type(str)==float:
        return str
    if len(str.split(' '))==2:
        date = str.split(' ')[0].split('-')
        time = str.split(' ')[1].split(':')
    else:
        date = ['0','0','0']
        time = ['0','0']
        time.append(str)
    sec = int(date[0])*365*24*3600 + int(date[1])*30*24*3600 + int(date[2])*24*3600 + int(time[0])*3600 + int(time[1])*60 + float(time[2])
    return sec

def binary_research(str,array,count):
    if str>array[-1]+2 or str<array[0]-10:
        return -1
    if str>array[-1]:
        return -2
    if str<array[0]:
        return -3
    if array[len(array)//2]<=str:
        if array[len(array)//2+1]>=str:
            return count[len(array)//2]
        else:
            return binary_research(str, array[len(array)//2:], count[len(array)//2:])
    else:
        return binary_research(str, array[:len(array)//2+1], count[:len(array)//2+1])
monitor = 0
for filename in filenames:
    if filename.endswith('xlsx'):
        filepath = os.path.join('./', filename)
        wb = xlrd.open_workbook(filepath)
        ws = wb.sheet_by_name('Sheet1')
        title = ws.row_values(0)
        dff = ws.col_values(title.index('dff'))[2:]
        time = ws.col_values(title.index('原始数据'))[2:]
        mark1 = ws.col_values(title.index('mark 1'))[2:]
        mark2 = []
        mark2.append(ws.col_values(title.index('mark 2'))[2:])
        mark2.append(ws.col_values(title.index('mark 2')+1)[2:])
        if '' in time:
            time = time[:time.index('')]
        if '' in mark2[0]:
            mark2[0] = mark2[0][:mark2[0].index('')]
        if '' in mark2[1]:
            mark2[1] = mark2[1][:mark2[1].index('')]
        if '' in mark1:
            mark1 = mark1[:mark1.index('')]
        if '' in dff:
            dff = dff[:dff.index('')]
        sec_time = []
        for time1 in time:
            sec_time.append(time2sec(time1))
        count = []
        for i in range(len(sec_time)):
            count.append(i)
        wwb = xlwt.Workbook(encoding='UTF-8')
        wws1 = wwb.add_sheet('mark 1')
        wws2 = wwb.add_sheet('mark 2')
        
        for i in range(len(mark1)):
            wws1.col(i).width=256*20
            index = binary_research(time2sec(mark1[i]), sec_time, count)
            dffwriter = []
            if index == -1:
                monitor = 1
                print('One time point of mark 1 can\'t be found in ', filename, ': ', mark1[i])
            else:
                for timeindex in range(len(time)):
                    if sec_time[timeindex]-time2sec(mark1[i])>=-2 and sec_time[timeindex]-time2sec(mark1[i])<=10:
                        if timeindex<len(dff):
                            dffwriter.append(time2sec(dff[timeindex]))
            for timeindex in range(len(dffwriter)):
                
                wws1.write(timeindex+1, i, dffwriter[timeindex])
            wws1.write(0, i, i+1)
        for j in range(len(mark2[0])):
            wws2.col(j).width=256*20
            if monitor == 1:
                break
            dffwriter2 = []
            index_begin = binary_research(time2sec(mark2[0][j])+sec_time[0], sec_time, count)
            if index_begin == -1:
                monitor = 1
                print('One begin time point of mark 2 can\'t be found in ', filename, ': ', mark2[0][j])
                break
            index_end = binary_research(time2sec(mark2[1][j])+sec_time[0], sec_time, count)
            if index_end == -1:
                monitor = 1
                print('One end time point of mark 2 can\'t be found in ', filename, ': ', mark2[1][j])
                break
            if index_begin == index_end == -2:
                monitor = 1
                print('Time point of mark 2 out of range in ', filename, ': ', mark2[1][j])
                break
            if index_begin == index_end == -2:
                monitor = 1
                print('Time point of mark 2 out of range in ', filename, ': ', mark2[1][j])
                break
            if index_begin == -3 and index_end == -2:
                index_begin = 0
                index_end = len(dff)-1
            if sec_time[index_begin] == time2sec(mark2[0][j]):
                for k in range(index_begin, index_end+1):
                    if k<len(dff):
                        dffwriter2.append(dff[k])
            else:
                for k in range(index_begin+1, index_end+1):
                    if k<len(dff):
                        dffwriter2.append(dff[k])
            for timeindex2 in range(len(dffwriter2)):
                wws2.write(timeindex2+1, j, dffwriter2[timeindex2])
            wws2.write(0, j, j+1)
        if monitor == 0:
            wwb.save(os.path.join(resultpath, filename))
        else:
            input('press any button to exit.')
            break
if monitor==0:
    input('press ENTER to exit.')