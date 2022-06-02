import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/StringConstants.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import '../dashboard/transporter_dashboard.dart';

class AddDriverDetails extends StatefulWidget {
  const AddDriverDetails({Key? key}) : super(key: key);

  @override
  State<AddDriverDetails> createState() => _AddDriverDetailsState();
}

class _AddDriverDetailsState extends State<AddDriverDetails> {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOffline = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _driverName = TextEditingController();
  final TextEditingController _driverEmail = TextEditingController();
  final TextEditingController _driverDob = TextEditingController();
  final TextEditingController _driverMobileNumber = TextEditingController();
  final TextEditingController _driverLicenseNo = TextEditingController();
  final TextEditingController _driverAadharNo = TextEditingController();

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
        resizeToAvoidBottomInset : true,
        body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.primaryColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "WorkSans"),),) :
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
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
                              "Add Driver Details",
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
                        Form(
                          key: formKey,
                          child: Center(
                            child: ListView(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              shrinkWrap: true,
                              children: [
                                /*  Text(
                                  "Welcome",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.welcomeTextColor,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "WorkSans",
                                    letterSpacing: 0.2
                                  ),
                                ),*/
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"),
                                  onChanged: (value) {
                                    //Do something with the user input.
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter a valid Name!';
                                    }else if(value.length <= 2) {
                                      return 'Please enter name at least 3 characters';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans",
                                        letterSpacing: 0.2,
                                        fontSize: 12,
                                        color: AppColors.iconDarkColor),
                                    hintText: 'Driver Name',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.iconDarkColor, width: 2.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0),

                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.person,
                                      color: AppColors.textPrimaryColor ,
                                    ),
                                  ),
                                  controller: _driverName,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"),

                                  onChanged: (value) {
                                    //Do something with the user input.
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter a valid email!';
                                    }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                      return 'Enter email address is not correct!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans",
                                        letterSpacing: 0.2,
                                        fontSize: 12,
                                        color: AppColors.iconDarkColor),
                                    hintText: 'Email',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.iconDarkColor, width: 2.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0),

                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: AppColors.textPrimaryColor ,
                                    ),
                                  ),
                                  controller: _driverEmail,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"),
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
                                      return 'Enter a valid Mobile Number!';
                                    }else if(value.length != 10) {
                                      return 'Enter 10 digit mobile number';
                                    }else if(!value.startsWith("6") && !value.startsWith("7") && !value.startsWith("8") && !value.startsWith("9")) {
                                      return 'Mobile number should starts with 6/7/8/9';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans",
                                        letterSpacing: 0.2,
                                        fontSize: 12,
                                        color: AppColors.iconDarkColor),
                                    hintText: 'Mobile Number',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.iconDarkColor, width: 2.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0),

                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.phone_android_outlined,
                                      color: AppColors.textPrimaryColor ,
                                    ),
                                  ),
                                  controller: _driverMobileNumber,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  style: new TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Select date of birth';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans",
                                        letterSpacing: 0.2,
                                        fontSize: 12,
                                        color: AppColors.iconDarkColor),
                                    hintText: 'Date of Birth',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.iconDarkColor, width: 2.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),

                                  ),
                                  controller: _driverDob,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  style: new TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Aadhar Number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans",
                                        letterSpacing: 0.2,
                                        fontSize: 12,
                                        color: AppColors.iconDarkColor),
                                    hintText: 'Aadhar Number',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.iconDarkColor, width: 2.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),

                                  ),
                                  controller: _driverDob,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                TextFormField(
                                  style: new TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "WorkSans"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter License Number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "WorkSans",
                                        letterSpacing: 0.2,
                                        fontSize: 12,
                                        color: AppColors.iconDarkColor),
                                    hintText: 'License Number',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.iconDarkColor, width: 2.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                    ),

                                  ),
                                  controller: _driverLicenseNo,
                                ),

                                Container(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: const Text(
                                    'Driver Permanent Address',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildComposer(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Upload Aadhar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2,
                                          fontSize: 10,
                                          color: AppColors.editTextErrorBorderColor
                                      ),
                                    ),
                                    Text(
                                      "Upload License",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2,
                                          fontSize: 10,
                                          color: AppColors.editTextErrorBorderColor
                                      ),
                                    ),
                                    Text(
                                      "Upload Driver Photo",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2,
                                          fontSize: 10,
                                          color: AppColors.editTextErrorBorderColor
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: AppColors.textPrimaryColor,
                                    ),
                                    Icon(
                                      Icons.image,
                                      color: AppColors.textPrimaryColor,
                                    ),
                                    Icon(
                                      Icons.image,
                                      color: AppColors.textPrimaryColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30,),
                                Container(
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
                                    onPressed: () {
                                      final isValid = formKey.currentState!.validate();
                                      if (!isValid) {
                                        return;
                                      }
                                      Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (context)=>TransporterDashboardScreen()));
                                    },
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 0, right: 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {},
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your feedback...'),
              ),
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
