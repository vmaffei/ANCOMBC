% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ancombc2.R
\name{ancombc2}
\alias{ancombc2}
\title{Analysis of Compositions of Microbiomes with Bias Correction 2
(ANCOM-BC2)}
\usage{
ancombc2(
  data,
  assay_name = "counts",
  tax_level = NULL,
  fix_formula,
  rand_formula = NULL,
  p_adj_method = "holm",
  pseudo = 0,
  pseudo_sens = TRUE,
  prv_cut = 0.1,
  lib_cut = 0,
  s0_perc = 0.05,
  group = NULL,
  struc_zero = FALSE,
  neg_lb = FALSE,
  alpha = 0.05,
  n_cl = 1,
  verbose = FALSE,
  global = FALSE,
  pairwise = FALSE,
  dunnet = FALSE,
  trend = FALSE,
  iter_control = list(tol = 0.01, max_iter = 20, verbose = FALSE),
  em_control = list(tol = 1e-05, max_iter = 100),
  lme_control = lme4::lmerControl(),
  mdfdr_control = list(fwer_ctrl_method = "holm", B = 100),
  trend_control = list(contrast = NULL, node = NULL, solver = "ECOS", B = 100)
)
}
\arguments{
\item{data}{the input data. A
\code{phyloseq}, \code{SummarizedExperiment}, or
\code{TreeSummarizedExperiment} object, which consists of
a feature table (microbial count table), a sample metadata, a
taxonomy table (optional), and a phylogenetic tree (optional). The row names
of the metadata must match the sample names of the feature table, and the
row names of the taxonomy table must match the taxon (feature) names of the
feature table. See \code{?phyloseq::phyloseq},
\code{?SummarizedExperiment::SummarizedExperiment}, or
\code{?TreeSummarizedExperiment::TreeSummarizedExperiment} for more details.
It is highly recommended that the input data
are in low taxonomic levels, such as OTU or species level, as the estimation
of sampling fractions requires a large number of taxa.}

\item{assay_name}{character. Name of the count table in the data object
(only applicable if data object is a \code{(Tree)SummarizedExperiment}).
Default is "counts".
See \code{?SummarizedExperiment::assay} for more details.}

\item{tax_level}{character. The taxonomic level of interest. The input data
can be analyzed at any taxonomic level without prior agglomeration. 
Note that \code{tax_level} must be a value from \code{taxonomyRanks}, which 
includes "Kingdom", "Phylum" "Class", "Order", "Family" "Genus" or "Species".
See \code{?mia::taxonomyRanks} for more details.
Default is NULL, i.e., do not perform agglomeration, and the
ANCOM-BC2 anlysis will be performed at the lowest taxonomic level of the
input \code{data}.}

\item{fix_formula}{the character string expresses how the microbial absolute
abundances for each taxon depend on the fixed effects in metadata.}

\item{rand_formula}{the character string expresses how the microbial absolute
abundances for each taxon depend on the random effects in metadata. ANCOM-BC2
follows the \code{lmerTest} package in formulating the random effects. See
\code{?lmerTest::lmer} for more details. Default is \code{NULL}.}

\item{p_adj_method}{character. method to adjust p-values. Default is "holm".
Options include "holm", "hochberg", "hommel", "bonferroni", "BH", "BY",
"fdr", "none". See \code{?stats::p.adjust} for more details.}

\item{pseudo}{numeric. Add pseudo-counts to the data.
Default is 0 (no pseudo-count addition).}

\item{pseudo_sens}{logical. Whether to perform the sensitivity analysis to
the pseudo-count addition. Default is \code{TRUE}. See \code{Details} for
a more comprehensive discussion on this sensitivity analysis.}

\item{prv_cut}{a numerical fraction between 0 and 1. Taxa with prevalences
less than \code{prv_cut} will be excluded in the analysis. For instance,
suppose there are 100 samples, if a taxon has nonzero counts presented in
less than 10 samples, it will not be further analyzed. Default is 0.10.}

\item{lib_cut}{a numerical threshold for filtering samples based on library
sizes. Samples with library sizes less than \code{lib_cut} will be
excluded in the analysis. Default is 0, i.e. do not discard any sample.}

\item{s0_perc}{a numerical fraction between 0 and 1. Inspired by
\href{https://doi.org/10.1073/pnas.091062498}{Significance
Analysis of Microarrays (SAM)} methodology, a small positive constant is
added to the denominator of ANCOM-BC2 test statistic corresponding to
each taxon to avoid the significance due to extremely small standard errors,
especially for rare taxa. This small positive constant is chosen as
\code{s0_perc}-th percentile of standard error values for each fixed effect.
Default is 0.05 (5th percentile).}

\item{group}{character. The name of the group variable in metadata.
\code{group} should be discrete. Specifying \code{group} is required for
detecting structural zeros and performing multi-group comparisons (global
test, pairwise directional test, Dunnett's type of test, and trend test).
Default is NULL. If the \code{group} of interest contains only two
categories, leave it as NULL.}

\item{struc_zero}{logical. Whether to detect structural zeros based on
\code{group}. Default is FALSE. See \code{Details} for
a more comprehensive discussion on structural zeros.}

\item{neg_lb}{logical. Whether to classify a taxon as a structural zero using
its asymptotic lower bound. Default is FALSE.}

\item{alpha}{numeric. Level of significance. Default is 0.05.}

\item{n_cl}{numeric. The number of nodes to be forked. For details, see
\code{?parallel::makeCluster}. Default is 1 (no parallel computing).}

\item{verbose}{logical. Whether to generate verbose output during the
ANCOM-BC2 fitting process. Default is FALSE.}

\item{global}{logical. Whether to perform the global test. Default is FALSE.}

\item{pairwise}{logical. Whether to perform the pairwise directional test.
Default is FALSE.}

\item{dunnet}{logical. Whether to perform the Dunnett's type of test.
Default is FALSE.}

\item{trend}{logical. Whether to perform trend test. Default is FALSE.}

\item{iter_control}{a named list of control parameters for the iterative
MLE or RMEL algorithm, including 1) \code{tol}: the iteration convergence
tolerance (default is 1e-02), 2) \code{max_iter}: the maximum number of
iterations (default is 20), and 3)\code{verbose}: whether to show the verbose
output (default is FALSE).}

