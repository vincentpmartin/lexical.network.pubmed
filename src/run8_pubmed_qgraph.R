#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : compute the adjacency matrix and weighted degrees 
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================

rm(list=ls())

input_file1 <- "../data/pubmed_tdm.Rdata"
input_file2 <- "../data/pubmed_tdm_group.Rdata"


library(tidyverse)
library(qgraph)
library(NbClust)
library(dplyr)
library(tidyr)
library(ggplot2)
library(reshape2)
library(Hmisc)
library(igraph)
# load the pubmed tidy object and the terms order by group after topic modeling
load(input_file1)
load(input_file2)

#computing correlations
cor_matrix_reduite <- rcorr(matrix_pubmed,type="spearman")$r
cor_matrix_reduite[ rcorr(matrix_pubmed)$P >= 0.05] = 0.0


adjency <- melt(cor_matrix_reduite)
adjency <- filter(adjency, value != 42) %>% filter(Var1 != Var2)

#ID corresponding to nodes
nodes$ID <- rownames(nodes)
adjency$Source = nodes$ID[match(adjency$Var1, nodes$Label)]
adjency$Target = nodes$ID[match(adjency$Var2, nodes$Label)]

adjency$weight <- abs(adjency$value)


# computing weighted degrees ---------------------------------------


weighted_degree <- data.frame(node = unique(adjency$Var1),
                              weighted_degree=sapply(unique(adjency$Var1), function(n) sum(adjency[adjency$Var1==n,"weight"])),
                              unweighted_degree=sapply(unique(adjency$Var1), function(n) sum(adjency[adjency$Var1==n,"weight"]>0.0)))

# Printing and saving weighted degrees
print(weighted_degree[order(weighted_degree$weighted_degree),])
write.csv(weighted_degree, "../csv/weighted_degree.csv")


# customizing some parameters for beautiful representation using Gephi 

threshold = unname(quantile(adjency$weight, c(.94))) 
#threshold = 0.05
adjency[adjency$weight<threshold,"weight"] = 0.0
adjency[adjency$weight>0.4,"weight"] = 0.4 # to enhance vizualisation

# writing adjency matrix
write.csv(adjency, "../graph_csv/adjency.csv")

