import 'package:should_i_run/model/api_handler.dart';

class Scorer {
  ApiHandler apiHandler;
  int score;

  void init(ApiHandler apih) {
    apiHandler = apih;
    score = -1;
  }
}
