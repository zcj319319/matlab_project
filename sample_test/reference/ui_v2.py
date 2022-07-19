# -*- coding: utf-8 -*-
"""
Created on Wed May 19 16:37:41 2021

@author: gucheng
"""

from ui_base import ui_base
from ui_base import clk_option_dialog
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5 import QtGui
import sys
import re
import time
import numpy as np
import xlrd
import xlwt
import threading
import ctypes
import inspect
from ctypes import *
import ControlSPI

class ClkOptDialog(QDialog):
    Signal_parp = pyqtSignal(list)
    def __init__(self):
        super(ClkOptDialog, self).__init__()
        self.ui = clk_option_dialog.Ui_dialog()
        self.ui.setupUi(self)
        self.ui.pushButton.clicked.connect(self.para_updata)
        self.select_sheet = []
    def para_updata(self):
        self.select_sheet.append(self.ui.lineEdit.text())
        self.select_sheet.append(self.ui.lineEdit_2.text())
        self.select_sheet.append(self.ui.lineEdit_3.text())
        self.Signal_parp.emit(self.select_sheet)
        self.ok_and_quit()
    def ok_and_quit(self):
        self.close()

class MainDialog1(QDialog):
    Signal_parp = pyqtSignal(str)
    def __init__(self, sheet_lst):
        super(MainDialog1, self).__init__()
        self.ui = clk_option_dialog.Ui_Dialog1()
        self.ui.setupUi(self)
        self.sheet_lst = sheet_lst
        self.ui.comboBox.addItem('select one sheet')
        for x in sheet_lst:
            self.ui.comboBox.addItem(x)
        self.ui.comboBox.currentIndexChanged.connect(self.select_sheet)
        self.ui.pushButton.clicked.connect(self.ok_and_quit)
    def select_sheet(self):
        self.select_sheet = self.ui.comboBox.currentText()
        self.Signal_parp.emit(self.select_sheet)
    def ok_and_quit(self):
        self.close()

