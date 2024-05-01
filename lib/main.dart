import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ftf/authentication/account_type.dart';
import 'package:ftf/authentication/fighter_image_upload.dart';
import 'package:ftf/authentication/forgot_passwrod.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/authentication/register_fan.dart';
import 'package:ftf/authentication/register_fighter.dart';
import 'package:ftf/chat/chat_page.dart';
import 'package:ftf/create_offer_page/create_offer_fighter.dart';
import 'package:ftf/create_offer_page/dynamic_link_summary.dart';
import 'package:ftf/dashboard/dashboard_page.dart';
import 'package:ftf/fan_fights_overview/fights_overview_page.dart';
import 'package:ftf/fan_forum/fan_forum_page.dart';
import 'package:ftf/fighter_forum/fighter_forum.dart';
import 'package:ftf/fighters_overview/fighter_view.dart';
import 'package:ftf/fighters_overview/fighters_overview.dart';
import 'package:ftf/home_pages/fan_home_page.dart';
import 'package:ftf/home_pages/fighter_home_page.dart';
import 'package:ftf/my_account/my_account_fan.dart';
import 'package:ftf/my_account/my_account_fighter.dart';
import 'package:ftf/my_fighters_overview/my_followed_fighters.dart';
import 'package:ftf/my_offers/my_offers_page.dart';
import 'package:ftf/news_and_events/news_and_events_page.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/foreground_notification_service.dart';
import 'package:ftf/view_offer_page/view_offer_page_fan.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';
import 'package:month_year_picker/month_year_picker.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

const bool useEmulator = true;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void onForegroundNotificationTap(NotificationResponse response) {
  List<String> payloadSplit = response.payload?.split(' ') ?? [];

  if (payloadSplit.contains('userId')) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => FighterView(
          fighterId: payloadSplit[1],
        ),
      ),
    );
  }
  if (payloadSplit.contains('offerId') && payloadSplit.contains('fighter')) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ViewOfferPage(offerId: payloadSplit[1]),
      ),
    );
  }
  if (payloadSplit.contains('offerId') && payloadSplit.contains('fan')) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ViewOfferPageFan(offerId: payloadSplit[1]),
      ),
    );
  }
}

Future connectEmulator() async {
  final localHostString = Platform.isAndroid ? "10.0.2.2" : 'localhost';

  FirebaseFirestore.instance.settings = Settings(
    host: '$localHostString:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  await FirebaseAuth.instance
      .useAuthEmulator('http://$localHostString:9099', 9099);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (useEmulator) {
    await connectEmulator();
  }

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onForegroundNotificationTap);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

//when app terminated
  FirebaseMessaging.instance.getInitialMessage().then((value) => {
        if (value != null &&
            value.notification != null &&
            value.data.containsKey('userId'))
          {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => FighterView(
                  fighterId: value.data['userId'],
                ),
              ),
            )
          },
        if (value != null &&
            value.notification != null &&
            value.data.containsKey('offerId') &&
            value.data['type'] == 'fan')
          {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) =>
                    ViewOfferPageFan(offerId: value.data['offerId']),
              ),
            )
          },
        if (value != null &&
            value.notification != null &&
            value.data.containsKey('offerId') &&
            value.data['type'] == 'fighter')
          {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) =>
                    ViewOfferPage(offerId: value.data['offerId']),
              ),
            )
          }
      });

//app in background
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.notification != null && event.data.containsKey('userId')) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FighterView(
            fighterId: event.data['userId'],
          ),
        ),
      );
    }
    if (event.notification != null &&
        event.data.containsKey('offerId') &&
        event.data['type'] == 'fan') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) =>
              ViewOfferPageFan(offerId: event.data['offerId']),
        ),
      );
    }
    if (event.notification != null &&
        event.data.containsKey('offerId') &&
        event.data['type'] == 'fighter') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ViewOfferPage(offerId: event.data['offerId']),
        ),
      );
    }
  });

//app in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    String constructedPayload = message.data.containsKey('userId')
        ? "userId ${message.data['userId']} type ${message.data['type']}"
        : "offerId ${message.data['offerId']} type ${message.data['type']}";

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            playSound: true,
            icon: '@drawable/ftf_icon',
            color: Colors.black,
            colorized: true,
          ),
        ),
        payload: constructedPayload,
      );
    }
  });

  runApp(const MyApp());
}

User? currentUser = FirebaseAuth.instance.currentUser;

Widget initialWidget = const Placeholder();

Uri? deepLink;

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initDynamicLink();
  }

  Future<void> initDynamicLink() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (Platform.isIOS) {
      FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
          setState(() {
            deepLink = pendingDynamicLinkData.link;
          });
        },
      );
    }

    setState(() {
      deepLink = initialLink?.link;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;

      print(token);
    });
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        progressIndicatorTheme:
            ProgressIndicatorThemeData(color: Colors.yellow),
        primaryColor: Colors.black,
        primaryColorDark: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              overlayColor:
                  MaterialStatePropertyAll(Colors.red.withOpacity(0.2)),
              backgroundColor:
                  const MaterialStatePropertyAll(Color(lighterBlack)),
              foregroundColor: const MaterialStatePropertyAll(Colors.white)),
        ),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.white,
            selectionHandleColor: Colors.white),
      ),
      routes: {
        'fighterHome': (context) => const FighterHomePage(),
        'fanHome': (context) => const FanHomePage(),
        'accountType': (context) => AccountType(),
        'registerFighter': (context) => RegisterFighter(),
        'registerFan': (context) => const RegisterFan(),
        'loginPage': (context) => const LoginPage(),
        'fighterImageUpload': (context) => const FighterImageUpload(),
        'createOfferFighter': (context) => const CreateOfferFighter(),
        'dynamicLinkSummary': (context) => const DynamicLinkSummary(),
        'viewOffer': (context) => ViewOfferPage(),
        'dashboard': (context) => const DashboardPage(),
        'myOffers': (context) => MyOffersPage(),
        'fighterForum': (context) => const FighterForum(),
        'fanForum': (context) => const FanForumPage(),
        'newsEvents': (context) => const NewsAndEventsPage(),
        'myAccountFighter': (context) => const MyAccountFighter(),
        'myAccountFan': (context) => const MyAccountFan(),
        'fanFightsOverview': (context) => const FanFightsOverview(),
        'fightersOverview': (context) => const FightersOverview(),
        'myFighters': (context) => const MyFollowedFighters(),
        'forgotPassword': (context) => const ForgotPasswordPage(),
        'chatPage': (context) => ChatPage()
      },
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      home: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData &&
              !snapshot.data!.exists &&
              currentUser == null) {
            return LoginPage(
              offerId: deepLink?.queryParameters['offerId'],
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data?.get('route') == 'fighter' &&
              deepLink != null &&
              deepLink.toString().contains('offerId') &&
              currentUser != null) {
            return ViewOfferPage(
              offerId: deepLink?.queryParameters['offerId'],
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              currentUser != null &&
              snapshot.data?.get('route') == 'fan') {
            return const FanHomePage();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              currentUser != null &&
              snapshot.data?.get('route') == 'fighter') {
            return const FighterHomePage();
          }

          return SizedBox(
            child: Column(children: [
              LogoHeader(backRequired: false),
              const Center(child: CircularProgressIndicator())
            ]),
          );
        },
      ),
    );
  }
}
