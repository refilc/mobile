import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo_mobile_ui/premium/components/supporter_group_card.dart';
import 'package:filcnaplo_mobile_ui/premium/styles/gradients.dart';
import 'package:flutter/material.dart';

class SupportersScreen extends StatelessWidget {
  const SupportersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Supporters?>(
        future: FilcAPI.getSupporters(),
        builder: (context, snapshot) {
          final highlightedSupporters =
              snapshot.data?.github.where((e) => e.type == DonationType.monthly && e.price >= 5 && e.comment != "").toList() ?? [];
          final tintaSupporters =
              snapshot.data?.github.where((e) => e.type == DonationType.monthly && e.price >= 5 && e.comment == "").toList() ?? [];
          final kupakSupporters = snapshot.data?.github.where((e) => e.type == DonationType.monthly && e.price == 2).toList() ?? [];
          final onetimeSupporters = snapshot.data?.github.where((e) => e.type == DonationType.once && e.price >= 5).toList() ?? [];
          final patreonSupporters = snapshot.data?.patreon ?? [];

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  title: const Text(
                    "Támogatók",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (!snapshot.hasData)
                  const SliverPadding(
                    padding: EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (highlightedSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        title: const Text("Kiemelt támogatók"),
                        expanded: true,
                        supporters: highlightedSupporters,
                      ),
                    ),
                  ),
                if (tintaSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        icon: const Icon(FilcIcons.tinta),
                        title: Text(
                          "Tinta",
                          style: TextStyle(
                            foreground: GradientStyles.tinta,
                          ),
                        ),
                        glow: Colors.purple,
                        supporters: tintaSupporters,
                      ),
                    ),
                  ),
                if (kupakSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        icon: const Icon(FilcIcons.kupak),
                        title: Text(
                          "Kupak",
                          style: TextStyle(foreground: GradientStyles.kupak),
                        ),
                        glow: Colors.lightGreen,
                        supporters: kupakSupporters,
                      ),
                    ),
                  ),
                if (onetimeSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        title: const Text("Egyszeri támogatók"),
                        supporters: onetimeSupporters,
                      ),
                    ),
                  ),
                if (patreonSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        title: const Text("Régebbi támogatóink"),
                        supporters: patreonSupporters,
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
