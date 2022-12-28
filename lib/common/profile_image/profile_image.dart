import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/new_content_indicator.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/color.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
    this.onTap,
    this.name,
    this.backgroundColor,
    this.radius = 20.0,
    this.heroTag,
    this.badge = false,
    this.role = Role.student,
    this.censored = false,
  }) : super(key: key);

  final void Function()? onTap;
  final String? name;
  final Color? backgroundColor;
  final double radius;
  final String? heroTag;
  final bool badge;
  final Role? role;
  final bool censored;

  @override
  Widget build(BuildContext context) {
    if (heroTag == null) {
      return buildWithoutHero(context);
    } else {
      return buildWithHero(context);
    }
  }

  Widget buildWithoutHero(BuildContext context) {
    Color color = ColorUtils.foregroundColor(backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);
    Color roleColor;

    if (Theme.of(context).brightness == Brightness.light) {
      roleColor = const Color(0xFF444444);
    } else {
      roleColor = const Color(0xFF555555);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          shape: const CircleBorder(),
          color: backgroundColor ?? AppColors.of(context).text.withOpacity(.15),
          child: InkWell(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: radius * 2,
              width: radius * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: name != null && (name?.trim().length ?? 0) > 0
                  ? Center(
                      child: censored
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: color.withOpacity(.5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )
                          : Text(
                              (name?.trim().length ?? 0) > 0 ? (name ?? "?").trim()[0] : "?",
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0 * (radius / 20.0),
                              ),
                            ),
                    )
                  : Container(),
            ),
          ),
        ),

        // Role indicator
        if (role == Role.parent)
          SizedBox(
            height: radius * 2,
            width: radius * 2,
            child: Container(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.shield, color: roleColor, size: radius / 1.3),
            ),
          ),
      ],
    );
  }

  Widget buildWithHero(BuildContext context) {
    Color color = ColorUtils.foregroundColor(backgroundColor ?? Theme.of(context).scaffoldBackgroundColor);
    Color roleColor;

    if (Theme.of(context).brightness == Brightness.light) {
      roleColor = const Color(0xFF444444);
    } else {
      roleColor = const Color(0xFF555555);
    }

    Widget child = FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(
        (name?.trim().length ?? 0) > 0 ? (name ?? "?").trim()[0] : "?",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 18.0 * (radius / 20.0),
        ),
      ),
    );

    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (name != null && (name?.trim().length ?? 0) > 0)
            Hero(
              tag: heroTag! + "background",
              transitionOnUserGestures: true,
              child: Material(
                clipBehavior: Clip.hardEdge,
                shape: const CircleBorder(),
                color: backgroundColor ?? AppColors.of(context).text.withOpacity(.15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: radius * 2,
                  width: radius * 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          Hero(
            tag: heroTag! + "child",
            transitionOnUserGestures: true,
            child: Material(
              child: child,
              type: MaterialType.transparency,
            ),
          ),

          // Badge
          if (badge)
            Hero(
              tag: heroTag! + "new_content_indicator",
              child: NewContentIndicator(size: radius * 2),
            ),

          // Role indicator
          if (role == Role.parent)
            Hero(
              tag: heroTag! + "role_indicator",
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: SizedBox(
                  height: radius * 2,
                  width: radius * 2,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.shield, color: roleColor, size: radius / 1.3),
                  ),
                ),
              ),
            ),

          Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                height: radius * 2,
                width: radius * 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
