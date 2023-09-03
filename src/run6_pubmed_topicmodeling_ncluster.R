#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : graphe to choose the number of topics 
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================

rm(list=ls())

library(topicmodels)
library(tidytext)
library(dplyr)
library(ldatuning)


input_file <- "../data/pubmed_tdm.Rdata" 

# load the pubmed dataframe
load(input_file)


# determine the number of clusters
nb_cluster_curves <- ldatuning::FindTopicsNumber(
  dtm_pubmed,
  topics = seq(from = 2, to = 12, by = 1),
  metrics = c("CaoJuan2009",  "Deveaud2014", "Arun2010", "Griffiths2004"),
  control = list(seed = 2),
  verbose = TRUE
)

ldatuning::FindTopicsNumber_plot(nb_cluster_curves)


