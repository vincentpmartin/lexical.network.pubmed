#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : converting into abstract_words ; then filtering stop abstract_words and 
#                   methodology-related abstract_words
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================

# cleaning environment variables
rm(list=ls())


library(tidytext)
library(stringr)
library(purrr)  


input_file <- "../data/pubmed.Rdata" # datagrame from step n°1
output_file <- "../data/pubmed_tdm_after_filtering.Rdata" # output

# load the pubmed dataframe
load(input_file)


# select abstracts and PMID
abstracts <- results_pubmed[, c("PMID","AB")]


# we first convert abstract into abstract_words 
abstract_words <- unnest_tokens(tbl=abstracts, output="word", input="AB", token="words")
class(abstract_words) <- c("bibliometrixDB", "data.frame")

# loading usual stop abstract_words and defining custom ones
data("stop_words")
stop_words2 = rbind("matched","underwent","mg day", "outcome", "meta", "total", "cross", "control", "controlled","blind","confidence", "regression","double",  "blind","placebo","odds","related", "ci", "lower", "study", "retest", "baseline", "based", "effect", "result", "significant", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "covid", "2020")
total_stop_abstract_words = append(stop_words$word,stop_words2)

total_stop_abstract_words = data.frame("word" = total_stop_abstract_words)

#getting rid of all the stop_abstract_words
abstract_words <- dplyr::anti_join(abstract_words,total_stop_abstract_words)
abstract_words <-na.omit(abstract_words)


save(abstracts, abstract_words, total_stop_abstract_words, file = output_file)

