import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/history_controller.dart';
import '../../../widgets/app_button.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        title: const Text(
          "Historique",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: const AppButton(currentIndex: 1),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            children: [
              _periodSelector(),
              const SizedBox(height: 22),

              _chartCard(
                title: "Température (°C)",
                spots: controller.temperatureSpots,
                lineColor: const Color(0xff2087c8),
                fillColor: const Color(0xff2087c8).withOpacity(0.12),
              ),

              const SizedBox(height: 22),

              _chartCard(
                title: "Humidité (%)",
                spots: controller.humiditySpots,
                lineColor: const Color(0xff22b36b),
                fillColor: const Color(0xff22b36b).withOpacity(0.12),
              ),

              const SizedBox(height: 22),

              _chartCard(
                title: "Gaz (ppm)",
                spots: controller.gasSpots,
                lineColor: const Color(0xffe98a18),
                fillColor: const Color(0xffe98a18).withOpacity(0.12),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _periodSelector() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedPeriod.value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
          items: controller.periods
              .map(
                (period) =>
                    DropdownMenuItem(value: period, child: Text(period)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              controller.onPeriodChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required List<FlSpot> spots,
    required Color lineColor,
    required Color fillColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: LineChart(
              LineChartData(
                minY: _minY(spots),
                maxY: _maxY(spots),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (_maxY(spots) - _minY(spots)) / 3,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.18),
                      strokeWidth: 1,
                      dashArray: [6, 6],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: _bottomInterval(spots),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          controller.xLabel(value),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: fillColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _minY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final min = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    return min - 2;
  }

  double _maxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 10;
    final max = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return max + 2;
  }

  double _bottomInterval(List<FlSpot> spots) {
    if (spots.length <= 8) return 1;
    if (spots.length <= 15) return 3;
    return 6;
  }
}
