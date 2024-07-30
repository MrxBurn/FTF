import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Info',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              content: Text(
                  'Some offers might show a "-" instead of an opponent. This means the offer is for an opponent who has not yet registered with FTF.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          );
        },
        child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Icon(
              Icons.question_mark,
              size: 20,
              color: Colors.black,
            )));
  }
}
