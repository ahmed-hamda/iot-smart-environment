from flask import Blueprint, jsonify
from utils.supabase_client import supabase

alert_bp = Blueprint('alert', __name__)

@alert_bp.route('/alerts', methods=['GET'])
def get_alerts():
    try:
        response = (
            supabase
            .table("alerts")
            .select("*")
            .order("created_at", desc=True)
            .execute()
        )

        return jsonify({
            "message": "Alerts retrieved successfully",
            "data": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

@alert_bp.route('/alerts/unread', methods=['GET'])
def get_unread_alerts():
    try:
        response = (
            supabase
            .table("alerts")
            .select("*")
            .eq("is_read", False)
            .order("created_at", desc=True)
            .execute()
        )

        return jsonify({
            "message": "Unread alerts retrieved successfully",
            "data": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
from flask import request

@alert_bp.route('/alerts/<int:alert_id>/read', methods=['PATCH'])
def mark_alert_as_read(alert_id):
    try:
        response = (
            supabase
            .table("alerts")
            .update({"is_read": True})
            .eq("id", alert_id)
            .execute()
        )

        return jsonify({
            "message": "Alert marked as read",
            "data": response.data
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500