class ForecastScorer {
  double tempResult;
  double precipResult;
  int airQualityResult;
  double humidityResult;

  int score;

  ForecastScorer(double tempR, double precipR, int aiqR, double humR) {
    this.tempResult = tempR;
    this.precipResult = precipR;
    this.airQualityResult = aiqR;
    this.humidityResult = humR;
    this.score = -1;
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
    if (precip == 0.0) {
      return 100.0;
    } else if (precip > 0.0 && precip <= 4.0) {
      return 40.0;
    } else if (precip > 4.0 && precip <= 8.0) {
      return 15.0;
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
          return 70.0;
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
    double ts = calcTempScore(tempResult);
    double ps = calcPrecipScore(precipResult);
    double ais = calcAirQualityScore(airQualityResult);
    double hs = calcHumidityScore(humidityResult);

    if (ts == 0.0 || ps == 0.0 || ais == 0.0 || hs == 0.0) {
      score = 0;
    } else {
      score = ((1.0 / 4.0) * (ts + ps + ais + hs)).toInt();
    }
  }

  int getScore() {
    return score;
  }
}
