import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Grades": "Grades",
          "Ghost Grades": "Grades",
          "Subjects": "Subjects",
          "empty": "You don't have any subjects.",
          "annual_average": "Annual average"
        },
        "hu_hu": {
          "Grades": "Jegyek",
          "Ghost Grades": "Szellem jegyek",
          "Subjects": "Tantárgyak",
          "empty": "Még nincs egy tárgyad sem.",
          "annual_average": "Éves átlag"
        },
        "de_de": {
          "Grades": "Noten",
          "Ghost Grades": "Geist Noten",
          "Subjects": "Fächer",
          "empty": "Sie haben keine Fächer.",
          "annual_average": "Jahresdurchschnitt"
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
