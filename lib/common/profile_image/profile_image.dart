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
    this.newContent = false,
  }) : super(key: key);

  final void Function()? onTap;
  final String? name;
  final Color? backgroundColor;
  final double radius;
  final String? heroTag;
  final bool newContent;

  @override
  Widget build(BuildContext context) {
    if (heroTag == null)
      return buildWithoutHero(context);
    else
      return buildWithHero(context);
  }

  Widget buildWithoutHero(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: CircleBorder(),
      color: backgroundColor,
      // color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: name != null && (name?.trim().length ?? 0) > 0
              ? Center(
                  child: Text(
                    (name ?? "?").trim()[0],
                    style: TextStyle(
                      color: ColorUtils.foregroundColor(backgroundColor ?? Colors.black),
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0 * (radius / 20.0),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  Widget buildWithHero(BuildContext context) {
    Widget child = FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(
        (name ?? "?").trim()[0],
        style: TextStyle(
          color: ColorUtils.foregroundColor(backgroundColor ?? Colors.black),
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
                shape: CircleBorder(),
                color: backgroundColor,
                // color: Colors.transparent,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: radius * 2,
                  width: radius * 2,
                  decoration: BoxDecoration(
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
          if (newContent)
            Hero(
              tag: heroTag! + "new_content_indicator",
              child: NewContentIndicator(size: radius * 2),
            ),
          Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: CircleBorder(),
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
