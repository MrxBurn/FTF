import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/styles/styles.dart';

class ContractSplit extends StatefulWidget {
  bool contractedChecked;
  TextEditingController creatorValue;
  TextEditingController opponentValue;
  Function onTickChanged;
  Function onContractSplitChange;
  Function onEditingComplete;

  ContractSplit(
      {super.key,
      required this.contractedChecked,
      required this.creatorValue,
      required this.onTickChanged,
      required this.opponentValue,
      required this.onContractSplitChange,
      required this.onEditingComplete});

  @override
  State<ContractSplit> createState() => _ContractSplitState();
}

class _ContractSplitState extends State<ContractSplit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: 350, maxWidth: 350, minHeight: 150),
      decoration: BoxDecoration(
        color: const Color(lighterBlack),
        boxShadow: [containerShadowWhite],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Contract split',
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
                      readOnly: widget.contractedChecked == true ? true : false,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: widget.creatorValue,
                      style: TextStyle(
                          color: widget.contractedChecked == true
                              ? Colors.grey
                              : Colors.yellow,
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
                  Text(
                    'You',
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
                              : Colors.red,
                          fontSize: 24),
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
            checkValue: widget.contractedChecked,
            title: 'N/A - Contracted',
            onChanged: widget.onTickChanged,
          )
        ]),
      ),
    );
  }
}
