#!/usr/bin/env python 
# -*- coding: utf-8 -*-
'''
Time    : 2022/07/07 16:46
Author  : zhuchunjin
Email   : chunjin.zhu@taurentech.net
File    : hook-matlab.engine.py
Software: PyCharm
'''
from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all('engine')