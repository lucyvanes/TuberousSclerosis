#!/bin/bash

module load mrtrix/3.0.2
module load fsl/6.0.4

 # all subjects:
 # sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 


cd /data

for i in sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 
do
cd ${i}
echo ${i}

warp2metric subject2template_warp.mif -jdet subject2template_jdet.mif

cp subject2template_jdet.mif /data/template/jacobians/${i}.mif

cd /data/template/jacobians/
mrconvert ${i}.mif ${i}.nii

done

fslmerge -t all_jacs.nii.gz sub*.nii
randomise -i all_jacs.nii.gz -o Jacs_TwoSampT -d design_jacs.mat -t design_jacs.con -N 5000 -T