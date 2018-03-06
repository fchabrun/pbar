---
title: "Quick start with pbar: Progress bar"
author: "Floris CHABRUN"
date: "03/01/2018"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



# Quick start with pbar: Progress bar

## First steps into displaying your first progress bar

### Create the progress bar object

Creating and displaying a progress bar with `pbar` is extremely simple.

First, create a progress bar object with the `pbar` `new()` function.


```r
pb = pbar$new()
```

If you now how many iterations will occur, you can pass this value as the `max` parameter :


```r
n = 100000
pb = pbar$new(n)
```

By default, the progress bar starts with current index set to 0. You can change this value by modifying the `ini` parameter :



```r
pb = pbar$new(max = n, ini = 5000)
```

Full list of available parameters can be found by typing `help(pbInit)` in the R console.

### Run the progress bar

Then, while in-loop, just call the `pbar` `update()` method to provoke automatic values update of the pbar object, as well as console output refresh :


```r
for(i in 1:n) {
  Sys.sleep(0.001)
  pb$update()
}
```

If the `update` function is not called at every iteration of the loop, you can specify a delta index as a parameter of the `update()` function :

The use of this feature is discouraged. For performance improvment, modifying `outputpace` and `mindelay` parameters should be done instead (see Performance optimization).


```r
for(i in 1:n) {
  Sys.sleep(0.001)
  if (i %% 2==0)
    pb$update(2)
}
```

### Progress bar customization

The progress bar created with `pbar` is entirely customizable. Here are some possible formatting options for the console output :


```r
# Change the classic |#####/    | to a |=====/----| style :
pb = pbar$new(n, cursors = c('=','-'))

# Change the size of the progress bar, here on 20 characters : |##########/         |
pb = pbar$new(n, barlength = 20)

# Remove spinning cursor in middle of progress bar 
pb = pbar$new(n, spinningcursor = FALSE)
```

The time can be formatted in two ways : short format or exact format. The examples below show how the time will be output according to the chosen format :

- Time in seconds :           32           165          3601       5421.15    452632.456
- Short format :             32s            3m            1h            2h            5d
- Exact format :    00:00:32.00s  00:02:45.00s  01:01:00.00s  01:30:21.15s 125:43:52.46s

Below are some examples to change the time format in the console output :ting options for the console output :


```r
# Give a rapid straight-forward look
pb = pbar$new(n, format = 'Progress: :bar:percent Elapsed: :elapsed ETA: :eta/:tet')

# Change the format to show exact informations :
pb = pbar$new(n, format = ':current/:total :bar:percent Elapsed: :elapsedexact ETA: :etaexact Total: :tetexact')

# See short time format for elapsed and eta, but exact total estimated time :
pb = pbar$new(n, format = 'Progress: :bar:percent Elapsed: :elapsed ETA: :eta Total: :tetexact')
```

### Performance optimization

Progress bar performance depends widely on two initialization parameters :

`outputpace` determines the minimum iterations between two console updates. By default, when this value is omitted, it is automatically set to 0.01% of the total number of iterations.

`mindelay` determines the minimal delay (in seconds) between two console updates.

Default values when creating a progress bar instance are chosen to optimize performance and CPU-usage. Nonetheless, you can modify those parameters, for example to force output at every loop iteration :


```r
# Refresh console at every iteration without minimal delay between two updates
pb = pbar$new(outputpace = 1, mindelay = 0)
```

