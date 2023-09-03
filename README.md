# Lexical network and historical analysis of PubMed-related searches

[![CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/)

---

This repository fosters the replicability of the following paper : 

* Vincent P. Martin, Christophe Gauld, Jacques Taillard, Laure PeterDerex, Régis Lopez and Jean-Arthur Micoulaud-Franchi*, *To What Extent is Sleepiness Neurophysiological?*, submitted to *Neurophysiologie Clinique / Clinical Neurophysiology*


This code has been inspired by the previous one of 
Christophe Gauld,  Julien Maquet,  Jean-Arthur Micoulaud-Franchi and  Guillaume Dumas, *Popular and Scientific Discourse on Autism: Representational Cross-Cultural Analysis of Epistemic Communities to Inform Policy and Practice*, J Med Internet Res 2022;24(6):e32912, doi: 10.2196/32912 

Their code repository is the following: https://github.com/ChristopheGauld/TwiMed
  
## Instruction for use

### 1) Run the scripts in numerical orders :
1) [run1_pubmed_getdata.R](./src/run1_pubmed_getdata.R) for fetching all the article corresponding to a given resquest in PubMed.  &#9888; If the request generate more than 10k entries, you should slice them (e.g. for different temporal periods) an remerge them.
2) [run2filtering.R](./src/run2filtering.R) filters the abstract converted into words, in order to filter out the most common stop wods and some custome methodological keywords.
3) [run3_lumping.R](./src/run3_lumping.R) performs lumping on different n-grams level using automated rules. See the article below for more details.
4)  [run4_afterlump.R](./src/run4_afterlump.R) reformats the data into a usable form.
5) [run5_temporal_analysis_preparation.R](./src/run5_temporal_analysis_preparation.R) prepares data for the historical analysis of the script [analyse_bilbiometrie_trigrams.ipynb](./src/analyse_bibliometrie_trigrams.ipynb)
6) [run6_pubmed_topicmodeling_ncluster.R](./src/run6_pubmed_topicmodeling_ncluster.R)  is used to determine the number of clusters in the topic modelling analysis.
7) [run7_pubmed_topicmodeling.R](./src/run7_pubmed_topicmodeling.R) performs the topic modelling, and produce the [./graph_csv/nodes.csv](./graph_csv/nodes.csv) file necessary for the plot of the graph.
8) [run8_pubmed_qgraph.R](./src/run8_pubmed_qgraph.R) is used for computing the edges of the graph (partial correlations), and generate the [./graph_csv/adjency.csv](./graph_csv/adjency.csv) file necessary for the plot of the graph.

### 2) Historical analysis
To perform the historical analysis, open and run the [analyse_bibliometrie_trigrams.ipynb](./src/analyse_bibliometrie_trigrams.ipynb) notebook, replacing the studied keywords by the keywords of interest.

### 3) Plotting the graph
To plot the graph : 

1) open the generated [./graph_csv/nodes.csv](./graph_csv/nodes.csv) with a data editor (e.g. Excel) and rename the first column "ID"
2) open the generated [./graph_csv/adjency.csv](./graph_csv/adjency.csv) with a data editor (e.g. Excel) and delete the first column
3) Using [Gephi](https://gephi.org/), import both file resp. for the nodes and the links, remembering when importing to add the data to the existing workspace ("add to existing workspace").   


# Contact
For any question, please contact either Vincent P. Martin [vpmartin at proton.me] or Jean-Arthur Micoulaud-Franchi [jarthur.micoulaud at gmail.com]
