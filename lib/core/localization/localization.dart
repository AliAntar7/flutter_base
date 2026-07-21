import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Provides the application's localization API.
///
/// The rest of the application must use this module instead of importing
/// `easy_localization` directly.
abstract final class AppLocalization {
  /// The English application locale.
  static const english = Locale('en');

  /// The Arabic application locale.
  static const arabic = Locale('ar');

  /// Locales supported by the application.
  static const supportedLocales = <Locale>[english, arabic];

  /// Locale used when the device locale is not supported.
  static const fallbackLocale = english;

  static const _translationsPath = 'assets/translations';

  /// Wraps the application with the localization provider.
  static Widget wrap(Widget child) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: fallbackLocale,
      startLocale: english,
      path: _translationsPath,
      useOnlyLangCode: true,
      saveLocale: false,
      child: child,
    );
  }

  /// Returns the current locale from the localization context.
  static Locale localeOf(BuildContext context) => context.locale;

  /// Returns the supported locales from the localization context.
  static Iterable<Locale> supportedLocalesOf(BuildContext context) {
    return context.supportedLocales;
  }

  /// Returns delegates required by Flutter's localization system.
  static Iterable<LocalizationsDelegate<dynamic>> delegatesOf(
    BuildContext context,
  ) {
    return context.localizationDelegates.cast<LocalizationsDelegate<dynamic>>();
  }

  /// Changes the application locale.
  static Future<void> setLocale(BuildContext context, Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      throw ArgumentError.value(locale, 'locale', 'Locale is not supported.');
    }
    await context.setLocale(locale);
  }

  /// Translates [key] using the current application locale.
  static String translate(
    BuildContext context,
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    return context.tr(key, args: args, namedArgs: namedArgs, gender: gender);
  }
}
