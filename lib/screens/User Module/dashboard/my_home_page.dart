import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/utils/colors.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import 'home_screen.dart';
import 'new_dashboard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                AppUtils().UserAppBar(context, "Vehicle Details"),
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
                                "Nippani(KA) - Mysuru(KA)",
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
                              Text(
                                "Posted on 31 Mar, 12:55 PM | Expires in 24 Hour(s)",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    color: AppColors.closeIconColor,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto"
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
                                SizedBox(width: 30,),
                                Container(
                                  width: 100,
                                  height: 35,
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
                              children: [
                                Text(
                                  "Galilee Intelegent Logistic",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: AppColors.blackColor,
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
                                "Nippani(KA) - Mysuru(KA)",
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
                              Text(
                                "Posted on 31 Mar, 12:55 PM | Expires in 24 Hour(s)",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    color: AppColors.closeIconColor,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto"
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
                                SizedBox(width: 30,),
                                Container(
                                  width: 100,
                                  height: 35,
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
                              children: [
                                Text(
                                  "Galilee Intelegent Logistic",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: AppColors.blackColor,
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
                                "Nippani(KA) - Mysuru(KA)",
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
                              Text(
                                "Posted on 31 Mar, 12:55 PM | Expires in 24 Hour(s)",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    color: AppColors.closeIconColor,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto"
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
                                SizedBox(width: 30,),
                                Container(
                                  width: 100,
                                  height: 35,
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
                                  "₹20000",
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
                              children: [
                                Text(
                                  "Galilee Intelegent Logistic",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: AppColors.blackColor,
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
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  UserHomeScreen()));
    return true;
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
