const functions = require("firebase-functions");
const admin = require("firebase-admin");

// *********************
// *********************
//  FIGHTER NOTIFICATION
//  WHEN OFFER IS CREATED
// *********************
// *********************

const sendNotification = async (data, title, body, offerId) => {
  const fighterData = await admin
      .firestore()
      .collection("users")
      .doc(data.opponentId)
      .get().then((res) => res.data());

  if (fighterData.deviceToken) {
    const notification = {
      token: fighterData.deviceToken,
      notification:
      {
        title: title,
        body: body,
      },
      data: {
        offerId: offerId,
        type: "fighter",
      },
    };
    try {
      await admin.messaging().send(notification);
      console.log(data);
      console.log(`${data.creator} success`);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }
};

const sendNotificationOnOfferStatusChange = async (data, title, body, offerId) => {
  const creatorData = await admin
      .firestore()
      .collection("users")
      .doc(data.createdBy)
      .get().then((res) => res.data());

  const opponentData = await admin
      .firestore()
      .collection("users")
      .doc(data.opponentId)
      .get().then((res) => res.data());

  if (creatorData.deviceToken) {
    const notification = {
      token: creatorData.deviceToken,
      notification:
      {
        title: title,
        body: body,
      },
      data: {
        offerId: offerId,
        type: "fighter",
      },
    };
    try {
      await admin.messaging().send(notification);
      console.log(`done`);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }

  if (opponentData.deviceToken) {
    const notification = {
      token: opponentData.deviceToken,
      notification:
      {
        title: title,
        body: body,
      }, data: {
        offerId: offerId,
        type: "fighter",
      },
    };
    try {
      await admin.messaging().send(notification);
      console.log(`done`);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }
};

const sendNotificationOnNegotiationSent = async (data, offerId) => {
  const lastNegotiation = data.negotiationValues.slice(-1)[0];

  console.log(lastNegotiation.createdBy);

  // check if creator negotiated
  if (data.createdBy == lastNegotiation.createdBy) {
    const fighterData = await admin
        .firestore()
        .collection("users")
        .doc(data.opponentId)
        .get().then((res) => res.data());

    if (fighterData.deviceToken) {
      const notification = {
        token: fighterData.deviceToken,
        notification:
        {
          title: `Negotiation received`,
          body: `${data.creator} has sent you a negotiation`,
        },
        data: {
          offerId: offerId,
          type: "fighter",
        },
      };
      try {
        await admin.messaging().send(notification);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }
  }

  if (data.opponentId == lastNegotiation.createdBy) {
    const fighterData = await admin
        .firestore()
        .collection("users")
        .doc(data.createdBy)
        .get().then((res) => res.data());

    if (fighterData.deviceToken) {
      const notification = {
        token: fighterData.deviceToken,
        notification:
        {
          title: `Negotiation received`,
          body: `${data.opponent} has sent you a negotiation`,
        },
        data: {
          offerId: offerId,
          type: "fighter",
        },
      };
      try {
        await admin.messaging().send(notification);
        console.log(data);
        console.log(`${data.creator} success`);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }
  }
};


exports.sendNotificationOnOfferCreated = functions.firestore.document("fightOffers/{offerId}").onCreate(async (snap, context) => {
  const data = snap.data();
  const offerId = context.params.offerId;

  sendNotification(data, "Offer received", `${data.creator} has sent you an offer`, offerId);
});

exports.sendNotificationOnNegotiation = functions.firestore.document("fightOffers/{offerId}").onUpdate(async (change, context) => {
  const offerId = context.params.offerId;
  const before = change.before.data();
  const after = change.after.data();


  if (before.negotiationValues.length !== after.negotiationValues.length) {
    sendNotificationOnNegotiationSent(change.after.data(), offerId);
  }
});

exports.sendNotificationOnApproveCreator = functions.firestore.document("fightOffers/{offerId}").onUpdate(async (change, context) => {
  const offerId = context.params.offerId;
  const before = change.before.data();
  const after = change.after.data();

  if (before.status === "PENDING" && after.status === "APPROVED") {
    sendNotificationOnOfferStatusChange(change.after.data(), "Offer approved", `One of your offers has been approved`, offerId);
  }
  if (before.status === "PENDING" && after.status === "DECLINED") {
    sendNotificationOnOfferStatusChange(change.after.data(), "Offer declined", `One of your offers has been declined`, offerId);
  }
});

// *********************
// *********************
//  FIGHTER NOTIFICATION
//  WHEN MESSAGE IS SENT/RECEIVED
// *********************
// *********************

const sendNotificationOnMessageSent = async (messageData, offerId) => {

  console.log(offerId);

  //get offer
  const offer = await admin
  .firestore()
  .collection("fightOffers")
  .doc(offerId)
  .get().then((res) => res.data());


  //if sender is the creator
  //then send a message to opponent
  if(messageData.senderId == offer.createdBy)
  {

    const fighterData = await admin
    .firestore()
    .collection("users")
    .doc(offer.opponentId)
    .get().then((res) => res.data());

    if (fighterData.deviceToken) {
      const notification = {
        token: fighterData.deviceToken,
        notification:
        {
          title: `New message from ${offer.opponent}`,
          body: `${messageData.message}`,
        },
        data: {
          offerId: offerId,
        },
      };
      try {
        await admin.messaging().send(notification);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }
  }
   //if sender is the opponent
  //then send a message to creator
  if(messageData.senderId == offer.opponentId)
  {

    const fighterData = await admin
    .firestore()
    .collection("users")
    .doc(offer.createdBy)
    .get().then((res) => res.data());

    if (fighterData.deviceToken) {
      const notification = {
        token: fighterData.deviceToken,
        notification:
        {
          title: `New message from ${offer.opponent}`,
          body: `${messageData.message}`,
        },
        data: {
          offerId: offerId,
        },
      };
      try {
        await admin.messaging().send(notification);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }
  }
}


exports.sendNotificationOnMessageSent = functions.firestore.document("fightOffers/{offerId}/messages/{messageId}").onCreate(async (snap, context) => {
  const offerId = context.params.offerId;
  if(offerId)
  {
    await sendNotificationOnMessageSent(snap.data(), offerId);
  }
})