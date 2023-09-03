#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : tokens / year for historical analysis 
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================



library(tidytext)
library(stringr)

rm(list=ls())
input_file1 <- "../data/pubmed_tdm_afterlump.Rdata"
input_file2 <- "../data/pubmed.Rdata"


load(input_file1)
load(input_file2)


temp <- dplyr::top_n(dplyr::count(filtered_lumped_ngrams, word,sort=TRUE), 10000, n)
filtered_lumped_ngrams <- subset(filtered_lumped_ngrams, word %in% temp$word)
filtered_lumped_ngrams <- unique(filtered_lumped_ngrams)

# merge here
merged <- merge(filtered_lumped_ngrams,results_pubmed)

results_year <- table(unlist(merged$word),merged$PY)

#cumulative
results_cumul <- results_year

for (word in unique(merged$word)){
  results_cumul[word,] = cumsum(results_cumul[word,])
}

write.csv(as.data.frame.matrix(results_cumul), paste("../csv/occurrences_cumulees_trigrams.csv"))

# short version for animation
# results_cumul <- results_cumul[order(results_cumul[,"2022"], decreasing = TRUE),]
# write.csv(results_cumul[1:100,], paste("../csv/cumulees_trigrams_short_for_animation.csv"))
