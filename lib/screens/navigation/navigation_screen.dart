import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/helpers/quick_actions.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_mobile_ui/common/system_chrome.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_route.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_route_handler.dart';
import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/status_bar.dart';
import 'package:filcnaplo_mobile_ui/screens/news/news_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/common/screens.i18n.dart';
import 'package:filcnaplo/api/providers/news_provider.dart';
import 'package:filcnaplo/api/providers/sync.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  static NavigationScreenState? of(BuildContext context) => context.findAncestorStateOfType<NavigationScreenState>();

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> with WidgetsBindingObserver {
  late NavigationRoute selected;
  List<String> initializers = [];
  final _navigatorState = GlobalKey<NavigatorState>();

  bool init(String id) {
    if (initializers.contains(id)) return false;

    initializers.add(id);

    return true;
  }

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsProvider>(context, listen: false);
    selected = NavigationRoute();
    selected.index = settings.startPage.index; // set page index to start page

    // add brightness observer
    WidgetsBinding.instance?.addObserver(this);

    // set client User-Agent
    Provider.of<KretaClient>(context, listen: false).userAgent = settings.config.userAgent;

    // Get news
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.restore().then((value) => newsProvider.fetch());

    // Get releases
    updateProvider = Provider.of<UpdateProvider>(context, listen: false);
    updateProvider.fetch();

    // Initial sync
    syncAll(context);
    setupQuickActions();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    if (settings.theme == ThemeMode.system) {
      Brightness? brightness = WidgetsBinding.instance?.window.platformBrightness;
      if (brightness != null) {
        Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark);
      }
    }
    super.didChangePlatformBrightness();
  }

  late SettingsProvider settings;
  late NewsProvider newsProvider;
  late UpdateProvider updateProvider;

  void setPage(String page) => setState(() => selected.name = page);

  @override
  Widget build(BuildContext context) {
    setSystemChrome(context);
    settings = Provider.of<SettingsProvider>(context);
    newsProvider = Provider.of<NewsProvider>(context);

    // Show news
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (newsProvider.show) {
        newsProvider.lock();
        NewsView.show(newsProvider.news[newsProvider.state], context: context).then((value) => newsProvider.release());
      }
    });

    handleQuickActions(context, (page) {
      setPage(page);
      _navigatorState.currentState?.pushReplacementNamed(page);
    });

    return WillPopScope(
      onWillPop: () async {
        if (_navigatorState.currentState?.canPop() ?? false) _navigatorState.currentState?.pop();
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Navigator(
                key: _navigatorState,
                initialRoute: selected.name,
                onGenerateRoute: (settings) => navigationRouteHandler(settings),
              ),
            ),

            // Status bar
            const StatusBar(),

            // Bottom Navigaton Bar
            SafeArea(
              top: false,
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    label: "home".i18n,
                    icon: const Icon(FilcIcons.home),
                  ),
                  BottomNavigationBarItem(
                    label: "grades".i18n,
                    icon: const Icon(FeatherIcons.bookmark),
                  ),
                  BottomNavigationBarItem(
                    label: "timetable".i18n,
                    icon: const Icon(FeatherIcons.calendar),
                  ),
                  BottomNavigationBarItem(
                    label: "messages".i18n,
                    icon: const Icon(FeatherIcons.messageSquare),
                  ),
                  BottomNavigationBarItem(
                    label: "absences".i18n,
                    icon: const Icon(FeatherIcons.clock),
                  ),
                ],
                currentIndex: selected.index,
                onTap: (index) {
                  // Vibrate, then set the active screen
                  if (selected.index != index) {
                    switch (settings.vibrate) {
                      case VibrationStrength.light:
                        HapticFeedback.lightImpact();
                        break;
                      case VibrationStrength.medium:
                        HapticFeedback.mediumImpact();
                        break;
                      case VibrationStrength.strong:
                        HapticFeedback.heavyImpact();
                        break;
                      default:
                    }
                    setState(() => selected.index = index);
                    _navigatorState.currentState?.pushReplacementNamed(selected.name);
                  }
                },
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
