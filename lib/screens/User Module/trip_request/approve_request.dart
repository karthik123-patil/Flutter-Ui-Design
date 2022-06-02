import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/screens/User%20Module/trip_request/booking_status.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import '../dashboard/home_screen.dart';

class ApproveRequestScreen extends StatefulWidget {
  const ApproveRequestScreen({Key? key}) : super(key: key);

  @override
  State<ApproveRequestScreen> createState() => _ApproveRequestScreenState();
}

class _ApproveRequestScreenState extends State<ApproveRequestScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOffline = false;
  bool value = false;

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
    return Scaffold(
      body: isOffline? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.textColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
        Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          color: AppColors.background,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  AppUtils().ApproveStatusBar(context, "Approve Booking"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Document",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontStyle: FontStyle.normal,
                              fontFamily: "WorkSans"
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.image,
                            color: AppColors.blackColor,
                          ),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Port Entry Document",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontStyle: FontStyle.normal,
                              fontFamily: "WorkSans"
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.image,
                            color: AppColors.blackColor,
                          ),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        activeColor: AppColors.gradientBlueColor,
                        value: this.value,
                        onChanged: (bool? value) {
                          setState(() {
                            this.value = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'approve booking',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontStyle: FontStyle.normal,
                              fontFamily: "WorkSans"
                          ),
                        ),
                      ),
                      //Checkbox
                    ], //<Widget>[]
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
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

                              AppColors.editTextErrorBorderColor,
                              AppColors.editTextErrorBorderColor,
                            ],
                          ),
                          color: AppColors.editTextErrorBorderColor,
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
                            _onCancelTrip();
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              1.0,
                            ),
                            child: Text(
                              'Cancel',
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
                      Container(
                        height: 40,
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

                              AppColors.gradientBlueColor,
                              AppColors.gradientBlueColor,
                            ],
                          ),
                          color: AppColors.gradientBlueColor,
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
                            AppUtils().showSuccessToastMsg(
                              "You have booked the vehicle. Please wait once the approval is done from transporter."
                            );
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>BookingStatusScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              1.0,
                            ),
                            child: Text(
                              'Book Now',
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
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

  Future<bool> _onCancelTrip() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?',
          style: TextStyle(
              fontSize: 15.0,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              fontStyle: FontStyle.normal,
              fontFamily: "WorkSans"
          ),
        ),
        content:const Text('Do you want cancel the request',
          style: TextStyle(
              fontSize: 12.0,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              fontStyle: FontStyle.normal,
              fontFamily: "WorkSans"
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  const Text('No',
              style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.editTextErrorBorderColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontStyle: FontStyle.normal,
                  fontFamily: "WorkSans"
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UserHomeScreen()));
            },
            child:  const Text('Yes',
              style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontStyle: FontStyle.normal,
                  fontFamily: "WorkSans"
              ),
            ),
          ),
        ],
      ),
    )) ?? false;
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
