
<!-- README.md is generated from README.Rmd. Please edit that file -->
MLtoolkit
=========

MLtoolkit is an R package providing functions to help with machine learning & feature engineering tasks.

Installation
------------

You can install MLtoolkit from GitHub using:

``` r
# install.packages("devtools")
devtools::install_github("AndrewKostandy/MLtoolkit")
```

Currently Implemented Functions:
--------------------------------

-   single\_mod\_results(): Computes performance metrics of a single caret model object across resamples.
-   mult\_mod\_results(): Computes performance metrics of multiple caret model objects across resamples.
-   plot\_mod\_results(): Creates a box plot with the performance metrics of multiple caret model objects across resamples.
-   pred\_improve(): Gets the model performance improvement of each predictor relative to the null model.
-   plot\_pred\_improve(): Plots the model performance improvement of each predictor relative to the null model.
-   get\_perc(): Gets the percentiles & the interquartile range of a dataframe's numeric columns.
-   trim\_df(): Trims a dataframe's numeric columns using different methods.
-   get\_prop(): Gets the proportion of each predictor level associated with each outcome level.
-   plot\_prop(): Plots the proportion of each predictor level having a specific outcome level.

Parallelization
---------------

The following functions can make use of parallelization to increase computation speed if desired:

-   mult\_mod\_results()
-   plot\_mod\_results()
-   pred\_improve()
-   plot\_pred\_improve()
-   get\_perc()
-   trim\_df()

The future package can be used as per the below example:

``` r
library(future)
plan("multiprocess") # To enable parallel processing
pred_improve(...) # This function will now make use of parallel processing
plan("sequential") # To return to sequential processing if needed
```

Example: Comparing Model Performance
------------------------------------

The two following sections demonstrate how to compute performance metrics for caret model objects across resamples for binary classification and regression and plotting the results in each case.

### Binary Classification

We'll use the BreastCancer data set from the mlbench library and do some minor modifications on it.

The metrics computed for binary classification are: Area under ROC Curve (AUROC), Sensitivity, Specificity, Area under Precision-Recall Curve (AUPRC), Precision, F1 Score, Accuracy, Cohen's Kappa, Log Loss, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, KS Statistic, and False Discovery Rate.

``` r
library(tidyverse)
#> Warning: package 'tibble' was built under R version 3.5.2
library(caret)
library(MLtoolkit)
library(mlbench)

data(BreastCancer)
dat <- BreastCancer %>%
  select(-Id) %>%
  modify_at(c(1:9), as.numeric)

# Since caret requires the positive class (malignant) to be the first factor level in the outcome:
dat <- mutate(dat, Class = fct_rev(Class))

set.seed(42)
id <- createMultiFolds(dat$Class, k = 10, times = 4)

train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
                           index = id,
                           classProbs = TRUE,
                           savePredictions = "final")

glm_fit_1 <- train(Class ~ Cl.thickness + Cell.size + Cell.shape, data = dat,
                   method = "glm",
                   trControl = train_ctrl)

glm_fit_2 <- train(Class ~ Cl.thickness + Cell.size + Cell.shape + Marg.adhesion, data = dat,
                   method = "glm",
                   trControl = train_ctrl)

glm_fit_3 <- train(Class ~ Bl.cromatin + Normal.nucleoli + Mitoses, data = dat,
                   method = "glm",
                   trControl = train_ctrl)
```

The single\_mod\_results() function works with a single caret model object and computes its performance metrics:

