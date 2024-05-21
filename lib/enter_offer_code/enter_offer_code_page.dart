import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/main.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';

class EnterOfferCodePage extends StatefulWidget {
  const EnterOfferCodePage({super.key});

  @override
  State<EnterOfferCodePage> createState() => _EnterOfferCodePageState();
}

class _EnterOfferCodePageState extends State<EnterOfferCodePage> {
  TextEditingController codeController = TextEditingController();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('fightOffers');

  void onOfferCodeSubmitted(String offerCode) async {
    List res = await collectionReference
        .where('offerId', isEqualTo: offerCode)
        .get()
        .then((e) => e.docs.map((e) => e.data()).toList());

    if (res.length != 0 &&
        res[0]['fighterNotFoundChecked'] &&
        res[0]['opponent'] == '-') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewOfferPage(offerId: offerCode),
          ));
    } else {
      showSnackBarNoContext(
          text: 'Offer not found or already assigned',
          snackbarKey: snackbarKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: true),
            Padding(
              padding: paddingLRT,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Color(lighterBlack),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Enter the code received from another fighter to join the offer',
                          style: TextStyle(),
                        ),
                      ),
                      InputFieldWidget(
                          controller: codeController,
                          pLabelText: 'Enter code here'),
                      BlackRoundedButton(
                          isLoading: false,
                          onPressed: () =>
                              onOfferCodeSubmitted(codeController.text),
                          text: 'Join offer')
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
