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
The team consists of:
- Accuracy team (mathematical formulation) - based in Vienna
  - Jakob Etzel, managing director Mantigma
  - Bernd Funovits, post-doctoral researcher econometrics, Uni Helsinki / TU Wien; Mantigma
  - Jose Luis Salinas, post-doctoral researcher hydrology, TU Wien
  - Alexander Braumann, PhD candidate mathematics, TU Braunschweig; Mantigma
  - Kostiantyn Lapchevskyi, MSc candidate data science, UCU Lviv; Mantigma
  - Zuzana Greganova, BSc candidate mathematics, TU Wien
  - Fabian Schroeder, post-doctoral researcher computational statistics, TU Wien
- Speed team (performance optimisation) - based in Timisoara
  - Marc Frincu, assoc. professor computer science, UVT; IeAT
  - Marius E. Penteliuc, MSc candidate computer science, UVT; IeAT
  - Anca Vulpe, MSc candidate computer science, UVT; IeAT
  - Florin Adrian Spătaru, PhD student computer science, UVT; IeAT
  - Bogdan-Petru Butunoi, MSc student machine learning, UVT

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
