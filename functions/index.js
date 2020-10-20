const functions = require('firebase-functions');
const Filter = require('bad-words');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


exports.detectBadStatus = functions.firestore
    .document('users_status/{documentId}')
    .onCreate(async (doc, ctx) => {

        const filter = new Filter();
        const { status, username } = doc.data();


        if (filter.isProfane(status)) {
            const cleaned = filter.clean(status);
            await doc.ref.update({ 'status': cleaned });
            await db.collection('bad_words').add({ 'username': username, 'status': status });
        }

    });


exports.sendStatusPushNotifications = functions.firestore
    .document('users_status/{documentId}')
    .onCreate(async (doc, ctx) => {
        const querySnapshot = await db
            .collection('user_names').get();

        // the created status, username data
        const { status, username } = doc.data();

        // users FCM tokens
        const tokens = [];

        // iterate querySnapshot docs and push fcm_token to tokens array
        for (let index = 0; index < querySnapshot.docs.length; index++) {
            const snap = querySnapshot.docs[index];
            // extract username 
            const user = snap.get('username');
            // evoid send notification to the status user creator
            if (user !== username) {
                // push the token
                tokens.push(snap.get('fcm_token'));
            }

        }

        // If tokens list is not empty, send notifications to devices
        if (tokens.length !== 0) {
            // filter bad words status
            const filter = new Filter();
            const payload = {
                notification: {
                    title: username + ' just uploaded new status',
                    body: filter.clean(status),
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
            };

            return fcm.sendToDevice(tokens, payload);
        }

    });

