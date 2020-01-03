import 'package:conversation_maker/feature/feature.dart';

class RuntimeBehavior {
  bool isFeatureEnabled(Feature feature) {
    return feature.defaultValue;
  }
}
