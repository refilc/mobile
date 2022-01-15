import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Absences": "Absences",
          "Delays": "Delays",
          "Misses": "Misses",
          "empty": "You have no absences.",
          "stat_1": "Excused Absences",
          "stat_2": "Unexcused Absences",
          "stat_3": "Excused Delay",
          "stat_4": "Unexcused Delay",
          "min": "min",
        },
        "hu_hu": {
          "Absences": "Hiányzások",
          "Delays": "Késések",
          "Misses": "Hiányok",
          "empty": "Nincsenek hiányaid.",
          "stat_1": "Igazolt hiányzások",
          "stat_2": "Igazolatlan hiányzások",
          "stat_3": "Igazolt Késés",
          "stat_4": "Igazolatlan Késés",
          "min": "perc",
        },
        "de_de": {
          "Absences": "Abwesenheiten",
          "Delays": "Verspätung",
          "Misses": "Fehlt",
          "empty": "Sie haben keine Abwesenheiten.",
          "stat_1": "Entschuldigte Abwesenheiten",
          "stat_2": "Unentschuldigte Abwesenheiten",
          "stat_3": "Entschuldigte Verspätung",
          "stat_4": "Unentschuldigte Verspätung",
          "min": "min",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