class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        self.ui = ui_base.Ui_MainWindow()
        self.ui.setupUi(self)
        self.ui.clk_option_cfg_button.clicked.connect(self.clk_opt_cfg)
        self.ddc_config()
        self.ui.nco_update_pushButton.clicked.connect(self.nco_update)
        self.j204b_config()
        self.ui.j204b_update_pushButton.clicked.connect(self.j204b_update)
        self.sds_config()
        self.ui.sds_button.clicked.connect(self.sds_update)
        self.ui.sds_button_2.clicked.connect(self.sds_test_prbs7)
        self.ui.sds_button_3.clicked.connect(self.sds_test_clk0101)
        self.ui.read_button.clicked.connect(self.read_addr)
        self.ui.write_button.clicked.connect(self.write_addr)
        self.ui.init_button.clicked.connect(self.load_test_seq)
        self.ui.cali_run_button.clicked.connect(self.background_test)
        self.ui.mem_rd_button.clicked.connect(self.mem_read)
        self.spi_config()
        self.ui.pushButton.clicked.connect(self.spi_update)
        self.push_button_cnt = 'start'
    def write_atom(self,addr,data):
        write_buffer = (c_ubyte * 3)()
        read_buffer = (c_ubyte * 1)()
        addr_str = '{:0>4x}'.format(addr)
        write_buffer[0] = int(addr_str[0:2],16)
        write_buffer[1] = int(addr_str[2:],16)
        write_buffer[2] = data
        nRet = ControlSPI.VSI_WriteBytes(ControlSPI.VSI_USBSPI, 0, 0, write_buffer, 3)
    def read_atom(self,addr):
        write_buffer = (c_ubyte * 2)()
        read_buffer = (c_ubyte * 1)()
        addr_str = '{:0>4x}'.format(addr)
        write_buffer[0] = int(addr_str[0:2], 16)+128
        write_buffer[1] = int(addr_str[2:], 16)
        nRet = ControlSPI.VSI_WriteReadBytes(ControlSPI.VSI_USBSPI, 0, 0, write_buffer, 2, read_buffer, 1)
        return read_buffer
    def read_addr(self):
        now_addr = self.ui.addr_textEdit.toPlainText()
        if re.match('^0x', now_addr):
            addr_read = int(now_addr,16)
        else:
            addr_read = int(now_addr)
        read_value = self.read_atom(addr_read)
        self.ui.textEdit.setText(hex(read_value[0]))
        # read_value_bin = '{:0>8b}'.format(read_value[0])
    def write_addr(self):
        now_addr = self.ui.addr_textEdit.toPlainText()
        if re.match('^0x', now_addr):
            addr_write = int(now_addr,16)
        else:
            addr_write = int(now_addr)
        now_value = self.ui.textEdit.toPlainText()
        if re.match('^0x',now_value):
            write_value = int(now_value,16)
        else:
            write_value = int(now_value)
        # write_value_bin = '{:0>8b}'.format(write_value)
        self.write_atom(addr_write, write_value)
    def load_test_seq(self):
        dialog = QFileDialog()
        dialog.setFileMode(QFileDialog.AnyFile)
        dialog.setFilter(QDir.Files)
        if dialog.exec():
            self.test_seq_file = dialog.selectedFiles()
            # self.ui.textBrowser.insertPlainText('test seq file is '+str(self.test_seq_file[0])+'\n...\n...\n')
        # self.ui.textBrowser.insertPlainText('starting reading '+str(self.test_seq_file[0])+'\n')
        self.parser_seq_file(self.test_seq_file[0])
    def parser_seq_file(self, fn):
        data = xlrd.open_workbook(fn)
        sheetsall = data.sheet_names()
        dialog = MainDialog1(sheetsall)
        dialog.Signal_parp.connect(self.deal_emit_sheet)
        dialog.show()
        dialog.exec_()
        sheet_idx = sheetsall.index(self.sheet_sel_lst)
        # self.ui.textBrowser.insertPlainText(time.ctime()+': seq '+sheetsall[sheet_idx]+' config begin!\n')
        sheet_data = data.sheets()[sheet_idx]
        rows_num = sheet_data.nrows
        for x in range(0,rows_num):
            if sheet_data.cell_value(x,0) == 'sleep':
                if sheet_data.cell_value(x,1) == '':
                    time.sleep(5)
                    # self.ui.textBrowser.insertPlainText('sleep 5\n')
                else:
                    tmp_time = int(sheet_data.cell_value(x,1))
                    time.sleep(tmp_time)
                    # self.ui.textBrowser.insertPlainText('sleep '+str(tmp_time)+'\n')
            elif sheet_data.cell_value(x,0) == 'wait':
                temp_addr = int(sheet_data.cell_value(x,1),16)
                temp_value = int(sheet_data.cell_value(x,2),16)
                for i in range(0,300):
                    time.sleep(1)
                    read_value = self.read_atom(temp_addr)
                    if read_value[0] == temp_value:
                        break
            elif sheet_data.cell_value(x,0) == '':
                pass
            else:
                temp_addr = int(sheet_data.cell_value(x, 0), 16)
                temp_data = int(sheet_data.cell_value(x, 1), 16)
                self.write_atom(temp_addr, temp_data)
    def deal_emit_sheet(self, select_sheet):
        self.sheet_sel_lst = select_sheet
    def read_mem_reg(self, addr0, addr1):
        write_buffer = (c_ubyte * 2)()
        read_buffer = (c_ubyte * 4096)()
        write_buffer[0] = addr0
        write_buffer[1] = addr1
        nRet = ControlSPI.VSI_WriteReadBytes(ControlSPI.VSI_USBSPI, 0, 0, write_buffer, 2, read_buffer, 4096)
        return read_buffer
    def mem_read(self):
        smp_lst = ['smp ddc output', 'smp tiskew corr', 'initial mem to 0', 'initial mem to 1', 'weight_rd']
        dialog = MainDialog1(smp_lst)
        dialog.Signal_parp.connect(self.deal_emit_sheet)
        dialog.show()
        dialog.exec_()
        sheet_idx = smp_lst.index(self.sheet_sel_lst)
        if sheet_idx == 0:
            # self.ui.textBrowser.insertPlainText('start sample ddc output!\n')
            #ddc output
            self.write_atom(0xf18, 0x00)
            self.write_atom(0xf16, 0x00)
            self.write_atom(0xf1d, 0x1)
            self.write_atom(0xf1c, 0x1)
            self.write_atom(0xf16, 0x08)
            self.write_atom(0xf17, 0x40)
            self.write_atom(0xf19, 0x3c)
            self.write_atom(0xf1a, 0x00)
            self.write_atom(0xf1b, 0x10)
            self.write_atom(0xf1d, 0x0)
            self.write_atom(0xf1c, 0x0)
            self.write_atom(0xf18, 0x02)
        elif sheet_idx == 1:
            # self.ui.textBrowser.insertPlainText('start sample tiskew_corr output!\n')
            pass
        elif sheet_idx == 2:
            # self.ui.textBrowser.insertPlainText('start initial mem to 0!\n')
            self.write_atom(0xf10, 0x0)
            self.write_atom(0xf11, 0x0)
            for i in range(0, 131072):
                self.write_atom(0xf24, 0x0)
        elif sheet_idx == 3:
            # self.ui.textBrowser.insertPlainText('start initial mem to 1!\n')
            self.write_atom(0xf10, 0x0)
            self.write_atom(0xf11, 0x0)
            for i in range(0, 131072):
                self.write_atom(0xf24, 0xff)
        elif sheet_idx == 4:
            self.weight_rd()
        ##transport output0
        # self.write_atom(0xf18, 0x00)
        # self.write_atom(0xf16, 0x00)
        # self.write_atom(0xf1d, 0x1)
        # self.write_atom(0xf1c, 0x1)
        # self.write_atom(0xf16, 0xb)
        # self.write_atom(0xf17, 0x64)
        # self.write_atom(0xf19, 0x3c)
        # self.write_atom(0xf1a, 0x00)
        # self.write_atom(0xf1b, 0x10)
        # self.write_atom(0xf1d, 0x0)
        # self.write_atom(0xf1c, 0x0)
        # self.write_atom(0x5f8, 0x10)
        # self.write_atom(0xf18, 0x0)
        # ##transport output1
        # self.write_atom(0xf18, 0x00)
        # self.write_atom(0xf16, 0x00)
        # self.write_atom(0xf1d, 0x1)
        # self.write_atom(0xf1c, 0x1)
        # self.write_atom(0xf16, 0xb)
        # self.write_atom(0xf17, 0x24)
        # self.write_atom(0xf19, 0x3c)
        # self.write_atom(0xf1a, 0x00)
        # self.write_atom(0xf1b, 0x10)
        # self.write_atom(0xf1d, 0x0)
        # self.write_atom(0xf1c, 0x0)
        # self.write_atom(0x5f8, 0x15)
        # self.write_atom(0xf18, 0x0)
        ##read mem
        if sheet_idx == 0:
            self.write_atom(0xf16, 0x10)
            self.write_atom(0xf10, 0x01)
            self.write_atom(0xf10, 0x0)
            self.write_atom(0xf11, 0x0)
            time.sleep(5)
            offset = 0x00
            data_old = 0x55
            fp = open('memory_dump_data.txt', 'w')
            for i in range(0, 32):
                data_new = i * 4 + offset
                self.write_atom(0xf11, data_old)
                self.write_atom(0xf11, data_new)
                read_buffer = self.read_mem_reg(0x8f, 0x24)
                for k in range(0, len(read_buffer)):
                  fp.write("%02x\n" % (read_buffer[k]))
            fp.close()
        # if sheet_idx == 1:
        #     fd = open(r'C:\Project\reg_map\write\memory_dump_data.txt')
        #     all_data = [x.strip() for x in fd]
        #     fd.close()
        #     fo = open('mem.dat', 'w')
        #     for i in range(0, 2):
        #         for j in range(0, 2048):
        #             dout = ''
        #             for k in range(0, 8):
        #                 for m in range(0, 4):
        #                     idx = i * 65536 + j * 4 + k * 8192 + m
        #                     dout = all_data[idx] + dout
        #             fo.write(dout + '\n')
        #     fo.close()
            # self.ui.textBrowser.insertPlainText(time.ctime()+': mem read done!\n')
    def weight_rd(self):
        wb = xlwt.Workbook()
        ws = wb.add_sheet('adc_weight')
        ws.write(0,0,'ch_idx')
        ws.write(0,1,'ch0')
        ws.write(0,2,'ch1')
        ws.write(0,3,'ch2')
        ws.write(0,4,'ch3')
        ws.write(1,0,'mdac0_weight1')
        ws.write(2,0,'mdac1_weight1')
        ws.write(3,0,'mdac2_weight1')
        ws.write(4,0,'mdac3_weight1')
        ws.write(5,0,'mdac4_weight1')
        ws.write(6,0,'mdac5_weight1')
        ws.write(7,0,'mdac6_weight1')
        ws.write(8,0,'mdac7_weight1')
        ws.write(9,0,'mdac0_weight2')
        ws.write(10,0,'mdac1_weight2')
        ws.write(11,0,'mdac2_weight2')
        ws.write(12,0,'mdac3_weight2')
        ws.write(13,0,'mdac4_weight2')
        ws.write(14,0,'mdac5_weight2')
        ws.write(15,0,'mdac6_weight2')
        ws.write(16,0,'mdac7_weight2')
        ws.write(17,0,'bkadc0_weight1')
        ws.write(18,0,'bkadc1_weight1')
        ws.write(19,0,'bkadc2_weight1')
        ws.write(20,0,'bkadc3_weight1')
        ws.write(21,0,'bkadc4_weight1')
        ws.write(22,0,'bkadc5_weight1')
        ws.write(23,0,'bkadc6_weight1')
        ws.write(24,0,'bkadc7_weight1')
        ws.write(25,0,'bkadc0_weight2')
        ws.write(26,0,'bkadc1_weight2')
        ws.write(27,0,'bkadc2_weight2')
        ws.write(28,0,'bkadc3_weight2')
        ws.write(29,0,'bkadc4_weight2')
        ws.write(30,0,'bkadc5_weight2')
        ws.write(31,0,'bkadc6_weight2')
        ws.write(32,0,'bkadc7_weight2')
        ws.write(33,0,'bkadc0_weight3')
        ws.write(34,0,'bkadc1_weight3')
        ws.write(35,0,'bkadc2_weight3')
        ws.write(36,0,'bkadc3_weight3')
        ws.write(37,0,'bkadc4_weight3')
        ws.write(38,0,'bkadc5_weight3')
        ws.write(39,0,'bkadc6_weight3')
        ws.write(40,0,'bkadc7_weight3')
        ws.write(41,0,'mdac_os0_weight')
        ws.write(42,0,'mdac_os1_weight')
        ws.write(43,0,'mdac_gec_weight')
        ws.write(44,0,'mdac_dither_weight')
        ws.write(45,0,'gec_coeff')
        ws.write(46,0,'chopper_coeff')
        ws.write(47,0,'tios_coeff')
        ws.write(48,0,'tigain_coeff')
        ws.write(49, 0, 'tiskew_code')
        ws.write(50, 0, 'opgain_code')
        for ch_idx in range(0,4):
            for os_idx in range(0,2):
                read_data = self.read_atom(0x800+0x1d+ch_idx*4+os_idx*2)
                read_data1 = self.read_atom(0x800+0x1e+ch_idx*4+os_idx*2)
                weight = read_data1[0]*256+read_data[0]
                ws.write(41+os_idx,1+ch_idx,weight)
            read_data = self.read_atom(0x800+0x2d+ch_idx*2)
            read_data1 = self.read_atom(0x800+0x2e+ch_idx*2)
            weight = read_data1[0]*256+read_data[0]
            ws.write(43,1+ch_idx,weight)
            for mdac_idx in range(0,8):
                read_data = self.read_atom(0x800+0x3c+ch_idx*24+mdac_idx*3)
                read_data1 = self.read_atom(0x800+0x3d+ch_idx*24+mdac_idx*3)
                read_data2 = self.read_atom(0x800+0x3e+ch_idx*24+mdac_idx*3)
                weight = read_data2[0]*65536+read_data1[0]*256+read_data[0]
                ws.write(1+mdac_idx,1+ch_idx,weight)
                read_data = self.read_atom(0x800+0x9c+ch_idx*16+mdac_idx*2)
                read_data1 = self.read_atom(0x800+0x9d+ch_idx*16+mdac_idx*2)
                weight = read_data1[0]*256+read_data[0]
                ws.write(9+mdac_idx,1+ch_idx,weight)
                read_data = self.read_atom(0x800+0xdc+ch_idx*16+mdac_idx*2)
                read_data1 = self.read_atom(0x800+0xdd+ch_idx*16+mdac_idx*2)
                weight = read_data1[0]*256+read_data[0]
                ws.write(17+mdac_idx,1+ch_idx,weight)
                read_data = self.read_atom(0x800+0x11c+ch_idx*16+mdac_idx*2)
                read_data1 = self.read_atom(0x800+0x11d+ch_idx*16+mdac_idx*2)
                weight = read_data1[0]*256+read_data[0]
                ws.write(25+mdac_idx,1+ch_idx,weight)
                read_data = self.read_atom(0x800+0x15c+ch_idx*16+mdac_idx*2)
                read_data1 = self.read_atom(0x800+0x15d+ch_idx*16+mdac_idx*2)
                weight = read_data1[0]*256+read_data[0]
                ws.write(33+mdac_idx,1+ch_idx,weight)
            read_data = self.read_atom(0x800+0x19c+ch_idx*3)
            read_data1 = self.read_atom(0x800+0x19d+ch_idx*3)
            read_data2 = self.read_atom(0x800+0x19e+ch_idx*3)
            weight = read_data2[0]*65536+read_data1[0]*256+read_data[0]
            ws.write(44,1+ch_idx,weight)
            read_data = self.read_atom(0x800+0x365+ch_idx*2)
            read_data1 = self.read_atom(0x800+0x366+ch_idx*2)
            weight = read_data1[0]*256+read_data[0]
            ws.write(45,1+ch_idx,weight)
            read_data = self.read_atom(0x800+0x383+ch_idx*2)
            read_data1 = self.read_atom(0x800+0x384+ch_idx*2)
            weight = read_data1[0]*256+read_data[0]
            ws.write(46,1+ch_idx,weight)
            read_data = self.read_atom(0x800+0x3a6+ch_idx*2)
            read_data1 = self.read_atom(0x800+0x3a7+ch_idx*2)
            weight = read_data1[0]*256+read_data[0]
            ws.write(47,1+ch_idx,weight)
            read_data = self.read_atom(0x800+0x3c8+ch_idx*2)
            read_data1 = self.read_atom(0x800+0x3c9+ch_idx*2)
            weight = read_data1[0]*256+read_data[0]
            ws.write(48,1+ch_idx,weight)
            read_data = self.read_atom(0x800 + 0x3fa + ch_idx * 2)
            read_data1 = self.read_atom(0x800 + 0x3fb + ch_idx * 2)
            weight = read_data1[0] * 256 + read_data[0]
            ws.write(49, 1 + ch_idx, weight)
            read_data = self.read_atom(0x800 + 0x38 + ch_idx)
            weight = read_data[0]
            ws.write(50, 1 + ch_idx, weight)
        wb.save('ana_weight.xls')
        # self.ui.textBrowser.insertPlainText(time.ctime() + ': weight read done!\n')
    def background_test(self):
        self.cali_run = []
        self.cali_run.append(self.ui.checkBox.isChecked())
        self.cali_run.append(self.ui.checkBox_2.isChecked())
        self.cali_run.append(self.ui.checkBox_3.isChecked())
        self.cali_run.append(self.ui.checkBox_4.isChecked())
        self.cali_run.append(self.ui.checkBox_5.isChecked())
        if self.push_button_cnt == 'start':
            self.push_button_cnt = 'end'
            self.ui.cali_run_button.setStyleSheet("QPushButton{border-image: url(./ui_base/end.png)}")
            # self.ui.textBrowser.insertPlainText(time.ctime()+': starting run ')
            # if self.ui.checkBox.isChecked():
            #     self.ui.textBrowser.insertPlainText('DNC ')
            # if self.ui.checkBox_2.isChecked():
            #     self.ui.textBrowser.insertPlainText('GEC ')
            # if self.ui.checkBox_3.isChecked():
            #     self.ui.textBrowser.insertPlainText('TIOS ')
            # if self.ui.checkBox_4.isChecked():
            #     self.ui.textBrowser.insertPlainText('TIGAIN ')
            # if self.ui.checkBox_5.isChecked():
            #     self.ui.textBrowser.insertPlainText('TISKEW')
            # self.ui.textBrowser.insertPlainText('\n')
            fs = self.ui.fs_display.text()
            fin = self.ui.fin_display.text()
            if fs != '' and fin != '':
                fs = float(fs)
                fin = float(fin)
                direct2 = (np.sign(np.sin(2*np.pi*fin/fs))*-1+1)/2
                direct1 = (np.sign(np.sin(2*np.pi*2*fin/fs))*-1+1)/2
                direct0 = (np.sign(np.sin(2*np.pi*fin/fs))*-1+1)/2
                direct = int(direct2*4+direct1*2+direct0)
                self.write_atom(0xbf9,direct)
            if self.cali_run[0] == 1:       ##DNC
                self.write_atom(0x810,0x1)
                time.sleep(5)
                self.write_atom(0x810,0x0)
            self.cali_thread = threading.Thread(target=self.cali_bk_run)
            self.cali_thread.start()
        else:
            self.push_button_cnt = 'start'
            self.ui.cali_run_button.setStyleSheet("QPushButton{border-image: url(./ui_base/start.png)}")
            # self.ui.textBrowser.insertPlainText(time.ctime()+': pause cali\n')
            self.stop_thread(self.cali_thread)
    def cali_bk_run(self):
        for x in range(500):
            # self.ui.textBrowser.insertPlainText(time.ctime()+': threading test'+str(x)+'!\n')
            if self.cali_run[1] == 1:       ##GEC
                self.write_atom(0xb60,0x1)
                time.sleep(1)
                self.write_atom(0xb60,0x0)
            if self.cali_run[2] == 1:       ##TIOS
                self.write_atom(0xba0,0x1)
                time.sleep(1)
                self.write_atom(0xba0,0x0)
            if self.cali_run[3] == 1:       ##TIGAIN
                self.write_atom(0xbd8,0x1)
                self.write_atom(0xbd9,0x1)
                self.write_atom(0xbda,0x1)
                self.write_atom(0xbdb,0x1)
                self.write_atom(0xbd8,0x0)
                self.write_atom(0xbd9,0x0)
                self.write_atom(0xbda,0x0)
                self.write_atom(0xbdb,0x0)
                self.write_atom(0xbc7,0x0)
                self.write_atom(0xbc0,0x1)
                time.sleep(1)
                self.write_atom(0xbc0,0x0)
            if self.cali_run[4] == 1:       ##TISKEW
                self.write_atom(0xbf0,0x1)
                for i in range(300):
                    time.sleep(1)
                    read_value = self.read_atom(0xbf1)
                    if read_value[0] == 1:
                        break
                    # if i == 299:
                        # self.ui.textBrowser.insertPlainText('after 5min, wait event not done! force quit\n')
                self.write_atom(0xbf0,0x0)
            time.sleep(5)
    def _async_raise(self,tid,exctype):
        tid = ctypes.c_long(tid)
        if not inspect.isclass(exctype):
            exctype = type(exctype)
        res = ctypes.pythonapi.PyThreadState_SetAsyncExc(tid,ctypes.py_object(exctype))
        if res == 0:
            raise ValueError('invalid thread id')
        elif res != 1:
            ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, None)
            raise SystemError("PyThreadState_SetAsyncExc failed")
    def stop_thread(self,thread):
        self._async_raise(thread.ident, SystemExit)
    def clk_opt_cfg(self):
        dialog = ClkOptDialog()
        dialog.Signal_parp.connect(self.deal_emit_clkopt)
        dialog.show()
        dialog.exec_()
        self.ui.fs_display.setText(self.clk_opt_cfg[0])
        self.ui.fin_display.setText(self.clk_opt_cfg[1])
        self.ui.fin_display_2.setText(self.clk_opt_cfg[2])
        if self.clk_opt_cfg[0] != '' and self.clk_opt_cfg[1] != '':
            fs = float(self.clk_opt_cfg[0])
            fin = float(self.clk_opt_cfg[1])
            direct2 = (np.sign(np.sin(2*np.pi*fin/fs))*-1+1)/2
            direct1 = (np.sign(np.sin(2*np.pi*2*fin/fs))*-1+1)/2
            direct0 = (np.sign(np.sin(2*np.pi*fin/fs))*-1+1)/2
            direct = int(direct2*4+direct1*2+direct0)
            self.write_atom(0xbf9,direct)
    def deal_emit_clkopt(self, opt_cfg):
        self.clk_opt_cfg = opt_cfg
    def ddc_config(self):
        self.ui.fs_display.setText('3000')
        self.ui.fin_display_2.setText('15.0')
        chip_mode = ['Full bandwidth', 'One DDC mode', 'Two DDC mode', 'Four DDC mode']
        self.ui.chip_mode_config.addItems(chip_mode)
        real_mode = ['Real', 'Complex']
        self.ui.real_mode_config.addItems(real_mode)
        self.ui.mix_mode_config.addItems(['Real','Complex'])
        self.ui.freq_mode_config.addItems(['Variable IF','0 Hz IF','fs/4 Hz IF','Test'])
        self.ui.gain_mode_config.addItems(['0db','6db'])
        self.ui.ddc0_config.addItem('Decimation=1')
        self.ui.ddc1_config.addItem('Unused')
        self.ui.ddc2_config.addItem('Unused')
        self.ui.ddc3_config.addItem('Unused')
        self.ui.chip_mode_config.activated.connect(self.ddc_mode_cfg_active)
        self.ui.real_mode_config.activated.connect(self.ddc_mode_cfg_active)
    def ddc_mode_cfg_active(self):
        self.ui.ddc0_config.clear()
        self.ui.ddc1_config.clear()
        self.ui.ddc2_config.clear()
        self.ui.ddc3_config.clear()
        self.ui.m_reg_cfg.clear()
        ddc_real_config = ['Decimation=1', 
                           'Decimation=2',
                           'Decimation=3', 
                           'Decimation=4', 
                           'Decimation=5', 
                           'Decimation=6',
                           'Decimation=8',
                           'Decimation=10',
                           'Decimation=12',
                           'Decimation=20',
                           'Decimation=24']
        ddc_complex_config = ['Decimation=2', 
                           'Decimation=3',
                           'Decimation=4', 
                           'Decimation=6', 
                           'Decimation=8', 
                           'Decimation=10',
                           'Decimation=12',
                           'Decimation=15',
                           'Decimation=16',
                           'Decimation=20',
                           'Decimation=24',
                           'Decimation=30',
                           'Decimation=40',
                           'Decimation=48']
        cur_mode = self.ui.chip_mode_config.currentText()
        real_mode = self.ui.real_mode_config.currentText()
        if cur_mode == 'Full bandwidth':
            self.ui.ddc0_config.addItem('Decimation=1')
            self.ui.ddc1_config.addItem('Unused')
            self.ui.ddc2_config.addItem('Unused')
            self.ui.ddc3_config.addItem('Unused')
            self.ui.m_reg_cfg.addItems(['1','2'])
        elif cur_mode == 'One DDC mode':
            if real_mode == 'Real':
                self.ui.ddc0_config.addItems(ddc_real_config)
                self.ui.m_reg_cfg.addItem('1')
            else:
                self.ui.ddc0_config.addItems(ddc_complex_config)
                self.ui.m_reg_cfg.addItem('2')
            self.ui.ddc1_config.addItem('Unused')
            self.ui.ddc2_config.addItem('Unused')
            self.ui.ddc3_config.addItem('Unused')
        elif cur_mode == 'Two DDC mode':
            if real_mode == 'Real':
                self.ui.ddc0_config.addItems(ddc_real_config)
                self.ui.ddc1_config.addItems(ddc_real_config)
                self.ui.m_reg_cfg.addItem('2')
            else:
                self.ui.ddc0_config.addItems(ddc_complex_config)
                self.ui.ddc1_config.addItems(ddc_complex_config)
                self.ui.m_reg_cfg.addItem('4')
            self.ui.ddc2_config.addItem('Unused')
            self.ui.ddc3_config.addItem('Unused')
        elif cur_mode == 'Four DDC mode':
            if real_mode == 'Real':
                self.ui.ddc0_config.addItems(ddc_real_config)
                self.ui.ddc1_config.addItems(ddc_real_config)
                self.ui.ddc2_config.addItems(ddc_real_config)
                self.ui.ddc3_config.addItems(ddc_real_config)
                self.ui.m_reg_cfg.addItem('4')
            else:
                self.ui.ddc0_config.addItems(ddc_complex_config)
                self.ui.ddc1_config.addItems(ddc_complex_config)
                self.ui.ddc2_config.addItems(ddc_complex_config)
                self.ui.ddc3_config.addItems(ddc_complex_config)
                self.ui.m_reg_cfg.addItem('8')
    def hcf(self,a,b):
        while(b!=0):
            temp = a%b
            a = b
            b = temp
        return a
    def nco_update(self):
        nco0_freq = self.ui.nco0_line_edit.text()
        nco1_freq = self.ui.nco1_line_edit.text()
        nco2_freq = self.ui.nco2_line_edit.text()
        nco3_freq = self.ui.nco3_line_edit.text()
        fs = self.ui.fs_display.text()
        ddc_num = self.ui.chip_mode_config.currentIndex()
        real_mode = 1-self.ui.real_mode_config.currentIndex()
        freq_mode = self.ui.freq_mode_config.currentIndex()
        gain_mode = self.ui.gain_mode_config.currentIndex()
        mix_mode = self.ui.mix_mode_config.currentIndex()
        ddc_dcm_str = self.ui.ddc0_config.currentText()
        ddc_dcm = int(re.match('Decimation=(\d+)',ddc_dcm_str).group(1))
        self.write_atom(0x200,ddc_num)
        self.gen_nco_cfg(nco0_freq,fs,0)
        self.gen_nco_cfg(nco1_freq,fs,1)
        self.gen_nco_cfg(nco2_freq,fs,2)
        self.gen_nco_cfg(nco3_freq,fs,3)
        if ddc_dcm == 1:
            self.write_atom(0x201,0x0)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,15*16)
        elif ddc_dcm == 2:
            self.write_atom(0x201,0x1)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+3)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 3:
            self.write_atom(0x201,0x8)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,7*16)
        elif ddc_dcm == 4:
            self.write_atom(0x201,0x2)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+0)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 5:
            self.write_atom(0x201,0x5)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,10*16)
        elif ddc_dcm == 6:
            self.write_atom(0x201,0x9)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+4)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 8:
            self.write_atom(0x201,0x3)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+1)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 10:
            self.write_atom(0x201,0x6)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,2*16)
        elif ddc_dcm == 12:
            self.write_atom(0x201,0xa)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+5)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 15:
            self.write_atom(0x201,0x7)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,8*16)
        elif ddc_dcm == 16:
            self.write_atom(0x201,0x4)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+2)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 20:
            self.write_atom(0x201,0xd)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,3*16)
        elif ddc_dcm == 24:
            self.write_atom(0x201,0xb)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+6)
                self.write_atom(0x311+32*i,0*16)
        elif ddc_dcm == 30:
            self.write_atom(0x201,0xe)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,9*16)
        elif ddc_dcm == 40:
            self.write_atom(0x201,0xf)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,4*16)
        elif ddc_dcm == 48:
            self.write_atom(0x201,0xc)
            for i in range(4):
                self.write_atom(0x310+32*i,mix_mode*128+gain_mode*64+freq_mode*16+real_mode*8+7)
                self.write_atom(0x311+32*i,0*16)
        time.sleep(1)
        self.write_atom(0x300,0x10)
        time.sleep(1)
        self.write_atom(0x300,0x0)
    def gen_nco_cfg(self,fin,fs,nco_no):
        if fin != '' and fs != '':
            fin = float(fin)
            fs = float(fs)
            tmp_div = self.hcf(fin,fs)
            fin_r = int(fin/tmp_div)
            fs_r = int(fs/tmp_div)
            ftw = '{:0>12x}'.format(int(2**48*fin_r/fs_r))
            maw = '{:0>12x}'.format(2**48*fin_r%fs_r)
            mbw = '{:0>12x}'.format(fs_r)
            for i in range(6):
                self.write_atom(0x316+32*nco_no+i,int(ftw[10-2*i:12-2*i],16))
                self.write_atom(0x390+16*nco_no+i,int(maw[10-2*i:12-2*i],16))
                self.write_atom(0x398+16*nco_no+i,int(mbw[10-2*i:12-2*i],16))
    def j204b_config(self):
        self.ui.ntotal_reg_cfg.addItems(['16','12','8'])
        self.ui.m_reg_cfg.addItems(['1','2','4','8'])
        self.ui.l_reg_cfg.addItems(['1','2','4','8'])
        self.ui.f_reg_cfg.addItems(['1','2','3','4','6','8','16'])
        self.ui.k_reg_cfg.addItem('32')
        self.ui.n_reg_cfg.addItems(['16','15','14','13','12','11','10','9','8'])
        self.ui.s_reg_cfg.addItem('1')
        self.ui.ntotal_reg_cfg.activated.connect(self.j204b_mode_cfg_active)
        self.ui.m_reg_cfg.activated.connect(self.j204b_mode_cfg_active)
        self.ui.l_reg_cfg.activated.connect(self.j204b_mode_cfg_active2)
        self.ui.f_reg_cfg.activated.connect(self.j204b_mode_cfg_active2)
        self.ui.ddc0_config.activated.connect(self.calc_lane_rate)
    def j204b_mode_cfg_active(self):
        self.ui.s_reg_cfg.clear()
        self.ui.n_reg_cfg.clear()
        m_reg = self.ui.m_reg_cfg.currentText()
        ntotal_reg = self.ui.ntotal_reg_cfg.currentText()
        f_reg = self.ui.f_reg_cfg.currentText()
        l_reg = self.ui.l_reg_cfg.currentText()
        s_reg = 8*int(f_reg)*int(l_reg)/int(m_reg)/int(ntotal_reg)
        self.ui.s_reg_cfg.addItem(str(int(s_reg)))
        self.ui.f_reg_cfg.clear()
        if ntotal_reg == '16':
            self.ui.n_reg_cfg.addItems(['16','15','14','13','12','11','10','9','8'])
            if m_reg == '1':
                self.ui.f_reg_cfg.addItems(['1','2','4'])
            elif m_reg == '8':
                self.ui.f_reg_cfg.addItems(['2','4','8','16'])
            else:
                self.ui.f_reg_cfg.addItems(['1','2','4','8'])
        elif ntotal_reg == '12':
            self.ui.l_reg_cfg.clear()
            self.ui.n_reg_cfg.addItems(['12','11','10','9','8'])
            if m_reg == '1':
                self.ui.f_reg_cfg.addItems(['1','3','6'])
                self.ui.l_reg_cfg.addItems(['1','2','3'])
            elif m_reg == '2':
                self.ui.f_reg_cfg.addItems(['1','3'])
                self.ui.l_reg_cfg.addItems(['1','2','3','4'])
            elif m_reg == '4':
                self.ui.f_reg_cfg.addItems(['2','3','6'])
                self.ui.l_reg_cfg.addItems(['1','2','3','4'])
            else:
                self.ui.f_reg_cfg.addItems(['3','6'])
                self.ui.l_reg_cfg.addItems(['2','4'])
        else:
            self.ui.n_reg_cfg.addItem('8')
            self.ui.l_reg_cfg.clear()
            self.ui.l_reg_cfg.addItems(['1','2','4'])
            self.ui.f_reg_cfg.addItems(['1','2','4'])
    def j204b_mode_cfg_active2(self):
        self.ui.s_reg_cfg.clear()
        ##self.ui.k_reg_cfg.clear()
        m_reg = self.ui.m_reg_cfg.currentText()
        ntotal_reg = self.ui.ntotal_reg_cfg.currentText()
        f_reg = self.ui.f_reg_cfg.currentText()
        l_reg = self.ui.l_reg_cfg.currentText()
        s_reg = 8*int(f_reg)*int(l_reg)/int(m_reg)/int(ntotal_reg)
        self.ui.s_reg_cfg.addItem(str(int(s_reg)))
        ##if f_reg == '1':
        ##    self.ui.k_reg_cfg.addItems(['20','24','28','32'])
        ##elif f_reg == '2':
        ##    self.ui.k_reg_cfg.addItems(['12','16','20','24','28','32'])
        ##elif f_reg == '3':
        ##    self.ui.k_reg_cfg.addItems(['12','16','20','24','28','32'])
        ##elif f_reg == '4':
        ##    self.ui.k_reg_cfg.addItems(['8','12','16','20','24','28','32'])
        ##elif f_reg == '6':
        ##    self.ui.k_reg_cfg.addItems(['8','12','16','20','24','28','32'])
        ##elif f_reg == '8':
        ##    self.ui.k_reg_cfg.addItems(['4','8','12','16','20','24','28','32'])
        ##elif f_reg == '16':
        ##    self.ui.k_reg_cfg.addItems(['4','8','12','16','20','24','28','32'])
        self.calc_lane_rate()
    def calc_lane_rate(self):
        m_reg = self.ui.m_reg_cfg.currentText()
        ntotal_reg = self.ui.ntotal_reg_cfg.currentText()
        l_reg = self.ui.l_reg_cfg.currentText()
        fadc = self.ui.fs_display.text()
        ddc_dcm_str = self.ui.ddc0_config.currentText()
        ddc_dcm = float(re.match('Decimation=(\d+)',ddc_dcm_str).group(1))
        if fadc == '':
            lane_rate = 0
        else:
            fadc = float(fadc)/1000
            lane_rate = float(m_reg)*float(ntotal_reg)*(10/8)*fadc/ddc_dcm/float(l_reg)
        self.ui.fin_display_2.setText(str(lane_rate))
    def j204b_update(self):
        m_reg = self.ui.m_reg_cfg.currentText()
        ntotal_reg = self.ui.ntotal_reg_cfg.currentText()
        f_reg = self.ui.f_reg_cfg.currentText()
        l_reg = self.ui.l_reg_cfg.currentText()
        s_reg = self.ui.s_reg_cfg.currentText()
        n_reg = self.ui.n_reg_cfg.currentText()
        k_reg = self.ui.k_reg_cfg.currentText()
        fs = self.ui.fs_display.text()
        lane_rate = self.ui.fin_display_2.text()    ##str
        self.write_atom(0x571,0x4)
        self.write_atom(0x5f9,0x0)
        if fs != '' and lane_rate != '':
            ddc_freq = float(fs)/4
            link_freq = float(lane_rate)*1000/40
            clk_div = int(ddc_freq/link_freq)
            self.write_atom(0xf0d,clk_div)
        else:
            self.write_atom(0xf0d,0x2)
        self.write_atom(0x5f9,0x0)
        self.write_atom(0x58b,128+int(l_reg)-1)
        self.write_atom(0x58e,int(m_reg)-1)
        self.write_atom(0x58c,int(f_reg)-1)
        self.write_atom(0x591,int(s_reg)-1)
        self.write_atom(0x58f,int(n_reg)-1)
        self.write_atom(0x590,32+int(ntotal_reg)-1)
        self.write_atom(0x58d,int(k_reg)-1)
        self.write_atom(0x5e4,int(k_reg)*int(f_reg))
        self.write_atom(0x5b2,0x45)
        self.write_atom(0x5b3,0x76)
        self.write_atom(0x5b5,0x03)
        self.write_atom(0x5b6,0x12)
        self.write_atom(0x571,0x5)
        self.ui.label_8.setPixmap(QtGui.QPixmap(":/xxx/xxx.png"))
    def sds_config(self):
        self.ui.refclk_div.setText('64')
        self.ui.fbc_div.setText('160')
        self.ui.comboBox.addItems(['0db', '3.5db', '6db', '9db'])
    def sds_update(self):
        lane_rate = self.ui.fin_display_2.text()    ##str
        ffe_sel = self.ui.comboBox.currentIndex()   ##int
        refclk_div = int(int(self.ui.refclk_div.text())/2)
        fbc_div = int(self.ui.fbc_div.text())
        self.write_atom(0x107d,refclk_div)
        self.write_atom(0x1148,fbc_div)
        if lane_rate == '':
            self.write_atom(0x113a,0x90)
            self.write_atom(0x113b,0xfd)
            self.write_atom(0x113c,0x07)
            self.write_atom(0x113d,0x05)
            self.write_atom(0x113e,0x90)
            self.write_atom(0x113f,0x81)
            self.write_atom(0x1140,0x00)
            self.write_atom(0x1141,0x0f)
            self.write_atom(0x1142,0x02)
            self.write_atom(0x1143,0x40)
            self.write_atom(0x1144,0xf0)
            self.write_atom(0x1145,0x57)
            self.write_atom(0x1146,0x2f)
            self.write_atom(0x1149,0x00)
            self.write_atom(0x114a,0x50)
            self.write_atom(0x1150,0x49)
            self.write_atom(0x1151,0x16)
            self.write_atom(0x1088,0x50)
        else:
            lane_rate = float(lane_rate)
            if lane_rate >=4 and lane_rate <= 6.5:
                self.write_atom(0x113a, 0x10)
                self.write_atom(0x113b, 0xfd)
                self.write_atom(0x113c, 0x0e)
                self.write_atom(0x113d, 0x7d)
                self.write_atom(0x113e, 0x90)
                self.write_atom(0x113f, 0x84)
                self.write_atom(0x1140, 0x00)
                self.write_atom(0x1141, 0x00)
                self.write_atom(0x1142, 0x02)
                self.write_atom(0x1143, 0x55)
                self.write_atom(0x1144, 0xf0)
                self.write_atom(0x1145, 0x07)
                self.write_atom(0x1146, 0x2f)
                self.write_atom(0x1149, 0x40)
                self.write_atom(0x114a, 0x5a)
                self.write_atom(0x1150, 0x49)
                self.write_atom(0x1151, 0x12)
                self.write_atom(0x1088, 0x50)
            elif lane_rate >6.5 and lane_rate <= 8:
                self.write_atom(0x113a, 0x90)
                self.write_atom(0x113b, 0xfd)
                self.write_atom(0x113c, 0x07)
                self.write_atom(0x113d, 0x00)
                self.write_atom(0x113e, 0x90)
                self.write_atom(0x113f, 0x81)
                self.write_atom(0x1140, 0x00)
                self.write_atom(0x1141, 0x0f)
                self.write_atom(0x1142, 0x02)
                self.write_atom(0x1143, 0x55)
                self.write_atom(0x1144, 0xf0)
                self.write_atom(0x1145, 0x57)
                self.write_atom(0x1146, 0x2f)
                self.write_atom(0x1149, 0x40)
                self.write_atom(0x114a, 0x5a)
                self.write_atom(0x1150, 0x49)
                self.write_atom(0x1151, 0x16)
                self.write_atom(0x1088, 0x50)
            elif lane_rate >8 and lane_rate <= 13.5:
                self.write_atom(0x113a, 0x10)
                self.write_atom(0x113b, 0xfd)
                self.write_atom(0x113c, 0x0e)
                self.write_atom(0x113d, 0x7d)
                self.write_atom(0x113e, 0x90)
                self.write_atom(0x113f, 0x84)
                self.write_atom(0x1140, 0x00)
                self.write_atom(0x1141, 0x00)
                self.write_atom(0x1142, 0x02)
                self.write_atom(0x1143, 0x55)
                self.write_atom(0x1144, 0xf0)
                self.write_atom(0x1145, 0x07)
                self.write_atom(0x1146, 0x2f)
                self.write_atom(0x1149, 0x40)
                self.write_atom(0x114a, 0x5a)
                self.write_atom(0x1150, 0x49)
                self.write_atom(0x1151, 0x12)
                self.write_atom(0x1088, 0x50)
            elif lane_rate >13.5 and lane_rate <= 16:
                self.write_atom(0x113a, 0x90)
                self.write_atom(0x113b, 0xfd)
                self.write_atom(0x113c, 0x07)
                self.write_atom(0x113d, 0x00)
                self.write_atom(0x113e, 0x90)
                self.write_atom(0x113f, 0x81)
                self.write_atom(0x1140, 0x00)
                self.write_atom(0x1141, 0x0f)
                self.write_atom(0x1142, 0x02)
                self.write_atom(0x1143, 0x55)
                self.write_atom(0x1144, 0xf0)
                self.write_atom(0x1145, 0x57)
                self.write_atom(0x1146, 0x2f)
                self.write_atom(0x1149, 0x40)
                self.write_atom(0x114a, 0x5a)
                self.write_atom(0x1150, 0x49)
                self.write_atom(0x1151, 0x16)
                self.write_atom(0x1088, 0x50)
        for i in range(8):
            self.write_atom(0x1092+i*10,0x84)
        if lane_rate == '':
            pass
        else:
            lane_rate = float(lane_rate)
            if lane_rate >= 8 and lane_rate <= 16:      ##8-16G
                for i in range(8):
                    if ffe_sel == 0:
                        self.write_atom(0x1091+i*10,0x60)
                    else:
                        self.write_atom(0x1091+i*10,0x63)
            elif lane_rate >= 4 and lane_rate <8:       ##4-8G
                for i in range(8):
                    if ffe_sel == 0:
                        self.write_atom(0x1091+i*10,0x70)
                    else:
                        self.write_atom(0x1091+i*10,0x73)
        if ffe_sel == 0:
            for i in range(8):
                self.write_atom(0x1090+i*10,0x3c)
                self.write_atom(0x108f+i*10,0xf4)
                self.write_atom(0x108e+i*10,0x0)
        elif ffe_sel == 1:
            for i in range(8):
                self.write_atom(0x1090+i*10,0x38)
                self.write_atom(0x108f+i*10,0xd4)
                self.write_atom(0x108e+i*10,0x0)
        elif ffe_sel == 2:
            for i in range(8):
                self.write_atom(0x1090+i*10,0x3c)
                self.write_atom(0x108f+i*10,0xc4)
                self.write_atom(0x108e+i*10,0x0)
        elif ffe_sel == 3:
            for i in range(8):
                self.write_atom(0x1090+i*10,0x3e)
                self.write_atom(0x108f+i*10,0xb4)
                self.write_atom(0x108e+i*10,0x0)
        self.write_atom(0x1089,0xf0)
        time.sleep(0.5)
        self.write_atom(0x1089,0xf1)
        for i in range(8):
            self.write_atom(0x10e3+12*i,0x02)
        time.sleep(0.5)
        for i in range(8):
            self.write_atom(0x10e3+12*i,0x00)
        time.sleep(0.5)
        self.write_atom(0x1087,0x04)
        time.sleep(0.5)
        self.write_atom(0x1087,0x0c)
    def sds_test_prbs7(self):
        for i in range(8):
            self.write_atom(0x108d+i*10,0x80)
        time.sleep(0.5)
        for i in range(8):
            self.write_atom(0x108d+i*10,0xa0)
    def sds_test_clk0101(self):
        for i in range(8):
            self.write_atom(0x108d+i*10,0x91)
    def spi_config(self):
        self.ui.lineEdit_2.setText('8')
        self.ui.lineEdit.setText('1.125')
        # Scan device
        nRet = ControlSPI.VSI_ScanDevice(1)
        if (nRet <= 0):
            self.ui.label_6.setPixmap(QtGui.QPixmap(":/status/OFF.png"))
        else:
            self.ui.label_6.setPixmap(QtGui.QPixmap(":/status/on.png"))
    def spi_update(self):
        # Scan device
        nRet = ControlSPI.VSI_ScanDevice(1)
        if (nRet <= 0):
            print("No device connect!")
        else:
            print("Connected device number is:" + repr(nRet))
        # Open device
        nRet = ControlSPI.VSI_OpenDevice(ControlSPI.VSI_USBSPI, 0, 0)
        if (nRet != ControlSPI.ERR_SUCCESS):
            print("Open device error!")
        else:
            print("Open device success!")
        # Initialize device
        SPI_Init = ControlSPI.VSI_INIT_CONFIG()
        if self.ui.lineEdit.text() == '':
            SPI_Init.ClockSpeed = 1125000
        else:
            SPI_Init.ClockSpeed = int(float(self.ui.lineEdit.text())*1000000)
        SPI_Init.ControlMode = 3
        SPI_Init.CPHA = 0
        SPI_Init.CPOL = 0
        SPI_Init.LSBFirst = 0
        SPI_Init.MasterMode = 1
        SPI_Init.SelPolarity = 0
        SPI_Init.TranBits = 8
        nRet = ControlSPI.VSI_InitSPI(ControlSPI.VSI_USBSPI, 0, byref(SPI_Init))
        if (nRet != ControlSPI.ERR_SUCCESS):
            print("Initialization device error!")
        else:
            print("Initialization device success!")
            self.ui.label_6.setPixmap(QtGui.QPixmap(":/status/on.png"))
                
