import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:trailer_tracking/screens/User%20Module/trip_request/trip_request_details.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';

class SearchAvailableVehicle extends StatefulWidget {
  const SearchAvailableVehicle({Key? key}) : super(key: key);

  @override
  State<SearchAvailableVehicle> createState() => _SearchAvailableVehicleState();
}

class _SearchAvailableVehicleState extends State<SearchAvailableVehicle> {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOffline = false;

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
      body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.textColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
      Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        color: AppColors.lightDimWhiteColor,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                AppUtils().UserAppBar(context, "Search Address Details"),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TripRequestDetails()));
                  },
                  child: Padding(
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
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                             IntrinsicHeight(
                               child: Row(
                                 children: [
                                   Column(
                                     children: [
                                       Container(
                                         height: 100,
                                         width: 100,
                                         decoration: BoxDecoration(
                                           color:AppColors.gradientBlueColor,
                                           borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                         ),
                                         child: Image.asset(
                                           "assets/images/img_truck1.png",
                                           fit: BoxFit.fitWidth,
                                         ),
                                       ),
                                     ],
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Text(
                                             "Tata Consultant",
                                             style: TextStyle(
                                                 fontSize: 14.0,
                                                 color: AppColors.themeColor,
                                                 fontWeight: FontWeight.w500,
                                                 letterSpacing: 0.2,
                                                 fontStyle: FontStyle.normal,
                                                 fontFamily: "WorkSans"
                                             ),
                                           ),
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                           child: Text(
                                             "Bangalore - Chennai",
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
                                         Padding(
                                           padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                           child: Text(
                                             "Approximate KM: 25",
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

                                 ],
                               ),
                             ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TripRequestDetails()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end ,
                                children: [
                                  Text(
                                    "Click",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: AppColors.blueColor,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.2,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans"
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.blueColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5,)
                                ],
                              ),
                            ),
                          ],
                        ),
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
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:AppColors.gradientBlueColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                      ),
                                      child: Image.asset(
                                        "assets/images/img_truck1.png",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Sri Benaka Transport",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.themeColor,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                        child: Text(
                                          "Hubli - Cochin",
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
                                      Padding(
                                        padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                        child: Text(
                                          "Approximate KM: 30",
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

                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end ,
                            children: [
                              Text(
                                "Click",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "WorkSans"
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.blueColor,
                                size: 18,
                              ),
                              SizedBox(width: 5,)
                            ],
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
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:AppColors.gradientBlueColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                      ),
                                      child: Image.asset(
                                        "assets/images/img_truck1.png",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Vrl Company",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.themeColor,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                        child: Text(
                                          "Bangalore- Cochin",
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
                                      Padding(
                                        padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                        child: Text(
                                          "Approximate KM: 30",
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

                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end ,
                            children: [
                              Text(
                                "Click",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "WorkSans"
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.blueColor,
                                size: 18,
                              ),
                              SizedBox(width: 5,)
                            ],
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
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:AppColors.gradientBlueColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                      ),
                                      child: Image.asset(
                                        "assets/images/img_truck1.png",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Ecolayer E Waste",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.themeColor,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "WorkSans"
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                        child: Text(
                                          "Bangalore - Chennai",
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
                                      Padding(
                                        padding: const EdgeInsets.only(top:0, left: 8.0, right: 8.0, bottom: 0),
                                        child: Text(
                                          "Approximate KM: 30",
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

                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end ,
                            children: [
                              Text(
                                "Click",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "WorkSans"
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.blueColor,
                                size: 18,
                              ),
                              SizedBox(width: 5,)
                            ],
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
