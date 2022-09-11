import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "new_update": "New Update",
          "download": "download",
          "downloading": "downloading",
          "installing": "installing",
          "error": "Failed to install update!"
        },
        "hu_hu": {
          "new_update": "Új frissítés",
          "download": "Letöltés",
          "downloading": "Letöltés",
          "installing": "Telepítés",
          "error": "Nem sikerült telepíteni a frissítést!"
        },
        "de_de": {
          "new_update": "Neues Update",
          "download": "herunterladen",
          "downloading": "Herunterladen",
          "installing": "Installation",
          "error": "Update konnte nicht installiert werden!"
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
