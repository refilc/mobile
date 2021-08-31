import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "goodmorning": "Good morning, %s!",
          "goodafternoon": "Good afternoon, %s!",
          "goodevening": "Good evening, %s!",
          "empty": "Nothing to see here.",
          "All": "All",
          "Grades": "Grades",
          "Messages": "Messages",
          "Absences": "Absences",
        },
        "hu_hu": {
          "goodmorning": "Jó reggelt, %s!",
          "goodafternoon": "Szép napot, %s!",
          "goodevening": "Szép estét, %s!",
          "empty": "Nincs itt semmi látnivaló.",
          "All": "Összes",
          "Grades": "Jegyek",
          "Messages": "Üzenetek",
          "Absences": "Hiányok",
        },
        "de_de": {
          "goodmorning": "Guten morgen, %s!",
          "goodafternoon": "Guten Tag, %s!",
          "goodevening": "Guten Abend, %s!",
          "empty": "Hier gibt es nichts zu sehen.",
          "All": "Alles",
          "Grades": "Noten",
          "Messages": "Nachrichten",
          "Absences": "Abwesenheiten",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
