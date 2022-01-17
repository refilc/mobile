import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
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
        color: AppColors.of(context).highlight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Text.rich(
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