``` r
single_mod_results(glm_fit_1, "GLM 1") %>% head()
#> # A tibble: 6 x 17
#>   Model Resample AUROC Sensitivity Specificity AUPRC Precision `F1 Score`
#>   <chr> <chr>    <dbl>       <dbl>       <dbl> <dbl>     <dbl>      <dbl>
#> 1 GLM 1 Fold01.… 0.996       0.958       0.978 0.949     0.958      0.958
#> 2 GLM 1 Fold01.… 1           1           1     0.96      1          1    
#> 3 GLM 1 Fold01.… 0.967       0.875       1     0.931     1          0.933
#> 4 GLM 1 Fold01.… 0.982       0.958       0.978 0.879     0.958      0.958
#> 5 GLM 1 Fold02.… 0.984       0.917       0.978 0.882     0.957      0.936
#> 6 GLM 1 Fold02.… 0.983       0.958       0.956 0.925     0.92       0.939
#> # … with 9 more variables: Accuracy <dbl>, `Cohen's Kappa` <dbl>, `Log
#> #   Loss` <dbl>, `Matthews Cor. Coef.` <dbl>, Concordance <dbl>,
#> #   Discordance <dbl>, `Somer's D` <dbl>, `KS Statistic` <dbl>, `False
#> #   Discovery Rate` <dbl>
```

The mult\_mod\_results() function works with multiple caret model objects and computes their model performance metrics:

``` r
mod_results <- mult_mod_results(list(glm_fit_1, glm_fit_2, glm_fit_3), c("GLM 1", "GLM 2", "GLM 3"))
mod_results %>% head()
#> # A tibble: 6 x 17
#>   Model Resample AUROC Sensitivity Specificity AUPRC Precision `F1 Score`
#>   <chr> <chr>    <dbl>       <dbl>       <dbl> <dbl>     <dbl>      <dbl>
#> 1 GLM 1 Fold01.… 0.996       0.958       0.978 0.949     0.958      0.958
#> 2 GLM 1 Fold01.… 1           1           1     0.96      1          1    
#> 3 GLM 1 Fold01.… 0.967       0.875       1     0.931     1          0.933
#> 4 GLM 1 Fold01.… 0.982       0.958       0.978 0.879     0.958      0.958
#> 5 GLM 1 Fold02.… 0.984       0.917       0.978 0.882     0.957      0.936
#> 6 GLM 1 Fold02.… 0.983       0.958       0.956 0.925     0.92       0.939
#> # … with 9 more variables: Accuracy <dbl>, `Cohen's Kappa` <dbl>, `Log
#> #   Loss` <dbl>, `Matthews Cor. Coef.` <dbl>, Concordance <dbl>,
#> #   Discordance <dbl>, `Somer's D` <dbl>, `KS Statistic` <dbl>, `False
#> #   Discovery Rate` <dbl>
```

The plot\_mod\_results() function produces a box plot of the models performance metrics:

``` r
plot_mod_results(mod_results, plot_cols = 3)
```

<p align="center">
<img src="man/figures/README-binary_classification_1.svg" width="1000px">
</p>

This function can alternatively take a list of caret model objects and a list or vector of model names:

``` r
# plot_mod_results(list(glm_fit_1, glm_fit_2, glm_fit_3), c("GLM 1", "GLM 2", "GLM 3"))
```

### Regression

We'll use the iris data set.

The performance metrics computed for regression are: Root Mean Squared Error (RMSE), Mean Absolute Error (MAE), Mean Absolute Percentage Error (MAPE), Spearman's Rho, Concordance Correlation Coefficient, and RSquared. Note that MAPE will not be provided if any observations equal zero to avoid division by zero.

``` r
set.seed(42)
id <- createMultiFolds(iris$Sepal.Length, k = 10, times = 4)

train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
                           index = id,
                           savePredictions = "final")

lm_fit_1 <- train(Sepal.Length ~ Sepal.Width, data = iris,
                  method = "lm",
                  trControl = train_ctrl)

lm_fit_2 <- train(Sepal.Length ~ Sepal.Width + Petal.Length, data = iris,
                  method = "lm",
                  trControl = train_ctrl)

lm_fit_3 <- train(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data = iris,
                  method = "lm",
                  trControl = train_ctrl)
