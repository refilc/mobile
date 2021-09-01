import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "supporters": "Supporters",
          "month": "Month",
          "top": "Top",
          "all": "All",
        },
        "hu_hu": {
          "supporters": "Támogatók",
          "month": "Hónap",
          "top": "Kiemelt",
          "all": "Összes",
        },
        "de_de": {
          "supporters": "Unterstützer",
          "month": "Monat",
          "top": "Top",
          "all": "Alle",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
