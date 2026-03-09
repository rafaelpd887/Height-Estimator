# Height Estimator (IRT + Linear Regression)

![R](https://img.shields.io/badge/R-4.3.1-blue)
![Docker](https://img.shields.io/badge/Docker-20.10.24-blue)

This project predicts a person's height using answers from a binary questionnaire.

The system uses **Item Response Theory (IRT)** to estimate a latent trait (θ) from the answers, and then predicts height using a **Linear Regression model**.

The application is deployed as a **REST API** (Plumber) and a **Shiny front-end**.

---

## Project Structure
Height-Estimator/

├─ training/ # scripts para treinar IRT e Linear Regression
├─ models/ # modelos salvos (.rds)
├─ api/ # Plumber API + healthcheck
├─ frontend/ # Shiny frontend
├─ docker-compose.yml # orquestra containers
├─ .gitignore
├─ .dockerignore
└─ README.md

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
Frontend (Shiny)

↓

REST API (Plumber)

↓

IRT + Linear Regression models

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
Rscript api/plumber_api.R
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
