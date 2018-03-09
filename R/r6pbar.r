#' String concatenation operator
#' 
#' Operator function to make string contatenation easier. This operator does
#' exactly the same as calling the function \code{paste0(a,b)}
#' 
#' @param a A character variable.
#' @param b A character variable.
#' @return A character variable, obtained by calling paste0(a,b).
#' @examples
#' 'Hello' %+% ', ' %+% 'world !'
#' @export
`%+%` <- function(a,b) {
  return(paste0(a,b))
}

#' Time format function
#' 
#' Converts time in seconds to time in hh:mm:ss format. If time value passed as
#' parameter is a float number, only the two first decimals will be kept.
#' 
#' @param s A numerical variable, a time in seconds to convert.
#' @return A character variable, formatted in hh:mm:ss (with two decimals).
#' @examples
#' formattime(32) # outputs '00:00:32.00s'
#' formattime(165) # outputs '00:02:45.00s'
#' formattime(3601) # outputs '01:00:01.00s'
#' formattime(5421.15) # outputs '01:30:21.15s'
#' formattime(452632.456) # outputs '125:43:52.46s'
#' @export
formattime <- function(s) {
  h = floor(s / 3600)
  s = s %% 3600
  m = floor(s / 60)
  s = s %% 60
  return(
    ifelse(h < 10, '0' %+% h, h) %+%
      ':' %+%
    ifelse(m < 10, '0' %+% m, m) %+%
      ':' %+%
      ifelse(s < 10, '0' %+% format(round(s, 2), nsmall = 2), format(round(s, 2), nsmall = 2)) %+%
      's')
}

#' Short time format function
#' 
#' Converts time in seconds to most easily readable non-decimal unit, between
#' days, hours, minutes or seconds, followed by the corresponding unit
#' 
#' @param s A numerical variable, a time in seconds to convert.
#' @return A character variable, formatted to short time
#' @examples
#' shortformattime(32) # outputs '32s'
#' shortformattime(165) # outputs '3m'
#' shortformattime(3601) # outputs '1h'
#' shortformattime(5421.15) # outputs '2h'
#' shortformattime(452632.456) # outputs '5d'
#' @export
shortformattime <- function(s) {
  if (s>86400)
    return(round(s/86400) %+% 'd')
  if (s>3600)
    return(round(s/3600) %+% 'h')
  if (s>60)
    return(round(s/60) %+% 'm')
  return(round(s) %+% 's')
}

#' Short speed format function
#' 
#' Converts speed in indexes per second to most easily readable two-decimal unit, between
#' indexes per day (i/d), hour (i/h), minute (i/m) or second (i/s), followed by the corresponding
#' unit
#' 
#' @param ips A numerical variable, a speed in indexes per second to convert.
#' @return A character variable, formatted to short speed
#' @examples
#' shortformatspeed(4564) # outputs '4564 i/s'
#' shortformatspeed(45) # outputs '45 i/s'
#' shortformatspeed(48/60) # outputs '48 i/m'
#' shortformatspeed(3/60) # outputs '3 i/m'
#' shortformatspeed(45/3600) # outputs '45 i/h'
#' shortformatspeed(0.5/3600) # outputs '12 i/d'
#' @export
shortformatspeed <- function(ips) {
  if (ips<1/3600)
    return(round(ips*86400, 2) %+% ' i/d')
  if (ips<1/60)
    return(round(ips*3600, 2) %+% ' i/h')
  if (ips<1)
    return(round(ips*60, 2) %+% ' i/m')
  return(round(ips, 2) %+% ' i/s')
}


