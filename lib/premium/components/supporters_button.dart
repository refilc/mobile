import 'package:filcnaplo_mobile_ui/premium/components/avatar_stack.dart';
import 'package:filcnaplo_mobile_ui/premium/supporters_screen.dart';
import 'package:flutter/material.dart';

class SupportersButton extends StatelessWidget {
  const SupportersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      margin: EdgeInsets.zero,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SupportersScreen()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  "Köszönjük, támogatók!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
              ),
              AvatarStack(
                children: [
                  CircleAvatar(backgroundColor: Colors.orange),
                  CircleAvatar(backgroundColor: Colors.blue),
                  CircleAvatar(backgroundColor: Colors.purple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
