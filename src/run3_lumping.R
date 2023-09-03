#!/usr/bin/env Rscript
# coding=utf-8
# ==============================================================================
# description     : lumping process after filtering
# date            : 05/07/2023
# version         : 1 (Vincent P. Martin)
# ==============================================================================


# cleaning environment variables
rm(list=ls())


library(tidytext)
library(stringr)
library(purrr) 


input_file <- "../data/pubmed_tdm_after_filtering.Rdata" # dataframes from step n°2
output_file <- "../data/pubmed_tdm_afterlump.Rdata"

# load the pubmed dataframe
load(input_file)

#defining the lumping function
#' Lump function
#'
#' @param target : token to find 
#' @param objective : label after lump
#' @param data : data in which to search the target
#' @param res : incremental agregation of lumped tokens
#' @param exact : bool, if the target should correspond exactly the ngram
#'
#' @return res with the new lumped token aggregated to it ; data without the lumped tokens

lump <- function(target, objective, data, res, exact=FALSE){
  print(paste("----- ", target, " -----"))
  nb_before = sum(res$word==objective)

  for (word in unique(data$word)){
    if (exact){ # exact target, usefull e.g. for "ess"
      if (word == target && unlist(word) != objective){
        temp = data[unlist(data$word)==word,]
        temp$word = objective
        res = rbind(res,temp)
        data = data[unlist(data$word)!=word,] 
      }
    }
    else{ # ngram containing the target
      if (str_detect(word,target) && unlist(word) != objective){
        temp = data[unlist(data$word)==word,]
        temp$word = objective
        res = rbind(res,temp)
        data = data[unlist(data$word)!=word,] 
      }
    }
  }
  print(sum(res$word==objective)-nb_before) # printing the number of token corresponding to the target
  return(list(res=res, data=data))
}


### aggregating the lumped token in res, and removing them from the search ngrams (to enhance speed)
res = abstract_words[0,]


# 4 words --------------------------------------------------------------------------------

# computing quadrigrams the dirty way
texts <- data.frame(PMID = numeric(0), text=character(0), stringsAsFactors=F)
# we convert abstracts back to texts
i = 0
for (Id in unique(abstract_words$PMID)) {
  if (i%%1000  == 0){ # printing evolution every 1k article
    print(paste(i, "/", length(unique(abstract_words$PMID))))
  }
  i = i+1
  word_id = abstract_words$word[abstract_words$PMID == Id]
  texts[nrow(texts)+1,] <- c(Id, paste(word_id, collapse = " "))
}

# removing NA
texts <-na.omit(texts)

# computing quadrigrams from texts
quadrigrams <- unnest_tokens(tbl=texts, output="word", input="text", token="ngrams", n = 4)
quadrigrams <-na.omit(quadrigrams)


### and let's go !

output <- lump("pittsburgh sleep quality index", "PSQI",quadrigrams, res, exact = TRUE)
quadrigrams = output$data
res = output$res

output <- lump("multiple sleep latency test", "MSLT",quadrigrams, res)
quadrigrams = output$data
res = output$res

output <- lump("functional outcomes sleep questionnaire", "FOSQ",quadrigrams,res, exact = TRUE)
quadrigrams = output$data
res = output$res

output <- lump("functional outcome sleep questionnaire", "FOSQ",quadrigrams,res, exact = TRUE)
quadrigrams = output$data
res = output$res

output <- lump("hospital anxiety depression scale", "HAD",quadrigrams, res)
quadrigrams = output$data
res = output$res

output <- lump("unified parkinson's disease rating", "UPDRS",quadrigrams, res)
quadrigrams = output$data
res = output$res

output <- lump("unified parkinson disease rating", "UPDRS",quadrigrams, res)
quadrigrams = output$data
res = output$res

output <- lump("continuous positive airway pressure", "CPAP",quadrigrams, res)
quadrigrams = output$data
res = output$res

output <- lump("international classification sleep disorders", "Classification of sleep disorders",trigrams, res)
trigrams = output$data
res = output$res

# 3 words --------------------------------------------------------------------------------------
#computing trigrams the dirty way
texts <- data.frame(PMID = numeric(0), text=character(0), stringsAsFactors=F)

