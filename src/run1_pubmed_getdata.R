#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : extraction of titles and abstracts from pubmed
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================


library(pubmedR)
library(bibliometrix)

output_file <- "../data/pubmed.Rdata" # name of the output file


# pubmed extraction ------------------------------------------------------------
# since there are too many articles and pmApiRequest is limited to 10k articles,
# we split the temporal span into three temporal periods

search_query1 <- ("sleepiness OR sleepy AND 1600/01/01:2004/12/31[dp]")
res1 <- pmQueryTotalCount(search_query1)
search_output1 <- pmApiRequest(query = search_query1, res1$total_count, api_key = NULL)

search_query2 <- ("sleepiness OR sleepy AND 2005/01/01:2014/12/31[dp]")
res2 <- pmQueryTotalCount(search_query2)
search_output2 <- pmApiRequest(query = search_query2, res2$total_count, api_key = NULL)


search_query3 <- ("sleepiness OR sleepy AND 2015/01/01:2022/12/31[dp]")
res3 <- pmQueryTotalCount(search_query3)
search_output3 <- pmApiRequest(query = search_query3, res3$total_count, api_key = NULL)

# convert to a dataframe
results_pubmed1 <- convert2df(search_output1, dbsource = "pubmed", format="api")
results_pubmed2 <- convert2df(search_output2, dbsource = "pubmed", format="api")
results_pubmed3 <- convert2df(search_output3, dbsource = "pubmed", format="api")

# then we merge the three different dataframes
results_pubmed <- rbind(results_pubmed1, results_pubmed2, results_pubmed3)

# uncomment for an in-terminal biblio analysis
# results <- biblioAnalysis(results_pubmed)
# summary(results)

save(results_pubmed, file = output_file)

