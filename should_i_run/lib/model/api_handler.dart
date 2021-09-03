import 'package:http/http.dart' as http;

class ApiHandler {
  double tempResult;
  double precipResult;
  int airQualityResult;
  double humidityResult;

  ApiHandler() {
    this.tempResult = 5.0;
    this.precipResult = 2.0;
    this.airQualityResult = 2;
    this.humidityResult = 20.0;
  }

  Future<http.Response> fetchWeatherData() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }
}