# we convert the quadrigrams back to texts
i = 0
for (Id in unique(quadrigrams$PMID)) {
  if (i%%1000  == 0){# checking progression every 1k article
    print(paste(i, "/", length(unique(quadrigrams$PMID))))
  }
  i = i+1
  quadrigram_id = quadrigrams$word[quadrigrams$PMID == Id]
  # taking one over four element
  texts[nrow(texts)+1,] <- c(Id, paste(quadrigram_id[seq(1,length(quadrigram_id),4)], collapse = " "))
}


# removing NA
texts <-na.omit(texts)

# computing trigrams
trigrams <- unnest_tokens(tbl=texts, output="word", input="text", token="ngrams", n = 3)
trigrams <-na.omit(trigrams)


### and let's go !

#neurophy

output <- lump("event related potential", "EPR",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("magnetic resonance imaging", "MRI",trigrams, res)
trigrams = output$data
res = output$res

#clinical etc.
output <- lump("attention deficit hyperactivity", "ADHD",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("respiratory disturbance index", "RDI",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("oxygen desaturation index", "ODI",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("insomnia severity index", "ISI",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("fatigue severity scale", "FSS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("sleep disordered breathing", "SDB",trigrams, res)
trigrams = output$data
res = output$res


output <- lump("excessive daytime sleepiness", "EDS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("psychomotor vigilance test", "PVT",trigrams, res)
trigrams = output$data
res = output$res
output <- lump("psychomotor vigilance task", "PVT",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("maintenance wakefulness test", "MWT",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("day time sleepiness", "EDS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("body mass index", "BMI",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("stanford sleepiness scale", "SSS",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("epworth sleepiness scale", "ESS",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("epworth sleepiness score", "ESS",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("karolinska sleepiness scale", "KSS",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("form health survey", "SF36",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("short form 36", "SF36",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("short-form health survey", "SF36",trigrams,res)
trigrams = output$data
res = output$res

output <- lump("beck depression inventory", "BDI",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("total sleep time", "TST",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("continuous positive airway", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("continuous airway pressure", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("continuous positive pressure", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("airway pressure treatment", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("positive airway pressure", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("airway pressure pap", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("airway pressure therapy", "CPAP",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("apnea hypoapnea index", "AHI",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("visual analogue scale", "VAS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("visual analog scale", "VAS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("multiple sleep latency", "MSLT",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("sleep latency test", "MSLT",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("multiple latency test", "MSLT",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("multiple sleep test", "MSLT",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("obstructive hypopnea syndrome", "OSAS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("apnea hypopnea syndrome", "OSAS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("periodic limb movement", "RLS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("periodic leg movement", "RLS",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("international classification sleep", "Classification of sleep disorders",trigrams, res)
trigrams = output$data
res = output$res

output <- lump("classification sleep disorders", "Classification of sleep disorders",trigrams, res)
trigrams = output$data
res = output$res

# 2 words ----------------------------------------------------

#computing bigrams the dirty way
text_after_trigrams <- data.frame(PMID = numeric(0), text=character(0), stringsAsFactors=F)

# on reconvertit tout en textes
i = 0
for (Id in unique(trigrams$PMID)) {
  if (i%%1000  == 0){ # checking progression every 1k article
    print(paste(i, "/", length(unique(trigrams$PMID))))
  }
  i = i+1
  trigrams_id = trigrams$word[trigrams$PMID == Id]
  # taking one over three element
  text_after_trigrams[nrow(text_after_trigrams)+1,] <- c(Id, paste(trigrams_id[seq(1,length(trigrams_id),3)], collapse = " "))
}

# removing NA
text_after_trigrams <-na.omit(text_after_trigrams)

# computing bigrams
bigrams <- unnest_tokens(tbl=text_after_trigrams, output="word", input="text", token="ngrams", n = 2)
bigrams <-na.omit(bigrams)


### et c'est parti !

#neurophy
output <- lump("electro encephalograph", "EEG",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("magneto encephalograph", "MEG",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("evoked potential", "ERP",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("event potential", "EPR",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("neuro modulation", "Neuromodulation",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("neuro stimulation", "Neurostimulation",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("functional imaging", "Neuroimaging",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("signal processing", "Signal processing",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("nervous system", "Nervous system",bigrams,res)
bigrams = output$data
res = output$res



#clinical etc.

output <- lump("sleep behavior", "Sleep Behavior",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("daytime sleepiness", "EDS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("excessive sleepiness", "EDS",bigrams, res)
bigrams = output$data
res = output$res

#sleep duration
output <- lump("sleep duration", "Sleep Duration",bigrams, res)
bigrams = output$data
res = output$res

#sleep quality
output <- lump("sleep quality", "Sleep Quality",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("quality sleep", "Sleep Quality",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("attention deficit", "ADHD",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("epworth score", "ESS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("epworth scale", "ESS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("restless leg", "RLS",bigrams, res)
bigrams = output$data
res = output$res


output <- lump("hypopnea index", "AHI",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("hypopnoea index", "AHI",bigrams, res)
bigrams = output$data
res = output$res


output <- lump("apnea index", "AHI",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("sleep apn", "OSAS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("obstructive apn", "OSAS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("obstructive sleep", "OSAS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("hypopnea syndrome", "OSAS",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("sf 36", "SF36",bigrams, res)
tidy.bigrams = output$data
res = output$res

output <- lump("sleep time", "TST",bigrams, res)
tidy.bigrams = output$data
res = output$res

#ADHD
output <- lump("ad hd", "ADHD",bigrams,res, exact = TRUE)
bigrams = output$data
res = output$res

#CPAP
output <- lump("positive pressure", "CPAP",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("airway pressure", "CPAP",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("health quality", "QoL",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("quality life", "QoL",bigrams,res)
bigrams = output$data
res = output$res

output <- lump("sleep onset", "TST",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("rapid eye", "REM",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("rapid movement", "REM",bigrams, res)
bigrams = output$data
res = output$res

output <- lump("eye movement", "REM",bigrams, res)
bigrams = output$data
res = output$res


### One word --------------------------------------------------------------------------

# recomputing words the dirty way

text_after_bigrams <- data.frame(PMID = numeric(0), text=character(0), stringsAsFactors=F)

# converting back to texts
i = 0
for (Id in unique(bigrams$PMID)) {
  if (i%%1000  == 0){ #checking progression every 1k article
    print(paste(i, "/", length(unique(bigrams$PMID))))
  }
  i = i+1
  bigrams_id = bigrams$word[bigrams$PMID == Id]
  # taking one over two element
  text_after_bigrams[nrow(text_after_bigrams)+1,] <- c(Id, paste(bigrams_id[seq(1,length(bigrams_id),2)], collapse = " "))
}

# removing NA
text_after_bigrams <-na.omit(text_after_bigrams)

# computing words
words <- unnest_tokens(tbl=text_after_bigrams, output="word", input="text", token="words")
words <-na.omit(words)


### Let's go !

#neurophysio

output <- lump("neurophysio", "Neurophysiology",words, res)
words = output$data
res = output$res

#ERP
output <- lump("erp", "ERP",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("p300", "ERP",words,res)
words = output$data
res = output$res

output <- lump("neuropsy", "Neuropsy",words,res)
words = output$data
res = output$res

output <- lump("electroencephalograph", "EEG",words,res)
words = output$data
res = output$res

output <- lump("eeg", "EEG",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("meg", "MEG",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("mri", "MRI",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("fmri", "MRI",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("magnetoencephalograph", "MEG",words,res)
words = output$data
res = output$res


output <- lump("myograph", "Myography",words,res)
words = output$data
res = output$res

output <- lump("electromyograph", "Myography",words,res)
words = output$data
res = output$res

output <- lump("electroneuromygraph", "Myography",words,res)
words = output$data
res = output$res

output <- lump("neuromygraph", "Myography",words,res)
words = output$data
res = output$res

output <- lump("neuromodulation", "Neuromodulation",words,res)
words = output$data
res = output$res

output <- lump("neurostimulation", "Neurostimulation",words,res)
words = output$data
res = output$res

output <- lump("neuroimaging", "Neuroimaging",words,res)
words = output$data
res = output$res

output <- lump("psychophysio", "Psychophysiology",words,res)
words = output$data
res = output$res


### clinical etc. 

#ESS
output <- lump("ess", "ESS",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("epworth", "ESS",words,res, exact = TRUE)
words = output$data
res = output$res


# SSS
output <- lump("sss", "SSS",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("stanford", "SSS",words,res, exact = TRUE)
words = output$data
res = output$res

# KSS
output <- lump("kss", "KSS",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("karolinska", "KSS",words,res, exact = TRUE)
words = output$data
res = output$res

# PVT
output <- lump("pvt", "PVT",words,res)
words = output$data
res = output$res

# MWT
output <- lump("mwt", "MWT",words,res)
words = output$data
res = output$res

# MSLT
output <- lump("msl", "MSLT",words,res)
words = output$data
res = output$res

# parasomnia
output <- lump("parasomn", "parasomnia",words,res)
words = output$data
res = output$res

# OSA
output <- lump("osa", "OSAS",words,res)
words = output$data
res = output$res

# EDS
output <- lump("eds", "EDS",words,res, exact = TRUE)
words = output$data
res = output$res

# CPAP
output <- lump("cpap", "CPAP",words,res)
words = output$data
res = output$res

#RLS
output <- lump("rls", "RLS",words,res)
words = output$data
res = output$res

#PSG

output <- lump("psg", "PSG",words,res)
words = output$data
res = output$res

output <- lump("polysomnograph", "PSG",words,res)
words = output$data
res = output$res

#BMI
output <- lump("bmi", "BMI",words,res)
words = output$data
res = output$res

#AHI
output <- lump("ahi", "AHI",words,res, exact = TRUE)
words = output$data
res = output$res

#REM
output <- lump("rem", "REM",words,res, exact = TRUE)
words = output$data
res = output$res

#sleep disordered breathing SDB
output <- lump("sdb", "SDB",words,res)
words = output$data
res = output$res

#Beck Depression Inventory
output <- lump("bdi", "BDI",words,res, exact = TRUE)
words = output$data
res = output$res


#Parkinson

output <- lump("pd", "PD",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("parkinson", "PD",words,res)
words = output$data
res = output$res

#FSS
output <- lump("fss", "FSS",words,res)
words = output$data
res = output$res

#ADHD
output <- lump("adhd", "ADHD",words,res)
words = output$data
res = output$res

#TST
output <- lump("tst", "TST",words,res)
words = output$data
res = output$res

#PSQI
output <- lump("psqi", "PSQI",words,res)
words = output$data
res = output$res

output <- lump("pittsburgh", "PSQI",words,res)
words = output$data
res = output$res

#FOSQ
output <- lump("fosq", "FOSQ",words,res)
words = output$data
res = output$res

output <- lump("isi", "ISI",words,res, exact = TRUE)
words = output$data
res = output$res

#sf36
output <- lump("sf36", "SF36",words,res, exact = TRUE)
words = output$data
res = output$res

#rdi
output <- lump("rdi", "RDI",words,res, exact = TRUE)
words = output$data
res = output$res

#odi
output <- lump("odi", "ODI",words,res, exact = TRUE)
words = output$data
res = output$res

#had
output <- lump("had", "HAD",words,res, exact = TRUE)
words = output$data
res = output$res

output <- lump("narcolep", "Narcolepsy",words,res)
words = output$data
res = output$res

output <- lump("hypersomnia", "Hypersomnia",words,res)
words = output$data
res = output$res

output <- lump("insomnia", "Insomnia",words,res)
words = output$data
res = output$res

output <- lump("arous", "Arousal",words,res)
words = output$data
res = output$res

output <- lump("qol", "QoL",words,res)
words = output$data
res = output$res

output <- lump("children", "children",words,res)
words = output$data
res = output$res


# Recomputing trigrams with unlumped words -------------------------------------

#computing trigrams the dirty way
text_after_bigrams <- data.frame(PMID = numeric(0), text=character(0), stringsAsFactors=F)


# converting back to text
i = 1
for (Id in unique(words$PMID)) {
  if (i%%1000  == 0){
    print(paste(i, "/", length(unique(words$PMID))))
   }
  i = i+1
  words_id = words$word[words$PMID == Id]
  text_after_bigrams[nrow(text_after_bigrams)+1,] <- c(Id, paste(words_id, collapse = " "))
}


# removing NA
text_after_bigrams <-na.omit(text_after_bigrams)

# computing trigrams
trigrams_end <- unnest_tokens(tbl=text_after_bigrams, output="word", input="text", token="ngrams", n = 3)
trigrams_end <-na.omit(trigrams_end)

# agregating lumped tokens and trigrams
filtered_lumped_ngrams <- rbind(res, trigrams_end)

# NA omit
filtered_lumped_ngrams <-na.omit(filtered_lumped_ngrams)


# save
save(filtered_lumped_ngrams, res, abstracts, abstract_words, words, bigrams, trigrams, file = output_file)

