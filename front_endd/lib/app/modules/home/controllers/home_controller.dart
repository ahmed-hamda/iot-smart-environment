import 'dart:async';
import 'package:get/get.dart';

import '../../../data/services/measurement_service.dart';
import '../../../data/services/prediction_service.dart';

class HomeController extends GetxController {
  final MeasurementService measurementService = MeasurementService();
  final PredictionService predictionService = PredictionService();

  final temperature = 0.0.obs;
  final humidity = 0.obs;
  final gazPpm = 0.obs;
  final isRaining = false.obs;

  final rainProbability = 0.obs;
  final predictionLabel = ''.obs;

  final isOnline = false.obs;
  final isLoading = false.obs;

  final lastUpdate = ''.obs;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();

    timer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        fetchHomeData();
      },
    );
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;

      final sensors = await measurementService.getLatest();
      final prediction = await predictionService.getLatest();

      final data = sensors['data'];

temperature.value = data['indoor_temperature'].toDouble();
humidity.value = data['indoor_humidity'].toInt();
gazPpm.value = data['gas_value'].toInt();
isRaining.value = data['rain_sensor'] == 1;
      rainProbability.value =
          (prediction['rainProbability'] * 100).toInt();

      predictionLabel.value = prediction['predictionLabel'];

      isOnline.value = true;

      final now = DateTime.now();
      lastUpdate.value =
          '${now.day}/${now.month}/${now.year} • ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      isOnline.value = false;
      print('Erreur HomeController : $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }


  // 📌 LABEL PLUIE
String get rainLabel {
  return isRaining.value ? "Pluie" : "Pas de pluie";
}

// 📊 RATIO (0 → 1)
double get rainProbabilityRatio {
  return rainProbability.value / 100;
}

// 📊 FORMAT %
String get rainProbabilityFormatted {
  return "${rainProbability.value}%";
}

// 📊 PAS DE PLUIE %
String get noRainProbabilityFormatted {
  return "${100 - rainProbability.value}%";
}

// 🔄 REFRESH BUTTON
void onRefreshTapped() {
  fetchHomeData();
}
}