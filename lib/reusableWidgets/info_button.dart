import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector( onTap: () {showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Info',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      content: Text(
                                                          'Some of the offers created might have "-" instead of an opponent. That means the offers have been created without an opponent registered in the app and soon to be joining it. '),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text(
                                                              'Close',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      ],
                                                    ),
                                                  );}, child:  Container(
                                                    padding: EdgeInsets.zero,
                                                    decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.all(Radius.circular(30))), child: Icon(Icons.question_mark, size: 20, color: Colors.black,)));
  }
}