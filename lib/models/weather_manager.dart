import 'package:clima/delegates/weather_manager_delegate.dart';
import 'package:clima/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherManager {
  WeatherManagerDelegate delegate;

  final appId = 'YOUR_APP_ID';

  void fetchWeatherByCityName(String cityName) {
    var weatherUrl = _getEndpoint();
    final urlString = '$weatherUrl&q=$cityName';
    _performRequest(urlString);
  }

  void fetchWeatherByLocation(double latitude, double longitude) {
    var weatherUrl = _getEndpoint();
    final urlString = '$weatherUrl&lon=$longitude&lat=$latitude';
    _performRequest(urlString);
  }

  Future<void> _performRequest(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final weather = _parseJSON(response.body);
      delegate?.didUpdateWeather(weather);
    } catch (error) {
      delegate?.didFailWithError(error);
    }
  }

  WeatherModel _parseJSON(String dataString) {
    try {
      final decodedData = json.decode(dataString);
      final id = decodedData["weather"][0]["id"];
      final temp = decodedData["main"]["temp"];
      final name = decodedData["name"];
      final weather = WeatherModel(id, name, temp);
      return weather;
    } catch (error) {
      delegate?.didFailWithError(error);
      return null;
    }
  }

  String _getEndpoint() {
    return 'https://api.openweathermap.org/data/2.5/weather?appid=$appId&units=metric';
  }
}
