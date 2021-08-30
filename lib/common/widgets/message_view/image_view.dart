import 'dart:io';

import 'package:filcnaplo/helpers/share_helper.dart';
import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  const ImageView(this.path, {Key? key}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.of(context).text),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => ShareHelper.shareFile(path),
              icon: Icon(FeatherIcons.share2, color: AppColors.of(context).text),
              splashRadius: 24.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PhotoView(
          imageProvider: FileImage(File(path)),
          maxScale: 4.0,
          minScale: PhotoViewComputedScale.contained,
          backgroundDecoration: BoxDecoration(
            color: AppColors.of(context).background,
          ),
        ),
      ),
    );
  }
}
