import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/utils/lists.dart';

class ViewOfferPage extends StatefulWidget {
  const ViewOfferPage({super.key});

  @override
  State<ViewOfferPage> createState() => _ViewOfferPageState();
}

class _ViewOfferPageState extends State<ViewOfferPage> {
  String rematchClauseValue = rematchClause.first;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    print(arguments['link']);
    return Scaffold(
      body: Column(
        children: [
          LogoHeader(backRequired: true),
          DropDownWidget(
            dropDownList: rematchClause,
            dropDownValue: rematchClauseValue,
            dropDownName: 'Rematch clause*',
          ),
        ],
      ),
    );
  }
}
