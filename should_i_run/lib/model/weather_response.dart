class WeatherResponse {
  final double tempResult;
  final double precipResult;
  final int airQualityResult;
  final double humidityResult;

  WeatherResponse({
    this.tempResult,
    this.precipResult,
    this.airQualityResult,
    this.humidityResult,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      tempResult: json['current']['temp_c'],
      precipResult: json['current']['precip_mm'],
      airQualityResult: json['current']['air_quality']['us-epa-index'],
      humidityResult: json['current']['humidity'] * 1.0,
    );
  }
}
