# cyTOF compensation

This repository contains scripts used to reproduce a majority of figures from the paper "Compensation of signal spillover in suspension and imaging mass cytometry" by Stéphane Chevrier\*, Helena L. Crowell\*, Vito R.T. Zanotelli\*, Stefanie Engler, Mark D. Robinson, and Bernd Bodenmiller
available which is currently in press.

The bioRxiv version was made available under the name "Channel crosstalk correction in suspension and imaging mass cytometry": https://www.biorxiv.org/content/early/2017/09/07/185744

The raw data is available from Mendeley data under the DOI code 10.17632/v58yj49pfr
The CATALYST package developed specifically to allow a user friendly usage of the developped spillover estimation and compensation approach can be found for download at: http://bioconductor.org/packages/CATALYST
A link to the light version of the web app, installation instructions, example datasets, and vignettes for CATALYST are available from the project page: https://catalyst-project.github.io/. 

The repository is organized in the following scripts:

0) retrieve_data.R:\
Retrieves the data from the Mendeley repository.
If you want to run the scripts below this needs to be run first.

## Flow mass cytometry compensation

1) dilution_series.Rmd: \
[code](scripts/dilution_series.Rmd) \
[markdown](scripts/dilution_series.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/dilution_series.html) \
Assesses the linearity of spillover based on a dilution series of antibody staining
This will reproduce, among other plots, the following figures from the paper:
* Figure 1, C

2) even_odd.Rmd: \
[code](scripts/even_odd.Rmd) \
[markdown](scripts/even_odd.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/even_odd.html) \
Assessment of compensation accuracy for single stained beads vs. multiplexed cells. Reproduces:
* Figure 2, C

3) bc_titration.Rmd: \
[code](scripts/bc_titration.Rmd) \
[markdown](scripts/bc_titration.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/bc_titration.html) \
Support for our hypothesis that the difference observed in spillover between single-stained beads and multiplexed-stained cells is due to saturation effects. Reproduces:
* Figure 2, D+E 

4) correlation_analysis.Rmd: \
[code](scripts/correlation_analysis.Rmd) \
[markdown](scripts/correlation_analysis.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/correlation_analysis.html) \
Explore how spillover and compensation affect correlations and phenograph clusters in a cyTOF dataset.
This will reproduce, among other plots, the following figures from the paper:
* Figure 3, A-E
* Figure S4, A-C

5) spillmat_estimation_stability.Rmd:\
[code](scripts/spillmat_estimation_stability.Rmd) \
[markdown](scripts/spillmat_estimation_stability.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/spillmat_estimationstability.html) \
Comparison and stability analysis of spillover matrices obtained from 11 single stained bead replicates, 2 IMC measurements, and Fluidigm. Reproduces:
* Figure S3, B-E
* Figure S5, B-E

6) method_comparison.Rmd:\
[code](scripts/method_comparison.Rmd) \
[markdown](scripts/method_comparison.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/method_comparison.html) \
Compares different methods for spillover estimation. Reproduces:
* Figure S2, C-F

7) plotting-wrappers.R:\
[code](scripts/plotting-wrappers.R) \
Contains helper functions to plot the results of the above scripts.

## Imaging mass cytometry compensation

3) imc_generatespillmat_long.Rmd:\
[code](scripts/imc_generatespillmat_long.Rmd) \
[markdown](scripts/imc_generatespillmat_long.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/imc_generatespillmat_long.html) \
A detailed step by step script to calculate a spillover matrix from a single stain experiment.
Reproduces:
* Figure S5, A
* Figure 4, A

4) imc_generatespillmat_short.Rmd:\
[code](scripts/imc_generatespillmat_short.Rmd) \
[markdown](scripts/imc_generatespillmat_short.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/imc_generatespillmat_short.html) \
A short version of a script to generate a spillover matrix from an IMC single stain experiment in one step using a convenience function

5) imc_preprocessing.ipynb:\
[code](scripts/imc_preprocessing.ipynb) \
A script to convert & process IMC images for segmentation. Adapted from: https://github.com/BodenmillerGroup/ImcSegmentationPipeline
The CellProfiller & ilastik pipelines that were used for the IMC image analysis can be found in the data/IMC_image/pipelines

The segmentation output produced by the IMC image analysis is then analysed in script 7). The compensated images saved were used in ImageJ to reproduce Figure 4, B

6) imc_adaptsm.Rmd:\
[code](scripts/imc_adaptsm.Rmd) \
[markdown](scripts/imc_adaptsm.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/imc_adaptsm.html) \
Adapts the spillover matrix and saves it as a TIFF for usage in the CellProfiller pipeline.

7) imc_cpoutput_analysis.Rmd:\
[code](scripts/imc_cpoutput_analysis.Rmd) \
[markdown](scripts/imc_cpoutput_analysis.md) \
[html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/imc_cpoutput_analysis.html) \
Script that was used to compensate the CellProfiller output and display the segmented data on the masks.
Reproduces:
* Figure 3, D
and produces the mask images visualized in Fig 4 C using ImageJ

8) spillover_imc_helpers.R:\
[code](scripts/spillover_imc_helpers.R) \
Contains various helper functions used in the scripts above.

Bonus scripts:
- imc_comp_txt_example.Rmd:\
  [code](scripts/imc_comp_txt_example.Rmd) \
  [markdown](scripts/imc_comp_txt_example.md) \
  [html](https://github.com/BodenmillerGroup/cyTOFcompensation/blob/master/scripts/imc_comp_txt_example.html) \
  A supplemenatry script that shows how to directly compensate an IMC .txt raw data file and save it back as a .txt
  This was requested in the imc-forum: https://www.imc-forum.org/viewtopic.php?f=4&p=30#p13
  
  
