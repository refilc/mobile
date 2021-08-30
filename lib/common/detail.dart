import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  Detail({Key? key, required this.title, required this.description, this.maxLines = 3}) : super(key: key);

  final String title;
  final String description;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 18.0),
      child: Text.rich(
        TextSpan(
          text: "$title: ",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.of(context).text),
          children: [
            TextSpan(
              text: description,
              style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.85)),
            ),
          ],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
