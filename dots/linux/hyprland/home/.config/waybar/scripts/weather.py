#!/usr/bin/env python

# credits to: https://gist.github.com/bjesus/f8db49e1434433f78e5200dc403d58a3

import argparse
import json
import string as str
from datetime import datetime

import requests

# Get location argument
argParser = argparse.ArgumentParser()
argParser.add_argument("-l", "--location", help="Your wttr location")
argParser.add_argument("-u", "--unit", help="Your unit of measurement")
args = argParser.parse_args()

if args.unit == "C":
    temp_unit = "temp_C"
    hourly_temp_unit = "tempC"
    feels_like_unit = "FeelsLikeC"
    max_temp_unit = "maxtempC"
    min_temp_unit = "mintempC"
    temp_indicator = "°C"
else:
    temp_unit = "temp_F"
    hourly_temp_unit = "tempF"
    feels_like_unit = "FeelsLikeF"
    max_temp_unit = "maxtempF"
    min_temp_unit = "mintempF"
    temp_indicator = "°F"


localization = {
    "en": {
        "feels_like": "Feels like",
        "wind": "Wind",
        "humidity": "Humidity",
        "today": "Today",
        "tomorrow": "Tomorrow",
        "weatherDesc": "weatherDesc",
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind",
    }
}

lang = "en"
text = localization[lang]

WEATHER_CODES = {
    "113": "☀️",
    "116": "⛅️",
    "119": "☁️",
    "122": "☁️",
    "143": "🌫",
    "176": "🌦",
    "179": "🌧",
    "182": "🌧",
    "185": "🌧",
    "200": "⛈",
    "227": "🌨",
    "230": "❄️",
    "248": "🌫",
    "260": "🌫",
    "263": "🌦",
    "266": "🌦",
    "281": "🌧",
    "284": "🌧",
    "293": "🌦",
    "296": "🌦",
    "299": "🌧",
    "302": "🌧",
    "305": "🌧",
    "308": "🌧",
    "311": "🌧",
    "314": "🌧",
    "317": "🌧",
    "320": "🌨",
    "323": "🌨",
    "326": "🌨",
    "329": "❄️",
    "332": "❄️",
    "335": "❄️",
    "338": "❄️",
    "350": "🌧",
    "353": "🌦",
    "356": "🌧",
    "359": "🌧",
    "362": "🌧",
    "365": "🌧",
    "368": "🌨",
    "371": "❄️",
    "374": "🌧",
    "377": "🌧",
    "386": "⛈",
    "389": "🌩",
    "392": "⛈",
    "395": "❄️",
}

data = {}


weather = requests.get(
    "https://{lang}.wttr.in/{location}?format=j1".format(
        lang=lang, location=args.location
    )
).json()


def format_time(time):
    return time.replace("00", "").zfill(2)


def format_temp(temp):
    return (hour[hourly_temp_unit] + "°").ljust(3)


def format_event(event):
    return chances[event] + " " + hour[event] + "%"


def format_chances(hour):
    chances = [
        "chanceoffog",
        "chanceoffrost",
        "chanceofovercast",
        "chanceofrain",
        "chanceofsnow",
        "chanceofsunshine",
        "chanceofthunder",
        "chanceofwindy",
    ]

    probs = {
        text[e]: int(prob) for e, prob in hour.items() if e in chances and int(prob) > 0
    }
    sorted_probs = {e: probs[e] for e in sorted(probs, key=probs.get, reverse=True)}
    conditions = [f"{event} {prob}%" for event, prob in sorted_probs.items()]
    return ", ".join(conditions)


data["text"] = WEATHER_CODES[weather["current_condition"][0]["weatherCode"]] + " "
data["text"] += weather["current_condition"][0][temp_unit] + temp_indicator

weather_desc = text["weatherDesc"]
data[
    "tooltip"
] = f"<b>{weather['current_condition'][0][weather_desc][0]['value']} {weather['current_condition'][0][temp_unit]}°</b>\n"
data[
    "tooltip"
] += f"{text['feels_like']}: {weather['current_condition'][0][feels_like_unit]}°\n"
data[
    "tooltip"
] += f"{text['wind']}: {weather['current_condition'][0]['windspeedKmph']}Km/h\n"
data[
    "tooltip"
] += f"{text['humidity']}: {weather['current_condition'][0]['humidity']}%\n"
for i, day in enumerate(weather["weather"]):
    data["tooltip"] += f"\n<b>"
    if i == 0:
        data["tooltip"] += f"{text['today']}, "
    if i == 1:
        data["tooltip"] += f"{text['tomorrow']}, "
    if i == 2 and "day_after_tomorrow" in text:
        data["tooltip"] += f"{text['day_after_tomorrow']}, "
    data["tooltip"] += f"{day['date']}</b>\n"
    data["tooltip"] += f"⬆️ {day[max_temp_unit]}° ⬇️ {day[min_temp_unit]}° "
    data[
        "tooltip"
    ] += f"🌅 {day['astronomy'][0]['sunrise']} 🌇 {day['astronomy'][0]['sunset']}\n"
    for hour in day["hourly"]:
        if i == 0:
            if int(format_time(hour["time"])) < datetime.now().hour - 2:
                continue
        data[
            "tooltip"
        ] += f"{format_time(hour['time'])} {WEATHER_CODES[hour['weatherCode']]} {format_temp(hour[hourly_temp_unit])} {hour[weather_desc][0]['value']}, {format_chances(hour)}\n"


print(json.dumps(data))
