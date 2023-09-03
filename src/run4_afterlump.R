#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : data formatting after lump and keepin only most frequent 
#                   terms
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================


library(tidytext)
library(stringr)
library(purrr)  

rm(list=ls())
input_file <- "../data/pubmed_tdm_afterlump.Rdata"
output_file <- "../data/pubmed_tdm.Rdata"
# load the pubmed dataframe
load(input_file)

# keeping only the nNode token that are the most frequent 
nNode = 75 #nombre de noeuds dans le graphe


temp <- dplyr::top_n(dplyr::count(filtered_lumped_ngrams, word,sort=TRUE), nNode, n)
token_reduced <- subset(filtered_lumped_ngrams, word %in% temp$word)

# count frequency of each word in each abstract
frequency_in_abstracts <- dplyr::count(token_reduced, PMID, word, sort=TRUE)

# convert to a dtm
dtm_pubmed <- cast_dtm(frequency_in_abstracts, PMID, word, n)

# count frequency of each word across the whole corpus
frequency_whole_corpus <- dplyr::count(token_reduced, word, sort=TRUE)


# save
save(nNode, abstracts, temp, token_reduced, frequency_in_abstracts, frequency_whole_corpus, dtm_pubmed, file = output_file)
