// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class SearchBarWidget extends StatefulWidget {
  String searchbarText = '';

  String searchValue;

  Function onTap;

  List suggestions;

  ValueChanged<String> onChanged;

  //TODO: Find a way to get the value from controller

  SearchBarWidget(
      {Key? key,
      required this.searchbarText,
      required this.searchValue,
      required this.suggestions,
      required this.onTap,
      required this.onChanged})
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
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
                await widget.onTap();

                controller.openView();
              },
              onChanged: (value) {
                widget.onChanged(value);
              },
              leading: const Icon(Icons.search),
            ),
          );
        }, suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          if (widget.suggestions.isNotEmpty) {
            return List<ListTile>.generate(widget.suggestions.length,
                (int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.suggestions[index].profileImageURL),
                  radius: 20,
                ),
                title: Text(widget.suggestions[index].firstName +
                    " " +
                    widget.suggestions[index].lastName),
                onTap: () {
                  setState(() {
                    controller.closeView(widget.suggestions[index].firstName +
                        " " +
                        widget.suggestions[index].lastName);
                  });
                },
                onFocusChange: (value) {},
              );
            });
          } else {
            return List<Center>.generate(
                1,
                (index) => const Center(
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator())));
          }
        }));
  }
}
