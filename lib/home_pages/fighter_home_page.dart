import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_cards.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class FighterHomePage extends StatefulWidget {
  const FighterHomePage({super.key});

  @override
  State<FighterHomePage> createState() => _FighterHomePageState();
}

class _FighterHomePageState extends State<FighterHomePage> {
  late Image createOfferImage;
  late Image myOffersImage;
  late Image dashboardImage;
  late Image fighterForumImage;
  late Image eventsImage;
  late Image myAccountImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    createOfferImage = Image.asset(
      'assets/illustrations/create_offer.jpg',
      fit: BoxFit.fill,
      // height: 145,
      width: double.infinity,
    );
    myOffersImage = Image.asset(
      'assets/illustrations/my_offers.jpg',
      fit: BoxFit.fill,
      // height: 145,
      width: double.infinity,
    );
    dashboardImage = Image.asset(
      'assets/illustrations/dashboard.png',
      fit: BoxFit.fill,
      // height: 145,
      width: double.infinity,
    );
    fighterForumImage = Image.asset(
      'assets/illustrations/forum.jpeg',
      fit: BoxFit.fill,
      // height: 145,
      width: double.infinity,
    );
    eventsImage = Image.asset(
      'assets/illustrations/events.png',
      fit: BoxFit.fill,
      // height: 145,
      width: double.infinity,
    );
    myAccountImage = Image.asset(
      'assets/illustrations/my_account.jpg',
      fit: BoxFit.fill,
      // height: 145,
      width: double.infinity,
    );
  }

  @override
  void didChangeDependencies() async {
    setState(() {
      isLoading = true;
    });
    if (context.mounted) {
      precacheImage(
        createOfferImage.image,
        context,
      );
      precacheImage(
        myOffersImage.image,
        context,
      );
      precacheImage(
        dashboardImage.image,
        context,
      );
      precacheImage(
        fighterForumImage.image,
        context,
      );
      precacheImage(
        eventsImage.image,
        context,
      );
      precacheImage(
        myAccountImage.image,
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            isLoading == true
                ? const CircularProgressIndicator()
                : Padding(
                    padding: paddingLRT,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonCard(
                              image: createOfferImage,
                              name: 'Create offer',
                              route: 'createOfferFighter',
                            ),
                            ButtonCard(
                              image: myOffersImage,
                              route: 'myOffers',
                              name: 'My offers',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonCard(
                              image: dashboardImage,
                              route: 'dashboard',
                              name: 'Dashboard',
                            ),
                            ButtonCard(
                              image: fighterForumImage,
                              route: 'fighterForum',
                              name: 'Fighter forum',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonCard(
                              image: eventsImage,
                              route: 'newsEvents',
                              name: 'Events',
                            ),
                            ButtonCard(
                              image: myAccountImage,
                              route: 'myAccount',
                              name: 'My account',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
