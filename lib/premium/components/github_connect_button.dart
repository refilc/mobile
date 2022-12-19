import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubConnectButton extends StatelessWidget {
  const GithubConnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: const Color(0xff2B2B2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      child: InkWell(
        onTap: () {
          launchUrl(Uri.parse("https://github.com/sponsors/filc"));
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SvgPicture.asset(
                  "assets/images/github.svg",
                  height: 26.0,
                ),
              ),
              const Text(
                "GitHub csatlakoztatása",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
