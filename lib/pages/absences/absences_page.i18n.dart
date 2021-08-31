import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Absences": "Absences",
          "Delays": "Delays",
          "Misses": "Misses",
          "empty": "You have no absences.",
        },
        "hu_hu": {
          "Absences": "Hiányzások",
          "Delays": "Késések",
          "Misses": "Hiányok",
          "empty": "Nincsenek hiányaid.",
        },
        "de_de": {
          "Absences": "Abwesenheiten",
          "Delays": "Verzögerungen",
          "Misses": "Fehlt",
          "empty": "Sie haben keine Abwesenheiten.",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
