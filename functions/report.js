const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { FieldValue } = require("firebase-admin/firestore");

// *********************
// *********************
//  LOGIC TO DELETE REPORTED COMMENTS
// *********************
// *********************

const deleteCommentOnReport = async (data) => {
    await admin.firestore().collection('forumDiscussions').doc(data.forumTopic).collection('comments').doc(data.commentId).update({
        reportCount: FieldValue.increment(1)
    });

    const updatedComment = await admin.firestore().collection('forumDiscussions').doc(data.forumTopic).collection('comments').doc(data.commentId).get().then((value) => value.data());


    if (updatedComment.reportCount >= 4) {
        await admin.firestore().collection('forumDiscussions').doc(data.forumTopic).collection('comments').doc(data.commentId).delete();
    }
};

exports.deleteCommentOnReport = functions.firestore.document("reportComments/{reportId}").onCreate(async (snap, context) => {
    const data = snap.data();

    deleteCommentOnReport(data);
})

// *********************
// *********************
//  LOGIC TO DELETE REPORTED USER
// *********************
// *********************


const reportUserOnReport = async (data) => {
    await admin.firestore().collection('users').doc(data.reportedUser).update({
        reportCount: FieldValue.increment(1)
    });

    const updatedUser = await admin.firestore().collection('users').doc(data.reportedUser).get().then((res) => res.data());

    if (updatedUser.reportCount >= 4) {
        const createdByOffers = await admin.firestore().collection('fightOffers')
            .where('createdBy', '==', data.reportedUser)
            .get().then((dta) => dta.docs.map((data) => data.data()));

        const opponentOffers = await admin.firestore().collection('fightOffers')
            .where('opponentId', '==', data.reportedUser)
            .get().then((dta) => dta.docs.map((data) => data.data()));

        let combinedOffers = createdByOffers.concat(opponentOffers);

        for (let i = 0; i < combinedOffers.length; i++) {
            //TODO: Finalise this
            console.log(combinedOffers[i]);
        }
    }

}


exports.deleteUserOnReport = functions.firestore.document("reportUsers/{reportId}").onCreate(async (snap, context) => {
    const data = snap.data();


    reportUserOnReport(data);

});