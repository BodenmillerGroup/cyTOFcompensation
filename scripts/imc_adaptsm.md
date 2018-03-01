# Image Compensation
Vito Zanotelli et al.  

Adapts the spillover matrix
# Compensate an IMC image

```r
library(CATALYST)
```


##

```r
fn_sm = '../data/Figure_S5/paper_version_Spillover_Matrix_2_sm.csv'
fn_imc_metals = '../data/Figure_4/IMC_image/analysis/imc_example_image_a0_full.csv'
fol_out = dirname(fn_imc_metals)
prefix_out =  'adapted_'
```


Write the spillover matrix for cellprofier


```r
sm = read.csv(fn_sm, row.names = 1)
analysis_channels = read.csv(fn_imc_metals,header = F)
analysis_channels = paste(as.character(analysis_channels$V1), 'Di', sep = '')
sm_table = CATALYST::adaptSpillmat(input_sm = as.matrix(sm), out_chs = analysis_channels)
```

```
## WARNING: Compensation is likely to be inaccurate.
##          Spill values for the following interactions
##          have not been estimated:
```

```
## La139Di -> Gd155Di
```


```r
tiff::writeTIFF(sm_table, file.path(fol_out, 'imc_full_sm.tiff'), bits.per.sample = 32, reduce = T)
```

```
## [1] 1
```


```r
sessionInfo()
```

```
## R version 3.4.1 (2017-06-30)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.5 LTS
## 
## Matrix products: default
## BLAS: /usr/lib/openblas-base/libblas.so.3
## LAPACK: /usr/lib/lapack/liblapack.so.3.0
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] CATALYST_1.1.5
## 
## loaded via a namespace (and not attached):
##  [1] Biobase_2.36.2      httr_1.3.1          tidyr_0.7.1        
##  [4] viridisLite_0.2.0   jsonlite_1.5        splines_3.4.1      
##  [7] gtools_3.5.0        shiny_1.0.5         assertthat_0.2.0   
## [10] stats4_3.4.1        tiff_0.1-5          yaml_2.1.16        
## [13] robustbase_0.92-7   backports_1.1.1     lattice_0.20-35    
## [16] quantreg_5.33       glue_1.1.1          digest_0.6.15      
## [19] RColorBrewer_1.1-2  minqa_1.2.4         colorspace_1.3-2   
## [22] sandwich_2.4-0      httpuv_1.3.5        htmltools_0.3.6    
## [25] Matrix_1.2-11       plyr_1.8.4          pcaPP_1.9-72       
## [28] pkgconfig_2.0.1     SparseM_1.77        xtable_1.8-2       
## [31] purrr_0.2.3         flowCore_1.42.3     corpcor_1.6.9      
## [34] mvtnorm_1.0-6       scales_0.5.0        lme4_1.1-14        
## [37] MatrixModels_0.4-1  tibble_1.3.4        mgcv_1.8-22        
## [40] car_2.1-5           ggplot2_2.2.1       TH.data_1.0-8      
## [43] nnet_7.3-12         BiocGenerics_0.22.1 lazyeval_0.2.0     
## [46] pbkrtest_0.4-7      mime_0.5            survival_2.41-3    
## [49] magrittr_1.5        evaluate_0.10.1     nlme_3.1-131       
## [52] MASS_7.3-47         graph_1.54.0        tools_3.4.1        
## [55] data.table_1.10.4-1 matrixStats_0.53.0  multcomp_1.4-8     
## [58] stringr_1.2.0       plotly_4.7.1        munsell_0.4.3      
## [61] cluster_2.0.6       plotrix_3.7         bindrcpp_0.2       
## [64] compiler_3.4.1      rlang_0.1.2         grid_3.4.1         
## [67] nloptr_1.0.4        drc_3.0-1           htmlwidgets_1.0    
## [70] rmarkdown_1.6       gtable_0.2.0        codetools_0.2-15   
## [73] reshape2_1.4.3      rrcov_1.4-3         R6_2.2.2           
## [76] gridExtra_2.3       nnls_1.4            zoo_1.8-0          
## [79] knitr_1.17          dplyr_0.7.4         bindr_0.1          
## [82] rprojroot_1.2       stringi_1.1.5       parallel_3.4.1     
## [85] Rcpp_0.12.15        DEoptimR_1.0-8
```
