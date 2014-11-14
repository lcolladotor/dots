#' Get the last element
#'
#' Extract the last element of an object using \code{'['} or \code{'[['}
#'
#' @param x An object such as a vector or a list that has \code{'['} or 
#' \code{'[['} methods defined for it
#' @param ... Advanced arguments.
#'
#'
#' @export
#' @seealso \link{dots}
#' @author L. Collado-Torres
#'
#' 
#' @examples
#'
#' ## Last element of a vector
#' last(1:10)
#' 
#' ## Simple example list
#' l <- list(a = 1:10, b = 11:20)
#'
#' ## Get the last element using the '[' operator
#' last(l)
#'
#' ## Get the last element usign the '[[' operator
#' last(l, selector = '[[')

last <- function(x, ...) {
    ## Define the selector
    #' @param selector Choose between '[' or '[['
    selector <- dots('selector', '[', ...)
    
    ## Check input
    stopifnot(selector %in% c('[', '[['))
    
    ## Find length
    l <- length(x)
    
    ## Apply the appropriate operator
    if(selector == '[') {
        res <- x[l]
    } else {
        res <- x[[l]]
    }
    
    ## Done
    return(res)
}



#' Recursively get the last element
#'
#' From a complicated object such as nested lists, extract the last element.
#'
#' @param x An object such as a vector or a list that has \code{'['} or 
#' \code{'[['} methods defined for it
#' @param level An integer greater or equal to 1 specifying how far to take the 
#' recursion.
#' @param ... Advanced arguments.
#'
#'
#' @export
#' @aliases recursiveLast
#' @seealso \link{dots}, \link{last}
#' @author L. Collado-Torres
#'
#' @examples
#'
#' ## Define a complicated list where it's second object is a list itself
#' l2 <- list(j = 21:30, k = list(a = 1:10, b = 11:20))
#'
#' ## Run with defaults
#' recursive_last(l2)
#'
#' ## Run 2 levels of recursion
#' recursive_last(l2, level = 2L)
#'
#' ## Change the advanced argument 'selector' to '[['
#' recursive_last(l2, level = 2L, selector = '[[')
#'
#' ## Go 3 levels deep
#' recursive_last(l2, level = 3L, selector = '[[')
#' 
#' ## Go 2 levels deep using different selectors at each level
#' recursive_last(l2, level = 2L, selector = c('[', '[['))

recursive_last <- function(x, level = 1L, ...) {
    ## Check input
    stopifnot(level >= 1L)
    stopifnot(is.integer(level))
    
    ## Get selectors for each level and expand if necessary
    #' @param selector Choose between '[' or '[['. It can be a vector in which
    #' case it's expected to be of the same length as code{x}.
    selector <- dots('selector', '[', ...)
    if(length(selector) < level) {
        selector <- rep_len(selector, length.out = level)
    }
    
    ## Perform 1st level
    i <- 1
    res <- last(x, selector = selector[i])
    
    ## Perform recursion
    while(i < level) {
        i <- i + 1
        res <- last(res, selector = selector[i])
    }
    
    ## Done
    return(res)
}

#' @export
recursiveLast <- recursive_last
