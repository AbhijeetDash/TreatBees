const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { DataSnapshot } = require('firebase-functions/lib/providers/database');
admin.initializeApp(functions.config().firebase);

exports.createUser = functions.https.onCall((data,context)=>{
    const user = admin.firestore().collection("Users");
    return user.doc(`${data[0].userEmail}`).create({
        "userEmail":data[0].userEmail,
        "userPhone":data[0].userPhone,
        "userName":data[0].userName
    })
});

exports.getCurrentUser = functions.https.onCall((data, context)=>{
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`);
    return user.get().then((val) => val.data()); 
});

exports.createOrder = functions.https.onCall((data, context)=>{
    var datetime = new Date();
    var month = datetime.getMonth()+1;
    var today = datetime.getDate() +' : '+month+' : '+datetime.getFullYear();
    const cafe = admin.firestore().collection(`${data[0].cafeName}`);
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${today}`);
    user.doc(`${data[0].orderTime}`).create({
        "cafeName":data[0].cafeName,
        "orderItems":data[0].orderItems,
        "paymentID":data[0].paymentID,
        "orderDate":today,
        "orderTime": data[0].orderTime,
        "orderStatus":data[0].orderStatus
    });
    return cafe.doc('CafeOrders').collection(`${today}`).doc(`${data[0].orderTime}`).create({
        "orderBy":data[0].userMail,
        "orderByPhone":data[0].userPhone,
        "orderItems":data[0].orderItems,
        "paymentID":data[0].paymentID,
        "orderDate":today,
        "orderTime": data[0].orderTime,
        "orderStatus":data[0].orderStatus
    })
});

exports.createGroup = functions.https.onCall((data, context)=>{
    const group = admin.firestore().collection('Groups');
    return group.doc(data[0].groupName).create({
        "adminMail" :data[0].adminMail,
        "groupName" :data[0].groupName
    })
});

exports.getGroups = functions.https.onCall((data, context) => {
    const group = admin.firestore().collection('Groups');
    return group.get().then((snapshot)=>snapshot.docs);
})

exports.getCarousels = functions.https.onCall((data, context)=> {
    const carousels = admin.firestore().collection('Carousels');
    return carousels.get().then((snapshot)=>{
        var caro = [];
        snapshot.forEach(doc => {
           caro.push({
               "ID":doc.id,
               "data":doc.data()
           })
        });
        return caro;
    });    
})

exports.getCurrentOrders = functions.https.onCall((data, context) => {
    const orders = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${data[0].OF}`);
    return orders.get().then((snapshot)=>{
        var orders = [];
        snapshot.forEach(doc => {
           orders.push({
               "ID":doc.id,
               "data":doc.data()
           })
        });
        return orders;
    })
})