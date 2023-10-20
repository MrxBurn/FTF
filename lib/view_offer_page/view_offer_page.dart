import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/utils/lists.dart';

class ViewOfferPage extends StatefulWidget {
  String? offerId;

  ViewOfferPage({Key? key, this.offerId}) : super(key: key);

  @override
  State<ViewOfferPage> createState() => _ViewOfferPageState();
}

class _ViewOfferPageState extends State<ViewOfferPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.offerId);
    return Scaffold(
      body: Column(
        children: [
          LogoHeader(
            backRequired: true,
            onPressed: () => Navigator.pushNamed(context, 'fighterHome'),
          ),
          const Text('View offer page')
        ],
      ),
    );
  }
}
