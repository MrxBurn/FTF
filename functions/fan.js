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
                  data: {
                    userId: userId,
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
                  data: {
                    userId: userId,
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

const sendNotificationOnOfferCreateOpponent = async (data) => {
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
                data: {
                  offerId: data.offerId,
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

const sendNotificationOnOfferCreateCreator = async (data) => {
  const fighterData = await admin
      .firestore()
      .collection("users")
      .doc(data.createdBy)
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
                title: "A followed fighter created an offer",
                body: `${fighterData.firstName} ${fighterData.lastName} has created an offer`,
              },
                data: {
                  offerId: data.offerId,
                },
              };
              try {
                await admin.messaging().send(notification);
                console.log("offer created");
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
        sendNotificationOnOfferCreateOpponent(data);
      });

exports.sendNotificationToFanFollowedFighterAsCreator =
  functions
      .firestore
      .document("fightOffers/{offerId}").onCreate(async (snap) => {
        const data = snap.data();
        sendNotificationOnOfferCreateCreator(data);
      });


// *********************
// *********************
//  FAN NOTIFICATION
//  WHEN FIGHT OFFER IS ACCEPTED/DECLINED
// *********************
// *********************

const sendNotificationOnOfferAccepted = async (data) => {
  const fighterOpponentData = await admin
      .firestore()
      .collection("users")
      .doc(data.opponentId)
      .get().then((res) => res.data());

  const fighterCreatorData = await admin
      .firestore()
      .collection("users")
      .doc(data.createdBy)
      .get().then((res) => res.data());


  const creatorFollowersId = fighterCreatorData.followers;
  const opponentFollowersId = fighterOpponentData.followers;

  // creator logic
  creatorFollowersId
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
                title: "Offer has been approved",
                body: `${fighterCreatorData.firstName} ${fighterCreatorData.lastName} approved an offer`,
              },
                data: {
                  offerId: data.offerId,
                },
              };
              try {
                await admin.messaging().send(notification);
                console.log("offer approved creator");
              } catch (error) {
                console.error("Error sending notification:", error);
              }
            }
          }
        });
      });

  // opponent logic
  opponentFollowersId
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
                title: "Offer has been approved",
                body: `${fighterOpponentData.firstName} ${fighterOpponentData.lastName} approved an offer`,
              },
                data: {
                  offerId: data.offerId,
                },
              };
              try {
                await admin.messaging().send(notification);
                console.log("offer approved opponent");
              } catch (error) {
                console.error("Error sending notification:", error);
              }
            }
          }
        });
      });
};

const sendNotificationOnOfferDeclined = async (data) => {
  const fighterOpponentData = await admin
      .firestore()
      .collection("users")
      .doc(data.opponentId)
      .get().then((res) => res.data());

  const fighterCreatorData = await admin
      .firestore()
      .collection("users")
      .doc(data.createdBy)
      .get().then((res) => res.data());


  const creatorFollowersId = fighterCreatorData.followers;
  const opponentFollowersId = fighterOpponentData.followers;

  // creator logic
  creatorFollowersId
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
                title: "Offer has been declined",
                body: `${fighterCreatorData.firstName} ${fighterCreatorData.lastName} declined an offer`,
              },
                data: {
                  offerId: data.offerId,
                },
              };
              try {
                await admin.messaging().send(notification);
                console.log("offer declined creator");
              } catch (error) {
                console.error("Error sending notification:", error);
              }
            }
          }
        });
      });

  // opponent logic
  opponentFollowersId
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
                title: "Offer has been declined",
                body: `${fighterOpponentData.firstName} ${fighterOpponentData.lastName} declined an offer`,
              },
                data: {
                  offerId: data.offerId,
                },
              };
              try {
                await admin.messaging().send(notification);
                console.log("offer declined opponent");
              } catch (error) {
                console.error("Error sending notification:", error);
              }
            }
          }
        });
      });
};

exports.sendNotificationToFanOfferStatusChanged =
  functions
      .firestore
      .document("fightOffers/{offerId}").onUpdate(async (change) => {
        const before = change.before.data();
        const after = change.after.data();

        if (before.status === "PENDING" && after.status === "APPROVED") {
          sendNotificationOnOfferAccepted(change.after.data());
        }
        if (before.status === "PENDING" && after.status === "DECLINED") {
          sendNotificationOnOfferDeclined(change.after.data());
        }
      });
