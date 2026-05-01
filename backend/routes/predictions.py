from flask import Blueprint, jsonify
from utils.supabase_client import supabase

prediction_bp = Blueprint('prediction', __name__)

@prediction_bp.route('/predictions/latest', methods=['GET'])
def get_latest_prediction():
    try:
        response = (
            supabase
            .table("predictions")
            .select("*")
            .order("created_at", desc=True)
            .limit(1)
            .execute()
        )

        if not response.data:
            return jsonify({"message": "No prediction found"}), 404

        return jsonify({
            "message": "Latest prediction retrieved successfully",
            "data": response.data[0]
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@prediction_bp.route('/predictions', methods=['GET'])
def get_predictions():
    try:
        response = (
            supabase
            .table("predictions")
            .select("*")
            .order("created_at", desc=True)
            .execute()
        )

        return jsonify({
            "message": "Predictions retrieved successfully",
            "data": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500