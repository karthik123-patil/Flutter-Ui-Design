import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/screens/User%20Module/address/widget/new_address_appbar.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../widgets/internet_error_dialog.dart';
import 'manage_address_screen.dart';

class NewAddressScreen extends StatefulWidget {
  final String houseNo, streetDetails, pinCode, latitude, longitude,strCartValue, strSavedValue, strItemCounts;
  final String strCountry, strState, strCity;
  const NewAddressScreen({Key? key, required this.houseNo, required this.streetDetails, required this.pinCode, required this.latitude, required this.longitude, required this.strCartValue, required this.strSavedValue, required this.strItemCounts, required this.strCountry, required this.strState, required this.strCity}) : super(key: key);

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  bool isOffline = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnected = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCheckboxCheck = false;
  bool isRingBellCheck = false;
  bool isShow = false;
  bool isRingShow = false;
  bool isHome = false;
  bool isOffice = false;
  bool isOthers = false;
  bool isFetching = false;
  bool isLoading = false;
  bool isShowAddTypeMsg = false;
  String _strFetching = "", _strFetched = "", _strCityName = "", _strStateName = "", _strAddressType = "", _strErrorMsg = "", strAddress1 = "";
  String _strUserName = "Piyush", _strUserEmail = "piyush@gmail.com", _strMobileNo = "9090902010";
  bool isUrlImage = false;
  String imageUrl = "";

  final TextEditingController _houseNum = TextEditingController();
  final TextEditingController _streetAddress = TextEditingController();
  final TextEditingController _landMark = TextEditingController();
  final TextEditingController _pinCode = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _houseNumFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _streetAddressFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _landMarkFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _pinCodeFormKey = GlobalKey<FormFieldState>();

