import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GithubCard extends StatelessWidget {
  const GithubCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      color: const Color(0xff2B2B2B),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).add(const EdgeInsets.only(top: 4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Támogass minket Githubon, hogy megszerezd a jutalmakat!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SvgPicture.asset("assets/images/github.svg"),
              ],
            ),
            const SizedBox(height: 4.0),
            Chip(
              label: Text(
                "Már támogatsz? Jelentkezz be!",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