#' Progress bar
#' 
#' Creates a progress bar object by calling the \code{new} function. Progress
#' bar object may be updated at each loop iteration by calling the object's
#' \code{update} function. See below the different parameters which may be
#' passed while creating the progress bar for further instructions.
#'
#' - max A numerical variable, the total number of iterations. Used to
#'   calculate percentage of progress and estimated time available if any value
#'   greater than 0 is provided. Default value is 0.
#' - format A character variable, the console output that will be made
#'   by calling the \code{update} function of the progress bar object. Tokens
#'   can be used in this string :
#'     :bar / Displays the progress bar
#'     :current / Displays the current index
#'     :total / Displays the maximal index
#'     :shorttotal / Displays the maximal index, shortened (ie. 1m, 10k, etc.)
#'     :percent / Displays the progress percentage
#'     :elapsed / Displays the elapsed time, shortened formatting
#'     :elapsedexact / Displays the elapsed time, exact hh:mm:ss.ss format
#'     :eta / Displays the estimated available time (ETA), shortened formatting
#'     :etaexact / Displays the ETA, exact hh:mm:ss.ss format
#'     :tet / Displays the total estimated time (TET), shortened formatting
#'     :tetexact / Displays the TET, exact hh:mm:ss.ss format
#'   See examples for more information on how to use the format parameter.
#' - cursors A character vector of length 2, containing the progress bar
#'   complete state character (first character of vector) and the progress bar
#'   incomplete state character (second). Default value is c('#',' '), which
#'   will output a |#####      | like progress bar.
#' - ini A numerical variable, The initial index value. Can not be set
#'   to a negative value to prevent division by zero during progress. Default
#'   value is 1.
#' - barlength A numerical variable, the length in characters of the
#'   actual progress bar. Should be set between 0 (no bar displayed) and 100.
#'   Default value is 10.
#' - outputpace A numerical variable, the minimal delta index between two
#'   console updates. If set to 0, this value will automatically be set to 0.01%
#'   of the total iterations count to maximize performance. Default value is 0.
#' - mindelay A numerical variable, the minimal delay in milliseconds
#'   between two console updates. Default value is 0.1.
#' - spiningcursor A logical variable. If \code{TRUE}, an animated cursor will
#'   be shown in the progress bar. Default value is \code{TRUE}.
#'   
#' Returns a progress bar object with initial values set to passed parameters.
#' @examples
#' # The total iterations in each loop should be set to at least 100000 to see
#' # the progress bar. The examples below are ran with a value of 100 to make
#' # R code checking faster.
#' 
#' # n = 100000 # Uncomment for testing
#' n = 100 # Remove for testing
#' 
#' # A simple progress bar can be created by using the pb \code{new} function :
#' my_pb = pb$new(n)
#' # If total number of iterations is not known, passing no parameter is possible :
#' my_pb = pb$new()
#' 
#' # Once the progress bar object is created, the \code{update} function will
#' # provoke values update of the object, as well as console output refresh :
#' for(i in 1:n) {
#'   Sys.sleep(0.001)
#'   my_pb$update()
#' }
#' 
#' # Several formatting styles can be tried. Tokens will automatically be
#' # replaced when outputting the progress bar onto the console :
#' my_pb = pb$new(n,
#' format = ':current/:total :bar:percent Elapsed: :elapsedexact ETA: :etaexact Total: :tetexact')
#' for(i in 1:n) {
#'   Sys.sleep(0.001)
#'   my_pb$update()
#' }
#' 
#' my_pb = pb$new(n,
#'                format = 'Progress: :bar:percent Elapsed: :elapsed ETA: :eta Total: :tetexact')
#' for(i in 1:n) {
#'   Sys.sleep(0.001)
#'   my_pb$update()
#' }
#' 
#' # See vignettes for more information.
#' @export
pb <- R6::R6Class("Progress Bar",
                public = list(
                  t0 = NULL,
                  ini = NULL,
                  cur = NULL,
                  max = NULL,
                  format = NULL,
                  barlength = NULL,
                  outputpace = NULL,
                  lastupdate = NULL,
                  mindelay = NULL,
                  lastupdatetime = NULL,
                  formatted_max = NULL,
                  animate = NULL,
                  animstate = NULL,
                  animcursor = NULL,
                  animlastupdate = NULL,
                  cursors = NULL,
                  bounds = NULL,
                  cpt_current = NULL,
                  cpt_total = NULL,
                  cpt_shorttotal = NULL,
                  cpt_percent = NULL,
                  cpt_elapsed = NULL,
                  cpt_elapsedexact = NULL,
                  cpt_eta = NULL,
                  cpt_etaexact = NULL,
                  cpt_tet = NULL,
                  cpt_tetexact = NULL,
                  cpt_pbar = NULL,
                  cpt_speed = NULL,
                  laststreamlength = NULL,
                  initialize = function(max = 0, format = ':current/:shorttotal [:bar] :percent Elapsed: :elapsed ETA: :eta/:tet (:speed)', cursors = c('#',' '), ini = 0, barlength = 10, outputpace = 0, mindelay = 0.1, spiningcursor = T) {
                    # Analyze formatting
                    # possible formats :
                    # :bar
                    # :current
                    # :total
                    # :shorttotal
                    # :percent
                    # :elapsedexact # Elapsed time since beginning, short format
                    # :elapsed # Elapsed time since beginning, hh:mm:ss.ss format
                    # :etaexact # Estimated Time Available
                    # :eta
                    # :tetexact # Total Estimated Time
                    # :tet
                    # :speed
                    # Set max to 0 if negative value provided
                    if (max < 0)
                      max = 0
                    if (ini < 0) # If value reaches 0, would cause a division by 0 when computing eta
                      ini = 0
                    if (ini > max)
                      max = 0
                    # Prevent float, negative values of bar length
                    barlength = round(barlength)
                    if (barlength < 0)
                      barlength = 0
                    # Bar length shouldn't be > than 100
                    if (barlength > 100)
                      barlength = 100
                    # Set output pace in bounds if not already
                    if (outputpace == 0 & max > 0)
                      outputpace = (max - ini) / 10000 # display every 0.01% (useless to update more frequently)
                    if (outputpace < 0)
                      outputpace = 0
                    # Format max value
                    formatted_max = max
                    if (formatted_max >= 1000000000)
                      formatted_max = round(formatted_max/1000000000) %+% 'G'
                    else if (formatted_max >= 1000000)
                      formatted_max = round(formatted_max/1000000) %+% 'm'
                    else if (formatted_max >= 1000)
                      formatted_max = round(formatted_max/1000) %+% 'k'
                    # Set instance values
                    self$t0 = proc.time()[3]
                    self$ini = ini
                    self$cur = ini
                    self$max = max
                    # Reformat if missing total iterations
                    if (max == 0 | barlength == 0) {
                      format = gsub(':bar','',format)
                      format = gsub(':shorttotal','?',format)
                      format = gsub(':total','?',format)
                      format = gsub(':percent','?',format)
                      format = gsub(':etaexact','?',format)
                      format = gsub(':eta','?',format)
                      format = gsub(':tetexact','?',format)
                      format = gsub(':tet','?',format)
                    }
                    self$format = format
                    self$barlength = barlength
                    self$outputpace = outputpace
                    self$lastupdate = -1
                    self$mindelay = mindelay
                    self$lastupdatetime = proc.time()[3]
                    self$formatted_max = formatted_max
                    self$animate = spiningcursor
                    self$animstate = 1
                    self$animcursor = c('-','\\\\','|','/')
                    self$animlastupdate = proc.time()[3]
                    self$laststreamlength = 0
                    if (!(is.vector(cursors)&is.character(cursors)&length(cursors)==2)) {
                      self$cursors = c('#',' ')
                    } else {
                      self$cursors = cursors
                    }
                    # Prepare formatting
                    self$cpt_current = grepl(':current',format)
                    self$cpt_total = grepl(':total',format)
                    self$cpt_shorttotal = grepl(':shorttotal',format)
                    self$cpt_percent = grepl(':percent',format)
                    self$cpt_elapsed = grepl(':elapsed(?!exact)',format,perl=T)
                    self$cpt_eta = grepl(':eta(?!exact)',format,perl=T)
                    self$cpt_tet = grepl(':tet(?!exact)',format,perl=T)
                    self$cpt_elapsedexact = grepl(':elapsedexact',format)
                    self$cpt_etaexact = grepl(':etaexact',format)
                    self$cpt_tetexact = grepl(':tetexact',format)
                    self$cpt_speed = grepl(':speed',format)
                    self$cpt_pbar = grepl(':bar',format) & max > 0 & barlength > 0
                  },
                  update = function(i = 1) {
                    # Print message beforehand if first iteration
                    first_iter = F
                    if (self$cur == self$ini) {
                      cat('Starting iteration over ' %+% (self$max - self$ini) %+% ' elements')
                      # Reset start time to now
                      self$t0 = proc.time()[3]
                      first_iter = T
                    }
                    
                    # If current index is > max, set max value to 0 (ie. maximum value unknown)
                    
                    # Progress to next iteration(s)
                    self$cur = self$cur + i
                    
                    # Determine if function should do calculations and output text
                    if (first_iter | self$cur == self$max | (proc.time()[3] - self$lastupdatetime >= self$mindelay & self$cur - self$lastupdate >= self$outputpace)) {
                      
                      # Calculate delta time and percentage of progress
                      p = ifelse(self$max > 0, 100 * self$cur / self$max, 0)
                      dt = proc.time()[3] - self$t0
                      
                      # Compute ETA and TET
                      eta = dt*(self$max-self$cur)/self$cur
                      tet = dt+eta
                      
                      # Prepare console output
                      tmp_bar = self$format
                      if (self$cpt_current)
                        tmp_bar = gsub(':current',self$cur,tmp_bar)
                      if (self$cpt_total)
                        tmp_bar = gsub(':total',self$max,tmp_bar)
                      if (self$cpt_shorttotal)
                        tmp_bar = gsub(':shorttotal',self$formatted_max,tmp_bar)
                      if (self$cpt_percent)
                        tmp_bar = gsub(':percent',format(round(p, 2), nsmall = 2) %+% '%',tmp_bar)
                      if (self$cpt_elapsedexact)
                        tmp_bar = gsub(':elapsedexact',formattime(dt),tmp_bar)
                      if (self$cpt_elapsed)
                        tmp_bar = gsub(':elapsed',shortformattime(dt),tmp_bar)
                      if (self$cpt_etaexact)
                        tmp_bar = gsub(':etaexact',ifelse(self$max > 0, formattime(eta), '??:??s'),tmp_bar)
                      if (self$cpt_eta)
                        tmp_bar = gsub(':eta',ifelse(self$max > 0, shortformattime(eta), '??'),tmp_bar)
                      if (self$cpt_tetexact)
                        tmp_bar = gsub(':tetexact',ifelse(self$max > 0, formattime(tet), '??:??s'),tmp_bar)
                      if (self$cpt_tet)
                        tmp_bar = gsub(':tet',ifelse(self$max > 0, shortformattime(tet), '??'),tmp_bar)
                      if (self$cpt_speed)
                        tmp_bar = gsub(':speed',shortformatspeed((self$cur - self$ini) / dt),tmp_bar)
                      
                      if (self$cpt_pbar) {
                        # Update cursor
                        if (self$animate & proc.time()[3] - self$animlastupdate >= 0.1) {
                          self$animstate = self$animstate + 1
                          if (self$animstate > 4)
                            self$animstate = 1
                          self$animlastupdate = proc.time()[3]
                        }
                        
                        # Design progress bar
                        tmp_pbar = character(self$barlength)
                        for(j in 1:self$barlength) {
                          if (p>=j*100/self$barlength) {
                            tmp_pbar[j] = self$cursors[1]
                          }
                          else {
                            if (p>=(j-1)*100/self$barlength) {
                              if (self$animate) {
                                tmp_pbar[j] = self$animcursor[self$animstate]
                              } else {
                                tmp_bar[j] = self$cursors[2]
                              }
                            } else {
                              tmp_pbar[j] = self$cursors[2]
                            }
                          }
                        }
                        
                        tmp_bar = gsub(':bar',paste(tmp_pbar,sep='',collapse=''),tmp_bar)
                      }
                      
                      # Console output
                      cat('\r' %+% tmp_bar)
                      # If last output line was longer, make sure to print blank spaces to avoid graphical bugs
                      length_diff = self$laststreamlength - length(tmp_bar)
                      if (length_diff >= 0)
                        cat(rep(' ',length_diff+1),sep='')
                      # Reset last output line length
                      self$laststreamlength = length(tmp_bar)
                      
                      # Reset last update
                      self$lastupdate = self$cur
                      self$lastupdatetime = proc.time()[3]
                    }
                  }
                )
)