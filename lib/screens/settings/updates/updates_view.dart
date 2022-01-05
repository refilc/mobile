import 'package:filcnaplo/models/release.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_card.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/material_action_button.dart';
import 'package:filcnaplo/helpers/update_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'updates_view.i18n.dart';

class UpdateView extends StatefulWidget {
  const UpdateView(this.release, {Key? key}) : super(key: key);

  final Release release;

  static void show(Release release, {required BuildContext context}) => showBottomCard(context: context, child: UpdateView(release));

  @override
  _UpdateViewState createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  double progress = 0.0;
  UpdateState state = UpdateState.none;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "new_update".i18n,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                    Text(
                      "${widget.release.version}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: AppColors.of(context).text.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Image.asset(
                    "assets/icons/ic_launcher.png",
                    width: 64.0,
                  ),
                )
              ],
            ),
          ),

          // Description
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              height: 125.0,
              child: Markdown(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                physics: const BouncingScrollPhysics(),
                data: widget.release.body,
                onTapLink: (text, href, title) => launch(href ?? ""),
              ),
            ),
          ),

          // Download button
          Center(
            child: MaterialActionButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state == UpdateState.downloading || state == UpdateState.preparing)
                    Container(
                      height: 18.0,
                      width: 18.0,
                      margin: const EdgeInsets.only(right: 8.0),
                      child: CircularProgressIndicator(
                        value: progress > 0.05 ? progress : null,
                        color: ColorUtils.foregroundColor(AppColors.of(context).filc),
                      ),
                    ),
                  Text(["download".i18n, "downloading".i18n, "downloading".i18n, "installing".i18n][state.index].toUpperCase()),
                ],
              ),
              backgroundColor: AppColors.of(context).filc,
              onPressed: state == UpdateState.none ? () => download() : null,
            ),
          ),
        ],
      ),
    );
  }

  void download() {
    widget.release
        .install(updateCallback: (p, s) {
          if (mounted) {
            setState(() {
              progress = p;
              state = s;
            });
          }
        })
        .then((_) => Navigator.of(context).maybePop())
        .catchError((error, stackTrace) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              context: context,
              content: Text("error".i18n),
              backgroundColor: AppColors.of(context).red,
            ));
            setState(() => state = UpdateState.none);
          }
        });
  }
}
