\name{interestMeasure}
\alias{interestMeasure}
\alias{interestMeasure,rules-method}
\alias{interestMeasure,itemsets-method}
\title{Calculate Additional Interest Measures}
\description{
Provides the generic function \code{interestMeasure} and the needed S4 method 
to calculate various additional interest measures for existing sets of
itemsets or rules. A searchable list of definitions, equations and references for all available interest measures can be found here: 
\url{https://mhahsler.github.io/arules/docs/measures}
}
\usage{
interestMeasure(x, measure, transactions = NULL, reuse = TRUE, ...)
}
\arguments{
  \item{x}{ a set of itemsets or rules. }
  \item{measure}{ name or vector of names of the desired interest measures 
      (see details for available measures). If measure is missing then all 
      available measures are calculated.} 
  \item{transactions}{ the transaction data set used to mine 
    the associations or a set of different transactions to calculate
    interest measures from (Note: you need to set \code{reuse=FALSE} in the 
    later case). }
  \item{reuse}{ logical indicating if information in quality slot should
      be reuse for calculating the measures. This speeds up the process
      significantly since only very little (or no) transaction counting 
      is necessary if support, confidence and lift are already available.
      Use \code{reuse=FALSE} to force counting (might be very slow but
      is necessary if you use a different set of transactions than was used 
      for mining).}
  \item{\dots}{ further arguments for the measure calculation. Many measures are based on contingency table counts
    and zero counts can produce NaN values (division by zero). This issue can be resolved by using the 
    additional parameter \code{smoothCounts} which performs additive smoothing by adds a "pseudo count" of
    \code{smoothCounts} to each count in the contingency table. Use \code{smoothCounts = 1} or larger values for 
    Laplace smoothing. Use \code{smoothCounts = .5} for Haldane-Anscombe correction often used for chi-squared, 
    phi correlation and related measures. }
}
\details{
\bold{The following measures are implemented for itemsets \eqn{X}:}  
\describe{
\item{"allConfidence"}{
 
  Is defined on itemsets as the
  minimum confidence of all possible rule generated from the itemset. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#all-confidence}
  
  Range: \eqn{[0, 1]}}

\item{"crossSupportRatio", cross-support ratio}{ 
  
  Defined on itemsets as the ratio of the support of the least frequent item 
  to the support of the most frequent item.
  Cross-support patterns have 
  a ratio smaller than a set threshold. Normally many found patterns are 
  cross-support patterns which contain frequent as well as rare items. Such 
  patterns often tend to be spurious. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#cross-support-ratio}

  Range: \eqn{[0, 1]}}

\item{"lift"}{
  
  Lift is typically only defined for rules. In a similar way, we use the
  probability (support) of the itemset over the product of the probabilities 
  of all items in the itemset, i.e., 
  \eqn{\frac{supp(X)}{\prod_{x \in X} supp(X)}}{supp(X)/(supp(x_1) supp(x_2) ... supp(x_n))}. 
  
  Range: \eqn{[0, \infty]}{[0, Inf]} (1 indicated independence)}

\item{"support", supp}{
  
  Support is an estimate of \eqn{P(X)}, a measure of generality of the itemset. It is estimated by 
  the number of transactions that contain the itemset over the total number of transactions in the data set.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#support}

  Range: \eqn{[0, 1]}}

\item{"count"}{
  
  Absolute support count of the itemset, i.e., the number of transactions that contain the itemset. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#support}
  
  Range: \eqn{[0, \infty]}}
}


\bold{The following measures are implemented for rules of the form \eqn{X \Rightarrow Y}{X => Y}:}

\describe{

\item{"addedValue", added Value, AV, Pavillon index, centered confidence}{ 
  
  Defined as the rule confidence minus the rule's support. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#added-value}

  Range: \eqn{[-.5, 1]}}

\item{"boost", confidence boost}{ 
  
  Confidence boost is the ratio of the confidence of a rule to the confidence of any more general rule (i.e., a rule with the same consequent but one or more items removed in the LHS). 
  Values larger than 1 mean the new rule boosts the confidence compared to the best, more general rule. The measure is related to the improvement measure.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#confidence-boost}

  Range: \eqn{[0, \infty]}{[0, Inf]}}


\item{"chiSquared", \eqn{\chi^2}{X^2} statistic}{ 

  The chi-squared statistic 
  to test for independence between the lhs and rhs of the rule.
  The critical value of the chi-squared distribution with \eqn{1} degree of 
  freedom (2x2 contingency table) at \eqn{\alpha=0.05}{alpha=0.05} 
  is \eqn{3.84}; higher chi-squared
  values indicate that the lhs and the rhs are not independent.  
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#chi-squared}
  
  %Note that if
  %any cell in the contingency table has an expected value below \eqn{5}, the
  %chi-square value is set to \code{NA} 
  %since the approximation used in the chi-square test breaks down.
  Note that the contingency table is likely to have cells with
  low expected values and that thus
  Fisher's Exact Test might be more appropriate 
  (see below).
  
  Called with \code{significance = TRUE}, the p-value of the test for 
  independence is returned instead of the chi-squared statistic.  
  For p-values, substitution effects (the ocurrence of one item makes the ocurrance of another item less likely) can be tested using 
  the parameter \code{complements = FALSE}.
  Correction for multiple comparisons can be done using \code{\link{p.adjust}}.
  
  Range: \eqn{[0, \infty]}{[0, Inf]} or p-value scale}

\item{"certainty", certainty factor, CF, Loevinger}{
  The certainty factor is a measure of variation of the probability that 
  Y is in a transaction when only considering transactions with X. An increasing CF   
  means a decrease of the probability that Y is not in a transaction that X 
  is in. Negative CFs have a similar interpretation.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#certainty-factor}

  Range: \eqn{[-1, 1]} (0 indicates independence)
  }

\item{"collectiveStrength", Collective strength, S}{ 

  Collective strength gives 0 for perfectly negative correlated items, infinity for perfectly positive correlated    items, and 1 if the items co-occur as expected under independence.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#collective-strength}
  
  Range: \eqn{[0, \infty]}{[0, Inf]}}

\item{"confidence", Strength, conf}{ 
   Confidence is a measure of rule validity. Rule confidence is an estimate of \eqn{P(Y|X)}.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#confidence}
  
  Range: \eqn{[0, 1]}}

\item{"conviction"}{ 
  
  Conviction was developed as an alternative to lift that also incorporates the direction of the rule. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#conviction}
  
  Range: \eqn{[0, \infty]}{[0, Inf]} (\eqn{1} indicates unrelated items)}

\item{"cosine"}{
  
  A measure if correlation between the items in X and Y.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#cosine}
  
  Range: \eqn{[0, 1]}(\eqn{.5} indicates no correlation)}

\item{"count"}{
  
  Absolute support count of the rule, i.e., the number of transactions that contain all items in the rule. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#support}
  
  Range: \eqn{[0, \infty]}}
  
\item{"coverage", cover, LHS-support}{ 
    
    It measures the probability that a rule applies to a randomly selected transaction. It is estimated by the proportion of transactions that contain the antecedent (LHS) of the rule. Therefore, coverage is sometimes called antecedent support or LHS support.
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#coverage}
    
    Range: \eqn{[0, 1]}}


\item{"confirmedConfidence", descriptive confirmed confidence}{

    How much higher is the confidence of a rule compared to the confidence of the rule \eqn{X \Rightarrow \overline{Y}}{X -> !Y}. 
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#descriptive-confirmed-confidence}
    
    Range: \eqn{[-1, 1]}}

\item{"casualConfidence", casual confidence}{
    Confidence reinforced by the confidence of the rule \eqn{\overline{X} \Rightarrow \overline{Y}}{!X -> !Y}.
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#casual-confidence}
    
    Range: \eqn{[0, 1]}}

\item{"casualSupport", casual support}{
    Support reinforced by the support of the rule \eqn{\overline{X} \Rightarrow \overline{Y}}{!X -> !Y}.
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#casual-support}
    Range: \eqn{[-1, 1]}}

\item{"counterexample", example and counter-example rate}{

    Rate of the examples minus the rate of counter examples (i.e., \eqn{X \Rightarrow \overline{Y}}{X -> !Y}). 
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#example-and-counter-example-rate}
    
    Range: \eqn{[0, 1]}}

\item{"doc", difference of confidence}{
  Defined as the difference in confidence of the rule and the rule \eqn{\overline{X} \Rightarrow Y}{!X -> Y}
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#difference-of-confidence}
    Range: \eqn{[-1, 1]}}

\item{"fishersExactTest", Fisher's exact test}{
  p-value of Fisher's exact test used in the analysis of contingency tables 
  where sample sizes are small.
  By default complementary effects are mined, substitutes can be found
  by using the parameter \code{complements = FALSE}. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#fishers-exact-test}
  
  Note that it is equal to hyper-confidence with \code{significance=TRUE}.
  Correction for multiple comparisons can be done using \code{\link{p.adjust}}.
  
  Range: \eqn{[0, 1]} (p-value scale)}

\item{"gini", Gini index}{ 
  Measures quadratic entropy of a rule.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#gini-index}
  
  Range: \eqn{[0, 1]} (0 means the rule provides no information for the data set)}

\item{"hyperConfidence"}{
  Confidence level that the observed co-occurrence count of the LHS and RHS is too high 
  given the expected count using the hypergeometric model.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#hyper-confidence}
  
  Hyper-confidence reports the confidence level by default and the 
  significance level if \code{significance=TRUE} is used.
  
  By default complementary effects are mined, substitutes (too low co-occurrence counts) can be found
  by using the parameter \code{complements = FALSE}. 
  
  
  Range: \eqn{[0, 1]}}
  

\item{"hyperLift"}{ 
  Adaptation of the lift measure which evaluates the deviation from independence
  using a quantile of the hypergeometric distribution defined by the counts of the LHS and RHS. HyperLift can be used to calculate confidence intervals for the lift measure. 
  
  The used quantile can be given
  as parameter \code{level} (default: \code{level = 0.99}).

  See details: \url{https://mhahsler.github.io/arules/docs/measures#hyper-lift}

  Range: \eqn{[0, \infty]}{[0, Inf]} (1 indicates independence)}
  
\item{"imbalance", imbalance ratio, IR}{
  IR measures the degree of imbalance between the two events 
  that the lhs and the rhs are contained in a transaction.
  The ratio is close to 0 if the conditional probabilities are similar (i.e., 
  very balanced) and
  close to 1 if they are very different. 
  See also: \url{https://mhahsler.github.io/arules/docs/measures#imbalance-ratio}
  
  Range: \eqn{[0, 1]} (0 indicates a balanced rule)}

\item{"implicationIndex", implication index}{
  
  A variation of the Lerman similarity.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#implication-index}

  Range: \eqn{[0, 1]} (0 means independence)}

\item{"importance"}{
  Log likelihood of the right-hand side of the rule, 
  given the left-hand side of the rule using Laplace corrected confidence.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#importance}
  
  Range: \eqn{[-Inf, Inf]}}

\item{"improvement"}{
  The  improvement of a rule is 
  the minimum difference between its confidence and the confidence of any
  more general rule (i.e., a rule with the same consequent but one or 
  more items removed in the LHS). 
  
  Special case: We define improvement for a rules with an empty LHS 
  as its confidence.
  
  The idea of improvement can be generalized to other measures than confidence. Other measures like
  lift can be specified with the extra parameter \code{improvementMeasure}. 
  
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#improvement}
  
  Range: \eqn{[0, 1]}}

\item{"jaccard", Jaccard coefficient, sometimes also called Coherence}{
  Null-invariant measure of dependence defined as the Jaccard similarity between the two sets of transactions
  that contain the items in X and Y, respectively.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#jaccard-coefficient}

  Range: \eqn{[0, 1]}}

\item{"jMeasure", J-measure, J}{ 
  A scaled measures of cross entropy to measure the information content of a rule.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#j-measure}

  Range: \eqn{[0, 1]} (0 indicates X does not provide information for Y)}

\item{"kappa" Cohen's Kappa (Tan and Kumar, 2000)}{
  Cohen's Kappa of the rule (seen as a classifier) given as the rule's observed rule accuracy (i.e., confidence)      corrected by the expected accuracy (of a random classifier).
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#kappa}
  
  Range: \eqn{[-1,1]} (0 means the rule is not better than a random classifier)}


\item{"klosgen"}{
  
  Defined as \eqn{\sqrt{supp(X \cup Y)} conf(X \Rightarrow Y) - supp(Y)}{sqrt(supp(X & Y)) conf(X -> Y) - supp(Y)}
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#klosgen}

  Range: \eqn{[-1, 1]} (0 for independence)}

\item{"kulczynski", kulc}{

  Calculate the null-invariant Kulczynski measure with a preference for 
  skewed patterns. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#kulczynski}
  
  Range: \eqn{[0, 1]}}  

\item{"lambda", Goodman-Kruskal's \eqn{\lambda}{lambda}, predictive association}{
  
  Goodman and Kruskal's lambda to assess the association between the LHS and RHS of the rule.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#lambda}
  
  Range: \eqn{[0, 1]}}

\item{"laplace", Laplace corrected confidence/accuracy, L}{
  Estimates confidence by increasing each count by 1. Parameter \code{k} can be used
  to specify the number of classes (default is 2).
  Prevents counts of 0 and L decreases with lower support. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#laplace-corrected-confidence}
  
  Range: \eqn{[0, 1]}}

\item{"leastContradiction", least contradiction}{

    Probability of finding a matching transaction minus the probability of finding a contradicting transaction normalized by the probability of finding a transaction containing Y. 
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#least-contradiction}
    
    Range: \eqn{[-1, 1]}}

\item{"lerman", Lerman similarity}{
  
  Defined as \eqn{\sqrt{N} \frac{supp(X \cup Y) - supp(X)supp(Y)}{\sqrt{supp(X)supp(Y)}}}{sqrt(N) (supp(X & Y) - supp(X)supp(Y))/ sqrt(supp(X)supp(Y))}
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#lerman-similarity}

  Range: \eqn{[0, 1]}}


\item{"leverage", Piatetsky-Shapiro Measure, PS}{
   
  PS measures the difference of X and Y appearing together in the data set 
  and what would be expected if X and Y where statistically dependent. It can
  be interpreted as the gap to independence.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#leverage}
  
  Range: \eqn{[-1, 1]} (0 indicates independence)}

\item{"lift", interest factor}{
  
  Lift quantifies dependence between X and Y by comparing the probability that X and Y are contained in a transaction to the expected probability under independence (i.e., the product of the probabilities that X is contained in a transaction times the probability that Y is contained in a transaction).
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#lift}
  
  Range: \eqn{[0, \infty]}{[0, Inf]} (1 means independence between LHS and RHS)}

\item{"maxConfidence"}{
  Null-invariant symmetric measure defined as the larger of the confidence of the rule or the rule
  with X and Y exchanged.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#maxconfidence}
  Range: \eqn{[0, 1]}
}

\item{"mutualInformation", uncertainty, M}{
  Measures the information gain for Y provided by X.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#mutual-information}
  
  Range: \eqn{[0, 1]} (0 means that X does not provide information for Y)}

\item{"oddsRatio", odds ratio}{

  The odds of finding X in transactions which contain Y divided by
  the odds of finding X in transactions which do not contain Y.
  For zero counts, Haldane-Anscombe correction (adding .5 to all zells) is applied.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#odds_ratio}
  
  Range: \eqn{[0, \infty]}{[0, Inf]} (\eqn{1} indicates that Y is not associated to X)}
  
\item{"oddsRatioCI", odds ratio confidence interval}{

  Calculates the lower and upper bounds of the confidence interval around the odds ratio (using a normal approximation).
  The used confidence level defaults to 0.95, but can be adjusted with the additional 
  parameter \code{confidenceLevel}.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#odds-ratio}
  
  Range: \eqn{[0, \infty]}{[0, Inf]}}
  
\item{"phi", correlation coefficient \eqn{\phi}{phi}}{ 
  Correlation coefficient between the transactions containing X and Y represented as two binary vectors. Phi correlation is equivalent to Pearson's Product Moment Correlation Coefficient \eqn{\rho}{rho} with 0-1 values.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#phi-correlation-coefficient}
  Range: \eqn{[-1, 1]} (0 when X and Y are independent)}

\item{"ralambondrainy", Ralambondrainy Measure}{
    
    The measure is defined as the probability that a transaction contains X but not Y. A smaller value is better.
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#ralambondrainy}
    
    Range: \eqn{[0, 1]}}

\item{"rhsSupport", Support of the rule consequent}{
    
    Range: \eqn{[0, 1]}}

\item{"RLD", relative linkage disequilibrium}{

    RLD is an association measure motivated by
indices used in population genetics. It evaluates the deviation
    of the support of the whole rule from the support expected under 
    independence given the supports of the LHS and the RHS. 
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#relative-linkage-disequilibrium}
    
    The code was
    contributed by Silvia Salini. 
    
    Range: \eqn{[0, 1]}}

\item{"rulePowerFactor", rule power factor}{

    Product of support and confidence. Can be seen as rule confidence weighted
    by support. 
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#rule-power-factor}
    
    Range: \eqn{[0, 1]}}

\item{"sebag", Sebag-Schoenauer measure}{
    
    Confidence of a rule divided by the confidence of the rule  \eqn{X \Rightarrow \overline{Y}}{X -> !Y}.
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#sebag-schoenauer}
    
    Range: \eqn{[0, 1]}}

\item{"stdLift", Standardized Lift}{
    
    Standardized lift uses the minimum and maximum lift can reach for each rule to standardize lift between 0 and 1. By default, the measure is corrected for minimum support and minimum confidence. Correction can be disabled by using the argument \code{correct = FALSE}.
    
    

  See details: \url{https://mhahsler.github.io/arules/docs/measures#standardized-lift}
    
    Range: \eqn{[0, 1]}}
    
\item{"support", supp}{ 
  Support is an estimate of \eqn{P(X \cup Y)}{P(X & Y)} and 
  measures the generality of the rule. 
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#support}

  Range: \eqn{[0, 1]}}

\item{"table"}{ 
  Returns the counts for the contingency table. The values are labeled \eqn{n_{XY}}{n_XY}
  where \eqn{X} and \eqn{Y} represent the presence (1) or absence (0) of the LHS and RHS of the rule, respectively.
  If several measures are specified, then the counts have the prefix \code{table.}
  
  Range: counts}

\item{"varyingLiaison", varying rates liaison}{ 

  Defined as the lift of a rule minus 1 so 0 represents independence.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#Varying-Rates-Liaison}
  
  Range: \eqn{[-1, \infty]} (0 for independence)}

\item{"yuleQ", Yule's Q}{
  Defined as \eqn{\frac{\alpha-1}{\alpha+1}}{(alpha-1)/(alpha+1)} where
  \eqn{\alpha}{alpha} is the odds ratio.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#yules-q-and-yules-y}
  
  Range: \eqn{[-1, 1]}}

\item{"yuleY", Yule's Y}{
  Defined as \eqn{\frac{\sqrt{\alpha}-1}{\sqrt{\alpha}+1}}{(sqrt(alpha)-1)/(sqrt(alpha)+1)} where
  \eqn{\alpha}{alpha} is the odds ratio.
  

  See details: \url{https://mhahsler.github.io/arules/docs/measures#yules-q-and-yules-y}
  
  Range: \eqn{[-1, 1]}}

}}

\value{
   If only one measure is used, the function returns a numeric vector 
   containing the values of the interest measure for each association
   in the set of associations \code{x}. 

   If more than one measures are specified, the result is a data.frame 
   containing the different measures for each association as columns.
   
   \code{NA} is returned for rules/itemsets for which a certain measure is not 
   defined.
}
\references{
A complete list of references for each individual measure is available in the following document:

Hahsler, Michael (2015). 
A Probabilistic Comparison of Commonly Used Interest Measures for Association Rules, 2015, URL: \url{https://mhahsler.github.io/arules/docs/measures}.
}

\seealso{ \code{\link{itemsets-class}}, \code{\link{rules-class}} }
\author{Michael Hahsler}
\examples{
data("Income")
rules <- apriori(Income)

## calculate a single measure and add it to the quality slot
quality(rules) <- cbind(quality(rules), 
	hyperConfidence = interestMeasure(rules, measure = "hyperConfidence", 
	transactions = Income))

inspect(head(rules, by = "hyperConfidence"))

## calculate several measures
m <- interestMeasure(rules, c("confidence", "oddsRatio", "leverage"), 
	transactions = Income)
inspect(head(rules))
head(m)

## calculate all available measures for the first 5 rules and show them as a 
## table with the measures as rows
t(interestMeasure(head(rules, 5), transactions = Income))

## calculate measures on a different set of transactions (I use a sample here)
## Note: reuse = TRUE (default) would just return the stored support on the
##	data set used for mining
newTrans <- sample(Income, 100)
m2 <- interestMeasure(rules, "support", transactions = newTrans, reuse = FALSE) 
head(m2)

## calculate all available measures for the 5 frequent itemsets with highest support
its <- apriori(Income, parameter = list(target = "frequent itemsets"))
its <- head(its, 5, by = "support")
inspect(its)

interestMeasure(its, transactions = Income)
}
\keyword{models}
