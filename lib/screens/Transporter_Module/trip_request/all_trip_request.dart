import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/screens/Transporter_Module/trip_request/view_trip_request.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import '../dashboard/transporter_dashboard.dart';

class AllTripRequest extends StatefulWidget {
  const AllTripRequest({Key? key}) : super(key: key);

  @override
  State<AllTripRequest> createState() => _AllTripRequestState();
}

class _AllTripRequestState extends State<AllTripRequest> {
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
    return
      WillPopScope(
      onWillPop: _onWillPop,
        child: Scaffold(
          body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.primaryColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  AppUtils().WalletAppBar(context, "Trip Request"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      child: Column(
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Bid Amount: ₹20000",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.textColor,
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
                                    Divider(),
                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ViewTripRequest()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "View",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.blueColor,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.2,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: "WorkSans"
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Bid Amount: ₹20000",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.textColor,
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
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "View",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.blueColor,
                                                fontWeight: FontWeight.w600,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Bid Amount: ₹20000",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.textColor,
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
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "View",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.blueColor,
                                                fontWeight: FontWeight.w600,
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
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
          BottomAppBar(
              elevation: 5,
              color:AppColors.whiteColor,
              shape:const CircularNotchedRectangle(), //shape of notch
              notchMargin: 5,
              //notche margin between floating button and bottom appbar
              child:
              SizedBox(
                height: 60,
                child:
                Column(
                  children: [
                    const SizedBox(height: 10,),
                    Stack(
                      children: [
                        Align(
                          alignment:const Alignment(-0.8, 0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
                            },
                            child: Image.asset("assets/icons/icon_home.png",
                              color: AppColors.closeIconColor,
                              height: 20.6,
                              width: 20.42,),),
                        ),
                        Align(
                          alignment:const Alignment(-0.3, 0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AllTripRequest()));
                            },
                            child: Icon(Icons.book, color: AppColors.gradientBlueColor,),),
                        ),
                        Align(
                          alignment:const Alignment(0.28, 0),
                          child: InkWell(
                            onTap: (){
                            },
                            child: Icon(Icons.emoji_transportation, color: AppColors.closeIconColor,),),
                        ),

                        Align(
                          alignment:const Alignment(0.8, 0),
                          child: InkWell(
                            child: Image.asset("assets/icons/icon_user.png",scale: 0.5,
                              color: AppColors.closeIconColor,
                              height: 20.6,
                              width: 20.42,),),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment:const Alignment(-0.82, 0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
                            },
                            child: const Text(
                              "Home",
                              style:TextStyle(
                                  color: AppColors.closeIconColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                  fontFamily: "WorkSans",
                                  fontStyle: FontStyle.normal
                              ),
                            ),),
                        ),
                        Align(
                          alignment:const Alignment(-0.36, 0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AllTripRequest()));
                            },
                            child: const Text(
                              "Booking Status",
                              style:TextStyle(
                                  color: AppColors.gradientBlueColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                  fontFamily: "WorkSans",
                                  fontStyle: FontStyle.normal
                              ),
                            ),),
                        ),
                        Align(
                          alignment: const Alignment(0.32, 0),
                          child: InkWell(
                            onTap: (){
                            },
                            child: const Text(
                              "On Board",
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                  color: AppColors.closeIconColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                  fontFamily: "WorkSans",
                                  fontStyle: FontStyle.normal
                              ),
                            ),),
                        ),

                        Align(
                          alignment:const Alignment(0.88, 0),
                          child: InkWell(
                            child: const Text(
                              "Profile",
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                  color: AppColors.closeIconColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                  fontFamily: "WorkSans",
                                  fontStyle: FontStyle.normal
                              ),
                            ),),
                        )
                      ],
                    ),
                  ],
                ),
              )
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
