#!/usr/bin/python -u
import sys
import glob

SNRs=glob.glob('*.SNR-SV')
for file in SNRs:
    without_extension=file[0:-7]
    print without_extension

