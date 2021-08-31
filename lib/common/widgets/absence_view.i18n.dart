import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Lesson": "Lesson",
          "Excuse": "Excuse",
          "Mode": "Mode",
          "Submit date": "Submit Date",
        },
        "hu_hu": {
          "Lesson": "Óra",
          "Excuse": "Igazolás",
          "Mode": "Típus",
          "Submit date": "Rögzítés dátuma",
        },
        "de_de": {
          "Lesson": "Stunde",
          "Excuse": "Anerkannt",
          "Mode": "Typ",
          "Submit date": "Datum einreichen",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
