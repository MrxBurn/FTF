import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';

void showDreamOpponent(
  BuildContext context,
  List<Map<String, dynamic>> fightersList,
) {
  showDialog(
    context: context,
    builder: (context) {
      return ChoiceChipList(fightersList: fightersList);
    },
  );
}

class ChoiceChipList extends StatefulWidget {
  const ChoiceChipList({super.key, required this.fightersList});

  final List<Map<String, dynamic>> fightersList;

  @override
  State<ChoiceChipList> createState() => _ChoiceChipListState();
}

class _ChoiceChipListState extends State<ChoiceChipList> {
  int _selectedIndex = -1;

  Map<String, dynamic> selectedFighter = {};

  Future<void> suggestDreamOpponent() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 450,
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.fightersList.length,
              separatorBuilder: (context, index) => const SizedBox(
                width: 16,
              ),
              itemBuilder: (BuildContext context, idx) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: ChoiceChip(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: _selectedIndex == idx
                              ? Colors.yellow
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    checkmarkColor: Colors.yellow,
                    color: MaterialStateProperty.all<Color>(Colors.black),
                    labelStyle: TextStyle(
                        color: _selectedIndex == idx
                            ? Colors.yellow
                            : Colors.white),
                    avatar: CircleAvatar(
                      backgroundImage:
                          widget.fightersList[idx]['profileImageURL'] != ''
                              ? NetworkImage(
                                  widget.fightersList[idx]['profileImageURL'],
                                )
                              : NetworkImage(imgPlaceholder),
                    ),
                    label: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '${widget.fightersList[idx]['firstName']} ${widget.fightersList[idx]['lastName']}',
                      ),
                    ),
                    selected: _selectedIndex == idx,
                    onSelected: (selectValue) {
                      setState(() {
                        _selectedIndex = selectValue ? idx : -1;
                        if (_selectedIndex == -1) {
                          selectedFighter = {};
                        } else {
                          selectedFighter = widget.fightersList[idx];
                        }
                      });
                    },
                  ),
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    )),
                BlackRoundedButton(
                    width: 100,
                    height: 35,
                    fontSize: 14,
                    isLoading: false,
                    isDisabled: selectedFighter.isEmpty,
                    onPressed: () {},
                    text: 'Suggest'),
                const SizedBox(
                  width: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
