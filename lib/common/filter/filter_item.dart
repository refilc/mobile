import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';

class FilterItem {
  FilterItem({required this.label});

  final String label;
  bool active = false;
}

class FilterItemWidget extends StatelessWidget {
  const FilterItemWidget({Key? key, required this.item, this.activeColor, this.onTap}) : super(key: key);

  final FilterItem item;
  final Color? activeColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0, right: 3.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: 32.0,
            decoration: BoxDecoration(
              color: item.active ? (activeColor ?? AppColors.of(context).filc).withOpacity(0.25) : null,
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: item.active ? EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0) : EdgeInsets.symmetric(horizontal: 6.0),
            child: Center(
                child: Text(item.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: item.active ? activeColor ?? AppColors.of(context).filc : AppColors.of(context).text.withOpacity(0.65),
                    ))),
          ),
        ),
      ),
    );
  }
}
