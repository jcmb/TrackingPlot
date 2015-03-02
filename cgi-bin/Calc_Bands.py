#!/usr/bin/python -u

import glob

SNRs=glob.glob('*.SNR')
for file in SNRs:
    without_extension=file[0:-4]
    print without_extension
