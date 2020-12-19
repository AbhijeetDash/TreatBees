import 'package:TreatBees/utils/functions.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payments {
  Razorpay _razorpay;
  String userEmail, cafecode, time, userPhno, userName, docName;
  List<Map<String, String>> orderItems = [];
  String paymentId;

  Payments(String docName, String userName, String userEmail, String cafecode,
      String time, List<Map<String, String>> orderItems, String userPhno) {
    this.docName = docName;
    this.userName = userName;
    this.userEmail = userEmail;
    this.cafecode = cafecode;
    this.time = time;
    this.orderItems = orderItems;
    this.userPhno = userPhno;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void createOrder(int amount, String uName, String uEmail, String userPhone) {
    var options = {
      'key': 'rzp_test_qZ6mpIbWNzYTaI',
      'amount': amount,
      'name': uName,
      'description': 'Payment',
      'prefill': {'email': uEmail, "phone": userPhone},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Add Order to the database with payment status..
    // cafecode would be cafeID in the form of cafecode@TBID
    FirebaseCallbacks().placeOrder(docName, userName, userEmail, userPhno,
        cafecode, time, orderItems, response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // don't add the order and show error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // handle error and success and do the same as Success and Error
  }
}
