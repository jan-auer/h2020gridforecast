# h2020gridforecast
Submission for Horizon Prize Big Data Technologies by Mantigma GmbH, QuantiCo and the Research Institute e-Austria (IeAT).
## Setup
We assume the following folder structure (relative to this repo's folder):
*../local_data* (a folder to store results / reformatted data)
*../starting-kit* (the whole decompressed starting-kit folder)
*../shiny* (a folder of symlinks to files/folders which should be served by the shiny server)

Run the *R/setup.R* script to convert hdf5 data to R variables saved in rds files in *../local_data*.

To create symlinks for shiny files, run the following in the shiny folder:
```
ln ../h2020gridforecast/R/eda/aux_eda.Rmd aux_eda.Rmd
```
