import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_controller.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_item.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  FilterBar({Key? key, required this.items, required this.controller, this.padding = const EdgeInsets.symmetric(horizontal: 24.0)})
      : assert(items.length == controller.itemCount),
        super(key: key);

  final List<FilterItem> items;
  final FilterController controller;
  final EdgeInsetsGeometry padding;
  @override
  final Size preferredSize = const Size.fromHeight(42.0);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  void initState() {
    super.initState();
    widget.items[widget.controller.activeIndex].active = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48.0,
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              AppColors.of(context).background.withOpacity(0),
              AppColors.of(context).background.withOpacity(.7),
              AppColors.of(context).background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            stops: const [0, .7, 1]),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Colors.transparent, Colors.transparent, AppColors.of(context).background],
            stops: const [0, 0.9, 1],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              var itemWidget = FilterItemWidget(
                  item: widget.items[index]..active = index == widget.controller.activeIndex,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onTap: () {
                    if (widget.controller.activeIndex != index) {
                      widget.controller.activeIndex = index;
                      widget.controller.updateView();
                      setState(() {});
                    }
                  });

              return itemWidget;
            }),
      ),
    );
  }
}
