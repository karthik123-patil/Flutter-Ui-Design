import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:trailer_tracking/screens/User%20Module/dashboard/home_screen.dart';
import 'package:trailer_tracking/screens/User%20Module/wallet/wallet_activities_screen.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../utils/internet_connection.dart';

class WalletScreen extends StatefulWidget {
  static const String id = StringConstants.walletScreen;
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late StreamSubscription _connectionChangeStream;
  bool isConnected = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isOffline = false;
  bool isCheckboxCheck = false;
  bool isShow = false;
  bool isEliteShow = false;
  bool isShow500 = false;
  bool isShow1000 = false;
  bool isShow1500 = false;
  bool isShow2000 = false;
  bool isShow2500 = false;
  TextEditingController _addMoneyController = TextEditingController();
  late String payment_response;
  String _strTotalWalletAmount = "0.0", _strUserMobile = "", _strUserEmail = "" ,_strTotalCart = "", _strDeviceId ="";
  bool isCartTotal = false;
  /*late Razorpay razorpay;*/

  //Live
  String mid = StringConstants.paytmMerchantId;
  String PAYTM_MERCHANT_KEY = StringConstants.paytmMerchantKey;
  String website = "DEFAULT";
  bool testing = false;

  //Testing
  // String mid = "TEST_MID_HERE";
  // String PAYTM_MERCHANT_KEY = "TEST_KEY_HERE";
  // String website = "WEBSTAGING";
  // bool testing = true;

  double amount = 1;
  bool loading = false;
  DateTime todayDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getDeviceId();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    /*razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);*/
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  void getDeviceId() async{
    AppUtils().getId().then((value){
      _strDeviceId = value.toString();
    });
  }



