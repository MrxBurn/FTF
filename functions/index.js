const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnFighterDataChangeToFans = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
        const before = change.before.data(); // Data before the change
        const after = change.after.data(); // Data after the change

        // Check if userName changed
        if (before.weightClass !== after.weightClass) {
            const userId = context.params.userId;

            const fighterSnapshot = await admin
                .firestore()
                .collection("users")
                .doc(userId)
                .get();

            const fighterData = fighterSnapshot.data();

            if (fighterData && fighterData.route === "fighter") {
                const followers = fighterData.followers || [];

                const fanPromises = followers.map(async (followerId) => {
                    const fanSnapshot = await admin
                        .firestore()
                        .collection("users")
                        .doc(followerId)
                        .get();

                    const fanData = fanSnapshot.data();
                    if (fanData && fanData.route === "fan" && fanData.deviceToken) {
                        const notification = {
                            token: fanData.deviceToken,
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
                    }
                });

                await Promise.all(fanPromises);
            }
        }
    });

