#!/usr/bin/env python 
# -*- coding: utf-8 -*-
'''
Time    : 2022/07/06 16:03
Author  : zhuchunjin
Email   : chunjin.zhu@taurentech.net
File    : loadingPanel.py
Software: PyCharm
'''
import time

from PyQt5 import QtWidgets
from PyQt5.QtCore import QDir
from PyQt5.QtWidgets import QFileDialog, QMessageBox

from project_ui import Ui_Form
import numpy as np
import matlab.engine
import matlab

from smp_trans import smp_trans

engine = matlab.engine.start_matlab()  # 启动matlab


class LoadingPanel(QtWidgets.QWidget, Ui_Form):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.init_param()
        self.config_transfer = {}
        self.param_transfer = {}
        self.start_xihe_adc_test_regset.clicked.connect(self.xihe_adc_test_regset_start)
        self.start_xihe_adc_test_dnc.clicked.connect(self.xihe_adc_test_dnc_start)
        self.start_xihe_adc_test.clicked.connect(self.xihe_adc_test_start)
        self.toolButton.clicked.connect(self.add_floder_toolbtn)
        self.smp_trans.clicked.connect(self.smp_trans_start)
        self.toolButton_2.clicked.connect(self.choose_readWrite_file)
        self.start_xihe_adc_test_display.clicked.connect(self.run_fft)

    def textBrowser_normal_log(self, info):
        self.xihe_adc_test_dnc_ans.append("{0} {1}".format(time.strftime("%F %T"), info))

    def xihe_adc_test_regset_start(self):
        self.textBrowser_normal_log('xihe_adc_test_regset spi_init starting')
        try:
            engine.xihe_adc_test_regset()
        except Exception as e:
            self.textBrowser_normal_log("err: %s"%e)
        self.textBrowser_normal_log('xihe_adc_test_regset_start spi_init ending')

    def xihe_adc_test_dnc_start(self):
        try:
            self.textBrowser_normal_log('xihe_adc_test_dnc_start')
            calib = engine.xihe_adc_test_dnc()
            dnc_weight1 = calib['dnc_weight1']
            dnc_weight1_text = ''
            for i in range(len(dnc_weight1)):
                dnc_weight1_row_text = ''
                for j in range(len(dnc_weight1[i])):
                    text = str(dnc_weight1[i][j]) + " "
                    dnc_weight1_row_text += text
                dnc_weight1_text += dnc_weight1_row_text + '\n'
            self.textBrowser_normal_log('ans=\n' + dnc_weight1_text)

            dnc_weight2 = calib['dnc_weight2']
            dnc_weight2_text = ''
            for i in range(len(dnc_weight2)):
                dnc_weight2_row_text = ''
                for j in range(len(dnc_weight2[i])):
                    text = str(dnc_weight2[i][j]) + " "
                    dnc_weight2_row_text += text
                dnc_weight2_text += dnc_weight2_row_text + '\n'
            self.textBrowser_normal_log('ans=\n' + dnc_weight2_text)
        except Exception as e:
            self.textBrowser_normal_log('err is %s'%e)

    def xihe_adc_test_start(self):
        try:
            ans_rest = engine.xihe_adc_test()
            print(ans_rest)
            self.textBrowser_normal_log('calib=\n%s' + str(ans_rest))
        except Exception as e:
            self.textBrowser_normal_log('err: %s'%e)

    def add_floder_toolbtn(self):
        curPath = QDir.currentPath()
        file_path, f_type = QFileDialog.getOpenFileName(self, 'choose a File', curPath,
                                                        'All Files (*);;Text Files (*.txt)')
        if file_path != '':
            self.lineEdit.setText(file_path)
        else:
            return

    def smp_trans_start(self):
        if self.lineEdit.text() == '':
            QMessageBox.information(self, 'warning', 'please choose a file!')
        else:
            flag,text=smp_trans(self.lineEdit.text())
            if flag:
                self.lineEdit_2.setText(flag)
            else:
                self.textBrowser_normal_log( ' err: %s'%text)

    def choose_readWrite_file(self):
        curPath = QDir.currentPath()
        file_path, f_type = QFileDialog.getOpenFileName(self, 'choose a File', curPath,
                                                        'All Files (*);;Text Files (*.txt)')
        if file_path != '':
            self.lineEdit_2.setText(file_path)
        else:
            return

    def run_fft(self):
        if self.lineEdit_2.text().strip(" ")!='':
            try:
                self.check_param()
                perf = engine.xihe_adc_test_display(self.lineEdit_2.text(),self.param_transfer)
            except Exception as e:
                self.textBrowser_normal_log('err:%s'%e)

    def init_param(self):
        self.fs_input.setText('6e9')
        # self.sigbw_input.setText('100e6')
        # self.dpdbw_input.setText('300e6')
        self.sideband_input.setText('300')
        self.sideband_sig_input.setText('2e6')
        self.fullscale_input.setText('1000')
        self.Rl_input.setText('100')
        self.num_interleave_input.setText('4')
        self.num_HD_input.setText('13')
        self.num_IMD_input.setText('3')
        self.window_input.setText('hann')
        self.nyquitst_zone_input.setText('1')
        self.dacOSR_input.setText('1')
        self.plot_range_input.setText('0')
        self.dbc_th_HD_input.setText('-70')
        self.dbc_th_IMD_input.setText('-70')
        self.dbc_th_IL_input.setText('-70')
        self.dbc_th_SFDR_input.setText('70')
        self.ENOB_include_HD_input.setText('0')
        self.plot_option_input.setText('1')
        self.figure_overwrite_input.setText('1')
        self.refclk_ratio_input.setText('1')
        self.sig_angle_input.setText('0')
        self.dc_1f_noise_cancel_input.setText('20e6')

    def check_param(self):
        self.param_transfer = {}
        if self.fs_input.text().strip(" ") == '':
            raise Exception('error : fs is necessary')
        else:
            self.param_transfer['fs'] = float(self.fs_input.text().strip(" "))

        if self.sigbw_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['sigbw'] = float(self.sigbw_input.text().strip(" "))
        if self.dpdbw_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dpdbw'] = float(self.dpdbw_input.text().strip(" "))
        if self.sideband_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['sideband'] = float(self.sideband_input.text().strip(" "))
        if self.sideband_sig_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['sideband_sig'] = float(self.sideband_sig_input.text().strip(" "))
        if self.fullscale_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['fullscale'] = float(self.fullscale_input.text().strip(" "))
        if self.Rl_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['Rl'] = float(self.Rl_input.text().strip(" "))
        if self.num_interleave_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['num_interleave'] = float(self.num_interleave_input.text().strip(" "))
        if self.num_HD_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['num_HD'] = float(self.num_HD_input.text().strip(" "))
        if self.num_IMD_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['num_IMD'] = float(self.num_IMD_input.text().strip(" "))
        if self.window_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['window'] = self.window_input.text().strip(" ")
        if self.nyquitst_zone_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['nyquitst_zone'] = float(self.nyquitst_zone_input.text().strip(" "))
        if self.dacOSR_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dacOSR'] = float(self.dacOSR_input.text().strip(" "))
        if self.plot_range_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['plot_range'] = float(self.plot_range_input.text().strip(" "))
        if self.dbc_th_HD_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dbc_th_HD'] = float(self.dbc_th_HD_input.text().strip(" "))
        if self.dbc_th_IMD_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dbc_th_IMD'] = float(self.dbc_th_IMD_input.text().strip(" "))
        if self.dbc_th_IL_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dbc_th_IL'] = float(self.dbc_th_IL_input.text().strip(" "))
        if self.dbc_th_SFDR_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dbc_th_SFDR'] = float(self.dbc_th_SFDR_input.text().strip(" "))
        if self.ENOB_include_HD_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['ENOB_include_HD'] = float(self.ENOB_include_HD_input.text().strip(" "))
        if self.plot_option_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['plot_option'] = float(self.plot_option_input.text().strip(" "))
        if self.figure_overwrite_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['figure_overwrite'] = float(self.figure_overwrite_input.text().strip(" "))
        self.param_transfer['imd_mode'] = float(self.imd_mode_cmbox.currentText())
        if self.refclk_ratio_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['refclk_ratio'] = float(self.refclk_ratio_input.text().strip(" "))
        if self.sig_angle_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['sig_angle'] = float(self.sig_angle_input.text().strip(" "))
        if self.dc_1f_noise_cancel_input.text().strip(" ") == '':
            pass
        else:
            self.param_transfer['dc_1f_noise_cancel'] = float(self.dc_1f_noise_cancel_input.text().strip(" "))
