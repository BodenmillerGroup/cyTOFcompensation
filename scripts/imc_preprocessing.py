
# coding: utf-8

# In[ ]:

from imctools.scripts import ometiff2analysis
from imctools.scripts import imc2tiff


# In[ ]:

import os
import re


# 
# # IMC preprocessing
# 
# This script uses the imctools python package to a) convert the IMC images to a standardized .ome.tiff format b) prepare stacks for analysis with CellProfiller and segmentation with Ilastik.
# 
# This needs the imctools library installed: https://github.com/BodenmillerGroup/imctools
# 
# The full description of the pipeline and how it needs to be setup can be found at: https://github.com/BodenmillerGroup/ImcSegmentationPipeline

# In[ ]:

# the folders with the txt/mcd files for the analysis
folders = [
           '../data/Figure_4/IMC_image'           
          ]

# output for OME tiffs
out_tiff_folder = '../data/Figure_4/IMC_image/ome'

# filename part that all the imc txt files should have, can be set to '' if none
common_file_part = '.txt'

pannel_csv = '../data/Figure_4/IMC_image/imc_example_pannel.csv'
metal_col = 'Metal Tag'
ilastik_col = 'ilastik'
# Explicitly indicates which metals should be used for the full stack
full_col = 'full'
# specify the folder to put the analysis in
analysis_folder = '../data/Figure_4/IMC_image/analysis'
# specify the subfolders
cp_folder = '../data/Figure_4/IMC_image/cpoutput'

# parameters for resizing the images for ilastik
suffix_full = '_full'
suffix_ilastik = '_ilastik'

failed_images = list()


# Specify which steps to run

# In[ ]:

do_convert_txt = True
do_stacks = True
do_ilastik = True


# Generate all the folders if necessary

# In[ ]:

for fol in [out_tiff_folder, analysis_folder, cp_folder]:
    if not os.path.exists(fol):
        os.makedirs(fol)


# Convert txt to ome

# In[ ]:

if do_convert_txt:
    for fol in (folders):
        for fn in os.listdir(fol):
            if len([f for f in os.listdir(out_tiff_folder) if (fn.rstrip('.txt').rstrip('.mcd') in f)]) == 0:
                if common_file_part in fn: # and 'tuningtape' not in fn:
                    print(fn)
                    txtname = os.path.join(fol, fn)
                    try:
                        imc2tiff.save_imc_to_tiff(txtname,tifftype='ome',
                                                  outpath=out_tiff_folder)

                    except:
                        failed_images.append(txtname)
                        print(txtname)


# Generate the analysis stacks

# In[ ]:

if do_stacks:
    for img in os.listdir(out_tiff_folder):
        basename = img.rstrip('.ome.tiff')
        ometiff2analysis.ometiff_2_analysis(os.path.join(out_tiff_folder, img), analysis_folder, basename+suffix_full,
                                           pannelcsv=pannel_csv, metalcolumn=metal_col,
                                            usedcolumn=full_col, bigtiff=False, sort_channels=False)



# Generate the ilastik stacks

# In[ ]:

if do_ilastik:
    for img in os.listdir(out_tiff_folder):
        basename = img.rstrip('.ome.tiff')
        ometiff2analysis.ometiff_2_analysis(os.path.join(out_tiff_folder, img), analysis_folder,
                                            basename + suffix_ilastik, pannelcsv=pannel_csv, metalcolumn=metal_col,
                                            usedcolumn=ilastik_col, addsum=True, bigtiff=False,sort_channels=False)


# The next steps needs a CellProfiller setup according to the description in  https://github.com/BodenmillerGroup/ImcSegmentationPipeline
# It was tested with CellProfiller V2.x
# - Run the pipeline './imc_pipelines_cellprofiller_prepare_ilastik.cpproj' in CellProfiller
# - Run the pixel classification: 'ilastik_pixelclassification.ilp' in ilastik
#     -> maybe the image path needs to be set to the image 'imc_example_image_a0_ilastik_s2.tiff'
# - Run the pipeline 'cellprofiller_segmentandexport.cpproj' in CellProfiller
