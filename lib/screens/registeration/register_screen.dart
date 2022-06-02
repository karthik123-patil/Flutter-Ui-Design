import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/screens/registeration/login_screen.dart';

import '../../utils/StringConstants.dart';
import '../../utils/colors.dart';
import '../../utils/shared_preff.dart';
import '../../widgets/internet_error_dialog.dart';
import '../User Module/dashboard/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnected = true;
  bool _isObscure = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.primaryColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                Container(
                  color: AppColors.gradientBlueColor,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Form(
                        key: formKey,
                        child: Center(
                          child: ListView(
                            //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              // SizedBox(
                              //   height: 30.0,
                              // ),
                              Column(children: <Widget>[

                                // SizedBox(
                                //   height: 30.0,
                                // ),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0,bottom: 50.0),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 0.5,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100.0,
                                    ),
                                  ],
                                ),

                              ]),
                              Container(
                                width:MediaQuery.of(context).size.width,
                                //height: MediaQuery.of(context).size.height,

                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.zero,
                                    )                                ),
                                child: Column(

                                  children: [
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0)),
                                          Text(
                                            'Hello',
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.2,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Roboto"),
                                          ),

                                        ]),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 10.0, bottom: 10.0),),
                                          Text(
                                            'Create your account to continue',
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: AppColors.lightGrayColor,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.2,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Roboto"),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),

                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50.0,left: 50.0,top:10.0,bottom: 10.0),
                                      child: TextFormField(
                                        //keyboardType: TextInputType.text,
                                        style: new TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto"),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]")),
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        onChanged: (value) {
                                          //Do something with the user input.
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter a valid company name!';
                                          }else if(!RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value)){
                                            return 'Enter a valid company name!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Roboto",
                                              letterSpacing: 0.2,
                                              fontSize: 12,
                                              color: AppColors.lightGrayColor),
                                          hintText: 'Company Name',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: UnderlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(1.0)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 2.0),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0),

                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 1.5),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.person,
                                            color: AppColors.lightGrayColor ,
                                          ),
                                        ),
                                        controller: _companyName,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50.0,left: 50.0,top: 5.0,bottom: 10.0),
                                      child: TextFormField(
                                        //keyboardType: TextInputType.text,
                                        style: new TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto"),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]")),
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        onChanged: (value) {
                                          //Do something with the user input.
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter a valid contact person name!!';
                                          }else if(!RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value)){
                                            return 'Enter a valid contact person name!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Roboto",
                                              letterSpacing: 0.2,
                                              fontSize: 12,
                                              color: AppColors.lightGrayColor),
                                          hintText: 'Contact Person Name',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: UnderlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(1.0)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 2.0),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0),

                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 1.5),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.person,
                                            color: AppColors.lightGrayColor ,
                                          ),
                                        ),
                                        controller: _contactPersonName,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50.0,left: 50.0,bottom: 10.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        style: new TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto"),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter a valid email!';
                                          }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                            return 'Enter a valid email!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Roboto",
                                              letterSpacing: 0.2,
                                              fontSize: 12,
                                              color: AppColors.lightGrayColor),
                                          hintText: 'Email',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: UnderlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(1.0)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 2.0),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0),

                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 1.5),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.email,
                                            color: AppColors.lightGrayColor ,
                                          ),
                                        ),
                                        controller: _email,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50.0,left: 50.0,bottom: 10.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto"),
                                        // inputFormatters: <TextInputFormatter>[
                                        //   FilteringTextInputFormatter.digitsOnly,
                                        //   FilteringTextInputFormatter.allow(
                                        //       RegExp("[0-9]")),
                                        //   LengthLimitingTextInputFormatter(10),
                                        // ],
                                        onChanged: (value) {
                                          //Do something with the user input.

                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter a valid Mobile Number!';
                                          }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                            return 'Enter a valid Mobile Number!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Roboto",
                                              letterSpacing: 0.2,
                                              fontSize: 12,
                                              color: AppColors.lightGrayColor),
                                          hintText: 'Mobile Number',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: UnderlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(1.0)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 2.0),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0),

                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 1.5),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.phone_android_outlined,
                                            color: AppColors.lightGrayColor ,
                                          ),
                                        ),
                                        controller: _mobileNumber,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50.0,left: 50.0,bottom: 30.0),
                                      child: TextFormField(
                                        //keyboardType: TextInputType.text,
                                        style: new TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto"),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter a valid password!';
                                          }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                            return 'Enter a valid password!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Roboto",
                                              letterSpacing: 0.2,
                                              fontSize: 12,
                                              color: AppColors.lightGrayColor),
                                          hintText: 'Password',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: UnderlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(1.0)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 2.0),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0),

                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: AppColors.lightGrayColor, width: 1.5),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.lock,
                                            color: AppColors.lightGrayColor ,
                                          ),
                                        ),
                                        controller: _password,
                                      ),
                                    ),
                                    Container(
                                      width: 200,
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
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(15.0),
                                            ),
                                            onPrimary: AppColors.themeColor),
                                        onPressed: () {
                                          final isValid = formKey.currentState!.validate();
                                          if (!isValid) {
                                            return;
                                          }
                                          Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (context)=>UserHomeScreen()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            8.0,
                                          ),
                                          child: Text(
                                            'SignUp',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.2,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Roboto"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0,bottom: 30.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              'Already have an account?',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: AppColors.lightGrayColor,
                                                  fontWeight: FontWeight.w300,
                                                  letterSpacing: 0.2,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: "Roboto"),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (context)=>LoginScreen()));
                                              },
                                              child: Text(
                                                'Sign In',
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: AppColors.themeColor,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.2,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: "Roboto"),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 100.0,
                                            // ),

                                          ]),
                                    ),
                                  ],
                                ),
                                // alignment: Alignment(1.0, 0.0),
                                // padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
              ) ,
            ),

      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: (){
              StorageUtil.instance.removeAll();
              exit(0);
            },
            child: new Text('Yes'),
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
