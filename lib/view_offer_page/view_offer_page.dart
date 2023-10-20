// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

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
