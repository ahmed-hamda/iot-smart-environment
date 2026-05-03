import 'api_client.dart';
class PredictionService {
  final api = ApiClient();

  Future getLatest() async {
    return await api.getData('/predictions/latest');
  }

  Future getHistory() async {
    return await api.getData('/predictions');
  }
}