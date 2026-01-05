

#---------------------------------
# New invocation of recon-all Tue Jul 13 16:30:42 EDT 2021 

 mri_convert /autofs/cluster/fssubjects/testsets/bert/raw/001.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/001.mgz 


 mri_convert /autofs/cluster/fssubjects/testsets/bert/raw/002.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/002.mgz 


 mri_convert /autofs/cluster/fssubjects/testsets/bert/raw/003.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/003.mgz 

#--------------------------------------------
#@# MotionCor Tue Jul 13 16:30:58 EDT 2021

 mri_robust_template --mov /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/001.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/002.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/003.mgz --average 1 --template /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/rawavg.mgz --satit --inittp 1 --fixtp --noit --iscale --iscaleout /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/001-iscale.txt /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/002-iscale.txt /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/003-iscale.txt --subsample 200 --lta /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/001.lta /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/002.lta /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig/003.lta 


 mri_convert /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/rawavg.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/transforms/talairach.xfm /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig.mgz /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Tue Jul 13 16:32:12 EDT 2021

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection Tue Jul 13 16:35:45 EDT 2021

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/bin/extract_talairach_avi_QA.awk /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/transforms/talairach_avi.log 


 tal_QC_AZS /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Tue Jul 13 16:35:45 EDT 2021

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Tue Jul 13 16:39:08 EDT 2021

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Tue Jul 13 16:40:36 EDT 2021

 mri_em_register -skull nu.mgz /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Tue Jul 13 16:43:45 EDT 2021

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/RB_all_2020-01-02.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Tue Jul 13 16:46:19 EDT 2021

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Tue Jul 13 16:47:25 EDT 2021

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Tue Jul 13 17:39:48 EDT 2021

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg Tue Jul 13 18:25:00 EDT 2021

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/transforms/cc_up.lta bert 

#--------------------------------------
#@# Merge ASeg Tue Jul 13 18:25:45 EDT 2021

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Tue Jul 13 18:25:45 EDT 2021

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Tue Jul 13 18:27:49 EDT 2021

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Tue Jul 13 18:27:50 EDT 2021

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Tue Jul 13 18:30:21 EDT 2021

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz
#--------------------------------------------
#@# Tessellate lh Tue Jul 13 18:31:23 EDT 2021

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Tue Jul 13 18:31:26 EDT 2021

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Tue Jul 13 18:31:30 EDT 2021

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Tue Jul 13 18:31:30 EDT 2021

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Tue Jul 13 18:31:34 EDT 2021

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Tue Jul 13 18:31:34 EDT 2021

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Tue Jul 13 18:31:52 EDT 2021

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Tue Jul 13 18:31:52 EDT 2021

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#@# Fix Topology lh Tue Jul 13 18:34:21 EDT 2021

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 bert lh 

#@# Fix Topology rh Tue Jul 13 18:34:21 EDT 2021

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 bert rh 


 mris_euler_number ../surf/lh.orig.premesh 


 mris_euler_number ../surf/rh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.orig.premesh --output /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.orig 


 mris_remesh --remesh --iters 3 --input /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.orig.premesh --output /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm -f ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm -f ../surf/rh.inflated 

#--------------------------------------------
#@# AutoDetGWStats lh Tue Jul 13 18:39:35 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
#--------------------------------------------
#@# AutoDetGWStats rh Tue Jul 13 18:39:39 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc lh Tue Jul 13 18:39:43 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# WhitePreAparc rh Tue Jul 13 18:42:20 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# CortexLabel lh Tue Jul 13 18:44:55 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 0 ../label/lh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg lh Tue Jul 13 18:45:11 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
#--------------------------------------------
#@# CortexLabel rh Tue Jul 13 18:45:27 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 0 ../label/rh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg rh Tue Jul 13 18:45:43 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 lh Tue Jul 13 18:45:59 EDT 2021

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Tue Jul 13 18:46:00 EDT 2021

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Tue Jul 13 18:46:04 EDT 2021

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Tue Jul 13 18:46:04 EDT 2021

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Tue Jul 13 18:46:26 EDT 2021

 mris_curvature -w -seed 1234 lh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Tue Jul 13 18:46:27 EDT 2021

 mris_curvature -w -seed 1234 rh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 

