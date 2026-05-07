import 'package:flutter/material.dart';
import 'package:front_endd/app/widgets/app_button.dart';
import 'package:front_endd/app/widgets/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/prediction_controller.dart';

class PredictionView extends GetView<PredictionController> {
  const PredictionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prédictions IA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF1A1A2E),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1A1A2E),
            size: 20,
          ),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LastPredictionCard(controller: controller),
              const SizedBox(height: 24),
              const Text(
                'Historique des prédictions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              _HistoryList(controller: controller),
            ],
          ),
        );
      }),
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const AppButton(currentIndex: 3),
    );
  }
}

class _LastPredictionCard extends StatelessWidget {
  final PredictionController controller;

  const _LastPredictionCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isRain = controller.predictionLabel.value == 'Pluie probable';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dernière prédiction',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            controller.predictionDate.value,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              SizedBox(
                width: 72,
                height: 60,
                child: isRain ? _LargeRainIcon() : _SmallSunIcon(),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.predictionLabel.value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                  Text(
                    '${controller.probabilityRain.value}%',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      height: 1.1,
                    ),
                  ),
                  const Text(
                    'Probabilité de pluie',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: controller.probabilityRain.value / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF2979FF),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PercentLabel(
                percent: controller.probabilityNoRain.value,
                label: 'Pas de pluie',
                color: const Color(0xFF555555),
                alignEnd: false,
              ),
              _PercentLabel(
                percent: controller.probabilityRain.value,
                label: 'Pluie',
                color: const Color(0xFF2979FF),
                alignEnd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final PredictionController controller;

  const _HistoryList({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Aucune prédiction trouvée'),
        ),
      );
    }

    return Column(
      children: controller.history.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _HistoryCard(item: item),
        );
      }).toList(),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isRain = item['isRain'] == true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 40,
            child: isRain ? _SmallRainIcon() : _SmallSunIcon(),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['date'] ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['label'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isRain ? const Color(0xFFE3EEFF) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${item['probability']}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isRain
                    ? const Color(0xFF2979FF)
                    : const Color(0xFF43A047),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentLabel extends StatelessWidget {
  final int percent;
  final String label;
  final Color color;
  final bool alignEnd;

  const _PercentLabel({
    required this.percent,
    required this.label,
    required this.color,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          '$percent%',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
        ),
      ],
    );
  }
}

class _LargeRainIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 8,
          top: 0,
          child: _CloudShape(size: 42, color: const Color(0xFFB0BEC5)),
        ),
        Positioned(
          left: 0,
          top: 10,
          child: _CloudShape(size: 50, color: const Color(0xFF90A4AE)),
        ),
        Positioned(left: 10, top: 42, child: _RainDrops()),
      ],
    );
  }
}

class _CloudShape extends StatelessWidget {
  final double size;
  final Color color;

  const _CloudShape({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
    );
  }
}

class _RainDrops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 2,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF64B5F6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallRainIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 4,
          top: 0,
          child: _CloudShape(size: 28, color: const Color(0xFFB0BEC5)),
        ),
        Positioned(
          left: 0,
          top: 8,
          child: _CloudShape(size: 34, color: const Color(0xFF90A4AE)),
        ),
        Positioned(
          left: 6,
          top: 28,
          child: Row(
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Container(
                  width: 2,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF64B5F6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallSunIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 4,
          top: 0,
          child: _CloudShape(size: 34, color: const Color(0xFFB0BEC5)),
        ),
        Positioned(
          left: 0,
          top: 8,
          child: _CloudShape(size: 42, color: const Color(0xFF90A4AE)),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD54F),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
