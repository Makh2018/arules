# arules --- Mining Association Rules and Frequent Itemsets with R

[![CRAN version](https://www.r-pkg.org/badges/version/arules)](https://cran.r-project.org/package=arules)
[![Rdoc](https://www.rdocumentation.org/badges/version/arules)](https://www.rdocumentation.org/packages/arules) 
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/arules)](https://cran.r-project.org/package=arules)
[![R build status](https://github.com/mhahsler/arules/workflows/R-CMD-check/badge.svg)](https://github.com/mhahsler/arules/actions)

The arules package for R provides the infrastructure for representing,
manipulating and analyzing transaction data and patterns
using [frequent itemsets and association rules](https://en.wikipedia.org/wiki/Association_rule_learning). Also provides a wide range of 
[interest measures](https://mhahsler.github.io/arules/docs/measures) and mining algorithms including a interfaces and the code of
Christian Borgelt's popular and efficient C implementations of the association mining algorithms [Apriori](https://borgelt.net/apriori.html) and [Eclat](https://borgelt.net/eclat.html).

### arules core packages: 

* [arules](https://cran.r-project.org/package=arules): arules base package with data structures, mining algorithms (APRIORI and ECLAT), interest measures. 
* [arulesViz](https://github.com/mhahsler/arulesViz): Visualization of association rules. 
* [arulesCBA](https://github.com/ianjjohnson/arulesCBA): Classification algorithms based on association rules (includes CBA).  
* [arulesSequences](https://cran.r-project.org/package=arulesSequences):
   Mining frequent sequences (cSPADE).

### Other related packages:

#### Additional mining algorithms 

* [arulesNBMiner](https://github.com/mhahsler/arulesNBMiner):
  Mining NB-frequent itemsets and NB-precise rules.
* [opusminer](https://cran.r-project.org/package=opusminer): OPUS Miner algorithm for filtered top-k association discovery.
* [RKEEL](https://cran.r-project.org/package=RKEEL): Interface to KEEL's association rule mining algorithm.
* [RSarules](https://cran.r-project.org/package=RSarules): Mining algorithm which randomly samples association rules with one pre-chosen item as the consequent from a transaction dataset.


#### In-database analytics

* [ibmdbR](https://cran.r-project.org/package=ibmdbR): IBM in-database analytics for R can calculate association rules from a database table.
* [rfml](https://cran.r-project.org/package=rfml): Mine frequent itemsets or association rules using a MarkLogic server. 

#### Interface

* [rattle](https://cran.r-project.org/package=rattle): Provides a graphical user interface for association rule mining.
* [pmml](https://cran.r-project.org/package=pmml): Generates PMML (predictive model markup language) for association rules.

#### Classification 

* [arc](https://cran.r-project.org/package=arc): Alternative CBA implementation. 
* [inTrees](https://cran.r-project.org/package=inTrees): Interpret Tree Ensembles provides functions for: extracting, measuring and pruning rules; selecting a compact rule set; summarizing rules into a learner.
* [rCBA](https://cran.r-project.org/package=rCBA): Alternative CBA implementation.
* [qCBA](https://cran.r-project.org/package=qCBA): Quantitative Classification by Association Rules.
* [sblr](https://cran.r-project.org/package=sbrl): Scalable Bayesian rule lists algorithm for classification.

#### Outlier Detection

* [fpmoutliers](https://cran.r-project.org/package=fpmoutliers): Frequent Pattern Mining Outliers.

#### Recommendation/Prediction

* [recommenerlab](https://github.com/mhahsler/recommenderlab): Supports creating predictions using association rules.


## Installation

__Stable CRAN version:__ install from within R with
```R
install.packages("arules")
```
__Current development version:__ install from GitHub (needs devtools and [Rtools for Windows] (https://cran.r-project.org/bin/windows/Rtools/)). 
```R 
devtools::install_github("mhahsler/arules")
``` 

## Usage

Load package and mine some association rules.
```R
library("arules")
data("Adult")

rules <- apriori(Adult, parameter = list(supp = 0.5, conf = 0.9, target = "rules"))
```

```
Parameter specification:
 confidence minval smax arem  aval originalSupport support minlen maxlen target   ext
        0.9    0.1    1 none FALSE            TRUE     0.5      1     10  rules FALSE

Algorithmic control:
 filter tree heap memopt load sort verbose
    0.1 TRUE TRUE  FALSE TRUE    2    TRUE

Absolute minimum support count: 24421 

apriori - find association rules with the apriori algorithm
version 4.21 (2004.05.09)        (c) 1996-2004   Christian Borgelt
set item appearances ...[0 item(s)] done [0.00s].
set transactions ...[115 item(s), 48842 transaction(s)] done [0.03s].
sorting and recoding items ... [9 item(s)] done [0.00s].
creating transaction tree ... done [0.03s].
checking subsets of size 1 2 3 4 done [0.00s].
writing ... [52 rule(s)] done [0.00s].
creating S4 object  ... done [0.01s].
```

Show basic statistics.
```R
summary(rules)
```

```
set of 52 rules

rule length distribution (lhs + rhs):sizes
 1  2  3  4 
 2 13 24 13 

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  1.000   2.000   3.000   2.923   3.250   4.000 

summary of quality measures:
    support         confidence          lift            count      
 Min.   :0.5084   Min.   :0.9031   Min.   :0.9844   Min.   :24832  
 1st Qu.:0.5415   1st Qu.:0.9155   1st Qu.:0.9937   1st Qu.:26447  
 Median :0.5974   Median :0.9229   Median :0.9997   Median :29178  
 Mean   :0.6436   Mean   :0.9308   Mean   :1.0036   Mean   :31433  
 3rd Qu.:0.7426   3rd Qu.:0.9494   3rd Qu.:1.0057   3rd Qu.:36269  
 Max.   :0.9533   Max.   :0.9583   Max.   :1.0586   Max.   :46560  

mining info:
  data ntransactions support confidence
 Adult         48842     0.5        0.9
```

Inspect rules with the highest lift.
```R
inspect(head(rules, n = 3, by = "lift"))
```

```
    lhs                               rhs                            support confidence coverage lift count
[1] {sex=Male,                                                                                             
     native-country=United-States} => {race=White}                      0.54       0.91     0.60  1.1 26450
[2] {sex=Male,                                                                                             
     capital-loss=None,                                                                                    
     native-country=United-States} => {race=White}                      0.51       0.90     0.57  1.1 24976
[3] {race=White}                   => {native-country=United-States}    0.79       0.92     0.86  1.0 38493
```

## Using arule and tidyverse

arules works seemlessly with [tidyverse](https://www.tidyverse.org/). For example, dplyr can be used for cleaning and preparing the transactions and then functions in arules can be used with `%>%`.

```R
library("tidyverse")
library("arules")
data("Adult")

rules <- Adult %>% apriori(parameter = list(supp = 0.5, conf = 0.9, target = "rules"))
rules %>% head(n = 3, by = "lift") %>% inspect
```

```
    lhs                               rhs                            support confidence coverage lift count
[1] {sex=Male,                                                                                             
     native-country=United-States} => {race=White}                      0.54       0.91     0.60  1.1 26450
[2] {sex=Male,                                                                                             
     capital-loss=None,                                                                                    
     native-country=United-States} => {race=White}                      0.51       0.90     0.57  1.1 24976
[3] {race=White}                   => {native-country=United-States}    0.79       0.92     0.86  1.0 38493
```

## Usage arules from Python

See [Getting started with R arules using Python.](https://mhahsler.github.io/arules/docs/python/arules_python.html)

## Support

Please report bugs [here on GitHub.](https://github.com/mhahsler/arules/issues)
Questions should be posted on [stackoverflow and tagged with arules](https://stackoverflow.com/questions/tagged/arules).


## References

* Michael Hahsler, Sudheer Chelluboina, Kurt Hornik, and Christian Buchta. [The arules R-package ecosystem: Analyzing interesting patterns from large transaction datasets.](https://jmlr.csail.mit.edu/papers/v12/hahsler11a.html) _Journal of Machine Learning Research,_ 12:1977-1981, 2011.
* Michael Hahsler, Bettina Gr&uuml;n and Kurt Hornik. [arules - A Computational Environment for Mining Association Rules and Frequent Item Sets.](https://dx.doi.org/10.18637/jss.v014.i15) _Journal of Statistical Software,_ 14(15), 2005.
* Hahsler, Michael. [A Probabilistic Comparison of Commonly Used Interest Measures for Association Rules](https://michael.hahsler.net/research/association_rules/measures.html), 2015, URL: https://michael.hahsler.net/research/association_rules/measures.html.
