const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

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
                                  body: `${before.firstName} ${before.lastName} 
updated their weight
class to ${after.weightClass}`,
                                },
                  };
                  try {
                    await admin.messaging().send(notification);
                    console.log("Notification sent successfully");
                  } catch (error) {
                    console.error("Error sending notification:", error);
                  }
                }
              }
            });
          });
    };

// TODO: Create functions for on bio change

exports.sendNotificationOnFighterDataChangeToFans = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
      const before = change.before.data(); // Data before the change
      const after = change.after.data(); // Data after the change

      // Check if userName changed
      if (before.weightClass !== after.weightClass) {
        const userId = context.params.userId;
        sendNotificationOnFighterWeightClassChange(userId, before, after);
      }
    });
