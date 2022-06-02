import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import 'dart:math' as math;

class TripRequestDetails extends StatefulWidget {
  const TripRequestDetails({Key? key}) : super(key: key);

  @override
  State<TripRequestDetails> createState() => _TripRequestDetailsState();
}

class _TripRequestDetailsState extends State<TripRequestDetails> {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOffline = false;
  DateTime selectedDate = DateTime.now();
  String _strDate = "";

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


  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.gradientBlueColor, // header background color
              onPrimary: AppColors.whiteColor, // header text color
              onSurface: AppColors.gradientBlueColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      helpText:"Select pick up date",
      firstDate: selectedDate,
      lastDate: DateTime(2035),
      context: context,
      initialDate: selectedDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        //selectedDate = picked;
        _strDate = picked.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isOffline? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.textColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
      Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        color: AppColors.gradientBlueColor,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                AppUtils().tripAppBar(context, "Trip Details"),
                Container(
                  color:AppColors.gradientBlueColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tata Consultant Transport",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"
                                  ),
                                ),
                                Text(
                                  "Email:tata.consult@gmail.com",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"
                                  ),
                                ),
                                Text(
                                  "Tata Consultant Transport",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Transform(
                                transform: Matrix4.rotationY(math.pi),
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  "assets/images/img_truck1.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: AppColors.whiteColor,
                          //   borderRadius: BorderRadius.all(Radius.circular(20)),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: AppColors.passwordIconColor,
                          //         offset: Offset(0.0, 1.0), //(x,y)
                          //         blurRadius: 5.0,
                          //       )
                          //     ]
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/icon_dot.png",
                                          color: AppColors.gradientBlueColor,
                                          scale: 1.5,
                                        ),
                                        Image.asset(
                                          "assets/icons/icon_line.png",
                                          color: AppColors.blackColor,
                                          scale: 1.5,
                                        ),
                                        Image.asset(
                                          "assets/icons/icon_drop.png",
                                          color: AppColors.editTextErrorBorderColor,
                                          scale: 2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Bengaluru",
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.5,
                                                fontFamily: "WorkSans",
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 18),
                                        Container(
                                          color: Colors.black26,
                                          height: 1,
                                          width: 250,
                                        ),
                                        SizedBox(height: 18,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Chennai",
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.5,
                                                fontFamily: "WorkSans",
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.passwordIconColor,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Select Vehicle Type",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.gradientBlueColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "20 Feet",
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "40 Feet",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "45 Feet",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Flat Rack",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Reefer",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Car Carrying Trailer",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap:(){
                                        _selectDate(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.gradientBlueColor,
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.passwordIconColor,
                                                offset: Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 5.0,
                                              )
                                            ]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Select Date",
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                              fontFamily: "WorkSans",
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Text(
                                      _strDate,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.passwordIconColor,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cost Type",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.gradientBlueColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Cost Per Tonne",
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Cost Per KM",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Cost Per Slab",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.passwordIconColor,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cargo Type",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.gradientBlueColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Dry Cargo",
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.passwordIconColor,
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.passwordIconColor,
                                                    offset: Offset(0.0, 1.0), //(x,y)
                                                    blurRadius: 5.0,
                                                  )
                                                ]
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Cold Cargo",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                  fontFamily: "WorkSans",
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 50,
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

                                    AppColors.cardOrangeBorderColor,
                                    AppColors.cardOrangeBorderColor,
                                  ],
                                ),
                                color: AppColors.cardOrangeBorderColor,
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
                                    'Back',
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
                            SizedBox(width: 20,),
                            Container(
                              width: 150,
                              height: 50,
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
                                  showBottomDialog(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(
                                    1.0,
                                  ),
                                  child: Text(
                                    'Bid Now',
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
                      )
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

  void showBottomDialog(BuildContext context,
      ) {
    showGeneralDialog(
      barrierLabel: "showBidDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.center,
          child: BidDialogScreen(),
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
}

class BidDialogScreen extends StatefulWidget {
  const BidDialogScreen({Key? key}) : super(key: key);

  @override
  State<BidDialogScreen> createState() => _BidDialogScreenState();
}

class _BidDialogScreenState extends State<BidDialogScreen> {
  TextEditingController _bidPrice = TextEditingController();
  TextEditingController _Remarks = TextEditingController();
  bool isButtonEnable = false;
  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildImage(),
                const SizedBox(height: 8),
                _buildContinueText(),
                const SizedBox(height: 16),
                _buildFormField(),
                const SizedBox(height: 16),
                _buildContinueButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const image =
        "assets/images/img_lamp.png";
    return SizedBox(
      height: 60,
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }

  Widget _buildContinueText() {
    return const Text(
      'Bid Price',
      style: TextStyle(
          color: AppColors.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal
      ),
    );
  }

  Widget _buildFormField() {
    return Column(
      children: [
        TextField(
          controller: _bidPrice,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(
                RegExp("[0-9]")),
          ],
          onChanged: (value) {
            if(value.length > 0) {
              setState(() {
                isButtonEnable = true;
              });
            }else{
              setState(() {
                isButtonEnable = false;
              });
            }
          },
          style: const TextStyle(
              color: AppColors.iconDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: "Poppins"
          ),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.currency_rupee,
                color: AppColors.iconDarkColor,
                size: 15,
              ),
              hintText: StringConstants.hintPrice,
              contentPadding: const EdgeInsets.only(
                  left: 14.0, bottom: 8.0, top: 16.0),
              enabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.iconDarkColor),
              ),
              focusedBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.editTextEnableBorderColor),
              ),
              errorBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.editTextErrorBorderColor),
              )
          ),
        ),
        TextField(
          controller: _Remarks,
          keyboardType: TextInputType.text,
          onChanged: (value) {

          },
          style: const TextStyle(
              color: AppColors.iconDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: "Poppins"
          ),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.comment,
                color: AppColors.iconDarkColor,
                size: 15,
              ),
              hintText: StringConstants.hintRemarks,
              contentPadding: const EdgeInsets.only(
                  left: 14.0, bottom: 8.0, top: 16.0),
              enabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.iconDarkColor),
              ),
              focusedBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.editTextEnableBorderColor),
              ),
              errorBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.editTextErrorBorderColor),
              )
          ),
        )
      ],
    );
  }

  Widget _buildTextField() {
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
            onTap: (){
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(

                    gradient: isButtonEnable?LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      colors: [
                        Colors.red.shade300,
                        Colors.red.shade400,
                      ],
                    ):LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      colors: [
                        AppColors.editTextErrorBorderColor.withOpacity(0.2),
                        AppColors.editTextErrorBorderColor.withOpacity(0.2),
                      ],
                    ),
                    color: isButtonEnable ?Colors.red.shade300:AppColors.editTextErrorBorderColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        onPrimary: AppColors.primaryColor),
                    onPressed: isButtonEnable
                        ? () {
                      Navigator.of(context).pop(true);
                    }: null,
                    child: Container(
                      padding: EdgeInsets.all(
                        15.0,
                      ),
                      child: Text(
                        StringConstants.btnSubmit,
                        style: TextStyle(
                            fontSize: 16.0,
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
          ),
        ),
      );
  }
}
