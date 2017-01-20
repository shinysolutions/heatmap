library(shiny)
library(rCharts)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output, session) {
  HF <- read.csv("Data/HFGEO.csv", sep = ";", stringsAsFactors = FALSE) 
  HF <- HF[which(!is.na(HF$Lon)), -3]

  Post <- read.table("Data//postNr.txt", header = TRUE, stringsAsFactors = FALSE)
  Post$V1 <- formatC(Post$V1, width=4, flag="0")
  Post <- Post[, c("V1", "V5", "V6")]
  names(Post) <- c("Nr", "Lat", "Long")
  
  ## Source input and output;
  source("RScript/input.R",  local = TRUE)
  source("RScript/jsFun.R", local = TRUE)
  source("RScript/output.R", local = TRUE)
  
})