  Future<dynamic> generateOrderId() async{
    double  amt = double.parse(_addMoneyController.text) * 100;
    String key = StringConstants.razorPyaKey;
    String secret = StringConstants.razorPyaSecretKey;
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
    var responseJson;
    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data = '{ "amount": $amt, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'), headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    print('ORDER ID response => ${res.body}');
    responseJson = json.decode(res.body)['id'].toString();
    return responseJson;
  }

  Future<void> openCheckout() async {
    double  amt = double.parse(_addMoneyController.text) * 100;
    var options = {
      'key': StringConstants.razorPyaKey,
      'amount': amt, //in the smallest currency sub-unit.
      'name': 'MilkPot',
      //'order_id': orderId,// Generate order_id using Orders API
      'description': 'Payment for the Wallet',
      'timeout': 180, // in seconds
      'prefill': {
        'contact': _strUserMobile,
        'email': _strUserEmail,
      },
      'theme': {
        'color': '#134785',
        'hide_topbar': 'true', //To hide the back button
      },
      "checkout": {
        "method": {
          "netbanking": "1",
          "card": "1",
          "upi": "0",
          "wallet": "0"
        }
      },
    };

    try{
      //razorpay.open(options);
    }catch(e){
      print(e.toString());
    }

  }

  /*void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);
    Navigator.of(context).pop(true);
    addMoneyToWallet(_addMoneyController.text.toString(), "TXN_SUCCESS", response.paymentId.toString(), "", todayDate.toString().substring(0,10), "", "RAZORPAY");
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.of(context).pop(true);
    addMoneyToWallet(_addMoneyController.text.toString(), "TXN_FAILURE", response.code.toString(), "", todayDate.toString().substring(0,10), "", "RAZORPAY");
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    addMoneyToWallet(_addMoneyController.text.toString(), "TXN_SUCCESS", response.walletName.toString(), "", todayDate.toString().substring(0,10), "", "RAZORPAY");

    // Do something when an external wallet is selected
  }*/

  Future<void> _showPayFromWalletDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          content: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: const Alignment(1.05, -1.05),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.of(context).pop(true);
                          },
                          icon: const Icon(Icons.close, color: AppColors.editTextErrorBorderColor,),
                          iconSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/icons/icon_pay_delivery.png",
                        scale: 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    Text(
                      "Pay Via",
                      style:  TextStyle(
                        color: AppColors.gradientBlueColor,
                        fontSize: 14.0,
                        fontWeight:
                        FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: "Poppins",
                        fontStyle:
                        FontStyle.normal,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(
                        textAlign:TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'Choose the gateway for your payment',
                            style: TextStyle(
                                color: AppColors.textDarkColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                letterSpacing: 0.2,
                                fontStyle:
                                FontStyle.normal),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            const Divider(
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      //generateTxnToken(2);
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: AppColors.gradientBlueColor)
                          )
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/icons/icon_cards.png", scale: 2.5,),
                        const SizedBox(width: 5,),
                        const Text("Paytm", style: TextStyle(color:AppColors.gradientBlueColor, fontSize: 14, fontWeight: FontWeight.w500,letterSpacing: 1, fontFamily: "Poppins", fontStyle: FontStyle.normal)),
                      ],
                    ),
                  ),

                ),
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      //openCheckout();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: AppColors.gradientBlueColor)
                          )
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/icons/icon_razor.png", scale: 50,),
                        const SizedBox(width: 5,),
                        const Text("Razor Pay", style: TextStyle(color:AppColors.gradientBlueColor, fontSize: 14, fontWeight: FontWeight.w500,letterSpacing: 1, fontFamily: "Poppins", fontStyle: FontStyle.normal)),
                      ],
                    ),
                  ),

                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     statusBarIconBrightness: Brightness.dark,
    //     statusBarColor: AppColors.whiteColor,
    //     systemNavigationBarColor: AppColors.whiteColor,
    //     systemNavigationBarIconBrightness: Brightness.dark
    // ));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        //appBar:  WalletAppBar(strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity),
        body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.gradientBlueColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                AppUtils().UserWalletAppBar(context, "Wallet"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '₹',
                                        style: TextStyle(
                                            color: AppColors.gradientBlueColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      Text(
                                        _strTotalWalletAmount,
                                        style: const TextStyle(
                                            color: AppColors.gradientBlueColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const[
                                      Text(
                                        'Wallet Balance',
                                        style: TextStyle(
                                            color: AppColors.closeIconColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                            fontFamily: "WorkSans",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/images/img_verticle_line.png",
                                scale: 1,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: const[
                                        Text(
                                        '₹',
                                        style: TextStyle(
                                            color: AppColors.gradientBlueColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      Text(
                                        '0.0',
                                        style:   TextStyle(
                                            color: AppColors.gradientBlueColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Cashback Balance\t',
                                        style:   TextStyle(
                                            color: AppColors.closeIconColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          CashInfoBottomDialog().showBottomDialog(context);
                                        },
                                        child: Image.asset(
                                          "assets/icons/icon_info.png",
                                          scale: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: const[
                      Text(
                        'Top Up Wallet',
                        style:   TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                if(value.length > 0) {
                                  isShow = true;
                                }else{
                                  isShow = false;
                                }
                              });
                            },
                            controller: _addMoneyController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                color: AppColors.iconDarkColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Poppins"
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              label: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: "₹\t",
                                    style: TextStyle(
                                        color: AppColors.iconDarkColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 0.2),
                                  ),
                                  TextSpan(
                                    text: "00",
                                    style: TextStyle(
                                        color: AppColors.iconDarkColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Poppins",
                                        letterSpacing: 0.2),
                                  ),
                                ]),
                              ),
                              suffix: TextButton(
                                onPressed: (){
                                  _showPayFromWalletDialog(context);
                                },
                                child: Text(
                                    'Add money',
                                    style: TextStyle(
                                        color: isShow?AppColors.gradientBlueColor:AppColors.gradientBlueColor.withOpacity(0.2),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.2,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal)
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              enabledBorder:const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.passwordIconColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                          Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShow500 = true;
                                        isShow1000 = false;
                                        isShow1500 = false;
                                        isShow2000 = false;
                                        isShow2500 = false;
                                        isShow = true;
                                        _addMoneyController.text = "500";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isShow500 ?AppColors.gradientBlueColor :AppColors.whiteColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: AppColors.closeIconColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Image.asset(
                                              'assets/icons/icon_plus.png',
                                              scale: 2,
                                              color: isShow500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              '₹',
                                              style: TextStyle(
                                                  color: isShow500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              '500',
                                              style: TextStyle(
                                                  color: isShow500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShow500 = false;
                                        isShow1000 = true;
                                        isShow1500 = false;
                                        isShow2000 = false;
                                        isShow2500 = false;
                                        isShow = true;
                                        _addMoneyController.text = "1000";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isShow1000 ?AppColors.gradientBlueColor :AppColors.whiteColor,
                                          borderRadius:const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: AppColors.closeIconColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Image.asset(
                                              'assets/icons/icon_plus.png',
                                              scale: 2,
                                              color: isShow1000 ?AppColors.whiteColor :AppColors.closeIconColor,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              '₹',
                                              style: TextStyle(
                                                  color: isShow1000 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              '1000',
                                              style:  TextStyle(
                                                  color: isShow1000 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShow500 = false;
                                        isShow1000 = false;
                                        isShow1500 = true;
                                        isShow2000 = false;
                                        isShow2500 = false;
                                        isShow = true;
                                        _addMoneyController.text = "1500";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isShow1500 ?AppColors.gradientBlueColor :AppColors.whiteColor,
                                          borderRadius:const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: AppColors.closeIconColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Image.asset(
                                              'assets/icons/icon_plus.png',
                                              scale: 2,
                                              color:isShow1500 ?AppColors.whiteColor : AppColors.closeIconColor,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              '₹',
                                              style: TextStyle(
                                                  color: isShow1500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              '1500',
                                              style: TextStyle(
                                                  color: isShow1500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShow500 = false;
                                        isShow1000 = false;
                                        isShow1500 = false;
                                        isShow2000 = true;
                                        isShow2500 = false;
                                        isShow = true;
                                        _addMoneyController.text = "2000";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isShow2000 ?AppColors.gradientBlueColor :AppColors.whiteColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: AppColors.closeIconColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Image.asset(
                                              'assets/icons/icon_plus.png',
                                              scale: 2,
                                              color: isShow2000 ?AppColors.whiteColor :AppColors.closeIconColor,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              '₹',
                                              style: TextStyle(
                                                  color: isShow2000 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              '2000',
                                              style: TextStyle(
                                                  color: isShow2000 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShow500 = false;
                                        isShow1000 = false;
                                        isShow1500 = false;
                                        isShow2000 = false;
                                        isShow2500 = true;
                                        isShow = true;
                                        _addMoneyController.text = "2500";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isShow2500 ?AppColors.gradientBlueColor :AppColors.whiteColor,
                                          borderRadius:const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: AppColors.closeIconColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Image.asset(
                                              'assets/icons/icon_plus.png',
                                              scale: 2,
                                              color: isShow2500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              '₹',
                                              style: TextStyle(
                                                  color: isShow2500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              '2500',
                                              style: TextStyle(
                                                  color: isShow2500 ?AppColors.whiteColor :AppColors.closeIconColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /*SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Image.asset(
                                'assets/icons/icon_coupan.png',
                                scale: 1.5,
                              ),
                              Align(
                                alignment: Alignment(-0.3, -0),
                                child: Text(
                                  '25 Wallet Top Up coupons',
                                  style: const TextStyle(
                                      color: AppColors.cardLightBlueColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child:  Text(
                                  'View',
                                  style: const TextStyle(
                                      color: AppColors.blueColor,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ],
                          ),

                        ),*/
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>WalletActivitiesScreen())),
                    child: Container(
                      decoration:const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow:[
                            BoxShadow(
                              color: AppColors.passwordIconColor,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 5.0,
                            ),
                          ]
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>WalletActivitiesScreen())),
                              child:
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Image.asset(
                                    "assets/icons/icon_bag.png",
                                    color: AppColors.gradientBlueColor,
                                    scale: 1.5,
                                  ),
                                  const Align(
                                    alignment: Alignment(-0.3, -5),
                                    child: Text(
                                      'View Wallet Activities',
                                      style:   TextStyle(
                                          color: AppColors.gradientBlueColor,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child:  Image.asset(
                                      "assets/icons/icon_outline_forward.png",
                                      color: AppColors.blueColor,
                                      scale: 1.5,
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  UserHomeScreen()));
    return true;
  }


  void generateTxnToken(int mode) async {
    setState(() {
      loading = true;
    });
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (testing
        ? 'https://securegw-stage.paytm.in'
        : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    String amt = _addMoneyController.text.toString();

    var body = json.encode({
      "mid": mid,
      "key_secret": PAYTM_MERCHANT_KEY,
      "website": website,
      "orderId": orderId,
      "amount": amt,
      "callbackUrl": callBackUrl,
      "custId": "122",
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );

      if(response.statusCode == 503){
        AppUtils().showErrorToastMsg("Paytm Service Un-Available. So Please Try Later");
      }else{
        print("Paytm Response Body" + response.body);
        String txnToken = response.body;
        setState(() {
          payment_response = txnToken;
        });

        /*var paytmResponse = Paytm.payWithPaytm(
            mId: mid,
            orderId: orderId,
            txnToken: txnToken,
            txnAmount: amount.toString(),
            callBackUrl: callBackUrl,
            staging: testing,
            appInvokeEnabled: false);*/

       /* paytmResponse.then((value) {
          setState(() {
            loading = false;
            if (value['response']['STATUS'] == 'TXN_FAILURE') {
              if(value['response']['STATUS'] == 'TXN_FAILURE' && value['response']['RESPMSG'] == 'User has not completed transaction.'){
                Fluttertoast.showToast(
                  msg:value['response']['RESPMSG'].toString(),
                  backgroundColor: AppColors.editTextErrorBorderColor.withOpacity(0.8),
                  textColor: AppColors.whiteColor,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  fontSize: 14,
                );
              }
            } else if(value['response']['STATUS'] == "TXN_SUCCESS"){
              if (value['response'] != null) {
                payment_response = value['response']['STATUS'];
                String amount = value['response']['TXNAMOUNT'];
                String trnStatus = value['response']['STATUS'];
                String transactionId = value['response']['ORDERID'];
                String bankRefId = value['response']['BANKTXNID'];
                String trnDate = value['response']['TXNDATE'];
                String orderId = value['response']['ORDERID'];
                String paymentMode = value['response']['PAYMENTMODE'];
                addMoneyToWallet(amount, trnStatus, transactionId, bankRefId, trnDate, orderId, "PAYTM");
              }
            }
            payment_response += "\n" + value.toString();
            print("Paytm" + payment_response);
          });
        });*/
      }

    } catch (e) {
      print(e);
    }
  }
  void addMoneyToWallet(String amount, String trnStatus, String transactionId, String bankRefId, String trnDate, String orderId, String paymentMode) {

  }
}

class CashInfoBottomDialog {
  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(context),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  Widget _buildDialogContent(context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildImage(),
              const SizedBox(height: 8),
              _buildContinueText(),
              const SizedBox(height: 16),
              _buildEmapleText(),
              const SizedBox(height: 16),
              _buildTextField(),
              const SizedBox(height: 16),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const image =
        "assets/icons/icon_pay_delivery.png";
    return SizedBox(
      height: 60,
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }

  Widget _buildContinueText() {
    return const Text(
      'How cashback is used?',
      style: TextStyle(
          color: AppColors.gradientBlueColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 2,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal
      ),
    );
  }

  Widget _buildEmapleText() {
    return const Text(
      '10% of cashback balance is auto applied for every transport deliveries.',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColors.textDarkColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal
      ),
    );
  }

  Widget _buildTextField() {
    const iconSize = 40.0;
    return
      const Divider(
        color: AppColors.passwordIconColor,
      );
  }

  Widget _buildContinueButton(context) {
    return
      IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/icons/icon_circle_check.png",
                            scale: 2,
                            color: AppColors.gradientBlueColor,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child:const Text(
                            "Ok",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: AppColors.gradientBlueColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

}