#### Some straightforward R code for pulling the new NBA player tracking data from online and merging it into a data set in R ####

rm(list=ls())

#list of addresses for raw data.
addressList <- list(
  pullup_address ="http://stats.nba.com/js/data/sportvu/pullUpShootData.js",
  drives_address ="http://stats.nba.com/js/data/sportvu/drivesData.js",
  defense_address ="http://stats.nba.com/js/data/sportvu/defenseData.js",
  passing_address ="http://stats.nba.com/js/data/sportvu/passingData.js",
  touches_address ="http://stats.nba.com/js/data/sportvu/touchesData.js",
  speed_address ="http://stats.nba.com/js/data/sportvu/speedData.js",
  rebounding_address ="http://stats.nba.com/js/data/sportvu/reboundingData.js",
  catchshoot_address ="http://stats.nba.com/js/data/sportvu/catchShootData.js",
  shooting_address ="http://stats.nba.com/js/data/sportvu/shootingData.js"
)
  
#function that grabs the data from the website and converts to R data frame
readIt <- function(address){
  web_page <- readLines(address)
  
  ##regex to strip javascript bits and convert raw to csv format
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl=TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl=TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl=TRUE)
  x4 <- gsub(";", ",",x3, perl=TRUE)
  
  write(x4, "./nba.txt")
  nba<-read.table("./nba.txt", header=T, sep=",", skip=2, stringsAsFactors=FALSE)
  nba <- nba[,1:ncol(nba)-1] #strip last column
  
  return(nba)
}

# function for merging a list of data sets
merge.rec <- function(.list, ...){
  if(length(.list)==1) return(.list[[1]])
  Recall(c(list(merge(.list[[1]], .list[[2]], ...)), .list[-(1:2)]), ...)
}

#using each address, read in a data set
df_list <- lapply(addressList, readIt)

# variables to merge on 
mergevars <- c("PLAYER_ID", "PLAYER", "FIRST_NAME", "LAST_NAME", "TEAM_ABBREVIATION", "GP", "MIN")

# create the final data
final.data <- merge.rec(df_list, by=mergevars)

#create more informative column names:
varnames <- c(
  "PlAYER_ID",
  "PLAYER",
  "FIRST_NAME",
  "LAST_NAME",
  "TEAM_ABBREVIATION",
  "GP",
  "MIN",
  "PU_PPG",
  "PU_FGM_PG",
  "PU_FGA_PG",
  "PU_FG_PCT",
  "PU_FG3M_PG",
  "PU_FG3A_PG",
  "PU_FG3_PCT",
  "PU_EFG_PCT",
  "PU_PTS_TOT",
  "DVS",    #START DRIVES STATS
  "DVS_PPG", #drives player PPG
  "DVS_TPPG", #TEAM drives ppg
  "DVS_FG_PCT",
  "DVS_PP48", #drives pts per 48 min driving
  "DVS_PTS_TOT",
  "DVS_TOT",
  "BLK_PG", #START DEFENSIVE STATS
  "STL_PG",
  "OPP_FGM_RIM",
  "OPP_FGA_RIM",
  "OPP_FGP_RIM",
  "BLK_TOT",
  "PASS_PG", #START PASSING STATS
  "AST_PG",
  "AST_FT",
  "AST_SEC",
  "AST_OPPS_PG",
  "AST_PTS_CRT_PG",
  "AST_PTS_CRT_48",
  "AST_TOT",
  "TCH_PG", #BEGIN TOUCHES STATS
  "TCH_FC_PG", #FC = front court
  "TOP", #time of posession
  "CL_TCH_PG", #touches close to basket
  "EL_TCH_PG", #touches in the "elbow" area
  "PPG", #raw ppg
  "PP_TCH", #pts per touch
  "PP_HC_TCH", #pts per half court touch
  "TCH_TOT",
  "DIST", #START SPEED AND DIST STATS
  "AVG_SPD",
  "DIST_PG",
  "DIST_48",
  "DIST_OFF",
  "DIST_DEF",
  "AVG_SPD_OFF",
  "AVG_SPD_DEF",
  "REB_PG", #START REBOUNDING STATS
  "REB_CHANCE_PG",          
  "REB_COL_PCT",          
  "REB_CONTESTED",       
  "REB_UNCONTESTED",      
  "REB_UNCONTESTED_PCT", 
  "REB_TOT",              
  "OREB",                
  "OREB_CHANCE",          
  "OREB_COL_PCT",        
  "OREB_CONTESTED",       
  "OREB_UNCONTESTED",    
  "OREB_UNCONTESTED_PCT", 
  "DREB",                
  "DREB_CHANCE",          
  "DREB_COL_PCT",        
  "DREB_CONTESTED",       
  "DREB_UNCONTESTED",    
  "DREB_UNCONTESTED_PCT",
  "CS_PPG", #START CATCH AND SHOOT STATS
  "CS_FGM_PG",
  "CS_FGA_PG",
  "CS_FG_PCT",
  "CS_FG3M_PG",
  "CS_FG3A_PG",
  "CS_FG3_PCT",
  "CS_EFG_PCT",
  "CS_PTS_TOT",
  "CS_PPG",
  "PTS_DRIVE", #START SHOOTING EFFICIENCY STATS          
  "FGP_DRIVE",           
  "PTS_CLOSE",           
  "FGP_CLOSE",            
  "PTS_CATCH_SHOOT",     
  "FGP_CATCH_SHOOT",      
  "PTS_PULL_UP",         
  "FGP_PULL_UP",          
  "FGA_DRIVE",           
  "FGA_CLOSE",            
  "FGA_CATCH_SHOOT",     
  "FGA_PULL_UP",          
  "EFG_PCT"
  )

colnames(final.data) <- varnames