import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/search_input.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';

class CreateOfferFighter extends StatefulWidget {
  const CreateOfferFighter({super.key});

  @override
  State<CreateOfferFighter> createState() => _CreateOfferFighterState();
}

class _CreateOfferFighterState extends State<CreateOfferFighter> {
  bool checked = false;
  TextEditingController splitValue = TextEditingController(text: '0');

  TextEditingController opponentValue = TextEditingController(text: '0');
  @override
  Widget build(BuildContext context) {
    String searchValue = '';

    return GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              LogoHeader(backRequired: true),
              const Text(
                'Send offer',
                style: headerStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              SearchBarWidget(
                searchValue: searchValue,
                searchbarText: 'Search fighter...',
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: 205,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(lighterBlack),
                  boxShadow: [containerShadowRed],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(searchValue),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                constraints: const BoxConstraints(
                    minWidth: 350, maxWidth: 350, minHeight: 150),
                decoration: BoxDecoration(
                  color: const Color(lighterBlack),
                  boxShadow: [containerShadowWhite],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contract split',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: splitValue,
                                    style: const TextStyle(
                                        color: Colors.yellow, fontSize: 24),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  'You',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Text(
                              '%',
                              style: TextStyle(fontSize: 24),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: opponentValue,
                                    decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 24),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  'Opponent',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        CheckBoxWidget(
                          checkValue: checked,
                          title: 'N/A - Contracted',
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              DropDownWidget(
                dropDownList: rematchClause,
                dropDownValue: rematchClause.first,
                dropDownName: 'Rematch clause*',
              ),
              DropDownWidget(
                  dropDownValue: weightList.first,
                  dropDownList: weightList,
                  dropDownName: 'Weight class*'),
            ]),
          ),
        ));
  }
}