#--------------------------------------------
#@# Sphere lh Tue Jul 13 18:47:16 EDT 2021

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Tue Jul 13 18:47:16 EDT 2021

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh Tue Jul 13 18:53:22 EDT 2021

 mris_register -curv ../surf/lh.sphere /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh Tue Jul 13 18:53:22 EDT 2021

 mris_register -curv ../surf/rh.sphere /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Tue Jul 13 19:02:54 EDT 2021

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Tue Jul 13 19:02:54 EDT 2021

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Tue Jul 13 19:02:55 EDT 2021

 mrisp_paint -a 5 /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Tue Jul 13 19:02:55 EDT 2021

 mrisp_paint -a 5 /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Tue Jul 13 19:02:57 EDT 2021

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 bert lh ../surf/lh.sphere.reg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Tue Jul 13 19:02:57 EDT 2021

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 bert rh ../surf/rh.sphere.reg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs lh Tue Jul 13 19:03:08 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
#--------------------------------------------
#@# WhiteSurfs rh Tue Jul 13 19:05:23 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
#--------------------------------------------
#@# T1PialSurf lh Tue Jul 13 19:07:35 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white --o ../surf/lh.pial.T1 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --white-surf ../surf/lh.white
#--------------------------------------------
#@# T1PialSurf rh Tue Jul 13 19:10:09 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white --o ../surf/rh.pial.T1 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --white-surf ../surf/rh.white
#@# white curv lh Tue Jul 13 19:12:39 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
#@# white area lh Tue Jul 13 19:12:41 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
#@# pial curv lh Tue Jul 13 19:12:41 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
#@# pial area lh Tue Jul 13 19:12:43 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
#@# thickness lh Tue Jul 13 19:12:44 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# area and vertex vol lh Tue Jul 13 19:13:14 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# white curv rh Tue Jul 13 19:13:16 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
#@# white area rh Tue Jul 13 19:13:18 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
#@# pial curv rh Tue Jul 13 19:13:19 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
#@# pial area rh Tue Jul 13 19:13:21 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
#@# thickness rh Tue Jul 13 19:13:21 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
#@# area and vertex vol rh Tue Jul 13 19:13:52 EDT 2021
cd /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness

#-----------------------------------------
#@# Curvature Stats lh Tue Jul 13 19:13:54 EDT 2021

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm bert lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Tue Jul 13 19:13:56 EDT 2021

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm bert rh curv sulc 

#--------------------------------------------
#@# Cortical ribbon mask Tue Jul 13 19:13:59 EDT 2021

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon bert 

#-----------------------------------------
#@# Cortical Parc 2 lh Tue Jul 13 19:17:44 EDT 2021

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 bert lh ../surf/lh.sphere.reg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Tue Jul 13 19:17:44 EDT 2021

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 bert rh ../surf/rh.sphere.reg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 lh Tue Jul 13 19:17:59 EDT 2021

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 bert lh ../surf/lh.sphere.reg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Tue Jul 13 19:17:59 EDT 2021

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 bert rh ../surf/rh.sphere.reg /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast lh Tue Jul 13 19:18:12 EDT 2021

 pctsurfcon --s bert --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Tue Jul 13 19:18:12 EDT 2021

 pctsurfcon --s bert --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Tue Jul 13 19:18:16 EDT 2021

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Tue Jul 13 19:18:31 EDT 2021

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/mri/ribbon.mgz --threads 8 --lh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.cortex.label --lh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.white --lh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.pial --rh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.cortex.label --rh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.white --rh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.pial 


 mri_brainvol_stats bert 

#-----------------------------------------
#@# AParc-to-ASeg aparc Tue Jul 13 19:18:40 EDT 2021

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.aparc.annot 1000 --lh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.cortex.label --lh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.white --lh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.pial --rh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.aparc.annot 2000 --rh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.cortex.label --rh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.white --rh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Tue Jul 13 19:19:24 EDT 2021

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.cortex.label --lh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.white --lh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.pial --rh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.cortex.label --rh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.white --rh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Tue Jul 13 19:20:12 EDT 2021

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.cortex.label --lh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.white --lh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.pial --rh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.cortex.label --rh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.white --rh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.pial 

#-----------------------------------------
#@# WMParc Tue Jul 13 19:20:57 EDT 2021

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 8 --lh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.aparc.annot 3000 --lh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/lh.cortex.label --lh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.white --lh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/lh.pial --rh-annot /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.aparc.annot 4000 --rh-cortex-mask /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/label/rh.cortex.label --rh-white /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.white --rh-pial /autofs/vast/freesurfer/test/recons/bert/7.2.0/bert/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject bert --surf-wm-vol --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/WMParcStatsLUT.txt --etiv 

#-----------------------------------------
#@# Parcellation Stats lh Tue Jul 13 19:23:37 EDT 2021

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab bert lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab bert lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Tue Jul 13 19:23:37 EDT 2021

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab bert rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab bert rh pial 

#-----------------------------------------
#@# Parcellation Stats 2 lh Tue Jul 13 19:24:02 EDT 2021

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab bert lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Tue Jul 13 19:24:02 EDT 2021

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab bert rh white 

#-----------------------------------------
#@# Parcellation Stats 3 lh Tue Jul 13 19:24:16 EDT 2021

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab bert lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Tue Jul 13 19:24:16 EDT 2021

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab bert rh white 

