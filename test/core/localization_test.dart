import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_base/core/localization/localization.dart';

void main() {
  test('supports English and Arabic with English as the fallback', () {
    expect(
      AppLocalization.supportedLocales,
      containsAll(<Locale>[AppLocalization.english, AppLocalization.arabic]),
    );
    expect(AppLocalization.fallbackLocale, AppLocalization.english);
  });
}
