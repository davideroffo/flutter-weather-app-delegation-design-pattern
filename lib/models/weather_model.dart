import 'package:flutter/material.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';

class WeatherModel {
  int conditionId;
  String cityName;
  double temperature;

  String get temperatureString {
    return temperature.toStringAsFixed(1);
  }

  IconData get conditionIcon {
    if (conditionId < 300) {
      return WeatherIcons.wiDayThunderstorm;
    } else if (conditionId < 400) {
      return WeatherIcons.wiDayRain;
    } else if (conditionId < 600) {
      return WeatherIcons.wiRain;
    } else if (conditionId < 700) {
      return WeatherIcons.wiDaySnow;
    } else if (conditionId < 800) {
      return WeatherIcons.wiStrongWind;
    } else if (conditionId == 800) {
      return Icons.wb_sunny_outlined;
    } else if (conditionId <= 804) {
      return WeatherIcons.wiCloud;
    } else {
      return Icons.help_outline;
    }
  }

  WeatherModel(int conditionId, String cityName, double temperature) {
    this.conditionId = conditionId;
    this.cityName = cityName;
    this.temperature = temperature;
  }
}
