from routes.notification import send_alert_notification_to_all


def generate_alerts(measurement, prediction):
    alerts = []

    gas_value = measurement["gas_value"]
    indoor_temperature = measurement["indoor_temperature"]
    indoor_humidity = measurement["indoor_humidity"]
    rain_sensor = measurement["rain_sensor"]
    prediction_result = prediction["prediction_result"]

    # 🚨 Gas Alert
    if gas_value > 1000:
        alert = {
            "measurement_id": measurement["id"],
            "alert_type": "gas",
            "alert_message": f"Gas level is high: {gas_value}",
            "severity": "high"
        }

        alerts.append(alert)

        send_alert_notification_to_all(
            "🚨 Gas Alert",
            alert["alert_message"]
        )

    # 🌡️ Temperature Alert
    if indoor_temperature > 35:
        alert = {
            "measurement_id": measurement["id"],
            "alert_type": "temperature",
            "alert_message": f"Indoor temperature is high: {indoor_temperature}°C",
            "severity": "medium"
        }

        alerts.append(alert)

        send_alert_notification_to_all(
            "🌡️ Temperature Alert",
            alert["alert_message"]
        )

    # 💧 High Humidity Alert
    if indoor_humidity > 80:
        alert = {
            "measurement_id": measurement["id"],
            "alert_type": "humidity",
            "alert_message": f"Indoor humidity is high: {indoor_humidity}%",
            "severity": "medium"
        }

        alerts.append(alert)

        send_alert_notification_to_all(
            "💧 Humidity Alert",
            alert["alert_message"]
        )

    # 🏜️ Low Humidity Alert
    if indoor_humidity < 20:
        alert = {
            "measurement_id": measurement["id"],
            "alert_type": "low_humidity",
            "alert_message": f"Indoor humidity is very low: {indoor_humidity}%",
            "severity": "medium"
        }

        alerts.append(alert)

        send_alert_notification_to_all(
            "🏜️ Low Humidity Alert",
            alert["alert_message"]
        )

    # 🌧️ Rain Sensor Alert
    if rain_sensor == 1:
        alert = {
            "measurement_id": measurement["id"],
            "alert_type": "rain_sensor",
            "alert_message": "Rain detected by sensor",
            "severity": "medium"
        }

        alerts.append(alert)

        send_alert_notification_to_all(
            "🌧️ Rain Alert",
            alert["alert_message"]
        )

    # 🤖 AI Prediction Alert
    if prediction_result == "rain":
        alert = {
            "measurement_id": measurement["id"],
            "alert_type": "rain_prediction",
            "alert_message": "Rain predicted by AI model",
            "severity": "medium"
        }

        alerts.append(alert)

        send_alert_notification_to_all(
            "🤖 AI Rain Prediction",
            alert["alert_message"]
        )

    return alerts