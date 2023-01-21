import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GithubConnectButton extends StatelessWidget {
  const GithubConnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);

    if (premium.hasPremium) {
      return const SizedBox();
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: const Color(0xff2B2B2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      child: InkWell(
        onTap: () {
          premium.auth.initAuth();
          showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              final premium = Provider.of<PremiumProvider>(context);

              if (premium.hasPremium) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context, rootNavigator: true).maybePop();
                });
              }

              return AlertDialog(
                title: const Text("Premium auth token"),
                content: TextField(
                  onSubmitted: (token) => premium.auth.finishAuth(token),
                ),
              );
            },
          );
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