if __name__ == '__main__':
    # Scan device
    nRet = ControlSPI.VSI_ScanDevice(1)
    if (nRet <= 0):
        print("No device connect!")
    else:
        print("Connected device number is:" + repr(nRet))
    # Open device
    nRet = ControlSPI.VSI_OpenDevice(ControlSPI.VSI_USBSPI, 0, 0)
    if (nRet != ControlSPI.ERR_SUCCESS):
        print("Open device error!")
    else:
        print("Open device success!")
    # Initialize device
    SPI_Init = ControlSPI.VSI_INIT_CONFIG()
    SPI_Init.ClockSpeed = 1125000
    SPI_Init.ControlMode = 3
    SPI_Init.CPHA = 0
    SPI_Init.CPOL = 0
    SPI_Init.LSBFirst = 0
    SPI_Init.MasterMode = 1
    SPI_Init.SelPolarity = 0
    SPI_Init.TranBits = 8
    nRet = ControlSPI.VSI_InitSPI(ControlSPI.VSI_USBSPI, 0, byref(SPI_Init))
    if (nRet != ControlSPI.ERR_SUCCESS):
        print("Initialization device error!")
    else:
        print("Initialization device success!")
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon('./ui_base/logo.ico'))
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
    
# self.cali_run_button.setStyleSheet("QPushButton{border-image: url(./ui_base/start.png)}")
