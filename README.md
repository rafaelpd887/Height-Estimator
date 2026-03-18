# Height Estimator (IRT + Linear Regression)

![R](https://img.shields.io/badge/R-4.3.1-blue)
![Docker](https://img.shields.io/badge/Docker-20.10.24-blue)

This project predicts a person's height using answers from a binary questionnaire.

Try the **live app here**: [Height Estimator](https://height-estimator-frontend-1089523492288.southamerica-east1.run.app/)

The system uses **Item Response Theory (IRT)** to estimate a latent trait (θ) from the answers, and then predicts height using a **Linear Regression model**.

The application is deployed as a **REST API** (Plumber) and a **Shiny front-end**.

---

## Project Structure
Height-Estimator/

**├─ api/**               *(Plumber API with healthcheck + dockerfile)*

**├─ data/**              *(data files)* 

**├─ frontend/**          *(Shiny frontend + dockerfile)*

**├─ models/**            *(saved models)*

**├─ training/**          *(R script to train IRT and Linear Regression)*

**├─ .dockerignore**

**├─ .gitignore**

**├─ docker-compose.yml** *(container orchestration)*

**└─ README.md**

---

## Model Pipeline

User answers ➡️ IRT model ➡️ θ ➡️ Linear Regression ➡️ Height

### Steps:

1. **IRT model (mirt)**  
   Estimates the latent trait (θ) from questionnaire responses.

2. **Linear regression**  
   Converts the latent trait into a height prediction.

---

## Architecture

**Frontend (Shiny)**  
_User interacts with the app_

↓  

**REST API (Plumber)**  
_Receives requests and handles prediction logic_

↓  

**IRT + Linear Regression models**  
_Estimates latent trait θ and predicts height_

---

## Tech Stack

* R
* mirt
* Plumber (API)
* Shiny (Frontend)
* Docker

---

## Running Locally

### Without Docker

Start the API:

```
Rscript api/plumber.R
```

Run Shiny frontend:

```
Rscript -e "shiny::runApp('frontend/app.R')"
```

### Running with Docker

Build and start containers:

```
docker-compose up --build
```

This will start both the API and the Shiny frontend.

## Future Improvements

Cloud deployment (GKE, EKS, or AKS)

Structured logging

Automated tests

CI/CD integration

## Notes

Models (.rds) are loaded by the API to make predictions.

Questionnaire structure is in training/ for reference and retraining.

This repo demonstrates a full ML pipeline with API and front-end, ready for containerization and cloud deployment.
"<!-- Teste permiss�o actAs -->" 
