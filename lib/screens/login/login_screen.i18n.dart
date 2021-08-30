import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "username": "Username",
          "usernameHint": "Student ID number",
          "password": "Password",
          "passwordHint": "Date of birth",
          "school": "School",
          "login": "Log in",
          "welcome": "Welcome, %s!",
        },
        "hu_hu": {
          "username": "Felhasználónév",
          "usernameHint": "Oktatási azonosító",
          "password": "Jelszó",
          "passwordHint": "Születési dátum",
          "school": "Iskola",
          "login": "Belépés",
          "welcome": "Üdv, %s!",
        },
        "de_de": {
          "username": "Benutzername",
          "usernameHint": "Ausbildung ID",
          "password": "Passwort",
          "passwordHint": "Geburtsdatum",
          "school": "Schule",
          "login": "Einloggen",
          "welcome": "Wilkommen, %s!",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
