# cyTOF compensation

This repository contains scripts used to reproduce a majority of figures from the paper "Compensation of signal spillover in suspension and imaging mass cytometry" by Stéphane Chevrier*, Helena Crowell*, Vito R.T. Zanotelli*, Stefanie Engler, Mark D. Robinson, and Bernd Bodenmiller
submitted to Cell Systems.

The bioRxiv version was made available under the name "Channel crosstalk correction in suspension and imaging mass cytometry": https://www.biorxiv.org/content/early/2017/09/07/185744

The raw data is available from Mendeley data under the DOI code 10.17632/v58yj49pfr
The CATALYST package developped specifically to allow a user friendly usage of the developped spillover estimation and compensation approach can be found for download at: http://bioconductor.org/packages/CATALYST
A link to the light version of the web app, installation instructions, example datasets, and vignettes for CATALYST are available from the project page: https://catalyst-project.github.io/. 

The repository is organized in the following scripts:

0) retrieve_data.Rmd:
Retrieves the data from the Mendeley repository.
If you want to run the scripts below this needs to be run first.
TODO: Adapt to the correct URL once the data is online

## Flow mass cytometry compensation

1) dilution_series.Rmd:
Assesses the linearity of spillover based on a dilution series of antibody staining
This will reproduce, among other plots, the following figures from the paper:
* Figure 1, C

2) correlation_analysis.Rmd:
Explore how spillover and compensation affect correlations and phenograph clusters in a cyTOF dataset.
This will reproduce, among other plots, the following figures from the paper:
* Figure 3, A-E
* Figure S4, A-C

3) spillover_estimation.Rmd:
Estimates and compares spillover matrices obtained from 11 single stained bead replicates, Fluidigm, and IMC.
Reproduces:
* Figure S3, B-E
* Figure S5, B-E

4) method_comparison.Rmd:
Compares different methods for spillover estimation (single-cell vs. estimation based, and expected vs. all interactions).
Reproduces:
* Figure S2, B-F

## Imaging mass cytometry compensation

3) imc_generatespillmat_long.Rmd:
A detailed step by step script to calculate a spillover matrix from a single stain experiment.
Reproduces:
* Figure S5, A
* Figure 4, A

4) imc_generatespillmat_short.Rmd:
A short version of a script to generate a spillover matrix from an IMC single stain experiment in one step using a convenience function

5) imc_preprocessing.ipynb:
A script to convert & process IMC images for segmentation. Adapted from: https://github.com/BodenmillerGroup/ImcSegmentationPipeline
The belonging CellProfiller & ilastik pipelines can be found in the data/IMC_image/pipelines
To run this needs also script 6).
The segmentation output produced is used in script 7) and the images saved were used in ImageJ to reproduce Fig 4 B

6) imc_adaptsm.Rmd:
Adapts the spillover matrix and saves it as a TIFF for usage in the CellProfiller pipeline.

7) imc_cpoutput_analysis.Rmd:
Script that was used to compensate the CellProfiller output and display the segmented data on the masks.
Reproduces:
* Fig 3. D
and produces the mask images visualized in Fig 4 C using ImageJ

8) spillover_imc_helpers.R:
Contains various helper functions used in the scripts above.

Bonus scripts:
- imc_comp_txt_example.Rmd:
  A supplemenatry script that shows how to directly compensate an IMC .txt raw data file and save it back as a .txt
  This was requested in the imc-forum: https://www.imc-forum.org/viewtopic.php?f=4&p=30#p13
  
  
