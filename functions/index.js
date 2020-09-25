const functions = require('firebase-functions');
const Filter = require('bad-words');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

    
exports.detectBadStatus = functions.firestore
              .document('users_status/{documentId}')
              .onCreate(async (doc, ctx) => {

               const filter = new Filter();
               const { status, username } = doc.data(); 
       
       
               if (filter.isProfane(status)) {
                   //logger.log('detect bad status', username, status);
                   const cleaned = filter.clean(status);
                   await doc.ref.update({'status': cleaned});
                   await db.collection('bad_words').add({'username': username, 'status': status});
               } 
              
       });

