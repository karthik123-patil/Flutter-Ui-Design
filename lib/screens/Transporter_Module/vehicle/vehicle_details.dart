import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import '../dashboard/transporter_dashboard.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
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
        //resizeToAvoidBottomInset : false,
        body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.primaryColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Vehicle Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontFamily: "WorkSans",
                                letterSpacing: 0.2,
                                fontSize: 16,
                                color: AppColors.textPrimaryColor
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
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
                                      "assets/images/img_transport.png",
                                      scale: 4,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Ashok Leyland",
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
                                    SizedBox(width: 45,),
                                    Text(
                                      "KA-05-E2021",
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: AppColors.editTextErrorBorderColor,
                                          fontWeight: FontWeight.w400,
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
                                        "assets/images/user.png",
                                        scale: 20,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Manjunath Jagadi",
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
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.closeIconColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "+91-8050909090",
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
                                      Icon(
                                        Icons.directions_bus,
                                        color: AppColors.closeIconColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "ON-BOARD",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.cardOrangeBorderColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                      SizedBox(width: 80,),
                                      Text(
                                        "Track Vehicle",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.blueColor,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Source Address: Silkboard main bus stop 2nd cross, Bangalore-560001",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w600,
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
                                      Expanded(
                                        child: Text(
                                          "Destination Address: Silkboard main bus stop 2nd cross, Bangalore-560001",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
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
                                      "assets/images/img_transport.png",
                                      scale: 4,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Tata Motors",
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
                                    SizedBox(width: 45,),
                                    Text(
                                      "KA-05-E2031",
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: AppColors.editTextErrorBorderColor,
                                          fontWeight: FontWeight.w400,
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
                                        "assets/images/user.png",
                                        scale: 20,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Jagadeesh Puri",
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
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.closeIconColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "+91-8050909080",
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
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.welcomeTextColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "AVAILABLE",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                      SizedBox(width: 80,),
                                      Text(
                                        "Track Vehicle",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.blueColor,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Destination Address: Silkboard main bus stop 2nd cross, Bangalore-560001",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
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
                                      "assets/images/img_transport.png",
                                      scale: 4,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Tata Motors",
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
                                    SizedBox(width: 45,),
                                    Text(
                                      "KA-05-E2032",
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: AppColors.editTextErrorBorderColor,
                                          fontWeight: FontWeight.w400,
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
                                        "assets/images/user.png",
                                        scale: 20,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Prem Kumar",
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
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.closeIconColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "+91-8050909060",
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
                                      Icon(
                                        Icons.close,
                                        color: AppColors.editTextErrorBorderColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "DAMAGED",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.editTextErrorBorderColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                      SizedBox(width: 80,),
                                      Text(
                                        "Track Vehicle",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.blueColor,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "WorkSans"
                                        ),
                                      ),
                                    ],
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
              ],
            ),
          ),
        ),
      ),
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
