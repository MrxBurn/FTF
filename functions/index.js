const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();


// *********************
// *********************
//  FAN NOTIFICATION
//  WHEN BIO AND WEIGHTCLASS CHANGES
// *********************
// *********************

const sendNotificationOnFighterWeightClassChange =
  async (userId, before, after) => {
    const fighterData = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get().then((res) => res.data());

    const followersId = fighterData.followers;

    followersId
        .forEach((followerId) => {
          const snapshot = admin
              .firestore().collection("users").doc(followerId).get();
          snapshot.then(async (doc) => {
            if (doc.exists) {
              const fanData = doc.data();

              if (fanData.deviceToken) {
                const notification = {
                  token: fanData.deviceToken,
                  notification:
                {
                  title: "Figher profile information changed",
                  body: `${before.firstName} ${before.lastName} has changed weight class to ${after.weightClass}`,
                },
                };
                try {
                  await admin.messaging().send(notification);
                  console.log("Weight");
                } catch (error) {
                  console.error("Error sending notification:", error);
                }
              }
            }
          });
        });
  };


const sendNotificationOnFighterBioChange =
  async (userId, before) => {
    const fighterData = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get().then((res) => res.data());

    const followersId = fighterData.followers;

    followersId
        .forEach((followerId) => {
          const snapshot = admin
              .firestore().collection("users").doc(followerId).get();
          snapshot.then(async (doc) => {
            if (doc.exists) {
              const fanData = doc.data();

              if (fanData.deviceToken) {
                const notification = {
                  token: fanData.deviceToken,
                  notification:
                {
                  title: "Figher profile information changed",
                  body: `${before.firstName} ${before.lastName} has changed their bio`,
                },
                };
                try {
                  await admin.messaging().send(notification);
                  console.log("Bio");
                } catch (error) {
                  console.error("Error sending notification:", error);
                }
              }
            }
          });
        });
  };


exports.sendNotificationOnFighterDataChangeToFans = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
      const before = change.before.data(); // Data before the change
      const after = change.after.data(); // Data after the change
      const userId = context.params.userId;

      if (before.weightClass !== after.weightClass) {
        sendNotificationOnFighterWeightClassChange(userId, before, after);
      }
      if (before.description !== after.description) {
        sendNotificationOnFighterBioChange(userId, before);
      }
    });


// *********************
// *********************
//  FAN NOTIFICATION
//  WHEN FIGHTER RECEIVES OR CREATES A FIGHT
// *********************
// *********************

const sendNotificationOnOfferCreate = async (data) => {
  const fighterData = await admin
      .firestore()
      .collection("users")
      .doc(data.opponentId)
      .get().then((res) => res.data());

  const followersId = fighterData.followers;

  followersId
      .forEach((followerId) => {
        const snapshot = admin
            .firestore().collection("users").doc(followerId).get();
        snapshot.then(async (doc) => {
          if (doc.exists) {
            const fanData = doc.data();

            if (fanData.deviceToken) {
              const notification = {
                token: fanData.deviceToken,
                notification:
              {
                title: "A followed fighter received an offer",
                body: `${fighterData.firstName} ${fighterData.lastName} has received an offer`,
              },
              };
              try {
                await admin.messaging().send(notification);
              } catch (error) {
                console.error("Error sending notification:", error);
              }
            }
          }
        });
      });
};

exports.sendNotificationToFanFollowedFighterAsOpponent =
  functions
      .firestore
      .document("fightOffers/{offerId}").onCreate(async (snap) => {
        const data = snap.data();

        sendNotificationOnOfferCreate(data);
      });
