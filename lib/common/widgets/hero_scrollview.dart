import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';

class HeroScrollView extends StatefulWidget {
  const HeroScrollView(
      {Key? key,
      required this.child,
      required this.title,
      required this.icon,
      this.navBarItems = const [],
      this.onClose,
      this.iconSize = 100.0,
      this.scrollController})
      : super(key: key);

  final Widget child;
  final String title;
  final IconData? icon;
  final List<Widget> navBarItems;
  final VoidCallback? onClose;
  final double iconSize;
  final ScrollController? scrollController;

  @override
  _HeroScrollViewState createState() => _HeroScrollViewState();
}

class _HeroScrollViewState extends State<HeroScrollView> {
  late ScrollController _scrollController;

  bool showBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 42.0) {
        if (showBarTitle == false) setState(() => showBarTitle = true);
      } else {
        if (showBarTitle == true) setState(() => showBarTitle = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (context, _) => [
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                centerTitle: false,
                titleSpacing: 0,
                title: AnimatedOpacity(
                    opacity: showBarTitle ? 1.0 : 0.0,
                    child: Text(
                      widget.title.capital(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: AppColors.of(context).text, fontWeight: FontWeight.w500),
                    ),
                    duration: const Duration(milliseconds: 200)),
                leading: BackButton(
                    color: AppColors.of(context).text,
                    onPressed: () {
                      if (widget.onClose != null) {
                        widget.onClose!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    }),
                actions: widget.navBarItems,
                expandedHeight: 124.0,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Center(
                        child: Icon(
                          widget.icon,
                          size: widget.iconSize,
                          color: AppColors.of(context).text.withOpacity(.15),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          widget.title.capital(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 36.0, color: AppColors.of(context).text.withOpacity(.9), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
        body: widget.child);
  }
}
