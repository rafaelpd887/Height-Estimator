library(plumber)
library(mirt)
library(here)
library(logger)

source("logger.R")

model_tri <- readRDS("../models/model_irt.rds")
model_lm <- readRDS("../models/model_lm.rds")
item_names <- readRDS("../models/item_names.rds")

predict_height <- function(answers){
  
  answers <- as.numeric(unlist(answers))
  
  log_info("received answers: {answers}")
  log_info("length: {length(answers)}")
  
  response_df <- as.data.frame(t(answers))
  colnames(response_df) <- item_names
  
  theta_matrix <- fscores(
    model_tri,
    response.pattern = response_df,
    method = "EAP"
  )
  
  theta <- as.numeric(theta_matrix[1, "F1"])
  log_info("theta: {theta}")
  
  height <- predict(
    model_lm,
    newdata = data.frame(theta = theta)
  )
  
  log_info("Predicted height = {round(height, 2)} m")
  
  return(as.numeric(height)[1])
}

pr <- plumber::pr()

pr <- pr %>% 
  plumber::pr_post(
    path = "/predict",
    handler = function(answers){
      
      log_info("POST /predict called")
      
      result <- tryCatch({
        predict_height(answers)
      }, error = function(e){
        log_error("error: {e$message}")
        return(NULL)
      })
      
      if (is.null(result)) {
        return(list(error = "Prediction failed"))
      }
      
      list(
        height = round(result, 2),
        unit = "meters"
      )
    }
  )

pr <- pr %>% 
  plumber::pr_get(
    path = "/health",
    handler = function(){
      log_info("health called")
      list(status = "ok")
    }
  )

pr$run(host = "0.0.0.0", port = 8000)
