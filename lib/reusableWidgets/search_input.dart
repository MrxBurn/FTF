// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class SearchBarWidget extends StatefulWidget {
  String searchbarText = '';

  String searchValue;
  //TODO: Find a way to get the value from controller

  SearchBarWidget(
      {Key? key, required this.searchbarText, required this.searchValue})
      : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: SearchAnchor(builder: (BuildContext context, controller) {
          return SizedBox(
            height: 40,
            child: SearchBar(
              hintText: widget.searchbarText,
              backgroundColor: const MaterialStatePropertyAll(Color(black)),
              shadowColor: const MaterialStatePropertyAll(Colors.red),
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (value) {
                setState(() {
                  widget.searchValue = value;
                });
              },
              leading: const Icon(Icons.search),
            ),
          );
        }, suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        }));
  }
}
