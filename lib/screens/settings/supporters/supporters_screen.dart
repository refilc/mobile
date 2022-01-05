import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_mobile_ui/common/dot.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/supporters/supporter_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/models/supporter.dart';
import 'supporters.i18n.dart';

class SupportersScreen extends StatefulWidget {
  const SupportersScreen({Key? key}) : super(key: key);

  @override
  _SupportersScreenState createState() => _SupportersScreenState();
}

class _SupportersScreenState extends State<SupportersScreen> {
  Future<List<Widget>> _buildTiles() async {
    Supporters? supporters = await FilcAPI.getSupporters();

    if (supporters == null) return [];

    List<Widget> tiles = [];

    tiles.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            const Spacer(),
            const Dot(color: Color(0xFFE7513B)),
            const SizedBox(width: 6.0),
            const Text(
              "Patreon",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Dot(color: Colors.yellow.shade600),
            const SizedBox(width: 6.0),
            const Text(
              "Donate",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
          ],
        )));

    tiles.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
      child: Row(
        children: [
          Text("\$ ${supporters.progress}"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: LinearProgressIndicator(
                  minHeight: 12.0,
                  backgroundColor: AppColors.of(context).text.withOpacity(0.1),
                  color: Theme.of(context).colorScheme.secondary,
                  value: supporters.progress / supporters.max,
                ),
              ),
            ),
          ),
          Text("\$ ${supporters.max}"),
        ],
      ),
    ));

    // Top supporters
    if (supporters.top.isNotEmpty) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Panel(
            title: Text("top".i18n),
            child: Column(children: supporters.top.map((supporter) => SupporterTile(supporter)).toList()),
          ),
        ),
      );
    }

    // All supporters
    if (supporters.top.isNotEmpty) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Panel(
            title: Text("all".i18n),
            child: Column(children: supporters.all.map((supporter) => SupporterTile(supporter)).toList()),
          ),
        ),
      );
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _buildTiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) => Container(
          padding: const EdgeInsets.only(top: 28.0),
          child: Column(
            children: [
              ListTile(
                leading: BackButton(color: AppColors.of(context).text),
                title: Text(
                  "supporters".i18n,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _buildTiles();
                    setState(() {});
                  },
                  child: CupertinoScrollbar(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      children: snapshot.data ??
                          [
                            const SizedBox(
                              height: 200.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
