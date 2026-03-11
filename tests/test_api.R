library(testthat)
library(httr)
library(jsonlite)

test_that("API returns status 200", {
  
  res <- POST(
    "http://localhost:8000/predict",
    body = list(
      answers = c(1,0,1,1,0,0,1,0,0,1,1,1,0,0)
    ),
    encode = "json"
  )
  
  expect_equal(status_code(res), 200)
  
  content_json <- content(res, "text")
  
  data <- fromJSON(content_json)
  
  expect_true("height" %in% names(data))
  
  expect_true(is.numeric(data$height))
  
})