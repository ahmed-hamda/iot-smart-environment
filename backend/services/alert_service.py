def generate_alerts(measurement, prediction):
    alerts = []

    gas_value = measurement["gas_value"]
    indoor_temperature = measurement["indoor_temperature"]
    rain_sensor = measurement["rain_sensor"]
    prediction_result = prediction["prediction_result"]

    if gas_value > 1000:
        alerts.append({
            "measurement_id": measurement["id"],
            "alert_type": "gas",
            "alert_message": f"Gas level is high: {gas_value}",
            "severity": "high"
        })

    if indoor_temperature > 35:
        alerts.append({
            "measurement_id": measurement["id"],
            "alert_type": "temperature",
            "alert_message": f"Indoor temperature is high: {indoor_temperature}°C",
            "severity": "medium"
        })

    if rain_sensor == 1:
        alerts.append({
            "measurement_id": measurement["id"],
            "alert_type": "rain_sensor",
            "alert_message": "Rain detected by sensor",
            "severity": "medium"
        })

    if prediction_result == "rain":
        alerts.append({
            "measurement_id": measurement["id"],
            "alert_type": "rain_prediction",
            "alert_message": "Rain predicted by AI model",
            "severity": "medium"
        })

    return alerts