#--------------------------------------------
#@# ASeg Stats Tue Jul 13 19:24:29 EDT 2021

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/ASegStatsLUT.txt --subject bert 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /autofs/vast/freesurfer/test/recons/bert/7.2.0; ln -s /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh Tue Jul 13 19:25:09 EDT 2021

 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA1_exvivo.label --trgsubject bert --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA2_exvivo.label --trgsubject bert --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA3a_exvivo.label --trgsubject bert --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA3b_exvivo.label --trgsubject bert --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA4a_exvivo.label --trgsubject bert --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA4p_exvivo.label --trgsubject bert --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA6_exvivo.label --trgsubject bert --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA44_exvivo.label --trgsubject bert --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA45_exvivo.label --trgsubject bert --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.V1_exvivo.label --trgsubject bert --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.V2_exvivo.label --trgsubject bert --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.MT_exvivo.label --trgsubject bert --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject bert --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject bert --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.FG1.mpm.vpnl.label --trgsubject bert --trglabel ./lh.FG1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.FG2.mpm.vpnl.label --trgsubject bert --trglabel ./lh.FG2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.FG3.mpm.vpnl.label --trgsubject bert --trglabel ./lh.FG3.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.FG4.mpm.vpnl.label --trgsubject bert --trglabel ./lh.FG4.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.hOc1.mpm.vpnl.label --trgsubject bert --trglabel ./lh.hOc1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.hOc2.mpm.vpnl.label --trgsubject bert --trglabel ./lh.hOc2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.hOc3v.mpm.vpnl.label --trgsubject bert --trglabel ./lh.hOc3v.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.hOc4v.mpm.vpnl.label --trgsubject bert --trglabel ./lh.hOc4v.mpm.vpnl.label --hemi lh --regmethod surface 


 mris_label2annot --s bert --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/colortable_vpnl.txt --hemi lh --a mpm.vpnl --maxstatwinner --noverbose --l lh.FG1.mpm.vpnl.label --l lh.FG2.mpm.vpnl.label --l lh.FG3.mpm.vpnl.label --l lh.FG4.mpm.vpnl.label --l lh.hOc1.mpm.vpnl.label --l lh.hOc2.mpm.vpnl.label --l lh.hOc3v.mpm.vpnl.label --l lh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject bert --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject bert --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject bert --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject bert --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject bert --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject bert --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s bert --hemi lh --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.perirhinal_exvivo.label --l lh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s bert --hemi lh --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab bert lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab bert lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Tue Jul 13 19:26:24 EDT 2021

 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA1_exvivo.label --trgsubject bert --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA2_exvivo.label --trgsubject bert --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA3a_exvivo.label --trgsubject bert --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA3b_exvivo.label --trgsubject bert --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA4a_exvivo.label --trgsubject bert --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA4p_exvivo.label --trgsubject bert --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA6_exvivo.label --trgsubject bert --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA44_exvivo.label --trgsubject bert --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA45_exvivo.label --trgsubject bert --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.V1_exvivo.label --trgsubject bert --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.V2_exvivo.label --trgsubject bert --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.MT_exvivo.label --trgsubject bert --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject bert --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject bert --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.FG1.mpm.vpnl.label --trgsubject bert --trglabel ./rh.FG1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.FG2.mpm.vpnl.label --trgsubject bert --trglabel ./rh.FG2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.FG3.mpm.vpnl.label --trgsubject bert --trglabel ./rh.FG3.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.FG4.mpm.vpnl.label --trgsubject bert --trglabel ./rh.FG4.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.hOc1.mpm.vpnl.label --trgsubject bert --trglabel ./rh.hOc1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.hOc2.mpm.vpnl.label --trgsubject bert --trglabel ./rh.hOc2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.hOc3v.mpm.vpnl.label --trgsubject bert --trglabel ./rh.hOc3v.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.hOc4v.mpm.vpnl.label --trgsubject bert --trglabel ./rh.hOc4v.mpm.vpnl.label --hemi rh --regmethod surface 


 mris_label2annot --s bert --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/colortable_vpnl.txt --hemi rh --a mpm.vpnl --maxstatwinner --noverbose --l rh.FG1.mpm.vpnl.label --l rh.FG2.mpm.vpnl.label --l rh.FG3.mpm.vpnl.label --l rh.FG4.mpm.vpnl.label --l rh.hOc1.mpm.vpnl.label --l rh.hOc2.mpm.vpnl.label --l rh.hOc3v.mpm.vpnl.label --l rh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject bert --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject bert --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject bert --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject bert --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject bert --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /autofs/vast/freesurfer/test/recons/bert/7.2.0/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject bert --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s bert --hemi rh --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.perirhinal_exvivo.label --l rh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s bert --hemi rh --ctab /autofs/vast/freesurfer/centos7_x86_64/7.2.0-beta/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab bert rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab bert rh white 

