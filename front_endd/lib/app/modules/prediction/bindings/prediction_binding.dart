import 'package:get/get.dart';

import '../controllers/prediction_controller.dart';

class PredictionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionController>(
      () => PredictionController(),
    );
  }
}
