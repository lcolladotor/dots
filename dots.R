
## ----vignetteSetup, echo=FALSE, message=FALSE, warning = FALSE-----------
## Track time spent on making the vignette
startTime <- Sys.time()

## Bib setup
library('knitcitations')

## Load knitcitations with a clean bibliography
cleanbib()
cite_options(hyperlink = 'to.doc', citation_format = 'text', style = 'html')
# Note links won't show for now due to the following issue
# https://github.com/cboettig/knitcitations/issues/63

## Write bibliography information
write.bibtex(c(knitcitations = citation('knitcitations'),
    dots = citation('dots'), 
    knitrBootstrap = citation('knitrBootstrap'), 
    knitr = citation('knitr')[3],
    rmarkdown = citation('rmarkdown')),
    file = 'dotsRef.bib')
bib <- read.bibtex('dotsRef.bib')

## Assign short names
names(bib) <- c('knitcitations', 'dots', 'knitrBootstrap',
    'knitr', 'rmarkdown')


## ----'library'-----------------------------------------------------------
## Load the library
library('dots')


## ----'dotsCode', bootstrap.show.output = FALSE---------------------------
## Explore code
## Alias: advanced...()
dots


## ----'dotsExample'-------------------------------------------------------
myFun <- function(x, ...) {
    ## In all the cases, the user has to specify 'x' for this function to work
    
    ## However, only a few users will want to make the function print status
    ## reports (controlled by the 'verbose' argument)
    
    #' @param verbose Controls whether to print status reports or not.
    #' Use value from global 'verbose' option if available. Otherwise, use 
    #' \code{FALSE}
    verbose <- dots('verbose', getOption('verbose', FALSE), ...)
    if(verbose)
        message(paste(Sys.time(), 'myFun: performing analysis'))
    
    ## In this case, it's just a simple example, so lets return the identify value
    return(identity(x))
}

## Lets use it now
myFun(1:10)

## Experienced user wants to print status reports
myFun(1:10, verbose = TRUE)


## ----'formalCallCode', bootstrap.show.output = FALSE---------------------
## Explore source
## Alias: formalCall()
formal_call


## ----'formalCodeExample'-------------------------------------------------
myFunBroken <- function(x, ...) {
    identity(max(x, ...), ...)
}

## Test without using ...
myFunBroken(1:10)


## ----'formalBroken', eval = FALSE----------------------------------------
## ## Breaks when you use ...
## myFunBroken(1:10, 11:20)


## ----'formalFixed'-------------------------------------------------------
## Fix code using formal_call()
myFunFixed <- function(x, ...) {
    formal_call(identity, x = max(x, ...), ...)
}

## Check that we are getting the same value as before
identical(myFunBroken(1:10), myFunFixed(1:10))

## Doesn't break when you use ...
myFunFixed(1:10, 11:20)


## ----'funkyPlot'---------------------------------------------------------
## A more complicated example
funkyPlot <- function(x, y, ...) {
    verbose <- dots('verbose', getOption('verbose', FALSE), ...)
    if(verbose)
        message(paste(Sys.time(), 'funkyPlot: getting ready to roll'))
    plot(x, y, ...)
}

## funkyPlot() doesn't work
tryCatch(funkyPlot(1:10, 10:1, verbose = TRUE, xlab = 'Data (units)'), warning = function(w) { print(w) })


## ----'funkyPlot2'--------------------------------------------------------
## Use 'xlab'
funkyPlot2 <- function(x, y, ...) {
    verbose <- dots('verbose', getOption('verbose', FALSE), ...)
    if(verbose)
        message(paste(Sys.time(), 'funkyPlot: getting ready to roll'))
    xlab <- dots('xlab', '', ...)
    formal_call(plot, x = x, y = y, ..., formalCallUse = list(xlab = xlab))
}

## Works now =)
funkyPlot2(1:10, 10:1, verbose = TRUE, xlab = 'Data (units)')


## ----'funkyPlot3'--------------------------------------------------------
## If we knew for sure that we only want to exclude 'verbose' from ... before
## calling plot() we can do so this way.
funkyPlot3 <- function(x, y, ...) {
    verbose <- dots('verbose', getOption('verbose', FALSE), ...)
    if(verbose)
        message(paste(Sys.time(), 'funkyPlot: getting ready to roll'))
    
    ## Drop 'verbose' from ...
    use <- list(...)
    use <- use[!names(use) == 'verbose']
    
    ## Call plot. Note that we are not passing ... anymore.
    formal_call(plot, x = x, y = y, formalCallUse = use)
}

## Works with more graphical parameters
funkyPlot3(1:10, 10:1, verbose = TRUE, xlab = 'Data (units)', ylab = 'Success', main = 'Complicated example')


## ----createVignette, eval=FALSE, bootstrap.show.code=FALSE---------------
## ## Create the vignette
## library('knitrBootstrap')
## 
## knitrBootstrapFlag <- packageVersion('knitrBootstrap') < '1.0.0'
## if(knitrBootstrapFlag) {
##     ## CRAN version
##     library('knitrBootstrap')
##     system.time(knit_bootstrap('dots.Rmd', chooser=c('boot', 'code'), show_code = TRUE))
##     unlink('dots.md')
## } else {
##     ## GitHub version
##     library('rmarkdown')
##     system.time(render('dots.Rmd'))
## }
## unlink('dotsRef.bib')
## ## Note: if you prefer the knitr version use:
## # library('rmarkdown')
## # system.time(render('dots.Rmd', 'html_document'))
## 
## ## Extract the R code
## library('knitr')
## knit('dots.Rmd', tangle = TRUE)


## ----reproducibility1, echo=FALSE, bootstrap.show.code=FALSE-------------
## Date the vignette was generated
Sys.time()


## ----reproducibility2, echo=FALSE, bootstrap.show.code=FALSE-------------
## Processing time in seconds
totalTime <- diff(c(startTime, Sys.time()))
round(totalTime, digits=3)


## ----reproducibility3, echo=FALSE, bootstrap.show.code=FALSE, bootstrap.show.message=FALSE----
## Session info
library('devtools')
options(width = 90)
session_info()


## ----vignetteBiblio, results='asis', echo=FALSE--------------------------
## Print bibliography
bibliography()

