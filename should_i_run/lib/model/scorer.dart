import 'package:should_i_run/model/api_handler.dart';

class Scorer {
  ApiHandler apiHandler;
  int score;

  void init(ApiHandler apih) {
    apiHandler = apih;
    score = -1;
  }

  double calc_temp_between_minus_one_and_twelve(double te) {
    return (100.0 / 13.0) * (te + 1.0);
  }

  double calc_temp_between_twelve_and_thirty_five(double te) {
    return (-100.0 / 23.0) * (te - 35);
  }

  double calc_humidity(double hu) {
    return ((-80.0 / 100.0) * hu) + 100.0;
  }

  double calcTempScore(double temp) {
    if (temp <= -1.0) {
      return 0.0;
    } else if (temp > -1.0 && temp <= 12.0) {
      return calc_temp_between_minus_one_and_twelve(temp);
    } else if (temp > 12.0 && temp < 35.0) {
      return calc_temp_between_twelve_and_thirty_five(temp);
    } else if (temp >= 35.0) {
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
    }
  }

  double calcHumidityScore(double hum) {
    if (hum < 0.0) {
      return 100.0;
    } else if (hum >= 0.0 && hum <= 100.0) {
      return calc_humidity(hum);
    } else if (hum > 100.0) {
      return 20.0;
    }
  }
}
