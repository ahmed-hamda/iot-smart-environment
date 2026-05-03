import 'package:flutter/material.dart';
import 'package:front_endd/app/widgets/app_button.dart';
import 'package:front_endd/app/widgets/app_colors.dart';
import 'package:get/get.dart';

import '../controllers/alert_controller.dart';

class AlertView extends GetView<AlertController> {
  const AlertView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black87, size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Alertes',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black54),
            onPressed: () {
              // TODO: open filter sheet
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Tab bar ──────────────────────────────────────────
          _AlertTabBar(controller: controller),

          // ── Alert list ───────────────────────────────────────
          Expanded(
            child: Obx(() {
              final alerts = controller.filteredAlerts;
              if (alerts.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune alerte',
                    style: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                );
              }
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: alerts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return _AlertCard(
                    alert: alert,
                    onTap: () => controller.markAsRead(alert.id),
                    onDismiss: () => controller.deleteAlert(alert.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const AppButton(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tab bar
// ─────────────────────────────────────────────────────────
class _AlertTabBar extends StatelessWidget {
  final AlertController controller;
  const _AlertTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Obx(() => Row(
            children: [
              _TabItem(
                label: 'Toutes',
                isSelected:
                    controller.selectedTab.value == AlertTab.toutes,
                onTap: () => controller.selectTab(AlertTab.toutes),
              ),
              _TabItem(
                label: 'Non lues',
                isSelected:
                    controller.selectedTab.value == AlertTab.nonLues,
                onTap: () => controller.selectTab(AlertTab.nonLues),
                badge: controller.unreadCount,
              ),
              _TabItem(
                label: 'Lues',
                isSelected:
                    controller.selectedTab.value == AlertTab.lues,
                onTap: () => controller.selectTab(AlertTab.lues),
              ),
            ],
          )),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badge;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF2980B9)
                          : Colors.black45,
                    ),
                  ),
                  if (badge > 0) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Active underline
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              color: isSelected
                  ? const Color(0xFF2980B9)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Alert card
// ─────────────────────────────────────────────────────────
class _AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _AlertCard({
    required this.alert,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alert.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              _AlertIcon(iconType: alert.iconType, severity: alert.severity),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alert.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          alert.time,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      alert.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Severity badge
                    _SeverityBadge(severity: alert.severity),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Unread dot
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: alert.isRead
                        ? Colors.transparent
                        : _severityDotColor(alert.severity),
                    border: alert.isRead
                        ? Border.all(color: Colors.black12)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _severityDotColor(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.elevee:
        return Colors.redAccent;
      case AlertSeverity.moyenne:
        return const Color(0xFFE67E22);
      case AlertSeverity.faible:
        return const Color(0xFF2980B9);
    }
  }
}

// ─────────────────────────────────────────────────────────
// Alert icon
// ─────────────────────────────────────────────────────────
class _AlertIcon extends StatelessWidget {
  final AlertIconType iconType;
  final AlertSeverity severity;

  const _AlertIcon({required this.iconType, required this.severity});

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor();
    final icon = _icon();
    final color = _iconColor();

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Color _bgColor() {
    switch (severity) {
      case AlertSeverity.elevee:
        return const Color(0xFFFFECEC);
      case AlertSeverity.moyenne:
        return const Color(0xFFFFF3E0);
      case AlertSeverity.faible:
        return const Color(0xFFE3F2FD);
    }
  }

  IconData _icon() {
    switch (iconType) {
      case AlertIconType.warning:
        return Icons.warning_amber_rounded;
      case AlertIconType.cloud:
        return Icons.cloud;
      case AlertIconType.info:
        return Icons.info_outline_rounded;
    }
  }

  Color _iconColor() {
    switch (severity) {
      case AlertSeverity.elevee:
        return Colors.redAccent;
      case AlertSeverity.moyenne:
        return const Color(0xFFE67E22);
      case AlertSeverity.faible:
        return const Color(0xFF2980B9);
    }
  }
}

// ─────────────────────────────────────────────────────────
// Severity badge
// ─────────────────────────────────────────────────────────
class _SeverityBadge extends StatelessWidget {
  final AlertSeverity severity;
  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _borderColor(),
        ),
      ),
    );
  }

  String _label() {
    switch (severity) {
      case AlertSeverity.elevee:
        return 'Elevée';
      case AlertSeverity.moyenne:
        return 'Moyenne';
      case AlertSeverity.faible:
        return 'Faible';
    }
  }

  Color _borderColor() {
    switch (severity) {
      case AlertSeverity.elevee:
        return Colors.redAccent;
      case AlertSeverity.moyenne:
        return const Color(0xFFE67E22);
      case AlertSeverity.faible:
        return const Color(0xFF2980B9);
    }
  }
}