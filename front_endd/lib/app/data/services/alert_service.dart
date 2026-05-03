import 'api_client.dart';

class AlertService {
  final api = ApiClient();

  Future getAlerts() async {
    return await api.getData('/alerts');
  }

  Future markAsRead(String id) async {
    return await api.patchData('/alerts/$id/read', {"is_read": true});
  }
}