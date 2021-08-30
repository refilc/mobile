import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_card.dart';
import 'package:filcnaplo_mobile_ui/common/detail.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/accounts/account_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO: i18n

class AccountView extends StatelessWidget {
  const AccountView(this.user, {Key? key}) : super(key: key);

  final User user;

  static void show(User user, {required BuildContext context}) => showBottomCard(context: context, child: AccountView(user));

  @override
  Widget build(BuildContext context) {
    List<String> _nameParts = user.name.split(" ");
    String _firstName = _nameParts.length > 1 ? _nameParts[1] : _nameParts[0];

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountTile(
            profileImage: ProfileImage(
              name: _firstName,
              backgroundColor: ColorUtils.stringToColor(_firstName),
            ),
            name: Text(user.name, style: TextStyle(fontWeight: FontWeight.w500)),
            username: Text(user.username),
          ),

          // User details
          Detail(title: "Birth date", description: DateFormat("yyyy. MM. dd.").format(user.student.birth)),
          Detail(title: "School", description: user.student.school.name),
          if (user.student.className != null) Detail(title: "Class", description: user.student.className!),
          if (user.student.address != null) Detail(title: "Address", description: user.student.address!),
          if (user.student.parents.length > 0) Detail(title: "Parents", description: user.student.parents.join(", "))
        ],
      ),
    );
  }
}
