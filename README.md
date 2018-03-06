# pbar
Simple to Entirely Customizable Progress Bar with Low Memory Consumption and CPU Usage

Allows to easily create simple to entirely customizable progress bars in console output.
Very low memory consumption and CPU usage (compared to other progress bars R packages available) without any parameters tuning required.

The progress bars are entirely customizable (informations output, time formatting, progress bars cursors...). Unlike other progress bars R packages available, focuses on low memory consumption and CPU usage (e.g. about 10 to 40 times faster than progress R package, see examples), without any parameters tuning required. May display current progress, progress percentage, elapsed time, estimated time available (ETA) or total estimated time (TET), which is useful to easily evaluates if the iterations get faster or slower when work progresses. Check quick-start vignette, examples and R help() function for more information.

Examples :

# More examples can be found by using R help() function.
n = 1000
my_pb = pb$new(n)
for(i in 1:n) {
  Sys.sleep(0.001)
  my_pb$update()
}

# The example below compares pbar R package with progress R package

n = 100000

x = rep('Hello',n)
y = rep('world',n)
z = rep('',n)

# First loop, without any progress bar
t0 = proc.time()[3]
for (i in 1:n) {
  z = paste0(x[i], ' ', y[i], '!')
}
no_bar_time = proc.time()[3] - t0

# Second loop, with pbar progress bar
t0 = proc.time()[3]
my_pb = pb$new(n,
               format = 'Progress: [:bar] :percent Elapsed: :elapsedexact ETA: :eta/:tet')
for (i in 1:n) {
  z = paste0(x[i], ' ', y[i], '!')
  my_pb$update()
}
my_bar_time = proc.time()[3] - t0

# Third loop, with progress progress bar
library(progress)
t0 = proc.time()[3]
old_pb = progress_bar$new(total = n,
                          format = ':spin [:bar] :percent Elapsed: :elapsed ETA: :eta')
for (i in 1:n) {
  z = paste0(x[i], ' ', y[i], '!')
  old_pb$tick()
}
progress_bar_time = proc.time()[3] - t0

# Below outputs should show an average total elapsed time of :
no_bar_time # 0.30 seconds
my_bar_time # about 3.00 seconds
progress_bar_time # 100.00 to 120.00 seconds
