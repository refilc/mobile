class FilterController {
  FilterController({required this.itemCount, int initialIndex = 0})
      : assert(initialIndex < itemCount),
        activeIndex = initialIndex;

  int itemCount;
  int activeIndex;
  late void Function() updateView;
}
