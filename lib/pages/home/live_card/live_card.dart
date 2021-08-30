import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/category.dart';
import 'package:filcnaplo_mobile_ui/common/progress_bar.dart';
import 'package:flutter/material.dart';
import 'live_card.i18n.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({Key? key, this.onTap, this.child, this.shadowColor}) : super(key: key);

  final void Function()? onTap;
  final Widget? child;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "livecard",
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 21),
                blurRadius: 23.0,
                color: shadowColor ?? AppColors.of(context).shadow,
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14.0),
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 0.0,
                    leading: Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Icon(
                          SubjectIcon.lookup(
                              subject: Subject(
                                  id: "0", category: Category(id: "0", name: "Linux alapok", description: "Linux alapok"), name: "Linux Alapok")),
                          color: AppColors.of(context).text.withOpacity(0.75)),
                    ),
                    title: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: "3. ", style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: "Linux alapok", style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.of(context).text.withOpacity(0.8)))
                      ]),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Text(
                      "Dolgozat",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text("123",
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.7))),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 14.0, right: 14.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text.rich(
                              TextSpan(
                                  text: "next".i18n + ": ",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.of(context).text.withOpacity(0.65)),
                                  children: [
                                    TextSpan(
                                        text: "Irodalom",
                                        style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.65)))
                                  ]),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          Expanded(
                            child: Text("remaining".plural(23),
                                maxLines: 1,
                                softWrap: false,
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.65))),
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: ProgressBar(value: 15 / 45.0, backgroundColor: Theme.of(context).primaryColor),
                  ),
                  if (child != null) child!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
