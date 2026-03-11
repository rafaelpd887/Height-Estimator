library(plumber)
library(mirt)
library(here)

model_tri <- readRDS(here("models/model_irt.rds"))
model_lm <- readRDS(here("models/model_lm.rds"))
item_names <- readRDS(here("models/item_names.rds"))

predict_height <- function(answers){
  
  answers <- as.numeric(unlist(answers))
  
  print("received answers:")
  print(answers)
  print(length(answers))
  
  response_df <- as.data.frame(t(answers))
  colnames(response_df) <- item_names
  
  theta_matrix <- fscores(
    model_tri,
    response.pattern = response_df,
    method = "EAP"
  )
  
  print("theta_matrix:")
  print(theta_matrix)
  
  theta <- as.numeric(theta_matrix[1, "F1"])
  print(paste("theta:", theta))
  
  height <- predict(
    model_lm,
    newdata = data.frame(theta = theta)
  )
  
  print(paste("predicted height:", height))
  
  return(as.numeric(height)[1])
}

#* Predicts height from the answers
#* @param answers:list vector of answers (0 ou 1)
#* @post /predict
function(answers){
  
  answers_vector <- as.numeric(unlist(answers))
  
  result <- predict_height(answers_vector)
  
  list(height = result)
}

#* Health check
#* @get /health
function(){
  list(status = "ok")
}
