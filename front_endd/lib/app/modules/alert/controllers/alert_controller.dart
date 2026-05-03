import 'package:get/get.dart';
import '../../../data/services/alert_service.dart';

enum AlertSeverity { elevee, moyenne, faible }

enum AlertTab { toutes, nonLues, lues }

enum AlertIconType { warning, cloud, info }

class AlertModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final AlertSeverity severity;
  final AlertIconType iconType;
  bool isRead;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.severity,
    required this.iconType,
    this.isRead = false,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'].toString(),
      title: _titleFromType(json['alert_type']),
      description: json['alert_message'] ?? '',
      time: _formatTime(json['created_at']),
      severity: _severityFromJson(json['severity']),
      iconType: _iconFromType(json['alert_type']),
      isRead: json['is_read'] ?? false,
    );
  }

  static String _titleFromType(dynamic type) {
    switch (type) {
      case 'gas':
        return 'Gaz détecté';
      case 'rain':
      case 'rain_sensor':
        return 'Pluie détectée';
      case 'temperature':
        return 'Température élevée';
      case 'humidity':
        return 'Humidité anormale';
      default:
        return 'Alerte';
    }
  }

  static AlertSeverity _severityFromJson(dynamic severity) {
    switch (severity) {
      case 'high':
      case 'elevee':
      case 'élevée':
        return AlertSeverity.elevee;
      case 'medium':
      case 'moyenne':
        return AlertSeverity.moyenne;
      default:
        return AlertSeverity.faible;
    }
  }

  static AlertIconType _iconFromType(dynamic type) {
    switch (type) {
      case 'gas':
        return AlertIconType.warning;
      case 'rain':
      case 'rain_sensor':
        return AlertIconType.cloud;
      default:
        return AlertIconType.info;
    }
  }

  static String _formatTime(dynamic createdAt) {
  if (createdAt == null) return '';

  String value = createdAt.toString();

  // Supabase stocke souvent en UTC sans "Z"
  if (!value.endsWith('Z') && !value.contains('+')) {
    value = '${value}Z';
  }

  final date = DateTime.tryParse(value)?.toLocal();
  if (date == null) return createdAt.toString();

  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inDays == 0) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  if (diff.inDays == 1) {
    return 'Hier, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  return '${date.day}/${date.month}/${date.year}';
}
}

class AlertController extends GetxController {
  final AlertService alertService = AlertService();

  final selectedTab = AlertTab.toutes.obs;
  final _allAlerts = <AlertModel>[].obs;

  final isLoading = false.obs;

  List<AlertModel> get filteredAlerts {
    switch (selectedTab.value) {
      case AlertTab.nonLues:
        return _allAlerts.where((a) => !a.isRead).toList();
      case AlertTab.lues:
        return _allAlerts.where((a) => a.isRead).toList();
      case AlertTab.toutes:
      default:
        return List.from(_allAlerts);
    }
  }

  int get unreadCount => _allAlerts.where((a) => !a.isRead).length;

  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  void selectTab(AlertTab tab) {
    selectedTab.value = tab;
  }

  Future<void> loadAlerts() async {
    try {
      isLoading.value = true;

      final response = await alertService.getAlerts();
      final List data = response['data'];

      _allAlerts.assignAll(
        data.map((e) => AlertModel.fromJson(e)).toList(),
      );
    } catch (e) {
      print('Erreur AlertController loadAlerts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await alertService.markAsRead(id);

      final index = _allAlerts.indexWhere((a) => a.id == id);
      if (index != -1) {
        _allAlerts[index].isRead = true;
        _allAlerts.refresh();
      }
    } catch (e) {
      print('Erreur markAsRead: $e');
    }
  }

  Future<void> markAllAsRead() async {
    for (final alert in filteredAlerts.where((a) => !a.isRead)) {
      await markAsRead(alert.id);
    }
  }

  void deleteAlert(String id) {
    _allAlerts.removeWhere((a) => a.id == id);
  }
}