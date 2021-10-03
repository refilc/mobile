import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(this.message, {Key? key, this.onTap}) : super(key: key);

  final Message message;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Material(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        child: ListTile(
          onTap: onTap,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.only(left: 8.0, right: 4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          leading: ProfileImage(
            name: message.author,
            radius: 22.0,
            backgroundColor: ColorUtils.stringToColor(message.author),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  message.author,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5),
                ),
              ),
              if (message.attachments.length > 0) Icon(FeatherIcons.paperclip, size: 16.0)
            ],
          ),
          subtitle: Text(
            message.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
          ),
          trailing: Text(
            message.date.format(context),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: AppColors.of(context).text.withOpacity(.75),
            ),
          ),
        ),
      ),
    );
  }
}
