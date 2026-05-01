# 📌 IoT Smart Environment Monitoring System

## 🧠 Description

Système intelligent de surveillance environnementale basé sur :

* 🌡️ Capteurs IoT (ESP32)
* ⚙️ Backend Flask (API + Machine Learning)
* ☁️ Supabase (PostgreSQL)
* 📊 Dashboard Angular
* 📱 Application mobile Flutter

---

## 🏗️ Architecture globale

```
ESP32 (Sensors)
↓
Flask Backend (API + ML)
↓
Supabase (Database)
↓
Angular Dashboard + Flutter Mobile App
```

---

## 📁 Structure du projet

```
iot-project/
│
└── backend/
    │
    ├── app.py              # Point d'entrée Flask
    ├── config.py           # Configuration du projet
    ├── requirements.txt    # Dépendances
    │
    ├── models/             # Modèles de données
    ├── routes/             # Endpoints API
    ├── services/           # Logique métier (ML, météo, alertes)
    ├── utils/              # Connexion DB, helpers
    │
    ├── saved_models/       # Modèles ML sauvegardés
    │   ├── random_forest_model.joblib
    │   └── scaler.joblib
    │
    └── venv/               # Environnement virtuel (ignoré)
```

---

## ⚙️ Installation

### 1. Cloner le projet

```
git clone <repo-url>
cd iot-project/backend
```

---

### 2. Créer un environnement virtuel

```
python -m venv venv
```

---

### 3. Activer l’environnement

#### Windows

```
venv\Scripts\activate
```

#### Linux / Mac

```
source venv/bin/activate
```

---

### 4. Installer les dépendances

```
pip install -r requirements.txt
```

---

## 🚀 Lancer le serveur

```
python app.py
```

API disponible sur :

```
http://127.0.0.1:5000
```

---

## 📡 Endpoints API

### 🔹 Measurements

* `POST /measurements`
* `GET /measurements`
* `GET /measurements/latest`

### 🔹 Predictions

* `GET /predictions`
* `GET /predictions/latest`

### 🔹 Alerts

* `GET /alerts`
* `GET /alerts/unread`
* `PATCH /alerts/{id}/read`

---

## 🤖 Machine Learning

* Modèle : Random Forest
* Accuracy : ~99%
* F1-score : ~0.99
* Sauvegarde :

  * `.joblib` (recommandé)
  * `.pkl` (alternative)

---

## 📊 Fonctionnalités

* Collecte de données IoT (ESP32)
* Intégration API météo
* Prédiction de pluie (ML)
* Détection d’anomalies
* Génération d’alertes
* Historique des données
* Visualisation via Web & Mobile

---

## 🧪 Technologies utilisées

* Python (Flask)
* Scikit-learn
* PostgreSQL (Supabase)
* Angular
* Flutter
* ESP32

---

## 🎯 Objectif

Créer un système intelligent combinant :

```
IoT + Machine Learning + Cloud + Web + Mobile
```

---

## ⚠️ Important

* Le dossier `venv/` est ignoré via `.gitignore`
* Les modèles ML doivent être placés dans `saved_models/`

---

## 👨‍💻 Auteur

Projet académique – IoT + Machine Learning
Niveau : 🔥 Projet avancé (PFE ready)
