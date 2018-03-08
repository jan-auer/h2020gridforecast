# Additional data
As competition organisers are not providing us with auxiliary data for all the dates of target data, we load missing data ourselves. We do this because we think that the data sets in the starting kit have been reduced to keep download sizes small, but that in real competition circumstances full data will be available. It has not been confirmed by the organisers whether this will indeed be the case.

## GOSAT
To get GOSAT data, a registration is necessary. We receive userID and set a password. Then, file lists for the necessary products can be downloaded. The are provided in this folder:
* SWIRL2CH4_GU_V02.21.txt
* SWIRL2CO2_GU_V02.21.txt
* SWIRL2H2O_GU_V02.21.txt

The data is provided in hdf5 format with identical structure to the GOSAT data provided in the starting kit. Also, measurement version numbers are agreeing.

Data should be downloaded in the folder `../../additional_data/` (relative to this file) by `wget -i [file list txt file] --http-user=[userID] --http-passwd=[password]` and extracted afterwards.
