# Height Estimator (IRT + Machine Learning)

This project predicts a person's height using answers from a binary questionnaire.

The system uses **Item Response Theory (IRT)** to estimate a latent trait from the answers and then predicts height using a **linear regression model**.

The application is deployed as a **REST API** and a **Shiny front-end**.

---

## Model

The prediction pipeline has two stages:

1. **IRT model (mirt)**
   Estimates the latent trait (θ) from questionnaire responses.

2. **Linear regression**
   Converts the latent trait into a height prediction.

Pipeline:

User answers → IRT model → θ → Linear model → Height

---

## Architecture

Frontend (Shiny)
↓
REST API (Plumber)
↓
IRT + Linear Model prediction

---

## Tech Stack

* R
* mirt
* Plumber (API)
* Shiny (Frontend)
* Docker

---

## Running locally

Start the API:

```
Rscript api.R
```

Run the Shiny app:

```
runApp("front.R")
```

---

## Future Improvements

* Docker containerization
* Cloud deployment
* Structured logging
* Automated tests