```

The single\_mod\_results() function works with a single caret model object and computes its performance metrics:

``` r
single_mod_results(lm_fit_1, "LM 1") %>% head()
#> # A tibble: 6 x 8
#>   Model Resample  RMSE   MAE  MAPE `Spearman's Rho` `Concordance Co…     R2
#>   <chr> <chr>    <dbl> <dbl> <dbl>            <dbl>            <dbl>  <dbl>
#> 1 LM 1  Fold01.… 0.940 0.789  14.2          -0.0892          -0.0335 0.0267
#> 2 LM 1  Fold01.… 1.10  0.890  14.9          -0.216           -0.103  0.251 
#> 3 LM 1  Fold01.… 0.761 0.616  11.0           0.146            0.0473 0.0787
#> 4 LM 1  Fold01.… 0.771 0.644  10.6           0.389            0.0655 0.181 
#> 5 LM 1  Fold02.… 0.726 0.633  11.3           0.216            0.0464 0.0460
#> 6 LM 1  Fold02.… 0.750 0.641  11.5           0.440            0.0676 0.104
```

The mult\_mod\_results() function works with multiple caret model objects and computes their model performance metrics:

``` r
mod_results <- mult_mod_results(list(lm_fit_1, lm_fit_2, lm_fit_3), c("LM 1", "LM 2", "LM 3"))
mod_results %>% head()
#> # A tibble: 6 x 8
#>   Model Resample  RMSE   MAE  MAPE `Spearman's Rho` `Concordance Co…     R2
#>   <chr> <chr>    <dbl> <dbl> <dbl>            <dbl>            <dbl>  <dbl>
#> 1 LM 1  Fold01.… 0.940 0.789  14.2          -0.0892          -0.0335 0.0267
#> 2 LM 1  Fold01.… 1.10  0.890  14.9          -0.216           -0.103  0.251 
#> 3 LM 1  Fold01.… 0.761 0.616  11.0           0.146            0.0473 0.0787
#> 4 LM 1  Fold01.… 0.771 0.644  10.6           0.389            0.0655 0.181 
#> 5 LM 1  Fold02.… 0.726 0.633  11.3           0.216            0.0464 0.0460
#> 6 LM 1  Fold02.… 0.750 0.641  11.5           0.440            0.0676 0.104
```

The plot\_mod\_results() function produces a box plot of the models performance metrics. A 95% confidence interval for the mean can also be added:

``` r
plot_mod_results(mod_results, conf_int95 = TRUE)
```

<p align="center">
<img src="man/figures/README-regression_1.svg" width="1000px">
</p>

### References

The "InformationValue", "caret", and "MLmetrics" packages were used to compute many of the performance metrics.

Example: Get the Model Performance Improvement of Each Predictor Relative to the Null Model
-------------------------------------------------------------------------------------------

We'll use the BreastCancer data set from the mlbench library that we have modified above and add 4 uninformative predictors to it. 2 of those uninformative predictors will be numeric and 2 will be categorical.

``` r
dat2 <- dat %>% mutate(Rand_Num_1 = rnorm(n = nrow(dat)),
                       Rand_Num_2 = runif(n = nrow(dat)),
                       Rand_Cat_1 = sample(x = c("Cat1A", "Cat1B", "Cat1C"),
                                           size = nrow(dat), replace = TRUE,
                                           prob = c(0.4, 0.4, 0.2)),
                       Rand_Cat_2 = sample(x = c("Cat2A", "Cat2B", "Cat2C"),
                                           size = nrow(dat), replace = TRUE, 
                                           prob = c(0.1, 0.1, 0.8)))
```

The pred\_improve() function returns the performance improvement of each predictor relative to the null model. If the outcome is categorical, then a logistic regression model is used and the area under the ROC curve is used to assess performance. If the outcome is numeric, then an ordinary least squares model is used and the root mean squared error (RMSE) is used to assess performance.

The results are estimated across resamples and the p-value is determined using a one-sided paired t-test of the predictor results and the null model results in each case. The p-values are adjusted using the Benjamini-Hochberg method to control the false discovery rate.

``` r
pred_improve(data = dat2, outcome = Class, seed = 42, folds = 10, repeats = 3)
#> # A tibble: 13 x 3
#>    predictor       auroc_improvement significance
#>    <chr>                       <dbl>        <dbl>
#>  1 Cell.shape                0.473       1.67e-43
#>  2 Cell.size                 0.473       1.55e-39
#>  3 Bl.cromatin               0.439       3.39e-34
#>  4 Epith.c.size              0.421       2.70e-31
#>  5 Bare.nuclei               0.420       4.87e-32
#>  6 Cl.thickness              0.409       7.23e-32
#>  7 Marg.adhesion             0.396       4.64e-29
#>  8 Normal.nucleoli           0.388       2.70e-31
#>  9 Mitoses                   0.210       4.21e-20
#> 10 Rand_Cat_2                0.0249      8.75e- 3
#> 11 Rand_Cat_1                0.0151      1.04e- 1
#> 12 Rand_Num_1               -0.00991     9.50e- 1
#> 13 Rand_Num_2               -0.0405      9.99e- 1
```

The plot\_pred\_improve() function can be used to return a plot directly:

``` r
plot_pred_improve(data = dat2, outcome = Class, seed = 42, folds = 10, repeats = 3)
```

<p align="center">
<img src="man/figures/README-plot_pred_improve_1.svg" width="1000px">
</p>

### References

This technique was discussed in the book Feature Engineering and Selection: A Practical Approach for Predictive Models by Max Kuhn and Kjell Johnson.

Example: Data Trimming
----------------------

Below is a dataframe with numeric columns including univariate outliers:

``` r
training <- data_frame(a = c(10, 11, 12, seq(70, 90, 2), 50, 60),
                       b = c(3, 11, 12, seq(30, 40, 1), 44, 80))
