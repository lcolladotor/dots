dots [![Build Status](https://travis-ci.org/lcolladotor/dots.svg?branch=master)](https://travis-ci.org/lcolladotor/dots)
=========

Simplify your `R` functions by using the `...` argument to reduce the complexity of the function calls. This will make your functions more user friendly, while `dots` allows you to specify advanced arguments the more experienced users can supply.

# Installation instructions

Get R 3.0.3 or newer from [CRAN](http://cran.r-project.org/).

```R
## If needed
install.packages('devtools')

## Install dots
library('devtools')
install_github('lcolladotor/dots')
```

# Vignette

The vignette for this package can be viewed [here](http://lcolladotor.github.io/dots/).


# Travis CI

This package is automatically tested thanks to [Travis CI](travis-ci.org) and [r-travis](https://github.com/craigcitro/r-travis). If you want to add this to your own package use:

```R
## Use devtools to create the .travis.yml file
library('devtools')
use_travis('yourPackage')

## Read https://github.com/craigcitro/r-travis/wiki to configure .travis.yml appropriately

## Add a status image by following the info at http://docs.travis-ci.com/user/status-images/
```

Testing on R-devel for Bioc-devel is feasible thanks to [r-builder](https://github.com/metacran/r-builder).
