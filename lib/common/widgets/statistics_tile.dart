import 'package:auto_size_text/auto_size_text.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

class StatisticsTile extends StatelessWidget {
  const StatisticsTile({Key? key, required this.value, this.title, this.decimal = true, this.color, this.valueSuffix = ''}) : super(key: key);

  final double value;
  final Widget? title;
  final bool decimal;
  final Color? color;
  final String valueSuffix;

  @override
  Widget build(BuildContext context) {
    String valueText;
    if (decimal) {
      valueText = value.toStringAsFixed(2);
    } else {
      valueText = value.toStringAsFixed(0);
    }
    if (I18n.of(context).locale.languageCode != "en") valueText = valueText.replaceAll(".", ",");

    if (value.isNaN) {
      valueText = "?";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 21),
            blurRadius: 23.0,
            color: AppColors.of(context).shadow,
          )
        ],
      ),
      constraints: const BoxConstraints(
        minHeight: 130.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (title != null)
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
              child: title!,
            ),
          if (title != null) const SizedBox(height: 4.0),
          AutoSizeText.rich(
            TextSpan(
              text: valueText,
              children: [
                if (valueSuffix != "")
                  TextSpan(
                    text: valueSuffix,
                    style: const TextStyle(fontSize: 24.0),
                  ),
              ],
            ),
            maxLines: 1,
            minFontSize: 5,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color ?? gradeColor(context: context, value: value),
              fontWeight: FontWeight.w800,
              fontSize: 42.0,
            ),
          ),
        ],
      ),
    );
  }
}