#> Warning: `data_frame()` is deprecated, use `tibble()`.
#> This warning is displayed once per session.
```

The trim\_df() function will trim univariate outliers as follows:

If type = "iqr", then for each numeric variable:

-   Values below the 25th percentile by more than 1.5 x IQR are trimmed to be exactly 1.5 x IQR below the 25th percentile.

-   Values above the 75th percentile by more than 1.5 x IQR are trimmed to be exactly 1.5 x IQR above the 75th percentile.

 

If type = "1\_99", then for each numeric variable:

-   Values below the 1st percentile are trimmed to be exactly the value of the 1st percentile.

-   Values above the 99th percentile are trimmed to be exactly the value of the 99th percentile.

``` r
training_trimmed <- trim_df(training, type = "iqr")
```

This is our training data before and after trimming:

<p align="center">
<img src="man/figures/README-trimming_1.svg" width="1000px">
</p>

Note that test data can be trimmed using the training data percentile values.

Let's make some test data:

``` r
test <- data_frame(a = c(0, 11, 12, seq(70, 90, 2), 50, 100),
                   b = c(25, 11, 12, seq(25, 35, 1), 100, 90))
```

Let's get the percentiles of our original data:

``` r
training_percentiles <- get_perc(training)
training_percentiles
#> # A tibble: 6 x 3
#>   Key         a     b
#>   <chr>   <dbl> <dbl>
#> 1 Perc 1   10.1  4.20
#> 2 Perc 25  57.5 30.8 
#> 3 Perc 50  75   34.5 
#> 4 Perc 75  82.5 38.2 
#> 5 Perc 99  89.7 74.6 
#> 6 IQR      25    7.5
```

Let's use the percentiles of our training data to trim the test data:

``` r
test_trimmed <- trim_df(test, type = "iqr", training_percentiles)
```

Let's plot the test data before and after trimming using the percentiles of the original data:

<p align="center">
<img src="man/figures/README-trimming_2.svg" width="1000px">
</p>

Example: Get Outcome Levels Proportions for Each Predictor Level.
-----------------------------------------------------------------

This is what the diamonds data set looks like:

``` r
head(diamonds)
#> # A tibble: 6 x 10
#>   carat cut       color clarity depth table price     x     y     z
#>   <dbl> <ord>     <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
#> 1 0.23  Ideal     E     SI2      61.5    55   326  3.95  3.98  2.43
#> 2 0.21  Premium   E     SI1      59.8    61   326  3.89  3.84  2.31
#> 3 0.23  Good      E     VS1      56.9    65   327  4.05  4.07  2.31
#> 4 0.290 Premium   I     VS2      62.4    58   334  4.2   4.23  2.63
#> 5 0.31  Good      J     SI2      63.3    58   335  4.34  4.35  2.75
#> 6 0.24  Very Good J     VVS2     62.8    57   336  3.94  3.96  2.48
```

Let's take the "cut" column to be our outcome and the "clarity" column to be our predictor. We can get the proportion of each predictor level associated with each outcome level.

``` r
get_prop(diamonds, clarity, cut) %>% head()
#> # A tibble: 6 x 7
#>   clarity cut           n sum_n   prop low_95ci high_95ci
#>   <ord>   <ord>     <int> <int>  <dbl>    <dbl>     <dbl>
#> 1 I1      Fair        210   741 0.283    0.251     0.318 
#> 2 I1      Good         96   741 0.130    0.107     0.156 
#> 3 I1      Very Good    84   741 0.113    0.0919    0.139 
#> 4 I1      Premium     205   741 0.277    0.245     0.311 
#> 5 I1      Ideal       146   741 0.197    0.169     0.228 
#> 6 SI2     Fair        466  9194 0.0507   0.0463    0.0554
```

To plot the proportions and their confidence intervals of each predictor level having a specific outcome level, we can use the plot\_prop() function.

``` r
diamonds2 <- diamonds %>%
  mutate(cut = fct_collapse(cut,
                            `>= Premium` = c("Premium", "Ideal"),
                            `<= Very Good` = c("Fair", "Good", "Very Good")))

plot_prop(diamonds2, clarity, cut, ref_level = ">= Premium", ref_value = 0.5)
```

<p align="center">
<img src="man/figures/README-plot_prop_1.svg" width="1000px">
</p>

### References

This technique was discussed in the book Feature Engineering and Selection: A Practical Approach for Predictive Models by Max Kuhn and Kjell Johnson.
