import 'package:get/get.dart';
import '../../../data/services/measurement_service.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryController extends GetxController {

  final MeasurementService service = MeasurementService();

  // 📊 DATA FOR CHARTS
  var temperatureSpots = <FlSpot>[].obs;
  var humiditySpots = <FlSpot>[].obs;
  var gasSpots = <FlSpot>[].obs;

  var isLoading = false.obs;

  // 📊 PERIODS
  final periods = ["Aujourd'hui", "Semaine", "Mois"];
  var selectedPeriod = "Aujourd'hui".obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  // 🔥 FETCH DATA FROM BACKEND
  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;

      DateTime now = DateTime.now();
      DateTime from;

      // 📊 CHOOSE PERIOD
      if (selectedPeriod.value == "Aujourd'hui") {
        from = now.subtract(const Duration(hours: 24));
      } else if (selectedPeriod.value == "Semaine") {
        from = now.subtract(const Duration(days: 7));
      } else {
        from = now.subtract(const Duration(days: 30));
      }

      final response = await service.getByPeriod(
        from.toIso8601String(),
        now.toIso8601String(),
      );

      final List data = response['data'];

      // 🧹 CLEAR OLD DATA
      temperatureSpots.clear();
      humiditySpots.clear();
      gasSpots.clear();

      // 🔁 FILL CHART DATA
      for (int i = 0; i < data.length; i++) {
        final item = data[i];

        temperatureSpots.add(
          FlSpot(i.toDouble(), item['indoor_temperature'].toDouble()),
        );

        humiditySpots.add(
          FlSpot(i.toDouble(), item['indoor_humidity'].toDouble()),
        );

        gasSpots.add(
          FlSpot(i.toDouble(), item['gas_value'].toDouble()),
        );
      }

    } catch (e) {
      print("Erreur HistoryController: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔁 CHANGE PERIOD (Dropdown)
  void onPeriodChanged(String period) {
    selectedPeriod.value = period;
    fetchHistory();
  }

  // 🧠 LABEL X AXIS (optionnel)
  String xLabel(double value) {
    return value.toInt().toString();
  }
}