import firebase_admin
from firebase_admin import credentials, messaging
import os

class NotificationService:

    def __init__(self):
        if not firebase_admin._apps:
            # Chemin absolu basé sur l'emplacement du fichier
            base_dir = os.path.dirname(os.path.abspath(__file__))
            cred_path = os.path.join(base_dir, "..", "config", "serviceAccountKey.json")            
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)

    def send_notification(self, token, title, body):
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body
                ),
                token=token
            )
            response = messaging.send(message)
            return {"success": True, "response": response}

        except Exception as e:
            return {"success": False, "error": str(e)}