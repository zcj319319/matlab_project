# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(['main.py'],
             pathex=['C:\\Users\\Administrator\\AppData\\Local\\Programs\\Python\\Python36\\Lib\\site-packages\\matlab'],
             binaries=[('D:\\matlab2018b\\extern\\engines\\python\\dist\\matlab\\engine\\win64\\matlabengineforpython3_6.pyd','.'),
                        ('D:\\matlab2018b\\extern\\bin\\win64\\libMatlabDataArray.dll','.'),
                        ('D:\\matlab2018b\\extern\\bin\\win64\\libMatlabDataArray.dll.a','.'),
                        ('D:\\matlab2018b\\extern\\bin\\win64\\libMatlabEngine.dll','.'),
                        ('C:\\Windows\\System32\\libusb0.dll', '.')],
             datas=[],
             hiddenimports=[],
             hookspath=[],
             hooksconfig={},
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)

exe = EXE(pyz,
          a.scripts, 
          [],
          exclude_binaries=True,
          name='main',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=True,
          disable_windowed_traceback=False,
          target_arch=None,
          codesign_identity=None,
          entitlements_file=None )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas, 
               strip=False,
               upx=True,
               upx_exclude=[],
               name='main')
