import 'api_client.dart';
class MeasurementService {
  final api = ApiClient();

  Future getLatest() async {
    return await api.getData('/measurements/latest');
  }

  Future getHistory(String from, String to) async {
    return await api.getData('/measurements/by-period?from=$from&to=$to');
  }
  Future getByPeriod(String from, String to) async {
  return await api.getData(
    '/measurements/by-period?from=$from&to=$to'
  );
}
}