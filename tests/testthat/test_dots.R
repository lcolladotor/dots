context('dots')

minMax <- function(x, y, ...) {
    minValue <- dots('minValue', 0, ...)
    res <- max(x, y, minValue)
    return(res)
}

test_that('dots', {
    expect_that(minMax(1:2, 3:4), equals(4))
    expect_that(minMax(1:2, 3:4, minValue = 5), equals(5))
}
)

maxIdent2 <- function(x, ...) {
    m <- max(x, ...)
    y <- formal_call(identity, x = m, ...)
    return(y)
}

test_that('formal_call', {
    expect_that(formalArgs(identify, x = 5L, y = 2), throws_error())
    expect_that(maxIdent2(1, 2), equals(2))
}
)

context('last')

l <- list(a = 1:10, b = 11:20)
l2 <- list(j = 21:30, k = list(a = 1:10, b = 11:20))

test_that('Advanced args doc', {
    expect_that(names(last(l)), equals('b'))
    expect_that(last(l)[[1]], equals(11:20))
    expect_that(names(last(l, selector = '[[')), equals(NULL))
    expect_that(last(l, selector = '[['), equals(11:20))
    expect_that(names(recursive_last(l2)), equals('k'))
    expect_that(names(recursive_last(l2)[[1]]), equals(c('a', 'b')))
    expect_that(recursive_last(l2), equals(recursive_last(l2, level = 2L)))
    expect_that(recursive_last(l2, level = 2L, selector = '[['), equals(11:20))
    expect_that(recursive_last(l2, level = 3L, selector = '[['), equals(20))
    expect_that(recursive_last(l2, level = 2L, selector = c('[', '[[')), equals(l))
}
)

