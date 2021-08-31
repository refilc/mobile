import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/message_view_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MessageView extends StatefulWidget {
  MessageView(this.messages, {Key? key}) : super(key: key);

  final List<Message> messages;

  static show(List<Message> messages, {required BuildContext context}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MessageView(messages)));
  }

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.of(context).text),
        shadowColor: Color(0),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: 8.0),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(FeatherIcons.archive, color: AppColors.of(context).text),
          //     splashRadius: 32.0,
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: MessageViewTile(widget.messages[index]),
            );
          },
        ),
      ),
    );
  }
}
