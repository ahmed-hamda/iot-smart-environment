<<<<<<< HEAD
# front_endd

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# 📌 IoT Smart Environment Monitoring System

## 🧠 Description

Ce projet est un système intelligent de surveillance environnementale basé sur :

* IoT (ESP32 + capteurs)
* Backend Flask (API + Machine Learning)
* Base de données Supabase (PostgreSQL)
* Dashboard Web (Angular)
* Application Mobile (Flutter)

---

## 🏗️ Architecture

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
├── app.py
├── config.py
├── requirements.txt
│
├── models/
├── routes/
├── services/
├── utils/
│
└── saved_models/
```

---

## ⚙️ Installation

### 1. Cloner le projet

```
git clone <repo-url>
cd iot-project
```

### 2. Créer un environnement virtuel

```
python -m venv venv
```

### 3. Activer l'environnement

#### Windows

```
venv\Scripts\activate
```

#### Linux / Mac

```
source venv/bin/activate
```

### 4. Installer les dépendances

```
pip install -r requirements.txt
```

---

## 🚀 Lancer le projet

```
python app.py
```

API disponible sur :

```
http://127.0.0.1:5000
```

---

## 📡 Endpoints API

* `GET /test`
* `POST /measurements`
* `GET /measurements`
* `GET /predictions`
* `GET /alerts`

---

## 🤖 Machine Learning

* Modèle utilisé : Random Forest
* Accuracy : ~99%
* Sauvegarde : `.joblib` et `.pkl`

---

## 📊 Fonctionnalités

* Collecte des données (ESP32)
* Intégration API météo
* Prédiction de pluie
* Détection d'anomalies
* Alertes en temps réel

---

## 📌 Technologies utilisées

* Flask
* PostgreSQL (Supabase)
* Scikit-learn
* Angular
* Flutter
* ESP32

---

## 🎯 Objectif

Créer un système intelligent combinant :

```
IoT + AI + Cloud + Web + Mobile
```

---

## 👨‍💻 Auteur

Projet académique (PFE / IoT + ML)
>>>>>>> efda20fa5c81073300f676721fbaf1ecbda71046
