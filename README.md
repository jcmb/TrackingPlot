TrackingPlot
============

This is the series of scripts that are used on TrimbleTools and gnssplot for plotting Tracking information from T0x files.

It creates static and interactive plots of the SNR's and cycle slips

External Requirements:
-------------

It requires ViewDat, which is a trimble internal tool :-( 
gnuplot V5+ needs to be installed
Highcharts plotting needs to in installed in libraries on the web server

GitHub Modules
---------------
TZ.py needs to be installed on the path
WWW-common needs to be installed

Installation
------------

copy the files from WWW to a location on the web server
copy cgi-bin into cgi-bin/PositionPlot on the web server, make all the files executable (chmod +x)
