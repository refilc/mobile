import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "next": "Next",
          "remaining": "%d mins".one("%d min"),
          "upcoming": "Upcoming lessons:",
        },
        "hu_hu": {
          "next": "Következő",
          "remaining": "%d perc".one("%d perc"),
          "upcoming": "Következő órák:",
        },
        "de_de": {
          "next": "Nächste",
          "remaining": "%d Minuten".one("%d Minute"),
          "upcoming": "Nächste Stunde:",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
