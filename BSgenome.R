#!/usr/local/bin/R
#args = commandArgs()
bioc.packages = c("BSgenome")
bioc.check <- lapply(
  bioc.packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE, quietly = TRUE)) {
      if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
      BiocManager::install(x)
      suppressMessages({
        library(x, character.only = TRUE, quietly = TRUE) })
      }
    }
  )
setwd(paste0(getwd(),"/BSgenome"))
BSgenome::forgeBSgenomeDataPkg("BSgenome.Hsapiens.chm13v2.dms")
