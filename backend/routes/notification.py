from flask import Blueprint, request, jsonify
from services.notification_service import NotificationService

notification_bp = Blueprint('notification_bp', __name__)
service = NotificationService()

# 🔹 Stock les tokens en mémoire
fcm_tokens = []

@notification_bp.route('/register-token', methods=['POST'])
def register_token():
    data = request.json
    token = data.get("token")

    if token and token not in fcm_tokens:
        fcm_tokens.append(token)
        print(f"✅ Token enregistré: {token[:20]}...")

    return jsonify({"success": True, "message": "Token enregistré"})
# 🔹 Afficher tous les tokens enregistrés
@notification_bp.route('/get-tokens', methods=['GET'])
def get_tokens():
    return jsonify({
        "success": True,
        "count": len(fcm_tokens),
        "tokens": fcm_tokens
    })
@notification_bp.route('/send-notification', methods=['POST'])
def send_notification():
    data = request.json
    title = data.get("title")
    body = data.get("body")

    if not fcm_tokens:
        return jsonify({"success": False, "error": "Aucun token enregistré"})

    results = []
    for token in fcm_tokens:
        result = service.send_notification(token, title, body)
        results.append(result)

    return jsonify({"success": True, "results": results})

def send_alert_notification_to_all(title, body):
    results = []

    if not fcm_tokens:
        print("⚠️ Aucun token FCM enregistré")
        return results

    for token in fcm_tokens:
        result = service.send_notification(token, title, body)
        results.append(result)

    return results