\item{em_control}{a named list of control parameters for the E-M algorithm,
including 1) \code{tol}: the iteration convergence tolerance
(default is 1e-05) and 2) \code{max_iter}: the maximum number of iterations
(default is 100).}

\item{lme_control}{a list of control parameters for mixed model fitting.
See \code{?lme4::lmerControl} for details.}

\item{mdfdr_control}{a named list of control parameters for mixed directional
false discover rate (mdFDR), including 1) \code{fwer_ctrl_method}: family
wise error (FWER) controlling procedure, such as "holm", "hochberg",
"bonferroni", etc (default is "holm") and 2) \code{B}: the number of
bootstrap samples (default is 100). Increase \code{B} will lead to a more
accurate p-values. See \code{Details} for a more comprehensive discussion on
mdFDR.}

\item{trend_control}{a named list of control parameters for the trend test,
including 1) \code{contrast}: the list of contrast matrices for
constructing inequalities, 2) \code{node}: the list of positions for the
nodal parameter, 3) \code{solver}: a string indicating the solver to use
(default is "ECOS"), and 4) \code{B}: the number of bootstrap samples
(default is 100). Increase \code{B} will lead to a more accurate p-values.
See \code{vignette} for the corresponding trend test examples.}
}
\value{
a \code{list} with components:
        \itemize{
        \item{ \code{feature_table}, a \code{data.frame} of pre-processed
        (based on \code{prv_cut} and \code{lib_cut}) microbial count table.}
        \item{ \code{zero_ind}, a logical \code{data.frame} with TRUE
        indicating the taxon is detected to contain structural zeros in
        some specific groups.}
        \item{ \code{samp_frac}, a numeric vector of estimated sampling
        fractions in log scale (natural log).}
        \item{ \code{delta_em}, estimated sample-specific biases
        through E-M algorithm.}
        \item{ \code{delta_wls}, estimated sample-specific biases through
        weighted least squares (WLS) algorithm.}
        \item{ \code{pseudo_sens_tab}, the results of sensitivity analysis
        for the pseudo-count addition. }
        \item{ \code{res},  a \code{data.frame} containing ANCOM-BC2 primary
        result:}
        \itemize{
        \item{ columns started with \code{lfc}: log fold changes
        obtained from the ANCOM-BC2 log-linear (natural log) model.}
        \item{ columns started with \code{se}: standard errors (SEs) of
        \code{lfc}.}
        \item{ columns started with \code{W}: test statistics.
        \code{W = lfc/se}.}
        \item{ columns started with \code{p}: p-values. P-values are
        obtained from two-sided Z-test using the test statistic \code{W}.}
        \item{ columns started with \code{q}: adjusted p-values.
        Adjusted p-values are obtained by applying \code{p_adj_method}
        to \code{p}.}
        \item{ columns started with \code{diff}: TRUE if the
        taxon is significant (has \code{q} less than \code{alpha}).}
        }
        \item{ \code{res_global},  a \code{data.frame} containing ANCOM-BC2
        global test result for the variable specified in \code{group},
        each column is:}
        \itemize{
        \item{ \code{W}, test statistics.}
        \item{ \code{p_val}, p-values, which are obtained from two-sided
        Chi-square test using \code{W}.}
        \item{ \code{q_val}, adjusted p-values. Adjusted p-values are
        obtained by applying \code{p_adj_method} to \code{p_val}.}
        \item{ \code{diff_abn}, A logical vector. TRUE if the taxon has
        \code{q_val} less than \code{alpha}.}
        }
        \item{ \code{res_pair},  a \code{data.frame} containing ANCOM-BC2
        pairwise directional test result for the variable specified in
        \code{group}:}
        \itemize{
        \item{ columns started with \code{lfc}: log fold changes.}
        \item{ columns started with \code{se}: standard errors (SEs).}
        \item{ columns started with \code{W}: test statistics.}
        \item{ columns started with \code{p}: p-values.}
        \item{ columns started with \code{q}: adjusted p-values.}
        \item{ columns started with \code{diff}: TRUE if the
        taxon is significant (has \code{q} less than \code{alpha}).}
        }
        \item{ \code{res_dunn},  a \code{data.frame} containing ANCOM-BC2
        Dunnett's type of test result for the variable specified in
        \code{group}:}
        \itemize{
        \item{ columns started with \code{lfc}: log fold changes.}
        \item{ columns started with \code{se}: standard errors (SEs).}
        \item{ columns started with \code{W}: test statistics.}
        \item{ columns started with \code{p}: p-values.}
        \item{ columns started with \code{q}: adjusted p-values.}
        \item{ columns started with \code{diff}: TRUE if the
        taxon is significant (has \code{q} less than \code{alpha}).}
        }
        \item{ \code{res_trend},  a \code{data.frame} containing ANCOM-BC2
        trend test result for the variable specified in
        \code{group}:}
        \itemize{
        \item{ columns started with \code{lfc}: log fold changes.}
        \item{ columns started with \code{se}: standard errors (SEs).}
        \item{ \code{W}: test statistics.}
        \item{ \code{p_val}: p-values.}
        \item{ \code{q_val}: adjusted p-values.}
        \item{ \code{diff_abn}: TRUE if the
        taxon is significant (has \code{q} less than \code{alpha}).}
        }
        }
}
\description{
Determine taxa whose absolute abundances, per unit volume, of
the ecosystem (e.g., gut) are significantly different with changes in the
covariate of interest (e.g., group). The current version of
\code{ancombc2} function implements Analysis of Compositions of Microbiomes
with Bias Correction (ANCOM-BC2) in cross-sectional and repeated measurements
data. In addition to the two-group comparison, ANCOM-BC2 also supports
testing for continuous covariates and multi-group comparisons,
including the global test, pairwise directional test, Dunnett's type of
test, and trend test.
}
\details{
A taxon is considered to have structural zeros in some (>=1)
groups if it is completely (or nearly completely) missing in these groups.
For instance, suppose there are three groups: g1, g2, and g3.
If the counts of taxon A in g1 are 0 but nonzero in g2 and g3,
then taxon A will be considered to contain structural zeros in g1.
In this example, taxon A is declared to be differentially abundant between
g1 and g2, g1 and g3, and consequently, it is globally differentially
abundant with respect to this group variable.
Such taxa are not further analyzed using ANCOM-BC2, but the results are
summarized in the overall summary. For more details about the structural
zeros, please go to the
\href{https://doi.org/10.3389/fmicb.2017.02114}{ANCOM-II} paper.
Setting \code{neg_lb = TRUE} indicates that you are using both criteria
stated in section 3.2 of
\href{https://doi.org/10.3389/fmicb.2017.02114}{ANCOM-II}
to detect structural zeros; otherwise, the algorithm will only use the
equation 1 in section 3.2 for declaring structural zeros. Generally, it is
recommended to set \code{neg_lb = TRUE} when the sample size per group is
relatively large (e.g. > 30).

Like other differential abundance analysis methods, ANCOM-BC2 log transforms
the observed counts. However, to deal with zero counts, a pseudo-count is
added before the log transformation. Several studies have shown that
differential abundance results could be sensitive to the choice of
pseudo-count
(\href{https://doi.org/10.1038/nmeth.2897}{Costea et al. (2014)};
\href{https://doi.org/10.1038/nmeth.2898}{Paulson, Bravo, and Pop (2014)}),
resulting in an inflated false positive rate. To avoid such false positives,
we conduct a sensitivity analysis and provide a sensitivity score for
each taxon to determine if a particular taxon is sensitive to the choice of
pseudo-count. The larger the score, the more likely the significant
result is a false positive.

When performning pairwise directional (or Dunnett's type of) test, the mixed
directional false discover rate (mdFDR) should be taken into account.
The mdFDR is the combination of false discovery rate due to multiple testing,
multiple pairwise comparisons, and directional tests within each pairwise
comparison. For example, suppose we have five taxa and three experimental
groups: g1, g2, and g3. Thus, we are performing five tests corresponding to
five taxa. For each taxon, we are also conducting three pairwise comparisons
(g1 vs. g2, g2 vs. g3, and g1 vs. g3). Within each pairwise comparison,
we wish to determine if the abundance has increased or decreased or did not
change (direction of the effect size). Errors could occur in each step.
The overall false discovery rate is controlled by the mdFDR methodology we
adopted from
\href{https://doi.org/10.1111/j.1541-0420.2009.01292.x}{Guo, Sarkar, and Peddada (2010)} and
\href{https://doi.org/10.1186/s12859-016-0937-5}{Grandhi, Guo, and Peddada (2016)}.
}
\examples{
#===========Build a TreeSummarizedExperiment Object from Scratch=============
library(mia)

# microbial count table
otu_mat = matrix(sample(1:100, 100, replace = TRUE), nrow = 10, ncol = 10)
rownames(otu_mat) = paste0("taxon", 1:nrow(otu_mat))
colnames(otu_mat) = paste0("sample", 1:ncol(otu_mat))
assays = SimpleList(counts = otu_mat)

# sample metadata
smd = data.frame(group = sample(LETTERS[1:4], size = 10, replace = TRUE),
                 row.names = paste0("sample", 1:ncol(otu_mat)),
                 stringsAsFactors = FALSE)
smd = DataFrame(smd)

# taxonomy table
tax_tab = matrix(sample(letters, 70, replace = TRUE),
                 nrow = nrow(otu_mat), ncol = 7)
rownames(tax_tab) = rownames(otu_mat)
colnames(tax_tab) = c("Kingdom", "Phylum", "Class", "Order",
                      "Family", "Genus", "Species")
tax_tab = DataFrame(tax_tab)

# create TSE
tse = TreeSummarizedExperiment(assays = assays,
                               colData = smd,
                               rowData = tax_tab)

# convert TSE to phyloseq
pseq = makePhyloseqFromTreeSummarizedExperiment(tse)

#=======================Run ANCOMBC2 Using a Real Data=======================
library(ANCOMBC)
data(dietswap, package = "microbiome")
tse = mia::makeTreeSummarizedExperimentFromPhyloseq(dietswap)

colData(tse)$bmi_group = factor(colData(tse)$bmi_group,
                                levels = c("obese",
                                           "overweight",
                                           "lean"))

set.seed(123)
# Note that setting pseudo_sens = FALSE, max_iter = 1, and B = 1 is
# only for the sake of speed
# Set pseudo_sens = TRUE, and use default or larger values for max_iter and B
# for better performance
out = ancombc2(data = tse, assay_name = "counts", tax_level = "Phylum",
               fix_formula = "nationality + timepoint + bmi_group",
               rand_formula = "(timepoint | subject)",
               p_adj_method = "holm", pseudo = 0, pseudo_sens = FALSE,
               prv_cut = 0.10, lib_cut = 1000, s0_perc = 0.05,
               group = "bmi_group", struc_zero = TRUE, neg_lb = TRUE,
               alpha = 0.05, n_cl = 1, verbose = TRUE,
               global = TRUE, pairwise = TRUE, dunnet = TRUE, trend = TRUE,
               iter_control = list(tol = 1e-2, max_iter = 1, verbose = TRUE),
               em_control = list(tol = 1e-5, max_iter = 1),
               lme_control = lme4::lmerControl(),
               mdfdr_control = list(fwer_ctrl_method = "holm", B = 1),
               trend_control = list(contrast =
                                          list(matrix(c(1, 0, -1, 1),
                                                      nrow = 2,
                                                      byrow = TRUE)),
                                      node = list(2),
                                      solver = "ECOS",
                                      B = 1))
res_prim = out$res
res_global = out$res_global
res_pair = out$res_pair
res_dunn = out$res_dunn
res_trend = out$res_trend

}
\references{
\insertRef{kaul2017analysis}{ANCOMBC}

\insertRef{lin2020analysis}{ANCOMBC}

\insertRef{tusher2001significance}{ANCOMBC}

\insertRef{costea2014fair}{ANCOMBC}

\insertRef{paulson2014reply}{ANCOMBC}

\insertRef{guo2010controlling}{ANCOMBC}

\insertRef{grandhi2016multiple}{ANCOMBC}
}
\seealso{
\code{\link{ancom}} \code{\link{ancombc}}
}
\author{
Huang Lin
}
