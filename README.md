# Fractal Dimension Of The Brain
A computational pipeline for quantifying brain structural complexity from Freesurferr outputs using fractal geometry.

## Overview
This project implements an exploratory fractal dimension analysis pipeline for structural neuroimaginng data. It computes FD in three ways.

1. Voxel-based morphometry. This analyses the volumetric outputs of freesurfer including:
    - The cortical ribbon .
    - Brain parcellations based on many atlases of Freesurfer, often obtained from aparc+aseg.mgh.
The LUT which can be used to Label the segments such as 
`ROI_labels = [2035]`
which represents the right hemisphere insular cortex.

2. Surface based morphometry. This analyses outputs such as lh.pial and lh.white.
    - Currently, the program uses the vertices, and their .annot files released in the labels output of Freesurfer. Similar to voxel-based analysis, it incorporates a box counting technique.
    - As the surface files are not 3d but rather folded 2d epresentations of the cortex, the intervals within vertices is used instead for box counting. 
    - This method is currently under review for validity and accuracy, and I aim to try the box counting algorithm using mesh triangle faces rather than vertices first, and compare the results. 

3. Higuchi Fractal Dimension, which I have sourced.
    a. Source: "https://github.com/inuritdino/HiguchiFractalDimension"
    b. Author: Ilya Potapov
    c. License: MIT License
    d. usage: calculate 1D FD of cortical thickness, from the lh.thickness and rh.thickness files

The full license text is in ATTRIBUTIONS.md 

## Features
- Multimodal complexity- although in progress, there are many approaches to quantifying the brain/region complexity.
- Works directly with Freesurfer output.
- Supports every atlas, but ensure the label files are complementary and use the LUT for volumetric labels of atlas parcellations.
- cohort ready - Incorporates Pandas dataframes, allowing for direct analysis and batch processing.

## Decisions
 - for the box counting algorithms, I have used box sizes of the factors of 240. This is due to the high number of fsctors and therefore box sizes in this range. More boxes indicastes the linearity of the log-log graph and calculates a more conmprehensive FD
- The cutoff for an acceptable r^2 value is 0.995. This may seem arbirary or extreme, however lol-log graphs are extremely sensetive to tiny outliers, and by experimentation I have found the chosen r^2 to be the highest for which most regions still maintained more than five boxes in my results, which was the minimum required for the analysis.

## Limitations
- As mentioned, the surface-based morphometry section requires further review
- Additionally, some ROI have shown both bi and multi fractal properties. As I am yet to implement this, in the case of multiple FD the current code will simply choose the FD with the highest linearity, which limits analysis.
- Although the voxel-based code has been vectorised, the use of for loops in mesh calculations is inneficient, and requires improvement.


## Notes
- I have used the DK atlas for surface files, and a reference exists in DK_atlas_ref.txt. This program is, however, compatible with the Destrieux and DKT atlases.
-  If the HFD code experiences issues, please make sure you are using a working C compiler.

