import 'package:animations/animations.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
    this.message, {
    Key? key,
    this.messages,
  }) : super(key: key);

  final Message message;
  final List<Message>? messages;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, _) {
        return MessageView(messages ?? [message]);
      },
      closedElevation: 0,
      closedBuilder: (context, VoidCallback openContainer) {
        return Material(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          child: ListTile(
            onTap: openContainer,
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.only(left: 8.0, right: 4.0),
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
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5),
                  ),
                ),
                if (message.attachments.isNotEmpty) const Icon(FeatherIcons.paperclip, size: 16.0)
              ],
            ),
            subtitle: Text(
              message.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
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
        );
      },
      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      middleColor: Theme.of(context).backgroundColor,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedColor: Theme.of(context).backgroundColor,
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 400),
      useRootNavigator: true,
    );
  }
}
