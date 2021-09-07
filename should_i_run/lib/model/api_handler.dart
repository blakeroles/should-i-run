import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:should_i_run/model/weather_response.dart';

class WeatherApiHandler {
  final String urlString1 = 'http://api.weatherapi.com/v1/forecast.json?key=';
  final String urlString2 = '&q=';
  final String urlString3 = '&days=2&aqi=yes&alerts=no';
  final String apiKey = env['WEATHER_API_KEY'];
  String location;

  WeatherApiHandler(String loc) {
    this.location = loc;
  }

  Future<WeatherResponse> fetchWeatherData() async {
    String httpString =
        urlString1 + apiKey + urlString2 + location + urlString3;

    final response = await http.get(Uri.parse(httpString));

    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather information');
    }
  }
}
