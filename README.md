# h2020gridforecast
Submission for Horizon Prize Big Data Technologies by Mantigma GmbH, QuantiCo and the Research Institute e-Austria (IeAT).

## About the competition
To keep an electricity grid stable, at any moment demand and supply need to be matched exactly. In the past, the demand side had been forecasted and power generation schedules have been created for the supply side accordingly. Since years, wind and solar energy is added to the grid and as it is based on weather makes supply more and more volatile. Therefore, flows on the grids, which balance geographical separation of supply and demand, get more and more complex to forecast.

The European Commission wants to stimulate and accelerate research in the field of such grid flow forecasts and therefore has started the [Big data technolgies competition](http://ec.europa.eu/research/horizonprize/index.cfm?prize=bigdata) within its [Horizon 2020 programme](https://ec.europa.eu/programmes/horizon2020/) with a total prize amount of EUR 2m.

Additional documents about the competition:
* A collection of [FAQ](http://ec.europa.eu/research/horizonprize/pdf/bigdata/horizonprize_big_data_q-and-a.pdf#view=fit&pagemode=none)
* The [competition rules](http://ec.europa.eu/research/participants/data/ref/h2020/other/prizes/contest_rules/h2020-prizes-rules-big-data_en.pdf)

A set of training and validation data was released in the beginning of February to develop models and the software. Between 26 Feb 2018 and 12 Apr 2018, the software can be evaluated 3 times on a set of testing data whereas the results, but not the data itself will be available. The final submission (due by 12 Apr 2018) will be evaluated on a separate set of verification data. All data sets will originate from the same processes, but be of different time periods. The ranking is based on RMSE (root mean square error) for accuracy and OEET (overall elapsed execute time) for speed. (Exact definition of the ranking in the competition rules.)

## Data


## Team
People contributing to the project (alphabetical order):
- Alexander Braumann, PhD candidate mathematics, TU Braunschweig; statistician, Mantigma
- Bogdan-Petru Butunoi, MSc student machine learning, UVT
- Manfred Deistler, professor emeritus econometrics, TU Wien
- Jakob Etzel, managing director, Mantigma
- Marc Frincu, assoc. professor computer science, UVT; researcher, IeAT
- Bernd Funovits, post-doctoral researcher econometrics, TU Wien; statistician, Mantigma
- Zuzana Greganova, BSc candidate mathematics, TU Wien
- Kostiantyn Lapchevskyi, MSc candidate data science, UCU Lviv; statistician, Mantigma
- Marius E. Penteliuc, MSc candidate computer science, UVT; researcher, IeAT
- Jose Luis Salinas, post-doctoral researcher hydrology, TU Wien
- Fabian Schroeder, post-doctoral researcher computational statistics, TU Wien
- Florin Adrian Spătaru, PhD student computer science, UVT; researcher, IeAT
- Anca Vulpe, MSc candidate computer science, UVT; researcher IeAT
- Daniela Zaharie, professor computer science, UVT

## Folder structure
*additional_data/* for data not provided in the starting kit, see `additional_data/README.md`
*Python/* for Python code
*R/* for R code
*R/eda/* exploratory data analaysis
*R/pkg/h2020gridforecast/* the R package we write
*R/config/R* global R config file with e.g. paths
*R/setup* files generating local_data

## Setup
We assume the following folder structure (relative to this repo's folder):
*../local_data* (a folder to store results / reformatted data)
*../starting-kit* (the whole decompressed starting-kit folder)
*../shiny* (a folder of symlinks to files/folders which should be served by the shiny server)
*../additional_data* (a folder to store)

Run the *R/setup.R* script to convert hdf5 data to R variables saved in rds files in *../local_data*.

To create symlinks for shiny files, run the following in the shiny folder:
```
ln ../h2020gridforecast/R/eda/aux_eda.Rmd aux_eda.Rmd
```
## Leaderboard
### horizon=12, steps=4
forecast function | rmse     | oeet
------------------|----------|------
persistence       | 28.03879 |
averaged          | 21.86697 |
copy_last_day     | 38.96141 |

### horizon=12, steps=168
forecast function | rmse     | oeet
------------------|----------|------
persistence       |          |
averaged          |          |
