#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : modelling topics 
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================

rm(list=ls())

library(topicmodels)
library(tidytext)
library(dplyr)
library(ldatuning)


input_file <- "../data/pubmed_tdm.Rdata" 
output_file <- "../data/pubmed_tdm_group.Rdata"

# load the pubmed dataframe
load(input_file)


# set a seed so that the output of the model is predictable
lda_pubmed <- LDA(dtm_pubmed, k = 4, control = list(seed = 2), verbose = TRUE)

# compute word-topic probabilities
topics_prob_pubmed <- tidy(lda_pubmed, matrix = "beta")

# select for each term the topic with the highest probability of generating it
topic_max <- topics_prob_pubmed %>%
  group_by(term) %>%
  filter(beta == max(beta)) %>%
  ungroup()

# merging topicmax and tidy.pubmed for the graph
nodes <- merge(topic_max,temp, by.x = "term", by.y = "word", sort = FALSE)
nodes <- nodes[,-3]
names(nodes)[1] <- "Label" 
names(nodes)[2] <- "Groupe" 
nodes <- dplyr::top_n(nodes, nNode, n)

#writting in a file
write.csv(nodes, "../graph_csv/nodes.csv")

# create a cor matrix of the dtm
matrix_pubmed <- as.matrix(dtm_pubmed)

# save
save(matrix_pubmed, nodes, nNode, file = output_file)
