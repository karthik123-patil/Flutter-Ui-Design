import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';
import 'package:trailer_tracking/screens/User%20Module/address/user_current_location_screen.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../utils/internet_connection.dart';
const kGoogleApiKey = "AIzaSyCLOG6cNqwSL-85l90ZTzlArpUk_hSiwm4";

class ManageAddressScreen extends StatefulWidget {
  final String strCartValue, strSavedValue, strItemCounts;
  final String strCountry, strState, strCity;
  const ManageAddressScreen({Key? key, required this.strCartValue, required this.strSavedValue, required this.strItemCounts, required this.strCountry, required this.strState, required this.strCity}) : super(key: key);

  @override
  _ManageAddressScreenState createState() => _ManageAddressScreenState();
}

List id= [];
class _ManageAddressScreenState extends State<ManageAddressScreen> {
  late StreamSubscription _connectionChangeStream;
  bool isConnected = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isOffline = false;
  bool isCheckboxCheck = false;
  bool isShow = false;
  bool isRadioChecked = false;
  bool isSearchLocation = false;
  late String radioValue = "true";
  String _strAddressLength = "0", strSubscriptions = "", _userLat = "", _userLng = "";
  Color subscriptionColor = AppColors.darkTealColor;
  List<dynamic> address = [];
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  DetailsResult detailsResult = DetailsResult();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_){
      GetUserPosition();
    });
    googlePlace = GooglePlace(kGoogleApiKey);
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    super.initState();
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    setState(() {
      _userLat = position.latitude.toString();
      _userLng = position.longitude.toString();
    });
  }

  Future<void> GetUserPosition()async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);

  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          title:
          Text("Address",
            style: const TextStyle(
                color: AppColors.gradientBlueColor,
                fontSize: 14,
                fontFamily: "WorkSans",
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2
            ),

          )
        ),
        body:
        isSearchLocation?
        SafeArea(
          child:
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading:const CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.textColor,
                      child: Icon(
                        Icons.pin_drop,
                        color: AppColors.whiteColor,
                        size: 18,
                      ),
                    ),
                    title: Text(predictions[index].description.toString(),
                      style: const TextStyle(
                        color: AppColors.iconDarkColor,
                        fontSize: 14,
                        fontFamily: "WorkSans",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2
                      ),
                    ),
                    onTap: () {
                      debugPrint(predictions[index].placeId);
                      getDetils(predictions[index].placeId.toString());
                    },
                  ),
                  const Divider(
                    color: AppColors.closeIconColor,
                  ),
                ],
              );
            },
          ),
        )  :(isOffline)?
        const Center(
          child: Text(
            StringConstants.internetError,
            style: TextStyle(
                color: AppColors.textColor,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: "WorkSans"),
          ),
        ): SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration:const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.passwordIconColor,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                              UserCurrentLocationScreen(latitude: _userLat, longitude: _userLng, address: "", strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                builder: (context) =>
                                     UserCurrentLocationScreen(latitude: _userLat, longitude: _userLng, address: "",strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts , strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  "assets/icons/icon_drop.png",
                                  color: AppColors.gradientBlueColor,
                                  scale: 1.5,
                                ),
                                const Text(
                                  'Use current location',
                                  style: TextStyle(
                                      color: AppColors.gradientBlueColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Image.asset(
                                  "assets/icons/icon_outline_forward.png",
                                  color: AppColors.blueColor,
                                  scale: 1.5,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                            text: "Saved Addresses",
                            style: TextStyle(
                                color: AppColors.iconDarkColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Poppins",
                                letterSpacing: 1),
                          ),
                          TextSpan(
                            // text: "\t\t(1)",
                            text: "\t\t[1]",
                            style:const TextStyle(
                                color: AppColors.closeIconColor,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Poppins",
                                letterSpacing: 0.2),
                          ),
                        ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                              builder: (context) =>
                                  UserCurrentLocationScreen(latitude: _userLat, longitude: _userLng, address: "",strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity )));
                        },
                        child:const Text(
                          'Add new',
                          style: TextStyle(
                              color: AppColors.blueColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: Container(
                          decoration:const BoxDecoration(
                              color:
                              AppColors.whiteColor,
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      5)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors
                                      .passwordIconColor,
                                  offset: Offset(
                                      0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:50,
                                      child: RadioListTile<String>(
                                        activeColor: AppColors.gradientBlueColor,
                                        contentPadding:  EdgeInsets.zero,
                                        value: "1",
                                        groupValue: "1",
                                        onChanged: (ind) {
                                          setState(() async {
                                            radioValue = ind.toString();
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: RichText(
                                        text: TextSpan(
                                            children: <
                                                TextSpan>[
                                              TextSpan(
                                                text:
                                                "Home" ,
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .gradientBlueColor,
                                                    fontSize:
                                                    14,
                                                    fontWeight: FontWeight
                                                        .w500,
                                                    fontStyle: FontStyle
                                                        .normal,
                                                    fontFamily:
                                                    "WorkSans",
                                                    letterSpacing:
                                                    0.2),
                                              ),
                                              const TextSpan(
                                                text:
                                                "\t(default)",
                                                style: TextStyle(
                                                    color: AppColors
                                                        .editTextEnableBorderColor,
                                                    fontSize:
                                                    10,
                                                    fontWeight: FontWeight
                                                        .w500,
                                                    fontStyle: FontStyle
                                                        .normal,
                                                    fontFamily:
                                                    "WorkSans",
                                                    letterSpacing:
                                                    0.2),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left:8.0, right: 8,bottom: 12, top: 0),
                                  child:
                                  Stack(
                                    alignment: const Alignment(-0.6,0),
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          "Rt Nagar 14th cross, opposite road of Union Bank of india,\n Bangalore-560001",
                                          style: const TextStyle(
                                              color: AppColors.closeIconColor,
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              fontFamily: "WorkSans",
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: (){

                                          },
                                          child: Image.asset(
                                            "assets/icons/icon_delete.png",
                                            scale: 2,
                                            color: AppColors.editTextErrorBorderColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetils(String placeId) async {

    var result = await this.googlePlace.details.get(placeId);
    var lat;
    var lng;
    var address;
    if (result != null && result.result != null && mounted) {
      setState(() {
        print(result.result);
        detailsResult = result.result!;
        lat = detailsResult.geometry!.location!.lat.toString();
        lng = detailsResult.geometry!.location!.lng.toString();
        address = detailsResult.formattedAddress;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UserCurrentLocationScreen(latitude: lat.toString(), longitude: lng.toString(), address: address, strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity)));
     /* if (result.result.photos != null) {
        for (var photo in result.result.photos) {
          getPhoto(photo.photoReference);
        }
      }*/
    }
  }

  Future<bool> _onBackPressed() async {
    return true;
  }


}

class EditBottomDialog {
  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(context),
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

  Widget _buildDialogContent(context) {
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
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildImage(),
              const SizedBox(height: 8),
              _buildContinueText(),
              const SizedBox(height: 16),
              _buildEmapleText(),
              const SizedBox(height: 16),
              _buildTextField(),
              const SizedBox(height: 16),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const image = "assets/images/img_drop.png";
    return SizedBox(
      height: 60,
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }

  Widget _buildContinueText() {
    return const Text(
      'Do you want to edit address?',
      style: TextStyle(
          color: AppColors.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal),
    );
  }

  Widget _buildEmapleText() {
    return const Text(
      'Your address will be appoved by admin before it can be used for deliveries.',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColors.iconDarkColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal),
    );
  }

  Widget _buildTextField() {
    const iconSize = 40.0;
    return const Divider(
      color: AppColors.passwordIconColor,
    );
  }

  Widget _buildContinueButton(context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/img_back.png",
                          scale: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:const Text(
                          "Cancel",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: AppColors.welcomeTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Container(
                child: GestureDetector(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(

                        child: Image.asset(
                          "assets/icons/icon_edit.png",
                          scale: 2,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(

                        child:const Text(
                          "Edit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal),
                        ),
                      )
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

}

class BottomDialog {
  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(context),
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

  Widget _buildDialogContent(context) {
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
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildImage(),
              const SizedBox(height: 8),
              _buildContinueText(),
              const SizedBox(height: 16),
              _buildEmapleText(),
              const SizedBox(height: 16),
              _buildTextField(),
              const SizedBox(height: 16),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const image = "assets/images/img_drop.png";
    return SizedBox(
      height: 60,
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }

  Widget _buildContinueText() {
    return const Text(
      'Do you want to delete address?',
      style: TextStyle(
          color: AppColors.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal),
    );
  }

  Widget _buildEmapleText() {
    return const Text(
      'Your address is tied to multiple subscriptions and future deliveries.',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColors.iconDarkColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal),
    );
  }

  Widget _buildTextField() {
    const iconSize = 40.0;
    return const Divider(
      color: AppColors.passwordIconColor,
    );
  }

  Widget _buildContinueButton(context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/img_back.png",
                          scale: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:const Text(
                          "Cancel",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: AppColors.welcomeTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/icons/icon_delete.png",
                          scale: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {



                        },
                        child:const Text(
                          "Delete",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.editTextErrorBorderColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal),
                        ),
                      )
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
}
