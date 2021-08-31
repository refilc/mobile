import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "timetable": "Timetable",
          "empty": "No school this week!",
          "week": "Week",
        },
        "hu_hu": {
          "timetable": "Órarend",
          "empty": "Ezen a héten nincs iskola.",
          "week": "Hét",
        },
        "de_de": {
          "timetable": "Zeitplan",
          "empty": "Keine Schule diese Woche.",
          "week": "Woche",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
