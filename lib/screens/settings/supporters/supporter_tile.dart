import 'package:filcnaplo/models/supporter.dart';
import 'package:flutter/material.dart';
import 'supporters.i18n.dart';

class SupporterTile extends StatelessWidget {
  final Supporter supporter;

  const SupporterTile(this.supporter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    String suffix = "";

    switch (supporter.platform) {
      case "patreon":
        color = const Color(0xFFE7513B);
        suffix = "/ " + "month".i18n.substring(0, 2);
        break;
      // case "twitch":
      //   color = Color(0xFFA66BFF);
      //   suffix = "/ " + "month".i18n.substring(0, 2);
      //   break;
      case "donate":
        color = Colors.yellow.shade600;
        break;
    }

    return ListTile(
      leading: Container(
        width: 16.0,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          width: 16.0,
          height: 16.0,
        ),
      ),
      title: Text(
        supporter.name,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
      trailing: Text(supporter.amount + " " + suffix),
    );
  }
}
