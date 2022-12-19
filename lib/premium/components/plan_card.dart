import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumPlanCard extends StatelessWidget {
  const PremiumPlanCard({
    Key? key,
    this.icon,
    this.title,
    this.description,
    this.price = 0,
    this.url,
  }) : super(key: key);

  final Widget? icon;
  final Widget? title;
  final int price;
  final Widget? description;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onTap: () {
          if (url != null) {
            launchUrl(
              Uri.parse(url!),
              mode: LaunchMode.externalApplication,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (icon != null) ...[
                          IconTheme(
                            data: Theme.of(context).iconTheme.copyWith(size: 42.0),
                            child: icon!,
                          ),
                          const SizedBox(height: 12.0),
                        ],
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.bold, fontSize: 25.0),
                          child: title!,
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "\$$price"),
                      TextSpan(
                        text: " / hó",
                        style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(.7)),
                      ),
                    ]),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              if (description != null)
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(.8), fontSize: 18),
                  child: description!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
