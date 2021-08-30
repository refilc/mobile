import 'package:filcnaplo/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.details, {Key? key}) : super(key: key);

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(FeatherIcons.alertTriangle, size: 48.0, color: AppColors.of(context).red),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "An error occurred...",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: AppColors.of(context).highlight,
                  ),
                  child: CupertinoScrollbar(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: SelectableText(
                          (details.exceptionAsString() + '\n'),
                          style: TextStyle(fontFamily: "monospace"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
