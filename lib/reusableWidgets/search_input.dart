import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchbarText;

  final Function onTap;

  final List suggestions;

  final ValueChanged<String> onChanged;

  final bool displaySuggestions;

  final ScrollController scrollController;

  final Function onListTileTap;

  final Function onSelectedSuggestion;

  SearchBarWidget(
      {super.key,
      required this.searchbarText,
      required this.suggestions,
      required this.onTap,
      required this.onChanged,
      required this.displaySuggestions,
      required this.scrollController,
      required this.onListTileTap,
      required this.onSelectedSuggestion});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            height: widget.displaySuggestions ? 215 : 65,
            child: Column(
              children: [
                Material(
                  elevation: 10.0,
                  shadowColor: Colors.red,
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(lighterBlack),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: const Icon(Icons.arrow_downward),
                        hintText: widget.searchbarText,
                        border: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none,
                        )),
                    onTap: () async {
                      await widget.onTap();

                      if (context.mounted) {
                        widget.scrollController
                            .jumpTo(MediaQuery.of(context).size.height / 2.5);
                      }
                    },
                    onChanged: (value) {
                      widget.onChanged(value);
                    },
                  ),
                ),
                widget.displaySuggestions
                    ? FadeIn(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            height: widget.displaySuggestions ? 160 : 100,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(lighterBlack),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: widget.suggestions.length > 0
                                ? ListView.builder(
                                    itemCount: widget.suggestions.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: widget
                                                  .suggestions[index]
                                                  .profileImageURL
                                                  .isNotEmpty
                                              ? NetworkImage(widget
                                                  .suggestions[index]
                                                  .profileImageURL)
                                              : NetworkImage(imgPlaceholder),
                                          radius: 20,
                                        ),
                                        title: Text(widget
                                                .suggestions[index].firstName +
                                            " " +
                                            widget.suggestions[index].lastName),
                                        onTap: () {
                                          widget.onSelectedSuggestion(
                                              widget.suggestions[index]);

                                          widget.onListTileTap(widget
                                                  .suggestions[index]
                                                  .firstName +
                                              " " +
                                              widget
                                                  .suggestions[index].lastName);

                                          FocusScope.of(context).unfocus();
                                          _textEditingController.clear();
                                        },
                                      );
                                    })
                                : Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      'There are no users (athletes) at the moment.\nUsers will be displayed here once they register.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          )),
    );
  }
}
