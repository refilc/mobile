import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "missed_exams": "You missed %s exams this week.".one("You missed an exam this week."),
          "missed_exam_contact": "Contact %s, to resolve it!",
        },
        "hu_hu": {
          "missed_exams": "Ezen a héten hiányoztál %s dolgozatról.".one("Ezen a héten hiányoztál egy dolgozatról."),
          "missed_exam_contact": "Keresd %s-t, ha pótolni szeretnéd!",
        },
        "de_de": {
          "missed_exams": "Diese Woche haben Sie %s Prüfungen verpasst.".one("Diese Woche haben Sie eine Prüfung verpasst."),
          "missed_exam_contact": "Wenden Sie sich an %s, um sie zu erneuern!",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
