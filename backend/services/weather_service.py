import os
import requests
from dotenv import load_dotenv

load_dotenv()

def get_weather_data():
    api_key = os.getenv("OPENWEATHER_API_KEY")
    city = os.getenv("CITY", "Sfax")
    country_code = os.getenv("COUNTRY_CODE", "TN")

    url = "https://api.openweathermap.org/data/2.5/weather"

    params = {
        "q": f"{city},{country_code}",
        "appid": api_key,
        "units": "metric"
    }

    response = requests.get(url, params=params)

    if response.status_code != 200:
        return None

    data = response.json()

    return {
        "api_pressure": data["main"]["pressure"],
        "api_wind_speed": data["wind"]["speed"],
        "api_cloud_cover": data["clouds"]["all"],
        "api_outside_temperature": data["main"]["temp"],
        "api_outside_humidity": data["main"]["humidity"]
    }


print(get_weather_data())