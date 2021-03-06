#######################################################################
###  
###  Package lookup tables into an RData for use in FHR processing.
###  Expects 3 command-line args:
###    - CSV of partner names and IDs
###    - CSV of partner names and search defaults
###    - CSV of all search plugins and names
###    - RData file to output to.
###  
#######################################################################

library(data.table)
files <- commandArgs(TRUE)

## Current and expired partner IDs.
## Lookup table is stored as named vector.
## Identify expired partner builds with the suffix "|expired".
partner.ids <- as.data.table(read.csv(files[1], stringsAsFactors = FALSE))
partner.ids[type == "expired", partner := sprintf("%s|expired", partner)]
partner.list <- partner.ids[, setNames(partner, distrib_id)]

## Partner search plugins.
partner.plugins <- as.data.table(read.csv(files[2], stringsAsFactors = FALSE))
partner.plugins[type == "expired", partner := sprintf("%s|expired", partner)]
partner.plugins <- split(partner.plugins$search_name, partner.plugins$partner)
    
## All official search plugins.
official.plugins <- read.csv(files[3], stringsAsFactors = FALSE)[, "plugin_id"]

save(partner.list, partner.plugins, official.plugins, 
    file = files[4])   
   