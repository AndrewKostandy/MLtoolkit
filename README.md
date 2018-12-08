
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
#> 1 GLM 1 Fold01.… 0.992       0.88        0.978     0.957    0.943
#> 2 GLM 1 Fold01.… 0.961       0.917       0.956     0.917    0.942
#> 3 GLM 1 Fold01.… 0.971       0.708       0.978     0.944    0.884
#> 4 GLM 1 Fold01.… 0.986       0.875       0.957     0.913    0.929
#> 5 GLM 1 Fold02.… 0.984       0.917       0.978     0.957    0.957
#> 6 GLM 1 Fold02.… 0.997       0.958       1         1        0.986
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
#> 1 GLM 1 Fold01.… 0.992       0.88        0.978     0.957    0.943
#> 2 GLM 1 Fold01.… 0.961       0.917       0.956     0.917    0.942
#> 3 GLM 1 Fold01.… 0.971       0.708       0.978     0.944    0.884
#> 4 GLM 1 Fold01.… 0.986       0.875       0.957     0.913    0.929
#> 5 GLM 1 Fold02.… 0.984       0.917       0.978     0.957    0.957
#> 6 GLM 1 Fold02.… 0.997       0.958       1         1        0.986
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
The plot\_mod\_results() function can alternatively take a list of caret model objects and a list or vector of model names:

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
#>   Model Resample     RMSE       R2   MAE  MAPE
#>   <chr> <chr>       <dbl>    <dbl> <dbl> <dbl>
#> 1 LM 1  Fold01.Rep1 0.915 0.00179  0.698  11.3
#> 2 LM 1  Fold01.Rep2 0.696 0.242    0.606  10.9
#> 3 LM 1  Fold01.Rep3 0.856 0.00414  0.710  12.6
#> 4 LM 1  Fold01.Rep4 0.799 0.000514 0.681  11.8
#> 5 LM 1  Fold02.Rep1 0.759 0.0854   0.652  11.7
#> 6 LM 1  Fold02.Rep2 0.886 0.0573   0.678  11.9
```

The all\_mod\_results() function works with multiple caret model objects and computes their model performance metrics:

``` r
mod_results <- all_mod_results(list(lm_fit_1, lm_fit_2, lm_fit_3), c("LM 1", "LM 2", "LM 3"))
mod_results %>% head()
#> # A tibble: 6 x 6
#>   Model Resample     RMSE       R2   MAE  MAPE
#>   <chr> <chr>       <dbl>    <dbl> <dbl> <dbl>
#> 1 LM 1  Fold01.Rep1 0.915 0.00179  0.698  11.3
#> 2 LM 1  Fold01.Rep2 0.696 0.242    0.606  10.9
#> 3 LM 1  Fold01.Rep3 0.856 0.00414  0.710  12.6
#> 4 LM 1  Fold01.Rep4 0.799 0.000514 0.681  11.8
#> 5 LM 1  Fold02.Rep1 0.759 0.0854   0.652  11.7
#> 6 LM 1  Fold02.Rep2 0.886 0.0573   0.678  11.9
```

The plot\_mod\_results() function produces a box plot of the models performance metrics:

``` r
plot_mod_results(mod_results)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

The plot\_mod\_results() function can alternatively take a list of caret model objects and a list or vector of model names:

``` r
# plot_mod_results(list(lm_fit_1, lm_fit_2, lm_fit_3), c("LM 1", "LM 2", "LM 3"))
```

Example: Data Truncation
------------------------

This is a basic example which shows the truncate\_data() function in the package.

Below is a dataframe with numeric columns including univariate outliers:

``` r
theme_set(theme_light())

mydata <- data_frame(a=(c(10,11,12,seq(70,90,2),50,60)),
                     b=(c(5,11,12,seq(10,20,1),50,60)),
                     c=(c(3,11,12,seq(30,40,1),44,80)),
                     d=(c(0,0,12,seq(20,25,0.5),50,100)))

ggplot(gather(mydata, key, value), aes(key, value)) + geom_boxplot()
```

<img src="man/figures/README-example-1.png" width="100%" />

The truncate\_data() function will truncate univariate outliers as follows:

-   Values below the 1st quartile by more than 1.5 x IQR are truncated to be exactly 1.5 x IQR below the 1st quartile.

-   Values above the 3rd quartile by more than 1.5 x IQR are truncated to be exactly 1.5 x IQR above the 3rd quartile.

After truncation, this is what the data will look like:

``` r
mydata_truncated <- truncate_data(mydata)
ggplot(gather(mydata_truncated, key, value), aes(key, value)) + geom_boxplot()
```

<img src="man/figures/README-example_continued-1.png" width="100%" />

Note that new data (eg. test data), can be truncated using the training data quartile values:

Let's make some test data and draw a box plot:

``` r
mydata_test <- data_frame(a=(c(0,11,12, seq(70,90,2), 50, 110)),
                          b=(c(-10,20,25, seq(20,30,1), 50, 60)),
                          c=(c(25,11,12, seq(25,35,1), 104, 90)),
                          d=(c(-5,-12,12, seq(15,20,0.5), 50, 100)))

ggplot(gather(mydata_test, key, value), aes(key, value)) + geom_boxplot()
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

Let's get the quartiles of our original data:

``` r
mydata_quartiles <- get_quartiles(mydata)
mydata_quartiles
#> # A tibble: 4 x 5
#>   Key            a     b     c     d
#>   <chr>      <dbl> <dbl> <dbl> <dbl>
#> 1 Quartile 1  57.5  11.8  30.8 20.4 
#> 2 Quartile 2  75    14.5  34.5 22.2 
#> 3 Quartile 3  82.5  18.2  38.2 24.1 
#> 4 IQR         25     6.5   7.5  3.75
```

Let's use the quartiles of our original data to truncate the test data and plot the test data after truncation:

``` r
mydata_test_truncated <- truncate_data(mydata_test, mydata_quartiles)
ggplot(gather(mydata_test_truncated, key, value), aes(key, value)) + geom_boxplot()
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />
