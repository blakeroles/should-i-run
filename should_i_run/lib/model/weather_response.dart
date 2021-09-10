class WeatherResponse {
  final double tempResult;
  final double precipResult;
  final int airQualityResult;
  final double humidityResult;
  final String name;
  final String region;
  final String country;
  final String localTime;
  final List<dynamic> dayOneHourData;
  final List<dynamic> dayTwoHourData;

  WeatherResponse(
      {this.tempResult,
      this.precipResult,
      this.airQualityResult,
      this.humidityResult,
      this.name,
      this.region,
      this.country,
      this.localTime,
      this.dayOneHourData,
      this.dayTwoHourData});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      tempResult: json['current']['temp_c'],
      precipResult: json['current']['precip_mm'],
      airQualityResult: json['current']['air_quality']['us-epa-index'],
      humidityResult: json['current']['humidity'] * 1.0,
      name: json['location']['name'],
      region: json['location']['region'],
      country: json['location']['country'],
      localTime: json['location']['localtime'],
      dayOneHourData: json['forecast']['forecastday'][0]['hour'],
      dayTwoHourData: json['forecast']['forecastday'][1]['hour'],
    );
  }
}
