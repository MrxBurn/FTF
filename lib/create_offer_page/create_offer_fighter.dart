import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/date_picker.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
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

  TextEditingController bioController = TextEditingController();

  DateTime today = DateTime.now();

  //TODO: Display file name when uploaded

  //TODO: Use Reusable login, register button in all occurences

  @override
  Widget build(BuildContext context) {
    String searchValue = '';

    TextEditingController pickerController = TextEditingController(
        text: ('${today.day}-${today.month}-${today.year}').toString());

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
              DropDownWidget(
                  //TODO: Implement fight date logic
                  dropDownValue: weightList.first,
                  dropDownList: weightList,
                  dropDownName: 'Fight date*'),
              DatePicker(
                //TODO: Change date picker style
                leadingText: 'Offer expiry date',
                controller: pickerController,
              ),
              Padding(
                padding: paddingLRT,
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: bioController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Write a message...(200 characters)'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () => {},
                    label: const Text('Attach callout video'),
                    icon: const Icon(Icons.attach_file),
                  ),
                ),
              ),
              Padding(
                padding: paddingLRT,
                child: const Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              Padding(
                padding: paddingLRT,
                child: const Text(
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                    "Fans can vote and see your offer details, including messages and videos. Financials and market value will be privately discussed between you, your potential opponent, your manager/promoter, and your potential opponent's manager/promoter in our secure chat feature."),
              ),
              const SizedBox(
                height: 16,
              ),
              BlackRoundedButton(
                isLoading: false /*TODO: Implement is loading */,
                text: 'Send offer',
                onPressed: () => {} /* TODO: Implement on submit */,
              )
            ]),
          ),
        ));
  }
}
