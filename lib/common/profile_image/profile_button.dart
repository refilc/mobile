import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_route.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key, required this.child}) : super(key: key);

  final ProfileImage child;

  @override
  Widget build(BuildContext context) {
    return ProfileImage(
      backgroundColor: child.backgroundColor,
      heroTag: child.heroTag,
      key: child.key,
      name: child.name,
      radius: child.radius,
      newContent: child.newContent,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(settingsRoute(SettingsScreen()));
      },
    );
  }
}
