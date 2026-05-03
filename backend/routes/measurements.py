from flask import Blueprint, request, jsonify
from services.weather_service import get_weather_data
from services.ml_service import predict_rain
from services.alert_service import generate_alerts
from utils.supabase_client import supabase

measurement_bp = Blueprint('measurement', __name__)


@measurement_bp.route('/measurements', methods=['POST'])
def add_measurement():
    data = request.get_json()

    try:
        indoor_temperature = data['temperature']
        indoor_humidity = data['humidity']
        gas_value = data['gas']
        rain_sensor = data['rain']

        weather = get_weather_data()

        if weather is None:
            return jsonify({"error": "Weather API failed"}), 500

        insert_data = {
            "indoor_temperature": indoor_temperature,
            "indoor_humidity": indoor_humidity,
            "gas_value": gas_value,
            "rain_sensor": rain_sensor,
            "api_pressure": weather["api_pressure"],
            "api_wind_speed": weather["api_wind_speed"],
            "api_cloud_cover": weather["api_cloud_cover"],
            "api_outside_temperature": weather["api_outside_temperature"],
            "api_outside_humidity": weather["api_outside_humidity"]
        }

        # 1) Enregistrer la mesure
        measurement_response = supabase.table("measurements").insert(insert_data).execute()
        measurement = measurement_response.data[0]
        measurement_id = measurement["id"]

        # 2) Prédiction ML
        prediction = predict_rain({
            "indoor_temperature": indoor_temperature,
            "indoor_humidity": indoor_humidity,
            "api_wind_speed": weather["api_wind_speed"],
            "api_cloud_cover": weather["api_cloud_cover"],
            "api_pressure": weather["api_pressure"]
        })

        prediction_text = "rain" if prediction["prediction"] == 1 else "no_rain"

        # 3) Enregistrer la prédiction
        prediction_response = supabase.table("predictions").insert({
            "measurement_id": measurement_id,
            "prediction_result": prediction_text,
            "probability_no_rain": prediction["probability_no_rain"],
            "probability_rain": prediction["probability_rain"]
        }).execute()

        saved_prediction = prediction_response.data[0]

        # 4) Générer les alertes
        alerts = generate_alerts(measurement, saved_prediction)

        saved_alerts = []
        if alerts:
            alert_response = supabase.table("alerts").insert(alerts).execute()
            saved_alerts = alert_response.data

        return jsonify({
            "message": "Measurement + prediction + alerts saved successfully",
            "measurement": measurement,
            "prediction": saved_prediction,
            "alerts": saved_alerts
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@measurement_bp.route('/measurements/latest', methods=['GET'])
def get_latest_measurement():
    try:
        response = (
            supabase
            .table("measurements")
            .select("*")
            .order("created_at", desc=True)
            .limit(1)
            .execute()
        )

        if not response.data:
            return jsonify({"message": "No measurement found"}), 404

        return jsonify({
            "message": "Latest measurement retrieved successfully",
            "data": response.data[0]
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@measurement_bp.route('/measurements', methods=['GET'])
def get_measurements():
    try:
        response = (
            supabase
            .table("measurements")
            .select("*")
            .order("created_at", desc=True)
            .execute()
        )

        return jsonify({
            "message": "Measurements retrieved successfully",
            "data": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@measurement_bp.route('/measurements/by-period', methods=['GET'])
def get_measurements_by_period():
    try:
        start_date = request.args.get("from")
        end_date = request.args.get("to")

        query = (
            supabase
            .table("measurements")
            .select("*")
            .order("created_at", desc=False)
        )

        if start_date:
            query = query.gte("created_at", start_date)

        if end_date:
            query = query.lte("created_at", end_date)

        response = query.execute()

        return jsonify({
            "message": "Measurements by period retrieved successfully",
            "data": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500