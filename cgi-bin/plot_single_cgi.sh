#! /bin/bash
echo $1 "*" $2 "*" $3 "*" $4 "*" $5 "*<br>"
Ext=$2
FileFull=`basename $1`;
File=`basename $1 $2`;
Dir=`dirname $0`;
normalDir=`cd "${Dir}";pwd`
TrimbleTools=$3
Decimate=$4
Project=$5
#echo $PATH
PATH=${normalDir}:~/bin:$PATH


#mkdir -p ~/public_html/results/TRACKING/$File
#cd ~/public_html/results/TRACKING/$Fil
TMP_DIR=~/tmp

mkdir -p /var/www/html/results/Tracking$Project/$File
cd /var/www/html/results/Tracking$Project/$File
TMP_DIR=/run/shm


rm * 2> /dev/null

#set -o verbose
#set -o xtrace



echo $File > file.html
echo "Creating Week File"
WEEK=-2
WEEK=`viewdat -d19 $1 | Week_From_T19.pl`
echo GPS Week: $WEEK
#echo $TMP_DIR/$$.X27

echo Creating x27 file for $File
viewdat -d27 -x -o$TMP_DIR/$$.x27 $1 

echo "Decimation interval: " $Decimate
if [ "$Decimate" = -1 ]
then
   echo "Computing decimation interval" 
   eval $(compute_decimate.py $TMP_DIR/$$.x27)
fi

if [ $Decimate = 0 ]
then
    echo "No Decimation"
    echo "All Data, Interval($interval)">Decimation
else
    echo "Decimation interval: " $Decimate
    echo "Orginal interval: " $interval
    echo "Every: $Decimate (s), orginal ($interval)">Decimation
fi


echo Creating SNRs file for $File
decimate.py $Decimate <$TMP_DIR/$$.x27 | X27_SNRs.py $WEEK



echo "Computing Bands used"
Calc_Bands.py >Tracked.Bands

if [ ! -s Tracked.Bands ]
then
   echo "Bands files not created, trying again"
   echo Creating SNRs file for $File
   decimate.py $Decimate <$TMP_DIR/$$.x27 | X27_SNRs.py $WEEK
   echo "Computing Bands used"
   Calc_Bands.py >Tracked.Bands

   if [ ! -s Tracked.Bands ]
   then
      echo "Bands files not created, please try uploading again "
      exit 4
   fi
fi

rm $TMP_DIR/$$.x27

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
echo "</body>"
echo "</html>"
