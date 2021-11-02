import 'dart:io';

import 'package:filcnaplo_kreta_api/models/attachment.dart';
import 'package:filcnaplo/helpers/attachment_helper.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AttachmentTile extends StatelessWidget {
  const AttachmentTile(this.attachment, {Key? key}) : super(key: key);

  final Attachment attachment;

  Widget buildImage(BuildContext context) {
    return FutureBuilder<String>(
      future: attachment.download(context),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                          builder: (context) => ImageView(snapshot.data!),
                        ));
                      },
                      child: Ink.image(
                        image: FileImage(File(snapshot.data ?? "")),
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              )
            : Center(
                child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
              ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (attachment.isImage) return buildImage(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          attachment.open(context);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(children: [
            Icon(FeatherIcons.paperclip),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(attachment.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
