import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/text_ellipsis.dart';
import 'package:ftf/styles/styles.dart';

class ContractSplit extends StatefulWidget {
  final bool contractedChecked;
  final TextEditingController creatorValue;
  final TextEditingController opponentValue;
  final Function onTickChanged;
  final Function onContractSplitChange;
  final Function onEditingComplete;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final bool readOnly;
  final bool checkBoxRequired;
  final String title;
  final String creator;
  final String opponent;
  final Color creatorColour;
  final Color opponentColour;

  ContractSplit(
      {super.key,
      required this.contractedChecked,
      required this.creatorValue,
      required this.onTickChanged,
      required this.opponentValue,
      required this.onContractSplitChange,
      required this.onEditingComplete,
      this.maxWidth = 350,
      this.minHeight = 150,
      this.minWidth = 350,
      this.readOnly = false,
      this.checkBoxRequired = true,
      this.title = 'Contract split',
      this.creator = 'Creator',
      this.opponent = 'Opponent',
      this.creatorColour = Colors.yellow,
      this.opponentColour = Colors.red});

  @override
  State<ContractSplit> createState() => _ContractSplitState();
}

class _ContractSplitState extends State<ContractSplit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          minHeight: widget.minHeight),
      decoration: BoxDecoration(
        color: const Color(lighterBlack),
        boxShadow: [containerShadowWhite],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 20,
                color: widget.contractedChecked == true
                    ? Colors.grey
                    : Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 50,
                    child: TextField(
                      readOnly:
                          widget.readOnly || widget.contractedChecked == true
                              ? true
                              : false,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: widget.creatorValue,
                      style: TextStyle(
                          color: widget.contractedChecked == true
                              ? Colors.grey
                              : widget.creatorColour,
                          fontSize: 24),
                      onChanged: (value) => widget.onContractSplitChange(value),
                      onEditingComplete: () {
                        if (widget.creatorValue.text == '') {
                          widget.onEditingComplete();
                        }
                      },
                      onTapOutside: (value) {
                        if (widget.creatorValue.text == '') {
                          widget.onEditingComplete();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextEllipsis(
                    maxWidth: 100,
                    text: widget.creator,
                    style: TextStyle(
                        fontSize: 12,
                        color: widget.contractedChecked == true
                            ? Colors.grey
                            : Colors.white),
                  ),
                ],
              ),
              Text(
                '%',
                style: TextStyle(
                    fontSize: 24,
                    color: widget.contractedChecked == true
                        ? Colors.grey
                        : Colors.white),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: widget.opponentValue,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      readOnly: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.contractedChecked == true
                              ? Colors.grey
                              : widget.opponentColour,
                          fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextEllipsis(
                    maxWidth: 100,
                    text: widget.opponent,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          widget.checkBoxRequired
              ? CheckBoxWidget(
                  checkValue: widget.contractedChecked,
                  title: 'N/A - Contracted',
                  onChanged: widget.onTickChanged,
                )
              : const SizedBox()
        ]),
      ),
    );
  }
}
