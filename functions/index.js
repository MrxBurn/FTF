

const fan = require("./fan");
const fighter = require("./fighter");


// fan functions
exports.FANSendNotificationOnFighterDataChangeToFans = fan.sendNotificationOnFighterDataChangeToFans;
exports.FANSendNotificationToFanFollowedFighterAsCreator = fan.sendNotificationToFanFollowedFighterAsCreator;
exports.FANSendNotificationToFanFollowedFighterAsOpponent = fan.sendNotificationToFanFollowedFighterAsOpponent;
exports.FANSendNotificationToFanOfferStatusChanged = fan.sendNotificationToFanOfferStatusChanged;

// fighter functions
exports.FIGHTERSendNotificationOnOfferCreated = fighter.sendNotificationOnOfferCreated;
exports.FIGHTERSendNotificationOnNegotiation = fighter.sendNotificationOnNegotiation;
exports.FIGHTERSendNotificationOnApproveCreator = fighter.sendNotificationOnApproveCreator;
