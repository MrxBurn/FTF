import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/snack_bar.dart';

void showDreamOpponent(BuildContext context,
    List<Map<String, dynamic>> fightersList, String currentFighter) {
  showDialog(
    context: context,
    builder: (context) {
      return ChoiceChipList(
          fightersList: fightersList, currentFighter: currentFighter);
    },
  );
}

class ChoiceChipList extends StatefulWidget {
  const ChoiceChipList(
      {super.key, required this.fightersList, required this.currentFighter});

  final List<Map<String, dynamic>> fightersList;

  final String currentFighter;

  @override
  State<ChoiceChipList> createState() => _ChoiceChipListState();
}

class _ChoiceChipListState extends State<ChoiceChipList> {
  int _selectedIndex = -1;

  Map<String, dynamic> selectedFighter = {};

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<void> suggestDreamOpponent(
      String currentFighter, Map<String, dynamic> selectedFighter) async {
    Map<String, dynamic>? selectedDbFighter = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentFighter)
        .collection('dreamOpponents')
        .doc(selectedFighter['id'])
        .get()
        .then((value) => value.data());

    var calculatedSuggestions = selectedDbFighter?['fanIds'] != null
        ? [...selectedDbFighter!['fanIds']]
        : [currentUser];

    if (selectedDbFighter?['fanIds'] != null &&
        !selectedDbFighter?['fanIds'].contains(currentUser)) {
      calculatedSuggestions = [...selectedDbFighter!['fanIds'], currentUser];
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentFighter)
        .collection('dreamOpponents')
        .doc(selectedFighter['id'])
        .set({
      'dreamOpponent': selectedFighter['id'],
      'fanIds': calculatedSuggestions,
      'dreamOpponentName':
          '${selectedFighter['firstName']} ${selectedFighter['lastName']}',
      'fighterType': selectedFighter['fighterType'],
      'profileImageURL': selectedFighter['profileImageURL'],
    }, SetOptions(merge: true)).catchError((error) => error);
  }

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
                    onPressed: () => suggestDreamOpponent(
                            widget.currentFighter, selectedFighter)
                        .then((value) => {
                              Navigator.pop(context),
                              showSnackBar(
                                  text: 'Opponent suggested successfully',
                                  context: context,
                                  color: Colors.green)
                            }),
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
