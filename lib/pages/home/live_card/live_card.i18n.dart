import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "next": "Next",
          "remaining": "%d mins".one("%d min"),
          "pause": "Pause",
          "go to room": "Go to room %s.",
          "stay": "Maradj a helyeden.",
        },
        "hu_hu": {
          "next": "Következő",
          "remaining": "%d perc".one("%d perc"),
          "pause": "Szünet",
          "go to room": "Menj a(z) %s terembe.",
          "stay": "Maradj a helyeden.",
        },
        "de_de": {
          "next": "Nächste",
          "remaining": "%d Minuten".one("%d Minute"),
          "pause": "Pause",
          "go to room": "Gehe zu Raum %s.",
          "stay": "Maradj a helyeden.",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
