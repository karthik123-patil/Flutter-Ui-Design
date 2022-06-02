import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/screens/Transporter_Module/trip_request/all_trip_request.dart';
import 'package:trailer_tracking/screens/Transporter_Module/trip_request/view_trip_request.dart';
import 'package:trailer_tracking/utils/app_theme.dart';
import 'package:trailer_tracking/utils/colors.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../wallet/wallet_screen.dart';

class TransporterHomePage extends StatefulWidget {
  const TransporterHomePage({Key? key}) : super(key: key);

  @override
  State<TransporterHomePage> createState() => _TransporterHomePageState();
}

class _TransporterHomePageState extends State<TransporterHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              AppUtils().transporterAppBar(context, "Home"),
              Container(
                color: AppColors.passwordIconColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.supervised_user_circle,
                                    color: AppColors.gradientBlueColor,
                                    size: 35,
                                  ),
                                  Text(
                                    "Driver",
                                    style: TextStyle(
                                      color: AppColors.textPrimaryColor,
                                      fontSize: 14,
                                      fontFamily: "WorkSans",
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  Icon(
                                    Icons.drive_eta_rounded,
                                    color: AppColors.gradientBlueColor,
                                    size: 35,
                                  ),
                                  Text(
                                    "Details",
                                    style: TextStyle(
                                        color: AppColors.textPrimaryColor,
                                        fontSize: 14,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterWalletScreen()));
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.wallet_travel,
                                      color: AppColors.gradientBlueColor,
                                      size: 35,
                                    ),
                                    Text(
                                      "Wallet",
                                      style: TextStyle(
                                          color: AppColors.textPrimaryColor,
                                          fontSize: 14,
                                          fontFamily: "WorkSans",
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.directions_bus,
                                    color: AppColors.gradientBlueColor,
                                    size: 35,
                                  ),
                                  Text(
                                    "Vehicles",
                                    style: TextStyle(
                                        color: AppColors.textPrimaryColor,
                                        fontSize: 14,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  Icon(
                                    Icons.emoji_transportation,
                                    color: AppColors.gradientBlueColor,
                                    size: 35,
                                  ),
                                  Text(
                                    "On Board",
                                    style: TextStyle(
                                        color: AppColors.textPrimaryColor,
                                        fontSize: 14,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.gradientBlueColor,
                                    size: 35,
                                  ),
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                        color: AppColors.textPrimaryColor,
                                        fontSize: 14,
                                        fontFamily: "WorkSans",
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )

                    ),
                  ),
                ),
              ),
              /*Padding(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Your Subscription is going to end on",
                                        style: TextStyle(
                                          color: AppColors.textPrimaryColor,
                                          fontSize: 14,
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          fontStyle: FontStyle.normal,

                                        ),
                                      ),
                                      TextSpan(
                                        text: "\t\n22-Apr-2022",
                                        style: TextStyle(
                                          color: AppColors.blueColor,
                                          fontSize: 15,
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          fontStyle: FontStyle.normal,

                                        ),
                                      ),
                                      TextSpan(
                                        text: ". To get trip request so kindly activate subscription.",
                                        style: TextStyle(
                                          color: AppColors.textPrimaryColor,
                                          fontSize: 14,
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          fontStyle: FontStyle.normal,

                                        ),
                                      ),
                                    ]
                                  ),
                                )
                                *//*Text(
                                  "Your Subscription is going to end on 22-Apr-2022. To get trip request so kindly activate subscription",
                                  style: TextStyle(
                                    color: AppColors.textPrimaryColor,
                                    fontSize: 14,
                                    fontFamily: "WorkSans",
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                    fontStyle: FontStyle.normal,

                                  ),
                                ),*//*
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
                              "Click Here",
                              style: TextStyle(
                                color: AppColors.blueColor,
                                fontSize: 14,
                                fontFamily: "WorkSans",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                fontStyle: FontStyle.normal,

                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
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
                      InkWell(
                        onTap:(){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AllTripRequest()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Trip Request",
                                style: TextStyle(
                                    color: AppColors.textPrimaryColor,
                                    fontSize: 14,
                                    fontFamily: "WorkSans",
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2
                                ),
                              ),
                              Text(
                                "View All",
                                style: TextStyle(
                                    color: AppColors.blueColor,
                                    fontSize: 12,
                                    fontFamily: "WorkSans",
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2
                                ),
                              ),
                            ],
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
