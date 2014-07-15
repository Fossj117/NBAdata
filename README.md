#### Scraping NBA Player Tracking Data in R (and Python)

Basic scraper in R to grab the NBA sport tracking data from website and load it into one data frame. For more information, see blog post [here](http://jfoss.ghost.io/grabbing-player-tracking-data-with-r/). 

- `nbascraper.R` is the actual code for scraping the data. 
- `nba_data_5-10.csv` and `nba.csv` are somewhat-recent copies of the resulting CSV (if you just want the data).

In addition to the R code documented above, this repo also contains a related python script for pulling additional player metadata (e.g. positions, birthdates, etc.) from the NBA website via an internal API. 

- `pullPositions.py` is the script for pulling the position (and other) metadata
- `position_data.csv` is the resulting CSV. 