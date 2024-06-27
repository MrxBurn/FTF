const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {FieldValue} = require("firebase-admin/firestore");

// *********************
// *********************
//  LOGIC TO DELETE REPORTED COMMENTS
// *********************
// *********************

const deleteCommentOnReport = async (data) => {
  await admin.firestore().collection("forumDiscussions").doc(data.forumTopic).collection("comments").doc(data.commentId).update({
    reportCount: FieldValue.increment(1),
  });

  const updatedComment = await admin.firestore()
      .collection("forumDiscussions")
      .doc(data.forumTopic).collection("comments")
      .doc(data.commentId)
      .get().then((value) => value.data());


  if (updatedComment.reportCount >= 4) {
    await admin.firestore().collection("forumDiscussions").doc(data.forumTopic).collection("comments").doc(data.commentId).delete();
  }
};

exports.deleteCommentOnReport = functions.firestore.document("reportComments/{reportId}").onCreate(async (snap, context) => {
  const data = snap.data();

  deleteCommentOnReport(data);
});

// *********************
// *********************
//  LOGIC TO DELETE REPORTED USER
// *********************
// *********************


const listOfThreads = ["dreamMatchups", "fighterManagement", "mmaOverBoxing", "nutrition", "p4p", "pension", "predictions", "promotion"];

const reportUserOnReport = async (data) => {
  await admin.firestore().collection("users").doc(data.reportedUser).update({
    reportCount: FieldValue.increment(1),
  });

  const updatedUser = await admin.firestore()
      .collection("users")
      .doc(data.reportedUser)
      .get()
      .then((res) => res.data());

  if (updatedUser.reportCount >= 4) {
    // delete offers
    const createdByOffers = await admin.firestore().collection("fightOffers")
        .where("createdBy", "==", data.reportedUser)
        .get().then((dta) => dta.docs.map((data) => data.data()));

    const opponentOffers = await admin.firestore().collection("fightOffers")
        .where("opponentId", "==", data.reportedUser)
        .get().then((dta) => dta.docs.map((data) => data.data()));

    const combinedOffers = createdByOffers.concat(opponentOffers);

    for (let i = 0; i < combinedOffers.length; i++) {
      admin.firestore().collection("fightOffers").doc(combinedOffers[i].offerId).delete();
    }

    // delete comments

    for (let i = 0; i < listOfThreads.length; i++) {
      admin.firestore()
          .collection("forumDiscussions")
          .doc(listOfThreads[i])
          .collection("comments")
          .where("userId", "==", data.reportedUser)
          .get().
          then((thread) => {
            thread.docs.forEach((doc) => doc.ref.delete());
          },
          );
    }

    // Delete stored files

    // fighter profile image
    const profileImg = await admin.storage().bucket().getFiles({prefix: `fighterProfiles/${data.reportedUser}`});

    profileImg[0].forEach(async (img) => img.delete());


    // callout videos
    // folder created based on offerId => we need to check each offer for files and delete

    for (let i = 0; i < combinedOffers.length; i++) {
      const calloutVideos = await admin.storage().bucket().getFiles({prefix: `calloutVideos/${combinedOffers[i].offerId}`});

      calloutVideos[0].forEach(async (video) => video.delete());
    }


    // delete user object
    await admin.firestore().collection("users").doc(data.reportedUser).delete();

    // delete actual user
    await admin.auth().deleteUser(data.reportedUser);
  }
};


exports.deleteUserOnReport = functions.firestore.document("reportUsers/{reportId}").onCreate(async (snap, context) => {
  const data = snap.data();


  reportUserOnReport(data);
});
