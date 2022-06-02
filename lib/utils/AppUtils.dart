import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trailer_tracking/screens/Transporter_Module/dashboard/transporter_dashboard.dart';
import 'package:trailer_tracking/screens/Transporter_Module/wallet/wallet_screen.dart';
import 'package:trailer_tracking/screens/User%20Module/trip_request/bided_trip_request.dart';
import 'package:trailer_tracking/utils/shared_preff.dart';
import '../screens/User Module/dashboard/home_screen.dart';
import '../screens/User Module/trip_request/serach_available_vehicle.dart';
import '../screens/User Module/trip_request/trip_status_screen.dart';
import '../screens/User Module/wallet/wallet_screen.dart';
import 'StringConstants.dart';
import 'colors.dart';
import 'customdailog.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppUtils {
   Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

   void showLoading() async{
    SmartDialog.showLoading(
      isLoadingTemp: false,
      widget: const CustomLoading(type: 1),
    );
  }

  Future<void> hideLoading() async{
    await Future.delayed(const Duration(seconds: 0));
    SmartDialog.dismiss();
  }

  void showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin:const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void showToastMsg() {
     Fluttertoast.showToast(msg: StringConstants.featureMsg,
     textColor: AppColors.whiteColor,
       backgroundColor: AppColors.textColor,
       gravity: ToastGravity.BOTTOM,
       fontSize: 14,
       timeInSecForIosWeb: 2,
     );
  }

   void showSuccessToastMsg(String msg) {
     Fluttertoast.showToast(msg: msg,
       textColor: AppColors.whiteColor,
       backgroundColor: AppColors.textColor,
       gravity: ToastGravity.BOTTOM,
       fontSize: 14,
       timeInSecForIosWeb: 2,
     );
   }

   void showErrorToastMsg(String msg) {
     Fluttertoast.showToast(msg: msg,
       textColor: AppColors.whiteColor,
       backgroundColor: AppColors.editTextErrorBorderColor,
       gravity: ToastGravity.BOTTOM,
       fontSize: 14,
       timeInSecForIosWeb: 2,
     );
   }

  void sessionExpire(context) {
    Widget okButton = TextButton(
      child:const Text("Log-In",
        style: TextStyle(
          color: AppColors.editTextErrorBorderColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          fontFamily: "WorkSans",
          fontStyle: FontStyle.normal,
        ),
      ),
      onPressed:  () {
        StorageUtil.instance.removeAll();
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MobileNumberScreen()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/icon-expired.png",
            color: AppColors.editTextErrorBorderColor,
          ),
          const Text(
            "Session Expire",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              fontFamily: "WorkSans",
              fontStyle: FontStyle.normal,
            ),),
        ],
      ),
      content:const Text("The session is expired can you please Log-In again",
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: AppColors.iconDarkColor,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          fontFamily: "WorkSans",
          fontStyle: FontStyle.normal,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

   Widget UserWalletAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.blackColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UserHomeScreen()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget UserWalletActivitiesAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.blackColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> WalletScreen()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }


   Widget appBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, left: 8),
             child: SizedBox(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
             ),
           ),
            Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.wallet_travel,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> WalletScreen()));
                   },
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget BidAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.blackColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UserHomeScreen()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.wallet_travel,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> WalletScreen()));
                   },
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget transporterAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, left: 8),
             child: SizedBox(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.wallet_travel,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterWalletScreen()));
                   },
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget WalletAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget TripStatusAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.whiteColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> BidTripRequestScreen()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.whiteColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.wallet_travel,
                     color: AppColors.whiteColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }


   Widget ApproveStatusBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TripStatusScreen(tripStatus: "Agreed")));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.wallet_travel,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget BookingStatusBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.wallet_travel,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget UserAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UserHomeScreen()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.gradientBlueColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               color: Colors.white,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.gradientBlueColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Widget tripAppBar(BuildContext context, String appTitle) {
     return SizedBox(
       height: AppBar().preferredSize.height,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.arrow_back,
                     color: AppColors.whiteColor,
                   ),
                   onTap: () {
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SearchAvailableVehicle()));
                   },
                 ),
               ),
             ),
           ),
           Expanded(
             child: Padding(
               padding: EdgeInsets.only(top: 4),
               child: Text(
                 appTitle,
                 style: TextStyle(
                     color: AppColors.whiteColor,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     letterSpacing: 0.5,
                     fontFamily: "WorkSans",
                     fontStyle: FontStyle.normal
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 8, right: 8),
             child: Container(
               width: AppBar().preferredSize.height - 8,
               height: AppBar().preferredSize.height - 8,
               child: Material(
                 color: Colors.transparent,
                 child: InkWell(
                   borderRadius:
                   BorderRadius.circular(AppBar().preferredSize.height),
                   child: Icon(
                     Icons.notifications_none_outlined,
                     color: AppColors.whiteColor,
                   ),
                   onTap: () {
                   },
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }
}