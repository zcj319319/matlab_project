# _*_ coding   : UTF-8 _*_
# 开发者        : BigRiver
# 开发时间      : 2021/11/24 13:37
# 文件名称      : smp_data_trans.PY
# 开发工具      : PyCharm
import os
from ctypes import *
from time import sleep
import random
import numpy as np
import matplotlib.pyplot as plt


def smp_trans(read_file_name):
    try:
        MEM_SEC_NUM = 64
        MEM_SEC_SIZE = 1024

        ##need config
        start_sec_idx = 0
        end_sec_idx = 63
        bit_num = 2
        read_write_path = os.path.dirname(read_file_name)
        write_file_name = os.path.join(read_write_path, 'read_data_from_testmem_after_trans.txt')
        smp_width = (2 ** bit_num) * 32
        smp_sec_num = 2 ** bit_num
        sec_use_num = end_sec_idx - start_sec_idx + 1
        sec_grp_num = int(sec_use_num / smp_sec_num)

        with open(read_file_name, "r") as fn:
            rdata_buf = fn.readlines()
        for i in range(0, len(rdata_buf)):
            rdata_buf[i] = int(rdata_buf[i].rstrip('\n'), 16)

        wdata_buf = []

        cnt = 0
        print('sec_grp_num=' + str(sec_grp_num) + '\n')
        print('MEM_SEC_SIZE=' + str(MEM_SEC_SIZE) + '\n')
        print('smp_sec_num=' + str(smp_sec_num) + '\n')
        for sec_grp_idx in range(0, sec_grp_num):
            for sec_depth_idx in range(0, MEM_SEC_SIZE):
                for smp_sec_idx in range(0, smp_sec_num):
                    wdata_buf.append(
                        rdata_buf[
                            sec_grp_idx * smp_sec_num * MEM_SEC_SIZE + smp_sec_idx * MEM_SEC_SIZE + sec_depth_idx])
                    cnt = cnt + 1

        fp = open(write_file_name, 'w')
        wdata = []
        for i in range(0, len(wdata_buf)):
            fp.write("%02x\n" % (wdata_buf[i] % 65536))
            fp.write("%02x\n" % ((int(wdata_buf[i] / 65536)) % 65536))
            wdata.append(wdata_buf[i] % 65536)
            wdata.append((int(wdata_buf[i] / 65536)) % 65536)
        fp.close()

        wdata_buf = np.array(wdata)
        data_len = len(wdata_buf)
        ts = np.linspace(1, data_len, data_len)
        wdata_buf = np.where(wdata_buf >= 32768, wdata_buf - 65536, wdata_buf)

        fft_size = 16384

        data_fft = np.fft.rfft(wdata_buf[:fft_size]) / fft_size
        freq = np.linspace(1, int(fft_size / 2), int(fft_size / 2) + 1)
        # data_db = 20*np.log10(np.abs(data_fft))

        plt.figure(1)
        # plt.plot(freq, data_db)
        plt.plot(ts, wdata_buf)
        plt.show()
        return write_file_name , ''
    except Exception as e:
        return False, '%s'%e
