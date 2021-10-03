import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(this.note, {Key? key, this.onTap}) : super(key: key);

  final Note note;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.only(left: 8.0, right: 12.0),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: ProfileImage(
          name: note.teacher,
          radius: 22.0,
          backgroundColor: ColorUtils.stringToColor(note.teacher),
        ),
        title: Text(
          note.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          note.content.replaceAll('\n', ' '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        minLeadingWidth: 0,
      ),
    );
  }
}
