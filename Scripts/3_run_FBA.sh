#!/bin/bash

cd /data

 # all subjects:
 # sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 

# run this after calculating average response functions (for wm, gm, and csf) across all subjects using responsemean

echo "upsampling DW images"
#==============================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mrgrid IN/dwi_preprocessed_unbiased.mif regrid -vox 1.25 IN/dwi_preprocessed_unbiased_upsampled.mif

echo "creating mask for upsampled images"
#=========================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : dwi2mask IN/dwi_preprocessed_unbiased_upsampled.mif IN/dwi_mask_upsampled.mif
 
echo "FOD estimation"
#=======================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : dwi2fod msmt_csd IN/dwi_preprocessed_unbiased_upsampled.mif whole_group_average_response_wm.txt IN/FBA_wmfod.mif whole_group_average_response_gm.txt IN/FBA_gmfod.mif  whole_group_average_response_csf.txt IN/FBA_csffod.mif -mask IN/dwi_mask_upsampled.mif -force

 
 echo "Joint bias field correction / intensity normalisation"
#=============================================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mtnormalise IN/FBA_wmfod.mif IN/FBA_wmfod_norm.mif IN/FBA_gmfod.mif IN/FBA_gm_norm.mif IN/FBA_csffod.mif IN/FBA_csf_norm.mif -mask IN/dwi_mask_upsampled.mif -force


 echo "generating study specific template"
 #=============================================
 # symmbolic link all images and masks into folder
# make template folder; fod_input; mask_input first
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : ln -sr IN/FBA_wmfod_norm.mif template/fod_input/PRE.mif
  
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : ln -sr IN/dwi_mask_upsampled.mif template/mask_input/PRE.mif
 
population_template template/fod_input -mask_dir template/mask_input template/wmfod_template.mif -voxel_size 1.25
 
 echo "register FOD images to template"
 #======================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mrregister IN/FBA_wmfod_norm.mif -mask1 IN/dwi_mask_upsampled.mif template/wmfod_template.mif -nl_warp IN/subject2template_warp.mif IN/template2subject_warp.mif -force


echo "computing template mask"
#=====================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mrtransform IN/dwi_mask_upsampled.mif -warp IN/subject2template_warp.mif -interp nearest -datatype bit IN/dwi_mask_in_template_space.mif -force

mrmath TAP*/dwi_mask_in_template_space.mif min template/template_mask.mif -datatype bit -force



echo "computing white matter template analysis fixel mask"
#==========================================================
fod2fixel -mask template/template_mask.mif -fmls_peak_value 0.06 template/wmfod_template.mif template/fixel_mask -force

echo "warping FOD images to template space"
#===========================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mrtransform IN/FBA_wmfod_norm.mif -warp IN/subject2template_warp.mif -reorient_fod no IN/fod_in_template_space_NOT_REORIENTED.mif -force


echo "segmenting FOD images to estimate fixels and their apparent FD"
#====================================================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : fod2fixel -mask template/template_mask.mif IN/fod_in_template_space_NOT_REORIENTED.mif IN/fixel_in_template_space_NOT_REORIENTED -afd fd.mif -force



echo "reorienting fixels"
#===========================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : fixelreorient IN/fixel_in_template_space_NOT_REORIENTED IN/subject2template_warp.mif IN/fixel_in_template_space -force

# fixel_in_template_space_NOT_REORIENTED  can now be removed

echo "assigning subject fixels to template fixels"
#====================================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : fixelcorrespondence IN/fixel_in_template_space/fd.mif template/fixel_mask template/fd PRE.mif -force


echo "computing fibre crosssection metric"
#============================================
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : warp2metric IN/subject2template_warp.mif -fc template/fixel_mask template/fc IN.mif -force


# create logFC to ensure data is centred around 0 and normally distributed
mkdir template/log_fc
cp template/fc/index.mif template/fc/directions.mif template/log_fc
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mrcalc template/fc/IN.mif -log template/log_fc/IN.mif

echo "computing FDC"
#=========================
mkdir template/fdc
cp template/fc/index.mif template/fdc
cp template/fc/directions.mif template/fdc
for_each sub1 sub2 sub3 sub4 sub5 sub6 sub7 sub8 sub9 sub10 sub11 sub12 sub13 sub14 sub15 sub16 sub17 sub18 sub19 sub20 sub21 sub22 sub23 sub24 sub25 sub26 sub27 sub28 : mrcalc template/fd/IN.mif template/fc/IN.mif -mult template/fdc/IN.mif


echo "performing whole-brain tractography on the FOD template"
#==============================================================
cd template
tckgen -angle 22.5 -maxlen 250 -minlen 10 -power 1.0 wmfod_template.mif -seed_image template_mask.mif -mask template_mask.mif -select 20000000 -cutoff 0.06 tracks_20_million.tck


echo "reducing bias in tractogram densities"
#===========================================
tcksift tracks_20_million.tck wmfod_template.mif tracks_2_million_sift.tck -term_number 2000000


echo "generating fixel-fixel connectivity matrix"
#================================================
fixelconnectivity fixel_mask/ tracks_2_million_sift.tck matrix/


echo "smoothing fixel data"
#==============================
cp fc/index.mif log_fc/   
cp fc/directions.mif log_fc/   

fixelfilter fd smooth fd_smooth -matrix matrix/
fixelfilter log_fc smooth log_fc_smooth -matrix matrix/
fixelfilter fdc smooth fdc_smooth -matrix matrix/






# echo "performing stats"
#==============================
# fixelcfestats fd_smooth/ files.txt design_matrix.txt contrast_matrix.txt matrix/ stats_fd/
# fixelcfestats log_fc_smooth/ files.txt design_matrix.txt contrast_matrix.txt matrix/ stats_log_fc/
# fixelcfestats fdc_smooth/ files.txt design_matrix.txt contrast_matrix.txt matrix/ stats_fdc/

# make sure to include intercept
 
 
 
 
 
 
 
 
 
 
 
 

 
