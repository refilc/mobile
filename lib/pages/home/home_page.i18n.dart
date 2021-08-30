import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "goodmorning": "Good morning, %s!",
          "goodafternoon": "Good afternoon, %s!",
          "goodevening": "Good evening, %s!",
        },
        "hu_hu": {
          "goodmorning": "Jó reggelt, %s!",
          "goodafternoon": "Szép napot, %s!",
          "goodevening": "Szép estét, %s!",
        },
        "de_de": {
          "goodmorning": "Guten morgen, %s!",
          "goodafternoon": "Guten Tag, %s!",
          "goodevening": "Guten Abend, %s!",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
