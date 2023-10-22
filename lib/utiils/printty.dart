import 'package:flutter/foundation.dart';

printty(dynamic text) {
  if (kDebugMode) {
    print(text.toString());
  }
}
