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
import 'package:flutter/foundation.dart';
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

  NavigatorState? get navigator => _navigatorState.currentState;

  void customRoute(Route route) => navigator?.pushReplacement(route);

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
    WidgetsBinding.instance.addObserver(this);

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
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    if (settings.theme == ThemeMode.system) {
      Brightness? brightness = WidgetsBinding.instance.window.platformBrightness;
      Provider.of<ThemeModeObserver>(context, listen: false).changeTheme(brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        if (_navigatorState.currentState?.canPop() ?? false) {
          _navigatorState.currentState?.pop();
          if (!kDebugMode) {
            return true;
          }
          return false;
        }

        if (selected.index != 0) {
          setState(() => selected.index = 0);
          _navigatorState.currentState?.pushReplacementNamed(selected.name);
        }

        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Navigator(
                    key: _navigatorState,
                    initialRoute: selected.name,
                    onGenerateRoute: (settings) => navigationRouteHandler(settings),
                  ),
                  Container(
                    height: 8.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(Theme.of(context).brightness == Brightness.light ? .03 : .08), Colors.transparent],
                        stops: const [0.0, 1.0],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Status bar
            Material(
              color: Theme.of(context).backgroundColor,
              child: const StatusBar(),
            ),

            // Bottom Navigaton Bar
            SafeArea(
              top: false,
              child: NavigationBar(
                destinations: [
                  NavigationDestination(
                    label: "home".i18n,
                    icon: const Icon(FilcIcons.home),
                  ),
                  NavigationDestination(
                    label: "grades".i18n,
                    icon: const Icon(FeatherIcons.bookmark),
                  ),
                  NavigationDestination(
                    label: "timetable".i18n,
                    icon: const Icon(FeatherIcons.calendar),
                  ),
                  NavigationDestination(
                    label: "messages".i18n,
                    icon: const Icon(FeatherIcons.messageSquare),
                  ),
                  NavigationDestination(
                    label: "absences".i18n,
                    icon: const Icon(FeatherIcons.clock),
                  ),
                ],
                selectedIndex: selected.index,
                onDestinationSelected: (index) {
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
