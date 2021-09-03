import 'package:should_i_run/model/api_handler.dart';

class Scorer {
  ApiHandler apiHandler;
  int score;

  void init(ApiHandler apih) {
    apiHandler = apih;
    score = -1;
  }

  double calcTempBetweenMinusOneAndTwelve(double te) {
    return (100.0 / 13.0) * (te + 1.0);
  }

  double calcTempBetweenTwelveAndThirtyFive(double te) {
    return (-100.0 / 23.0) * (te - 35);
  }

  double calcHumidity(double hu) {
    return ((-80.0 / 100.0) * hu) + 100.0;
  }

  double calcTempScore(double temp) {
    if (temp <= -1.0) {
      return 0.0;
    } else if (temp > -1.0 && temp <= 12.0) {
      return calcTempBetweenMinusOneAndTwelve(temp);
    } else if (temp > 12.0 && temp < 35.0) {
      return calcTempBetweenTwelveAndThirtyFive(temp);
    } else if (temp >= 35.0) {
      return 0.0;
    } else {
      return 0.0;
    }
  }

  double calcPrecipScore(double precip) {
    if (precip <= 0.5) {
      return 100.0;
    } else if (precip > 0.5 && precip <= 4.0) {
      return 70.0;
    } else if (precip > 4.0 && precip <= 8.0) {
      return 25.0;
    } else if (precip > 8.0) {
      return 0.0;
    } else {
      return 0.0;
    }
  }

  double calcAirQualityScore(int air) {
    switch (air) {
      case 1:
        {
          return 100.0;
        }
        break;
      case 2:
        {
          return 80.0;
        }
        break;
      case 3:
        {
          return 50.0;
        }
        break;
      case 4:
        {
          return 0.0;
        }
        break;
      case 5:
        {
          return 0.0;
        }
        break;
      case 6:
        {
          return 0.0;
        }
        break;
      default:
        {
          return 0.0;
        }
        break;
    }
  }

  double calcHumidityScore(double hum) {
    if (hum < 0.0) {
      return 100.0;
    } else if (hum >= 0.0 && hum <= 100.0) {
      return calcHumidity(hum);
    } else if (hum > 100.0) {
      return 20.0;
    } else {
      return 0.0;
    }
  }

  void calcScore() {
    double ts = calcTempScore(apiHandler.tempResult);
    double ps = calcPrecipScore(apiHandler.precipResult);
    double ais = calcAirQualityScore(apiHandler.airQualityResult);
    double hs = calcHumidityScore(apiHandler.humidityResult);

    if (ts == 0.0 || ps == 0.0 || ais == 0.0 || hs == 0.0) {
      score = 0;
    } else {
      score = ((1.0 / 4.0) * (ts + ps + ais + hs)).toInt();
    }
  }
}
