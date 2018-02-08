### Download of the raw data from mendeley data
# 'source' the file to download and unzip all the raw data into the correct data subfolder
# This will only work once the Mendeley data is published
# author: Vito Zanotelli et al.

#urls_data = c(
#              'https://data.mendeley.com/datasets/v58yj49pfr/draft/files/1b30781a-7509-4c0a-9ff7-0e8d980ae3b9/Figure_1.zip?dl=1',
#              'https://data.mendeley.com/datasets/v58yj49pfr/draft/files/07368d1d-0882-4192-8d8e-494c50344c9f/Figure_2-3.zip?dl=1',
#              'https://data.mendeley.com/datasets/v58yj49pfr/draft/files/3ef240f2-96ab-4dd7-aba4-68150c286990/Figure_4.zip?dl=1',
#              'https://data.mendeley.com/datasets/v58yj49pfr/draft/files/8ac64093-0273-4ae3-a53e-fdb3348ee7ac/Figure_S5.zip?dl=1')

urls_data = c('file:///mnt/bbvolume/server_homes/vitoz/Git/cyTOFcompensation/data_b/Figure_1.zip',
              'file:///mnt/bbvolume/server_homes/vitoz/Git/cyTOFcompensation/data_b/Figure_2-3.zip',
              'file:///mnt/bbvolume/server_homes/vitoz/Git/cyTOFcompensation/data_b/Figure_4.zip',
              'file:///mnt/bbvolume/server_homes/vitoz/Git/cyTOFcompensation/data_b/Figure_S5.zip')

# set working directory to current script location
scriptdir <- dirname(parent.frame(2)$ofile)
setwd(scriptdir)
# create the data folder if it doesn't already exist
fol_download='../data'
dir.create(fol_download, showWarnings = FALSE)

# download the files
for (url in urls_data){
  td = tempdir()
  # create the placeholder file
  tf = tempfile(tmpdir=td, fileext=".zip")
  # download into the placeholder file
  download.file(url, tf)
  # unzip the file to target directory
  unzip(tf, exdir=fol_download, overwrite=TRUE)
  # remove the temporary file
  unlink(tf)
}
