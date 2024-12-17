const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.createProfile = functions.auth.user().onCreate((user) => {
  const { uid, displayName, photoURL } = user;
  return admin.firestore().collection('profiles').doc(uid).set({
    full_name: displayName || '',
    avatar_url: photoURL || '',
    updated_at: admin.firestore.FieldValue.serverTimestamp(),
  });
});

