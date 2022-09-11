import 'package:filcnaplo/models/release.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'update_tile.i18n.dart';

class UpdateTile extends StatelessWidget {
  const UpdateTile(this.release, {Key? key, this.onTap}) : super(key: key);

  final Release release;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: onTap,
      title: Text("update_available".i18n),
      leading: const Icon(FeatherIcons.download),
      trailing: Text(
        release.tag,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
