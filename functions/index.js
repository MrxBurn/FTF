const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnUserNameChange = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
      const before = change.before.data(); // Data before the change
      const after = change.after.data(); // Data after the change

      // Check if userName changed
      if (before.userName !== after.userName) {
        const userId = context.params.userId;


        const userSnapshot = await admin.
            firestore().collection("users").doc(userId).get();
        const userData = userSnapshot.data();

        if (userData && userData.deviceToken) {
        // Send notification using the user's device token
          const notification = {
            token: userData.deviceToken,
            notification: {
              title: "UserName Changed",
              body: `Your userName has been changed to ${after.userName}`,
            },
          };

          try {
            await admin.messaging().send(notification);
            console.log("Notification sent successfully");
          } catch (error) {
            console.error("Error sending notification:", error);
          }
        } else {
          console.log("User data or device token not found");
        }
      }
    });
