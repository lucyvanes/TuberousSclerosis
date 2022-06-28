#!/bin/bash

# ln -s /software/system/fsl/fsl-6.0.4/bin/eddy_cuda9.1 eddy_cuda
# export PATH=/data/bin:$PATH

module load mrtrix/3.0.2
module unload fsl/5.0.11
module load fsl/6.0.4
module load cuda/9.1
module load ants/2.3.5


cd /data
subs="$(ls -d sub*)"

for i in $subs

do
echo ${i}
echo "=================="
cd /data/${i}

echo "denoising"
dwidenoise dwi.mif dwi_den.mif -noise noise.mif
 ## calculate residual
mrcalc dwi.mif dwi_den.mif -subtract residual.mif
 ## make sure to inspect with mrview residual.mif
 ## if necessary adjust denoising filter, e.g. from 5 to 7 with
 ## dwidenoise dwi.mif dwi_den7.mif -extent 7 -noise noise.mif


 ## echo "removing Gibb's artefacts"
 ## mrdegibbs dwi_den.mif dwi_den_unr.mif

echo "preprocessing"
dwifslpreproc dwi_den.mif dwi_preprocessed.mif -pe_dir AP -rpe_pair -se_epi b0_pair.mif -eddy_options " --slm=linear"


# CSD
#========================================
echo "estimating response function"
dwi2response dhollander dwi_preprocessed.mif wm_response.txt gm_response.txt csf_response.txt -voxels voxels.mif
 ### check with shview wm_response.txt
 ### and mrview dwi_preprocessed.mif -overlay.load voxels.mif

echo "generating mask"
dwibiascorrect ants dwi_preprocessed.mif dwi_preprocessed_unbiased.mif -bias bias.mif
dwi2mask dwi_preprocessed_unbiased.mif mask.mif
 #### mrview mask.mif


done