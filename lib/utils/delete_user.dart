import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ftf/main.dart';
import 'package:ftf/utils/forum_data.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';

Future<void> deleteFighter(String? currentUser) async {
  //delete offers
  List userOffers = await FirebaseFirestore.instance
      .collection('fightOffers')
      .where(Filter.or(Filter('createdBy', isEqualTo: currentUser),
          Filter('opponentId', isEqualTo: currentUser)))
      .get()
      .then((data) => data.docs.map((data) => data.data()).toList());

  userOffers.forEach((offer) async {
    await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(offer['offerId'])
        .delete();
  });

//delete images/videos
  ListResult userProfilePictures = await FirebaseStorage.instance
      .ref('fighterProfiles/${currentUser}')
      .listAll();

  userProfilePictures.items.forEach((item) {
    item.delete();
  });

  userOffers.forEach((offer) async {
    ListResult userCalloutVideos = await FirebaseStorage.instance
        .ref('calloutVideos/${offer['offerId']}')
        .listAll();

    userCalloutVideos.items.forEach((item) {
      item.delete();
    });
  });

  for (var thread in threads) {
    await FirebaseFirestore.instance
        .collection('forumDiscussions')
        .doc(thread['collection'])
        .collection('comments')
        .where('userId', isEqualTo: currentUser)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) => doc.reference.delete());
    });
  }

  // delete user data
  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .delete();

  await FirebaseAuth.instance.currentUser?.delete().then((v) => {
        showSnackBarNoContext(
            text: 'Account deleted', snackbarKey: snackbarKey),
        navigatorKey.currentState
            ?.pushNamedAndRemoveUntil('loginPage', (route) => false)
      });
}

Future<void> deleteFan(String? currentUser) async {
  // delete user data
  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .delete();

  // delete comments
  for (var thread in threads) {
    await FirebaseFirestore.instance
        .collection('forumDiscussions')
        .doc(thread['collection'])
        .collection('comments')
        .where('userId', isEqualTo: currentUser)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) => doc.reference.delete());
    });
  }

  await FirebaseAuth.instance.currentUser?.delete().then((v) => {
        showSnackBarNoContext(
            text: 'Account deleted', snackbarKey: snackbarKey),
        navigatorKey.currentState
            ?.pushNamedAndRemoveUntil('loginPage', (route) => false)
      });

  showSnackBarNoContext(text: 'Account deleted', snackbarKey: snackbarKey);
}
