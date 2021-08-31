import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'settings_screen.i18n.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  static void show(BuildContext context) => showDialog(context: context, builder: (context) => PrivacyView(), barrierDismissible: true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("privacy".i18n),
              ),
              SelectableLinkify(
                text: """
A Filc Napló egy kliensalkalmazás, segítségével az e-Kréta rendszeréből letöltheted és felhasználóbarát módon megjelenítheted az adataidat. Tanulmányi adataid csak közvetlenül az alkalmazás és a Kréta-szerverek között közlekednek, titkosított kapcsolaton keresztül.
A Filc fejlesztői és üzemeltetői a tanulmányi adataidat semmilyen célból nem másolják, nem tárolják és harmadik félnek nem továbbítják. Ezeket így az e-Kréta Informatikai Zrt. kezeli, az ő tájékoztatójukat itt találod: https://tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038. Azok törlésével vagy módosítával kapcsolatban keresd az osztályfőnöködet vagy az iskolád rendszergazdáját.
Az alkalmazás néhány adat letöltéséhez (például: iskolalista, támogatók listája, konfiguráció) ugyan igénybe veszi a Filc Napló weboldalát (filcnaplo.hu), viszont oda nem tölt fel semmit.
Az alkalmazás belépéskor a GitHub API segítségével ellenőrzi, hogy elérhető-e új verzió, és kérésre innen is tölti le a telepítőt.
Amikor az alkalmazás hibába ütközik, lehetőséged van egy erről szóló jelentést továbbítani a Filc Napló Discord szerverére. Ez személyes információt nem tartalmaz, viszont az app futásáról, eszközöd típusáról részletesen beszámol, ezért küldés előtt mindenképp nézd át a jelentés tartalmát. Ezt a küldés előtt megjelenő képernyőn teheted meg.
A hibajelentésekhez csak a fejlesztők férnek hozzá (@DEV rangú felhasználók).
Ha az adataiddal kapcsolatban bármilyen kérdésed van (törlés, módosítás, adathordozás), keress minket a filcnaplo@filcnaplo.hu címen.
Az alkalmazás használatával jelzed, hogy ezt a tájékoztatót tudomásul vetted.
Utolsó módosítás: 2021. 04. 19.
A tájékoztató korábbi változatai: https://github.com/filc/filc.github.io/commits/master/docs/privacy
              """,
                onOpen: (link) => launch(link.url,
                    customTabsOption: CustomTabsOption(
                      toolbarColor: AppColors.of(context).background,
                      showPageTitle: true,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
