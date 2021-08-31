import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:filcnaplo_mobile_ui/common/material_action_button.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/common/screens.i18n.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class SettingsHelper {
  static const Map<String, String> langMap = {"en": "🇬🇧  English", "hu": "🇭🇺  Magyar", "de": "🇩🇪  Deutsch"};

  static const Map<Pages, String> pageTitle = {
    Pages.home: "home",
    Pages.grades: "grades",
    Pages.timetable: "timetable",
    Pages.messages: "messages",
    Pages.absences: "absences",
  };

  static Map<Pages, String> localizedPageTitles() => pageTitle.map((key, value) => MapEntry(key, ScreensLocalization(value).i18n));

  static void language(BuildContext context) {
    showBottomSheetMenu(
      context,
      items: List.generate(langMap.length, (index) {
        String lang = langMap.keys.toList()[index];
        return BottomSheetMenuItem(
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(context, language: lang);
            I18n.of(context).locale = Locale(lang, lang.toUpperCase());
            Navigator.of(context).maybePop();
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(langMap.values.toList()[index]),
              if (lang == I18n.of(context).locale.languageCode)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        );
      }),
    );
  }

  static void startPage(BuildContext context) {
    Map<Pages, IconData> pageIcons = {
      Pages.home: FilcIcons.home,
      Pages.grades: FeatherIcons.bookmark,
      Pages.timetable: FeatherIcons.calendar,
      Pages.messages: FeatherIcons.messageSquare,
      Pages.absences: FeatherIcons.clock,
    };

    showBottomSheetMenu(
      context,
      items: List.generate(Pages.values.length, (index) {
        return BottomSheetMenuItem(
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(context, startPage: Pages.values[index]);
            Navigator.of(context).maybePop();
          },
          title: Row(
            children: [
              Icon(pageIcons[Pages.values[index]], size: 20.0, color: Theme.of(context).colorScheme.secondary),
              SizedBox(width: 16.0),
              Text(localizedPageTitles()[Pages.values[index]] ?? ""),
              Spacer(),
              if (Pages.values[index] == Provider.of<SettingsProvider>(context, listen: false).startPage)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        );
      }),
    );
  }

  static void rounding(BuildContext context) {
    showRoundedModalBottomSheet(
      context,
      child: RoundingSetting(),
    );
  }

  static void theme(BuildContext context) {
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    void Function(ThemeMode) setTheme = (mode) {
      settings.update(context, theme: mode);
      Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(mode);
      Navigator.of(context).maybePop();
    };
    showBottomSheetMenu(context, items: [
      BottomSheetMenuItem(
        onPressed: () => setTheme(ThemeMode.system),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(FeatherIcons.smartphone, size: 20.0, color: Theme.of(context).colorScheme.secondary),
            ),
            Text(SettingsLocalization("system").i18n),
            Spacer(),
            if (settings.theme == ThemeMode.system)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      ),
      BottomSheetMenuItem(
        onPressed: () => setTheme(ThemeMode.light),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(FeatherIcons.sun, size: 20.0, color: Theme.of(context).colorScheme.secondary),
            ),
            Text(SettingsLocalization("light").i18n),
            Spacer(),
            if (settings.theme == ThemeMode.light)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      ),
      BottomSheetMenuItem(
        onPressed: () => setTheme(ThemeMode.dark),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(FeatherIcons.moon, size: 20.0, color: Theme.of(context).colorScheme.secondary),
            ),
            Text(SettingsLocalization("dark").i18n),
            Spacer(),
            if (settings.theme == ThemeMode.dark)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      )
    ]);
  }

  static void accentColor(BuildContext context) {
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    void Function(ThemeMode) setTheme = (mode) {
      settings.update(context, theme: mode);
      Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(mode);
      Navigator.of(context).maybePop();
    };
    showRoundedModalBottomSheet(
      context,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(AccentColor.values.length, (index) {
              return Padding(
                padding: EdgeInsets.all(4.0),
                child: ClipOval(
                  child: Material(
                    color: accentColorMap[AccentColor.values[index]],
                    child: InkWell(
                      onTap: () {
                        settings.update(context, accentColor: AccentColor.values[index]);
                        setTheme(settings.theme);
                        Navigator.of(context).maybePop();
                      },
                      child: Container(
                        width: 54.0,
                        height: 54.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Provider.of<SettingsProvider>(context, listen: false).accentColor == AccentColor.values[index]
                            ? Icon(FeatherIcons.check, color: Colors.black.withOpacity(0.7))
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  static void gradeColors(BuildContext context) {
    showRoundedModalBottomSheet(
      context,
      child: GradeColorsSetting(),
    );
  }
}

// Rounding modal
class RoundingSetting extends StatefulWidget {
  RoundingSetting({Key? key}) : super(key: key);

  @override
  _RoundingSettingState createState() => _RoundingSettingState();
}

class _RoundingSettingState extends State<RoundingSetting> {
  late double r;

  @override
  void initState() {
    super.initState();
    r = Provider.of<SettingsProvider>(context, listen: false).rounding / 10;
  }

  @override
  Widget build(BuildContext context) {
    int g;

    if (4.5 > 4.5.floor() + r) {
      g = 5;
    } else {
      g = 4;
    }

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Slider(
              value: r,
              min: 0.1,
              max: 0.9,
              divisions: 8,
              label: "${r.toStringAsFixed(1)}",
              activeColor: Theme.of(context).colorScheme.secondary,
              thumbColor: Theme.of(context).colorScheme.secondary,
              onChanged: (v) => setState(() => r = v),
            ),
          ),
          Container(
            width: 50.0,
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text("${r.toStringAsFixed(1)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  )),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("4.5", style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Icon(FeatherIcons.arrowRight, color: Colors.grey),
          ),
          GradeValueWidget(GradeValue(g, "", "", 100), fill: true, size: 32.0),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 12.0, top: 6.0),
        child: MaterialActionButton(
          child: Text(SettingsLocalization("done").i18n),
          onPressed: () {
            Provider.of<SettingsProvider>(context, listen: false).update(context, rounding: (r * 10).toInt());
            Navigator.of(context).maybePop();
          },
        ),
      ),
    ]);
  }
}

class GradeColorsSetting extends StatefulWidget {
  GradeColorsSetting({Key? key}) : super(key: key);

  @override
  _GradeColorsSettingState createState() => _GradeColorsSettingState();
}

class _GradeColorsSettingState extends State<GradeColorsSetting> {
  Color currentColor = Color(0);
  late SettingsProvider settings;

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            return ClipOval(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    showRoundedModalBottomSheet(
                      context,
                      child: Column(children: [
                        MaterialColorPicker(
                          selectedColor: settings.gradeColors[index],
                          onColorChange: (v) {
                            setState(() {
                              currentColor = v;
                            });
                          },
                          allowShades: true,
                          elevation: 0,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialActionButton(
                                onPressed: () {
                                  List<Color> colors = List.castFrom(settings.gradeColors);
                                  var defaultColors = SettingsProvider.defaultSettings().gradeColors;
                                  colors[index] = defaultColors[index];
                                  settings.update(context, gradeColors: colors);
                                  Navigator.of(context).maybePop();
                                },
                                child: Text(SettingsLocalization("reset").i18n),
                              ),
                              MaterialActionButton(
                                onPressed: () {
                                  List<Color> colors = List.castFrom(settings.gradeColors);
                                  colors[index] = currentColor.withAlpha(255);
                                  settings.update(context, gradeColors: settings.gradeColors);
                                  Navigator.of(context).maybePop();
                                },
                                child: Text(SettingsLocalization("done").i18n),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ).then((value) => setState(() {}));
                  },
                  child: GradeValueWidget(GradeValue(index + 1, "", "", 0), fill: true, size: 36.0),
                ),
              ),
            );
          }),
        ),
      ),
    ]);
  }
}
