const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { DataSnapshot } = require('firebase-functions/lib/providers/database');
admin.initializeApp(functions.config().firebase);

exports.createUser = functions.https.onCall((data, context) => {
    const user = admin.firestore().collection("Users");
    return user.doc(`${data[0].userEmail}`).get().then((val) => {
        if (val.exists) {
            user.doc(`${data[0].userEmail}`).update({
                "msgToken": data[0].msgToken
            });
            return { data: val.data() };
        }

        return user.doc(`${data[0].userEmail}`).create({
            "userEmail": data[0].userEmail,
            "userPhone": data[0].userPhone,
            "userName": data[0].userName,
            "msgToken": data[0].msgToken
        });
    });
});

exports.getCurrentUser = functions.https.onCall((data, context) => {
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`);
    return user.get().then((val) => val.data());
});

exports.createOrder = functions.https.onCall((data, context) => {
    var datetime = new Date();
    var today = data[0].today;
    var time = datetime.getHours() + ' : ' + datetime.getMinutes();
    const cafe = admin.firestore().collection(`${data[0].cafecode}`);
    const user = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${today}`);
    user.doc(`${data[0].orderTime}|${time}`).create({
        "cafeCode": data[0].cafecode,
        "orderItems": data[0].orderItems,
        "paymentID": data[0].paymentID,
        "orderDate": today,
        "orderTime": data[0].orderTime,
        "orderStatus": data[0].orderStatus
    });
    return cafe.doc('CafeOrders').collection(`${today}`).doc(`${data[0].orderTime}|${time}`).create({
        "orderBy": data[0].userMail,
        "userName": data[0].userName,
        "orderByPhone": data[0].userPhone,
        "orderItems": data[0].orderItems,
        "paymentID": data[0].paymentID,
        "orderDate": today,
        "orderTime": data[0].orderTime,
        "orderStatus": data[0].orderStatus
    })
});

exports.createGroup = functions.https.onCall((data, context) => {
    const group = admin.firestore().collection('Groups');
    return group.doc(data[0].groupName).create({
        "adminMail": data[0].adminMail,
        "groupName": data[0].groupName
    })
});

exports.getGroups = functions.https.onCall((data, context) => {
    const group = admin.firestore().collection('Groups');
    return group.get().then((snapshot) => snapshot.docs);
})

exports.getCarousels = functions.https.onCall((data, context) => {
    const carousels = admin.firestore().collection('Carousels');
    return carousels.get().then((snapshot) => {
        var caro = [];
        snapshot.forEach(doc => {
            caro.push({
                "ID": doc.id,
                "data": doc.data()
            })
        });
        return caro;
    });
})

exports.getCurrentOrders = functions.https.onCall((data, context) => {
    const orders = admin.firestore().collection('Users').doc(`${data[0].userMail}`).collection(`${data[0].OF}`);
    return orders.get().then((snapshot) => {
        var orders = [];
        snapshot.forEach(doc => {
            orders.push({
                "ID": doc.id,
                "data": doc.data()
            })
        });
        return orders;
    })
})

exports.getAllCafe = functions.https.onCall(async (data, context) => {
    var arry = [];
    const owners = admin.firestore().collection('Owners');
    const snap = await owners.get();
    for (doc of snap.docs) {
        const cafe = admin.firestore().collection(doc.data()['CafeCode']);
        await cafe.doc('INFO').get().then((data) => {
            arry.push({
                "INFO": data.data()
            });
        });
    }
    return arry
})


exports.sendNotificationToOwner = functions.https.onCall((data, context) => {
    const status = data[0]['status'];
    const cafeCode = data[0]['cafeCode'];

    const cafes = admin.firestore().collection('Owners').where("CafeCode", '==', cafeCode);
    cafes.get().then((cafeData) => {
        console.log(cafeData);
        cafeData.forEach((cafe) => {
            var token = cafe.data()['msgToken']
            switch (status) {
                case "accepted":
                    msg = "Order have been accepted."
                    break;
                case "rejected":
                    msg = "Sorry, cafe can't accept that order\nRefund is under processing."
                    break;
                case "preparing":
                    msg = "Your order is being prepared."
                    break;
                case "ready":
                    msg = "Your order is ready to pick-up."
                    break;
                case "Placed":
                    msg = "You have a new Order."
                    break;
                case "cancle":
                    msg = "One Order is cancelled"
                    break;
                default:
                    break;
            }
            var payload = {
                'notification': {
                    'title': "Order " + status,
                    'body': msg,
                    'sound': 'default',
                },
                'data': {}
            };
            admin.messaging().sendToDevice(token, payload).then((val) => { });
        })
    });
})