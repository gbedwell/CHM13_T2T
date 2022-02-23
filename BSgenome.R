#!/usr/local/bin/R
args = commandArgs()
bioc.packages = c("BSgenome")
bioc.check <- lapply(
  bioc.packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
      BiocManager::install(x)
      suppressPackageStartupMessages({
        library(x, character.only = TRUE, quietly = TRUE) })
      }
    }
  )
setwd(args[1])
forgeBSgenomeDataPkg("BSgenome.Hsapiens.T2T.CHM13v1.1.dms")
R CMD build BSgenome.Hsapiens.T2T.CHM13v1.1
R CMD check BSgenome.Hsapiens.T2T.CHM13v1.1_1.1.tar.gz
R CMD INSTALL BSgenome.Hsapiens.T2T.CHM13v1.1_1.1.tar.gz
