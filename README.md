
<!-- README.md is generated from README.Rmd. Please edit that file -->
MLtoolkit
=========

MLtoolkit is an R package providing functions to help with machine learning tasks.

Installation
------------

You can install MLtoolkit from GitHub using:

``` r
# install.packages("devtools")
devtools::install_github("AndrewKostandy/MLtoolkit")
```

Currently Implemented Functions:
--------------------------------

-   compute\_mod\_results(): Computes performance metrics of a single caret model object across resamples.
-   all\_mod\_results(): Computes performance metrics of multiple Ccaret model object across resamples.
-   plot\_mod\_results(): Produces a box plot with the performance metrics of multiple caret model object across resamples.
-   get\_quartiles(): Gets quartiles of a dataframe's numeric columns.
-   truncate\_data(): Truncates a dataframe's numeric columns.

Example: Comparing Model Performance
------------------------------------

The two following sections demonstrate how to compute performance metrics for caret model objects across resamples for binary classification and regression plotting those results in each case.

### Binary Classification

The performance metrics computed for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

``` r
library(MLtoolkit)
library(recipes)
library(mlbench)

data(BreastCancer)
dat <- BreastCancer %>%
  select(-Id) %>%
  modify_at(c(1:9), as.numeric)

# Since caret requires the positive class (malignant) to be the first factor level in the outcome:
dat <- mutate(dat, Class = fct_rev(Class))

rec1 <- recipe(Class ~ Cl.thickness + Cell.size + Cell.shape, data = dat)

rec2 <- recipe(Class ~ Marg.adhesion + Epith.c.size + Bare.nuclei, data = dat)

rec3 <- recipe(Class ~ Bl.cromatin + Normal.nucleoli + Mitoses, data = dat)

train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
                           classProbs = TRUE,
                           savePredictions = "final")

glm_fit_1 <- train(rec1, data = dat,
                   method = "glm",
                   trControl = train_ctrl)

glm_fit_2 <- train(rec2, data = dat,
                   method = "glm",
                   trControl = train_ctrl)

glm_fit_3 <- train(rec3, data = dat,
                   method = "glm",
                   trControl = train_ctrl)
```

The compute\_mod\_results() function works with a single caret model object and computes its performance metrics:

``` r
compute_mod_results(glm_fit_1, "GLM 1") %>% head()
#> # A tibble: 6 x 14
#>   Model Resample   ROC Sensitivity Specificity Precision Accuracy
#>   <chr> <chr>    <dbl>       <dbl>       <dbl>     <dbl>    <dbl>
#> 1 GLM 1 Fold01.… 0.978       0.917       0.957     0.917    0.943
#> 2 GLM 1 Fold01.… 0.971       0.917       1         1        0.971
#> 3 GLM 1 Fold01.… 0.999       1           0.935     0.889    0.957
#> 4 GLM 1 Fold01.… 0.993       0.833       1         1        0.943
#> 5 GLM 1 Fold02.… 0.996       0.917       1         1        0.971
#> 6 GLM 1 Fold02.… 0.993       0.917       0.957     0.917    0.943
#> # ... with 7 more variables: `Cohen's Kappa` <dbl>, `F1 Score` <dbl>,
#> #   `Matthews Corr. Coeff.` <dbl>, Concordance <dbl>, Discordance <dbl>,
#> #   `Somer's D` <dbl>, `KS Statistic` <dbl>
```

The all\_mod\_results() function works with multiple caret model objects and computes their model performance metrics:

``` r
mod_results <- all_mod_results(list(glm_fit_1, glm_fit_2, glm_fit_3), c("GLM 1", "GLM 2", "GLM 3"))
mod_results %>% head()
#> # A tibble: 6 x 14
#>   Model Resample   ROC Sensitivity Specificity Precision Accuracy
#>   <chr> <chr>    <dbl>       <dbl>       <dbl>     <dbl>    <dbl>
#> 1 GLM 1 Fold01.… 0.978       0.917       0.957     0.917    0.943
#> 2 GLM 1 Fold01.… 0.971       0.917       1         1        0.971
#> 3 GLM 1 Fold01.… 0.999       1           0.935     0.889    0.957
#> 4 GLM 1 Fold01.… 0.993       0.833       1         1        0.943
#> 5 GLM 1 Fold02.… 0.996       0.917       1         1        0.971
#> 6 GLM 1 Fold02.… 0.993       0.917       0.957     0.917    0.943
#> # ... with 7 more variables: `Cohen's Kappa` <dbl>, `F1 Score` <dbl>,
#> #   `Matthews Corr. Coeff.` <dbl>, Concordance <dbl>, Discordance <dbl>,
#> #   `Somer's D` <dbl>, `KS Statistic` <dbl>
```

The plot\_mod\_results() function produces a box plot of the models performance metrics:

``` r
plot_mod_results(mod_results, plot_columns = 3)
```

<p align="center">
<img src="man/figures/README-binary_classification_1.svg" width="1000px">
</p>

This function can alternatively take a list of caret model objects and a list or vector of model names:

``` r
# plot_mod_results(list(glm_fit_1, glm_fit_2, glm_fit_3), c("GLM 1", "GLM 2", "GLM 3"))
```

### Regression

The performance metrics computed for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE).

``` r
train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
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

