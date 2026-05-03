import 'package:get/get.dart';
import '../../../data/services/prediction_service.dart';

class PredictionController extends GetxController {
  final PredictionService predictionService = PredictionService();

  final isLoading = false.obs;

  final predictionLabel = ''.obs;
  final probabilityRain = 0.obs;
  final probabilityNoRain = 0.obs;
  final predictionDate = ''.obs;

  final history = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrediction();
  }

  Future<void> loadPrediction() async {
    try {
      isLoading.value = true;

      final latestResponse = await predictionService.getLatest();
      final latest = latestResponse['data'];

      probabilityRain.value =
          ((latest['probability_rain'] ?? 0) * 100).toInt();

      probabilityNoRain.value =
          ((latest['probability_no_rain'] ?? 0) * 100).toInt();

      predictionLabel.value =
          latest['prediction_result'] == 'rain'
              ? 'Pluie probable'
              : 'Pas de pluie';

      predictionDate.value = _formatDate(latest['created_at']);

      final historyResponse = await predictionService.getHistory();
      final List data = historyResponse['data'];

      history.value = data.map((item) {
        final rainPercent =
            ((item['probability_rain'] ?? 0) * 100).toInt();

        return {
          'date': _formatDate(item['created_at']),
          'label': item['prediction_result'] == 'rain'
              ? 'Pluie probable'
              : 'Pas de pluie',
          'probability': rainPercent,
          'isRain': item['prediction_result'] == 'rain',
        };
      }).toList();
    } catch (e) {
      print('Erreur PredictionController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDate(dynamic value) {
  if (value == null) return '';

  String dateValue = value.toString();

  // Supabase stocke souvent en UTC sans "Z"
  if (!dateValue.endsWith('Z') && !dateValue.contains('+')) {
    dateValue = '${dateValue}Z';
  }

  final date = DateTime.tryParse(dateValue)?.toLocal();
  if (date == null) return value.toString();

  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
}