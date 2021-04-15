import 'package:clima/models/weather_model.dart';

abstract class WeatherManagerDelegate {
  void didUpdateWeather(WeatherModel weatherModel);
  void didFailWithError(Error error);
}
