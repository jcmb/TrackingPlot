#! /bin/bash
#echo $1 "*" $2 "*" $3 "<br>"
Ext=$2
FileFull=`basename $1`;
File=`basename $1 $2`;
Dir=`dirname $0`;
normalDir=`cd "${Dir}";pwd`
TrimbleTools=$3
Project=$4
#echo $PATH
PATH=${normalDir}:~/bin:$PATH

#mkdir -p ~/public_html/results/TRACKING/$File
#cd ~/public_html/results/TRACKING/$File

mkdir -p /var/www/html/results/Tracking$Project/$File
cd /var/www/html/results/Tracking$Project/$File
rm * 2> /dev/null

echo Creating X29 file for $File

echo $File > file.html
set -o verbose
set -o xtrace
echo "Creating Week File"
WEEK=-2
WEEK=`viewdat -d19 $1 | Week_From_T19.pl`
echo GPS Week: $WEEK

echo Creating SNRs file for $File
viewdat -d27 -x $1 | X27_SNRs.py $WEEK
echo "Computing Bands used"
Calc_Bands.py >Tracked.Bands

if [ ! -s Tracked.Bands ]
then
   echo "Bands files not created, trying again"
   echo Creating SNRs file for $File
   viewdat -d27 -x $1 | X27_SNRs.py $WEEK
   echo "Computing Bands used"
   Calc_Bands.py >Tracked.Bands

   if [ ! -s Tracked.Bands ]
   then
      echo "Bands files not created, please try uploading again "
      exit 4
   fi
fi

echo "Computing SV used"
Calc_SVs.py >Tracked.SVs
echo "Computing Stats"
SNR_STATS.py

#mv $$.x29 $File.X29
mv $1 $FileFull

echo Processing completed
ln -s $normalDir/SNR_Plot.shtml
ln -s $normalDir/Tracking_Plot.shtml
ln -s $normalDir/Slips_Plot.shtml
ln -s $normalDir/SV_Tracking_Plot.shtml
ln -s $normalDir/Buttons.html
ln -s $normalDir/Tracking_Buttons.html
ln -s $normalDir/index.shtml
echo '</pre>'
#echo -n '<base href="http://trimbletools.com/results/TRACKING/'
#echo -n $File
#echo '/" />'
#cat index.shtml
