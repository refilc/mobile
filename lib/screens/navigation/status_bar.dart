import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'status_bar.i18n.dart';

class StatusBar extends StatefulWidget {
  StatusBar({Key? key}) : super(key: key);

  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  late StatusProvider statusProvider;

  @override
  Widget build(BuildContext context) {
    statusProvider = Provider.of<StatusProvider>(context);

    Status? currentStatus = statusProvider.getStatus();
    Color backgroundColor = _statusColor(currentStatus);
    Color color = ColorUtils.foregroundColor(backgroundColor);

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: currentStatus != null ? 28.0 : 0,
      width: double.infinity,
      child: Stack(
        children: [
          AnimatedContainer(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: currentStatus != null ? 28.0 : 0,
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [BoxShadow(color: AppColors.of(context).shadow, blurRadius: 8.0)],
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          if (currentStatus == Status.syncing)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.bottomLeft,
              child: AnimatedContainer(
                height: currentStatus != null ? 28.0 : 0,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                // height: 2.0,
                width: MediaQuery.of(context).size.width * statusProvider.progress - 16.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          Center(
            child: Text(
              _statusString(currentStatus),
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _statusString(Status? status) {
    switch (status) {
      case Status.syncing:
        return "Syncing data".i18n;
      case Status.maintenance:
        return "KRETA Maintenance".i18n;
      case Status.network:
        return "No connection".i18n;
      default:
        return "";
    }
  }

  Color _statusColor(Status? status) {
    switch (status) {
      case Status.maintenance:
        return AppColors.of(context).red;
      case Status.network:
      case Status.syncing:
      default:
        return AppColors.of(context).highlight;
    }
  }
}