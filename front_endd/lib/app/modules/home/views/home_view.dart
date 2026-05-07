import 'package:flutter/material.dart';
import 'package:front_endd/app/modules/home/controllers/home_controller.dart';
import 'package:front_endd/app/widgets/app_button.dart';
import 'package:front_endd/app/widgets/app_colors.dart';
import 'package:get/get.dart';

// ─── HomeView ─────────────────────────────────────────────────────────────────
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildSensorGrid(),
                    const SizedBox(height: 16),
                    _buildPredictionCard(),
                    const SizedBox(height: 16),
                    _buildStatusBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppButton(currentIndex: 0),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          _IconBtn(icon: Icons.menu_rounded, onTap: () {}),
          const Spacer(),
          Column(
            children: [
              const Text(
                'MÉTÉO',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: controller.isOnline.value
                            ? AppColors.accentGreen
                            : AppColors.accentRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.isOnline.value ? 'En ligne' : 'Hors ligne',
                      style: TextStyle(
                        color: controller.isOnline.value
                            ? AppColors.accentGreen
                            : AppColors.accentRed,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          _IconBtn(
            icon: Icons.notifications_none_rounded,
            onTap: () {
              Get.offAllNamed('/alert');
            },
          ),
        ],
      ),
    );
  }

  // ── Sensor Grid (2x2) ──────────────────────────────────────────────────────
  Widget _buildSensorGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('CONDITIONS ACTUELLES'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _SensorCard(
                  icon: Icons.thermostat_rounded,
                  iconColor: AppColors.accentRed,
                  label: 'Température',
                  value: '${controller.temperature.value}',
                  unit: '°C',
                  bgAccent: AppColors.accentRed.withOpacity(0.08),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _SensorCard(
                  icon: Icons.water_drop_rounded,
                  iconColor: AppColors.accent,
                  label: 'Humidité',
                  value: '${controller.humidity.value}',
                  unit: '%',
                  bgAccent: AppColors.accent.withOpacity(0.08),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _SensorCard(
                  icon: Icons.air_rounded,
                  iconColor: AppColors.accentGreen,
                  label: 'Gaz',
                  value: '${controller.gazPpm.value}',
                  unit: ' ppm',
                  bgAccent: AppColors.accentGreen.withOpacity(0.08),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _SensorCard(
                  icon: controller.isRaining.value
                      ? Icons.water_rounded
                      : Icons.wb_sunny_rounded,
                  iconColor: controller.isRaining.value
                      ? AppColors.accent
                      : AppColors.accentAmber,
                  label: 'Pluie',
                  value: controller.rainLabel,
                  unit: '',
                  bgAccent:
                      (controller.isRaining.value
                              ? AppColors.accent
                              : AppColors.accentAmber)
                          .withOpacity(0.08),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Prediction Card ────────────────────────────────────────────────────────
  Widget _buildPredictionCard() {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SectionLabel('PRÉDICTION IA'),
              const Spacer(),
              Obx(
                () => _PillBadge(
                  label: controller.predictionLabel.value,
                  color: controller.rainProbabilityRatio > 0.5
                      ? AppColors.accent
                      : AppColors.accentAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Big percentage
              Obx(
                () => Text(
                  controller.rainProbabilityFormatted,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1,
                    letterSpacing: -2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Probabilité',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'de pluie',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const _AnimatedRainIcon(),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          Obx(() => _RainProgressBar(ratio: controller.rainProbabilityRatio)),
          const SizedBox(height: 10),
          Obx(
            () => Row(
              children: [
                Text(
                  'Beau temps ${controller.noRainProbabilityFormatted}',
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  'Pluie ${controller.rainProbabilityFormatted}',
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Bar ─────────────────────────────────────────────────────────────
  Widget _buildStatusBar() {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.update_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dernière mise à jour',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  controller.lastUpdate.value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: controller.onRefreshTapped,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: AppColors.accent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textTertiary,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: child,
    );
  }
}

class _SensorCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final Color bgAccent;

  const _SensorCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.bgAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bgAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RainProgressBar extends StatelessWidget {
  final double ratio;
  const _RainProgressBar({required this.ratio});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Stack(
          children: [
            // Track
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Fill
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              height: 8,
              width: constraints.maxWidth * ratio.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F8EF7), Color(0xFF2255C4)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _PillBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,

        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}

/// Refined rain cloud icon using layered approach
class _AnimatedRainIcon extends StatelessWidget {
  const _AnimatedRainIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow background
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Main icon
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_rounded,
                size: 34,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: 8,
                      color: AppColors.accent.withOpacity(0.7 - i * 0.1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
