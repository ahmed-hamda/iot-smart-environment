from flask import Flask
from flask_cors import CORS

from routes.measurements import measurement_bp
from routes.predictions import prediction_bp
from routes.alerts import alert_bp

app = Flask(__name__)
CORS(app)

# 🔹 Register Blueprints
app.register_blueprint(measurement_bp)
app.register_blueprint(prediction_bp)
app.register_blueprint(alert_bp)

# 🔹 Route test
@app.route('/')
def home():
    return {"message": "IoT Backend is running 🚀"}

# 🔹 Run server (IMPORTANT pour ESP32)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)