import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  const Panel({Key? key, this.child, this.title, this.padding}) : super(key: key);

  final Widget? child;
  final Widget? title;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel Title
        if (title != null) PanelTitle(title: title!),

        // Panel Body
        if (child != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 21),
                  blurRadius: 23.0,
                  color: AppColors.of(context).shadow,
                )
              ],
            ),
            padding: padding ?? EdgeInsets.all(8.0),
            child: child,
          ),
      ],
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.0, right: 14.0, bottom: 8.0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600, color: AppColors.of(context).text.withOpacity(0.65)),
        child: title,
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  const PanelHeader({Key? key, required this.padding}) : super(key: key);

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(14.0), topRight: Radius.circular(14.0)),
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 21),
            blurRadius: 23.0,
            color: AppColors.of(context).shadow,
          )
        ],
      ),
    );
  }
}

class PanelBody extends StatelessWidget {
  const PanelBody(
      {Key? key, this.child, this.padding, this.singular = false, this.roundedTop = false, this.roundedBottom = false, this.shadowPct = 1})
      : super(key: key);

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool singular;
  final bool roundedTop;
  final bool roundedBottom;
  final double shadowPct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(roundedTop ? 14.0 : 0), bottom: Radius.circular(roundedBottom ? 14.0 : 0)),
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, shadowPct * 21),
            blurRadius: shadowPct * 23.0,
            color: AppColors.of(context).shadow,
          )
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class PanelFooter extends StatelessWidget {
  const PanelFooter({Key? key, required this.padding}) : super(key: key);

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14.0), bottomRight: Radius.circular(14.0)),
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 21),
            blurRadius: 23.0,
            color: AppColors.of(context).shadow,
          )
        ],
      ),
    );
  }
}
