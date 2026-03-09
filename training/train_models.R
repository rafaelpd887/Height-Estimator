rm(list = ls())

library(data.table)
library(mirt)

# Load data
base <- fread("../data/Dados_Altura.csv", 
              header = TRUE, 
              na.strings = "NA", 
              colClasses = "numeric",
              data.table = FALSE)

base_items <- base[, -c(1,2)]

n_itens <- ncol(base_items)

# Define model dynamically
prioris <- mirt.model(paste0(
  "F1 = 1-", n_itens, "
   PRIOR = (1-", n_itens, ", a1, lnorm, 0, 0.5)"
))

# Calibrate IRT
model_irt <- mirt(data = base_items,
                  model = prioris,
                  itemtype = "2PL",
                  SE = TRUE,
                  quadpts = 20)

# Estimate theta
theta <- fscores(model_irt, method = "EAP")
colnames(theta) <- "theta"

base_score <- cbind(base, theta)

# Train regression
model_lm <- lm(`Altura(m)` ~ theta, data = base_score)

# Save artifacts
saveRDS(model_irt, "../models/model_irt.rds") 
saveRDS(model_lm, "../models/model_lm.rds")
saveRDS(colnames(base_items), "../models/item_names.rds")