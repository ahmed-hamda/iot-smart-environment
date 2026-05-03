import 'package:get/get.dart';

import '../modules/alert/bindings/alert_binding.dart';
import '../modules/alert/views/alert_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/prediction/bindings/prediction_binding.dart';
import '../modules/prediction/views/prediction_view.dart';
import '../modules/history/views/history_view.dart';



part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.ALERT,
page: () => AlertView(),
      binding: AlertBinding(),
    ),
    GetPage(
      name: _Paths.PREDICTION,
      page: () => const PredictionView(),
      binding: PredictionBinding(),
    ),
  ];
}
