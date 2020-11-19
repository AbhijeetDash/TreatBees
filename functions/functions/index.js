const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { DataSnapshot } = require('firebase-functions/lib/providers/database');
admin.initializeApp(functions.config().firebase);


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.createOrder = functions.https.onCall((data, context)=>{
    // Takes UserEmail + CafeName + OrderItem + 
    // (Status == Ordered || Placed || Complete || Recieved) (Adons) +
    // OrderType? Delevery Details || None  
    // Then gets the Cafe-Collection from CafeName
    // In the Document CurrentOrders adds the order.


    // Get All the details and add it to User's Orders
});

exports.createGroup = functions.https.onCall((data, context)=>{
    const group = admin.firestore().collection('Groups');
    group.doc(data[0].groupName).create({
        "adminMail" :data[0].adminMail,
        "groupName" :data[0].groupName
    })
});

exports.getGroups = functions.https.onCall((data, context) => {
    const group = admin.firestore().collection('Groups');
    return group.get().then((snapshot)=>{return snapshot.docs});
})