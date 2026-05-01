import joblib
import numpy as np

# Charger modèle + scaler
model = joblib.load("saved_models/random_forest_model.joblib")
scaler = joblib.load("saved_models/scaler.joblib")

def predict_rain(data):
    features = np.array([[
        data["indoor_temperature"],
        data["indoor_humidity"],
        data["api_wind_speed"],
        data["api_cloud_cover"],
        data["api_pressure"]
    ]])

    features_scaled = scaler.transform(features)

    prediction = model.predict(features_scaled)[0]
    proba = model.predict_proba(features_scaled)[0]

    return {
        "prediction": int(prediction),
        "probability_no_rain": float(proba[0]),
        "probability_rain": float(proba[1])
    }