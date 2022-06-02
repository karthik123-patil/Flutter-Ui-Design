import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import '../dashboard/transporter_dashboard.dart';

class ViewTripRequest extends StatefulWidget {
  const ViewTripRequest({Key? key}) : super(key: key);

  @override
  State<ViewTripRequest> createState() => _ViewTripRequestState();
}

class _ViewTripRequestState extends State<ViewTripRequest> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOffline = true;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.primaryColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  AppUtils().WalletAppBar(context, "View Trip Request"),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.passwordIconColor,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/user.png",
                                      scale: 15,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Naveen Kumar",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: AppColors.textPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans"
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 30,),
                                    Text(
                                      "+91-9070503020",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: AppColors.blueColor,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans"
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/img_cubic.png",
                                        scale: 12,
                                        color: AppColors.closeIconColor,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Sugar",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/img_truck.png",
                                        scale: 45,
                                        color: AppColors.closeIconColor,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "25.00 Tonne(s) Hyva",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/img_pay.png",
                                        scale: 2.5,
                                        color: AppColors.closeIconColor,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "₹25000",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Source:",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.blueColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(
                                          "Rt Nagar 14th cross, Bengalore-560001",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.textPrimaryColor,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Destination:",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.editTextErrorBorderColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(
                                          "Chennamma Circle 2nd cross 1st floor, Hubli-580001",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.textPrimaryColor,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Customer Expected Price:\t",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                      Text(
                                        "₹20000",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.0, 1.0],
                                          colors: [
                                            Colors.green.shade300,
                                            Colors.green.shade400,
                                          ],
                                        ),
                                        color: Colors.green.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(15.0),
                                            ),
                                            onPrimary: AppColors.primaryColor),
                                        onPressed: () {

                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            1.0,
                                          ),
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.2,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "WorkSans"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.0, 1.0],
                                          colors: [

                                            Colors.red.shade300,
                                            Colors.red.shade400,
                                          ],
                                        ),
                                        color: Colors.red.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(15.0),
                                            ),
                                            onPrimary: AppColors.primaryColor),
                                        onPressed: () {

                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            1.0,
                                          ),
                                          child: Text(
                                            'Reject',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.2,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "WorkSans"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: 80,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.0, 1.0],
                                          colors: [

                                            Colors.blue.shade300,
                                            Colors.blue.shade400,
                                          ],
                                        ),
                                        color: Colors.blue.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(15.0),
                                            ),
                                            onPrimary: AppColors.primaryColor),
                                        onPressed: () {

                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            1.0,
                                          ),
                                          child: Text(
                                            'Bid',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.2,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "WorkSans"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
          ),
        )
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (context)=>TransporterDashboardScreen()));
    return true;
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          isOffline = false;
        }
        );
        break ;
      case ConnectivityResult.mobile:
        setState(() {
          isOffline = false;
        }
        );
        break ;
      case ConnectivityResult.none:
        setState(() {
          isOffline = true;
          showInternetDialog(context);
        });
        break;
      default:
        setState(() {
          isOffline = true;
          showInternetDialog(context);
        }
        );
        break;
    }
  }
  showInternetDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const InternetErrorDialog();
      },
    );
  }
}
