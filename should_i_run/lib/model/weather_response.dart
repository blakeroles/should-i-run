class WeatherResponse {
  final double tempResult;
  final double precipResult;
  final int airQualityResult;
  final double humidityResult;
  final String name;
  final String region;
  final String country;

  WeatherResponse(
      {this.tempResult,
      this.precipResult,
      this.airQualityResult,
      this.humidityResult,
      this.name,
      this.region,
      this.country});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      tempResult: json['current']['temp_c'],
      precipResult: json['current']['precip_mm'],
      airQualityResult: json['current']['air_quality']['us-epa-index'],
      humidityResult: json['current']['humidity'] * 1.0,
      name: json['location']['name'],
      region: json['location']['region'],
      country: json['location']['country'],
    );
  }
}
