const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onFollowUser = functions.firestore
    .document('/followers/{userId}/userFollowers/{followerId}')
    .onCreate(async (snapshot, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        // 팔로우 된 사용자의 팔로우 사용자수를 증가한다.
        const followedUserRef = admin.firestore().collection('users').doc(userId);
        const followedUserDoc = await followedUserRef.get();

        if (followedUserDoc.get('followers')) {
            await followedUserRef.update({followers: followedUserDoc.get('followers') + 1});
        } else {
            await followedUserRef.update({followers: 1});
        }

        // 팔로잉 한 사용자의 팔로잉 사용자수를 증가한다.
        const userRef = admin.firestore().collection('users').doc(followerId);
        const userDoc = await userRef.get();

        if (userDoc.get('following')) {
            await userRef.update({ following: userDoc.get('following') + 1 });
        } else {
            await userRef.update( { following: 1 });
        }

        // 팔로우 된 사용자의 post를 팔로우 한 사용자의 feed에 추가한다.
        const followedUserPostsRef = admin.firestore().collection('posts').where('author', '==', followedUserRef);
        const userFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed');
        const followedUserPostsSnapshot = await followedUserPostsRef.get();

        followedUserPostsSnapshot.forEach(doc => {
            if (doc.exists) {
                userFeedRef.doc(doc.id).set(doc.data());
            }
        });
    });

exports.onUnfollowUser = functions.firestore
    .document('/followers/{userId}/userFollowers/{followerId}')
    .onDelete(async (snapshot, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        // 언팔로루 된 사용자의 팔로우 사용자수를 증가한다.
        const followedUserRef = admin.firestore().collection('users').doc(userId);
        const followedUserDoc = await followedUserRef.get();

        if (followedUserDoc.get('followers')) {
            await followedUserRef.update({followers: followedUserDoc.get('followers') - 1});
        } else {
            await followedUserRef.update({followers: 0});
        }

        // 언팔로잉 한 사용자의 팔로잉 사용자수를 증가한다.
        const userRef = admin.firestore().collection('users').doc(followerId);
        const userDoc = await userRef.get();

        if (userDoc.get('following')) {
            await userRef.update({ following: userDoc.get('following') - 1 });
        } else {
            await userRef.update( { following: 0 });
        }

        // 팔로우 된 사용자의 post를 팔로우 한 사용자의 feed에 추가한다.
        const userFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed').where('author', '==', followedUserRef);
        const userPostSnapshot = await userFeedRef.get();

        userPostSnapshot.forEach(doc => {
            if (doc.exists) {
                doc.ref.delete();
            }
        });
    });