  bool _isFormValid() {
    return ((_houseNumFormKey.currentState!.isValid &&
        _streetAddressFormKey.currentState!.isValid &&
        _landMarkFormKey.currentState!.isValid && _pinCodeFormKey.currentState!.isValid));
  }
  var focusNode = FocusNode();
  var focusNodeStreet = FocusNode();
  var focusNodeLandMark = FocusNode();
  var focusNodePinCode = FocusNode();


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    focusNode.addListener(() {
      if(!focusNode.hasFocus){
        setState(() {
          _houseNum.text = _houseNum.text.trim();
        });
      }
    });
    focusNodeStreet.addListener(() {
      if(!focusNodeStreet.hasFocus){
        setState(() {
          _streetAddress.text = _streetAddress.text.trim();
        });
      }
    });
    focusNodeLandMark.addListener(() {
      if(!focusNodeLandMark.hasFocus){
        setState(() {
          _landMark.text = _landMark.text.trim();
        });
      }
    });
    focusNodePinCode.addListener(() {
      if(!focusNodePinCode.hasFocus){
        setState(() {
          _pinCode.text = _pinCode.text.trim();
        });
      }
    });
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
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewAddressAppBar(latitude: widget.latitude, longitude: widget.longitude, strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity),
        body: (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.textColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "Poppins"),),) :
        SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
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
                          Container(
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
                            child:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 60,),
                                      Text(
                                        _strUserName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: AppColors.iconDarkColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 2,
                                            fontFamily: "WorkSans",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: InkWell(
                                                      onTap: null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 20),
                                                        child: isUrlImage?CircleAvatar(
                                                          backgroundImage: NetworkImage(imageUrl),
                                                        ):const CircleAvatar(
                                                          backgroundImage: ExactAssetImage('assets/images/user.png'),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  alignment: Alignment.bottomRight,
                                                  margin: const EdgeInsets.only(top: 10, left: 10),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:10.0),
                                                    child: Container(
                                                      width: 11,
                                                      height: 11,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color:AppColors.editTextEnableBorderColor,
                                                          border: Border.all(color: Colors.white, width: 1)),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                _strUserEmail,
                                                textAlign: TextAlign.center,
                                                style:const TextStyle(
                                                    color: AppColors.closeIconColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.2,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal),
                                              ),

                                              Container(
                                                margin: const EdgeInsets.only(left: 30),
                                                child: GestureDetector(
                                                  child: Image.asset(
                                                    "assets/icons/icon_edit.png",
                                                    scale: 2,
                                                    color: AppColors.closeIconColor,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                _strMobileNo,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: AppColors.closeIconColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.2,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal),
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
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              key: _houseNumFormKey,
                              controller: _houseNum,
                              keyboardType: TextInputType.text,
                              focusNode: focusNode,
                              onChanged: (value) {
                                setState(() {
                                  _houseNumFormKey.currentState!.validate();
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return 'Enter House Number and Apartment Name';
                                }else if(value.length <= 4){
                                  return 'Enter more than 4 characters';
                                } else {
                                  return null;
                                }
                              },
                              style:const TextStyle(
                                  color: AppColors.iconDarkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "WorkSans"
                              ),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                label: RichText(
                                  textAlign: TextAlign.center,
                                  text:const  TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: "House Number, Apartment Name\t",
                                      style: TextStyle(
                                          color: AppColors.passwordIconColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2),
                                    ),
                                    TextSpan(
                                      text: "(mandatory)",
                                      style: TextStyle(
                                          color: AppColors.editTextErrorBorderColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2),
                                    ),
                                  ]),
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
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              controller: _streetAddress,
                              keyboardType: TextInputType.text,
                              key: _streetAddressFormKey,
                              focusNode: focusNodeStreet,
                              onChanged: (value) {
                                setState(() {
                                  _streetAddressFormKey.currentState!.validate();
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return 'Enter street details';
                                }else if(value.length <= 4){
                                  return 'Enter more than 4 characters';
                                } else {
                                  return null;
                                }
                              },
                              style:const TextStyle(
                                  color: AppColors.iconDarkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "WorkSans"
                              ),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                label: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(children: <TextSpan> [
                                    TextSpan(
                                      text: "Street Details\t",
                                      style: TextStyle(
                                          color: AppColors.passwordIconColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2),
                                    ),
                                    TextSpan(
                                      text: "(mandatory)",
                                      style: TextStyle(
                                          color: AppColors.editTextErrorBorderColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2),
                                    ),
                                  ]),
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
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              controller: _landMark,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  //_landMarkFormKey.currentState!.validate();
                                });
                              },
                              focusNode: focusNodeLandMark,
                              style: const TextStyle(
                                  color: AppColors.iconDarkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "WorkSans"
                              ),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                label: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: "Landmark",
                                      style: TextStyle(
                                          color: AppColors.passwordIconColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Poppins",
                                          letterSpacing: 0.2),
                                    ),
                                  ]),
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
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              controller: _pinCode,
                              keyboardType: TextInputType.number,
                              key: _pinCodeFormKey,
                              focusNode: focusNodePinCode,
                              readOnly: true,
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return 'Enter pincode';
                                }else if(value.length != 6 ){
                                  return 'Please enter 6digit pincode';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(
                                  color: AppColors.iconDarkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "WorkSans"
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _pinCodeFormKey.currentState!.validate();
                                  if(value.length != 6) {
                                    _strFetching = "Please enter valid pin code";
                                  }else if(value.length == 6) {
                                    _strFetching = "Fetching city and state ...";
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                //suffixIcon: Image.asset("assets/icons/icon_loader.png", scale: 2.5,),
                                suffixIcon: isLoading?Container(
                                  height: 8,
                                  width: 8,
                                  margin:const EdgeInsets.all(15),
                                  child:const CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: AppColors.textColor,
                                  ),
                                ):null,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                helperText: isFetching ? _strFetched : _strFetching,
                                helperStyle:const TextStyle(
                                    color: AppColors.closeIconColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                    fontFamily: "WorkSans",
                                    fontStyle: FontStyle.normal),
                                label: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: "Pincode",
                                      style: TextStyle(
                                          color: AppColors.passwordIconColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2),
                                    ),
                                    TextSpan(
                                      text: "(mandatory)",
                                      style: TextStyle(
                                          color: AppColors.editTextErrorBorderColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "WorkSans",
                                          letterSpacing: 0.2),
                                    ),
                                  ]),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                enabledBorder:const UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.passwordIconColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: const[
                                  Text(
                                  'Address Type',
                                  style:   TextStyle(
                                      color: AppColors.iconDarkColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2,
                                      fontFamily: "WorkSans",
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: isHome?AppColors.gradientBlueColor:AppColors.whiteColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        border: Border.all(
                                          color: isHome?AppColors.gradientBlueColor:AppColors.closeIconColor,
                                        )
                                    ),
                                    width: 70,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        'Home',
                                        style: TextStyle(
                                            color: isHome?AppColors.whiteColor:AppColors.closeIconColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontFamily: "WorkSans",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    _strAddressType = "Home";
                                    isShowAddTypeMsg = false;
                                    setState(() {
                                      isHome = true;
                                      isOffice = false;
                                      isOthers = false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 20,),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: isOffice?AppColors.gradientBlueColor:AppColors.whiteColor,
                                        borderRadius:const BorderRadius.all(Radius.circular(20)),
                                        border: Border.all(
                                          color: isOffice?AppColors.gradientBlueColor:AppColors.closeIconColor,
                                        )
                                    ),
                                    width: 70,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        'Office',
                                        style: TextStyle(
                                            color: isOffice?AppColors.whiteColor:AppColors.closeIconColor,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontFamily: "WorkSans",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    _strAddressType = "Office";
                                    isShowAddTypeMsg = false;
                                    setState(() {
                                      isHome = false;
                                      isOffice = true;
                                      isOthers = false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 20,),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: isOthers?AppColors.gradientBlueColor:AppColors.whiteColor,
                                        borderRadius:const BorderRadius.all(Radius.circular(20)),
                                        border: Border.all(
                                          color: isOthers?AppColors.gradientBlueColor:AppColors.closeIconColor,
                                        )
                                    ),
                                    width: 70,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        'Others',
                                        style: TextStyle(
                                            color: isOthers?AppColors.whiteColor:AppColors.closeIconColor,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                            fontFamily: "WorkSans",
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    _strAddressType = "Others";
                                    isShowAddTypeMsg = false;
                                    setState(() {
                                      isHome = false;
                                      isOffice = false;
                                      isOthers = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isShowAddTypeMsg,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10,),
                                const IconButton(onPressed: null, icon: Icon(Icons.warning_amber_outlined, color: AppColors.editTextErrorBorderColor, size: 14,)),
                                InkWell(
                                  onTap: null,
                                  child: Text(
                                    _strErrorMsg,
                                    style:const TextStyle(
                                        color: AppColors.editTextErrorBorderColor,
                                        fontSize: 10,
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2,
                                        fontStyle: FontStyle.normal
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 0.7,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: AppColors.textColor,
                                    value: isCheckboxCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isCheckboxCheck = value!;
                                        if(isCheckboxCheck == true){
                                          isShow = true;
                                        }else{
                                          isShow = false;
                                        }

                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'Set address as default',
                                  style:  TextStyle(
                                      color: isShow? AppColors.gradientBlueColor :AppColors.passwordIconColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2,
                                      fontFamily: "WorkSans",
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 0.7,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: AppColors.gradientBlueColor,
                                    value: isRingBellCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isRingBellCheck = value!;
                                        if(isRingBellCheck == true){
                                          isRingShow = true;
                                        }else{
                                          isRingShow = false;
                                        }

                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  'Do not ring the bell',
                                  style:  TextStyle(
                                      color: isRingShow? AppColors.gradientBlueColor :AppColors.passwordIconColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2,
                                      fontFamily: "WorkSans",
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async{
                                final isValid = _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }else if(_strAddressType == ""){
                                  setState(() {
                                    isShowAddTypeMsg = true;
                                    _strErrorMsg = "Please select address type";
                                  });
                                }else{
                                  isShowAddTypeMsg = false;
                                  addNewAddress();
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.gradientBlueColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side:const BorderSide(color: AppColors.gradientBlueColor)
                                    )
                                ),
                              ),
                              child: const Text(StringConstants.btnAddNewAddress, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,letterSpacing: 1, fontFamily: "Poppins", fontStyle: FontStyle.normal)),
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
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (context)=> ManageAddressScreen(strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity)));
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
  void addNewAddress() {
    AppUtils().showSuccessToastMsg("Delivery address added successfully");
  }
}
