#!/bin/bash

ln -s /software/system/fsl/fsl-6.0.4/bin/eddy_cuda9.1 eddy_cuda


module load mrtrix/3.0.2
module unload fsl/5.0.11
module load fsl/6.0.4
module load cuda/9.1

#
cd /data
subs="$(ls -d sub*)"
##

cd /data


for i in $subs

# assuming all subjects' relevant series are in series: 6 7 8 9


do
echo ${i}
echo "=================="

mkdir /data/${i}
cd /data/${i}

# makde symbolic link to DICOM
ln -s /data/${i}/dwi/DICOM/

echo "concatenating dwi"
#======================== 
dwicat DICOM/0007 DICOM/0009 dwi.mif

echo "getting first forward b0 (volume 1)"
#==========================================
dwiextract dwi.mif -bzero - | mrconvert - -coord 3 0 b0_forward.mif

echo "getting reverse b0 (volume 6)"
#=====================================
mrconvert DICOM/0008 -coord 3 5 b0_reverse.mif

echo "concatenating forward and reverse b0s"
#============================================
mrcat b0_forward.mif b0_reverse.mif b0_pair.mif -force

done
















