import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 450,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.fightersList.length,
          separatorBuilder: (context, index) => const SizedBox(
            width: 16,
          ),
          itemBuilder: (BuildContext context, idx) {
            return Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: ChoiceChip(
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
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
