#' Run a function only using its formal arguments.
#'
#' Extract from the function definition its formal arguments. Then from 
#' \code{...}, only use the arguments that are in the formal definition and
#' drop the rest. This helps avoid conflicts when you are passing arguments
#' with \code{...} but is not used by all of the functions you need.
#'
#'
#' @param fun A function to use (the actual function, not the character)
#' @param ... A set of arguments. Only those matching the formal definition of
#' \code{fun} will be used when evaluating \code{fun}.
#'
#' @export
#' @aliases formalCall
#' @author L. Collado-Torres
#'
#' @details
#' Some functions are not defined with the \code{...} argument, and they will 
#' choke if you use them in your functions and pass arguments they are not 
#' using.
#'
#' @examples
#'
#' ## Lets define a very simple identity function
#' ident <- function(x) return(x)
#'
#' ## Now lets use it inside another function
#' maxIdent <- function(x, ...) {
#'     m <- max(x, ...)
#'     y <- ident(m, ...)
#'     return(y)
#' }
#' ## Seems to work
#' maxIdent(1:10)
#'
#' ## But not when we actually use '...'
#' \dontrun{
#' maxIdent(1:10, 11)
#' }
#'
#' ## Lets now use formal_call() to run ident() only using the arguments it
#' ## has as part of its function definition.
#' maxIdent2 <- function(x, ...) {
#'     m <- max(x, ...)
#'     y <- formal_call('ident', x = m, ...)
#'     return(y)
#' }
#' 
#' ## Works now =)
#' maxIdent2(1:10, 11)
#'

formal_call <- function(fun, ...) {
    ## Identify the formal arguments and the supplied info
    formal <- formalArgs(fun)
    args <- list(...)
    
    ## Are any arguments you absolutely want to use?
    ## Useful when the formal definition uses ... and you still want to supply
    ## something
    
    #' @param formalCallUse A named list with parameters you certainly want to 
    #' use. See \code{plot()} example in vignette.
    use <- dots('formalCallUse', NULL, ...)
    if(!is.null(use)) {
        stopifnot(is.list(use))
        stopifnot(!is.null(names(use)))
        ## Avoid using the same argument twice
        args <- args[!names(args) %in% names(use)]
        input <- use
    } else {
        input <- NULL
    }
    
    ## Match any of the remaining formal arguments and drop any of the
    ## extra stuff in ... which doesn't match the formal arguments
    input <- c(input, args[names(args) %in% formal])
    
    ## Evaluate the function
    result <- do.call(fun, input)
    return(result)
}

#' @export
formalCall <- formal_call