The compute\_mod\_results() function works with a single caret model object and computes its performance metrics:

``` r
compute_mod_results(lm_fit_1, "LM 1") %>% head()
#> # A tibble: 6 x 6
#>   Model Resample     RMSE      R2   MAE  MAPE
#>   <chr> <chr>       <dbl>   <dbl> <dbl> <dbl>
#> 1 LM 1  Fold01.Rep1 0.782 0.0216  0.631 10.9 
#> 2 LM 1  Fold01.Rep2 0.778 0.189   0.674 12.1 
#> 3 LM 1  Fold01.Rep3 0.867 0.0271  0.703 12.1 
#> 4 LM 1  Fold01.Rep4 0.635 0.161   0.558  9.84
#> 5 LM 1  Fold02.Rep1 0.787 0.00317 0.681 12.0 
#> 6 LM 1  Fold02.Rep2 0.713 0.00959 0.623 10.7
```

The all\_mod\_results() function works with multiple caret model objects and computes their model performance metrics:

``` r
mod_results <- all_mod_results(list(lm_fit_1, lm_fit_2, lm_fit_3), c("LM 1", "LM 2", "LM 3"))
mod_results %>% head()
#> # A tibble: 6 x 6
#>   Model Resample     RMSE      R2   MAE  MAPE
#>   <chr> <chr>       <dbl>   <dbl> <dbl> <dbl>
#> 1 LM 1  Fold01.Rep1 0.782 0.0216  0.631 10.9 
#> 2 LM 1  Fold01.Rep2 0.778 0.189   0.674 12.1 
#> 3 LM 1  Fold01.Rep3 0.867 0.0271  0.703 12.1 
#> 4 LM 1  Fold01.Rep4 0.635 0.161   0.558  9.84
#> 5 LM 1  Fold02.Rep1 0.787 0.00317 0.681 12.0 
#> 6 LM 1  Fold02.Rep2 0.713 0.00959 0.623 10.7
```

The plot\_mod\_results() function produces a box plot of the models performance metrics:

``` r
plot_mod_results(mod_results)
```

<p align="center">
<img src="man/figures/README-regression_1.svg" width="1000px">
</p>

Example: Data Truncation
------------------------

This is a basic example which shows the truncate\_data() function in the package.

Below is a dataframe with numeric columns including univariate outliers:

``` r
mydata <- data_frame(a=c(10,11,12,seq(70,90,2),50,60),
                     b=c(3,11,12,seq(30,40,1),44,80))
```

The truncate\_data() function will truncate univariate outliers as follows:

-   Values below the 1st quartile by more than 1.5 x IQR are truncated to be exactly 1.5 x IQR below the 1st quartile.

-   Values above the 3rd quartile by more than 1.5 x IQR are truncated to be exactly 1.5 x IQR above the 3rd quartile.

``` r
mydata_truncated <- truncate_data(mydata)
```

This is our data (training data) before and after truncation:

<p align="center">
<img src="man/figures/README-truncation_1.svg" width="1000px">
</p>

Note that new data (eg. test data), can be truncated using the training data quartile values:

Let's make some test data:

``` r
mydata_test <- data_frame(a=c(0,11,12, seq(70,90,2), 50, 100),
                          b=c(25,11,12, seq(25,35,1), 100, 90))
```

Let's get the quartiles of our original data:

``` r
mydata_quartiles <- get_quartiles(mydata)
mydata_quartiles
#> # A tibble: 4 x 3
#>   Key            a     b
#>   <chr>      <dbl> <dbl>
#> 1 Quartile 1  57.5  30.8
#> 2 Quartile 2  75    34.5
#> 3 Quartile 3  82.5  38.2
#> 4 IQR         25     7.5
```

Let's use the quartiles of our original data to truncate the test data:

``` r
mydata_test_truncated <- truncate_data(mydata_test, mydata_quartiles)
```

Let's plot the test data before and after truncation using the quartiles of the original data:

<p align="center">
<img src="man/figures/README-truncation_2.svg" width="1000px">
</p>
