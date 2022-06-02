import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../utils/pin_pill_info.dart';
import '../../../widgets/internet_error_dialog.dart';
import '../trip_request/serach_available_vehicle.dart';
import 'my_home_page.dart';

class UserImportExportDashboard extends StatefulWidget {
  const UserImportExportDashboard({Key? key}) : super(key: key);

  @override
  State<UserImportExportDashboard> createState() => _UserImportExportDashboardState();
}

const kGoogleApiKey = 'AIzaSyCLOG6cNqwSL-85l90ZTzlArpUk_hSiwm4';
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 20;
const double CAMERA_BEARING = 10;
const LatLng SOURCE_LOCATION = LatLng(12.8452, 77.6602);

class _UserImportExportDashboardState extends State<UserImportExportDashboard> {

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
        DefaultTabController(
          length: 2,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.lightDimWhiteColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  children: [
                    AppUtils().appBar(context, "Home"),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.passwordIconColor,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 5.0,
                            )
                          ]
                      ),
                      child: TabBar(
                        unselectedLabelColor: AppColors.gradientBlueColor,
                        labelColor: AppColors.whiteColor,
                        unselectedLabelStyle: TextStyle(
                          color: AppColors.gradientBlueColor,
                        ),
                        indicator: BubbleTabIndicator(
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          indicatorHeight: 40.0,
                          indicatorColor: AppColors.gradientBlueColor,
                        ),
                        tabs: [
                          Text("Import",
                            style: TextStyle(
                                fontSize: 14.0,
                                //color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontStyle: FontStyle.normal,
                                fontFamily: "WorkSans"
                            ),
                          ),
                          Text("Export",
                            style: TextStyle(
                                fontSize: 14.0,
                                //color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontStyle: FontStyle.normal,
                                fontFamily: "WorkSans"
                            ),
                          ),
                        ],
                        onTap: (index){

                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                          ImportScreen(),
                          ExportScreen(),
                        ],
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

class ImportScreen extends StatefulWidget {
  const ImportScreen({Key? key}) : super(key: key);

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {

  String _userLatitude= "", _userLongitude = "", Address = "";
  Set<Marker> markers = {};
  MarkerId markerId = const MarkerId("YOUR-MARKER-ID");
  late String _markerString;
  String strState = "", strCountry = "", strAdministrativeArea = "", strSubLocality = "", strCity = "", strLat = "", strLng = "";
  double pinPillPosition = -100;
  bool isProfilePic = false;
  String location ='Null, Press Button';
  final Set<Marker> _markers = Set<Marker>();
  Animation<double>? _animation;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: const LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late BitmapDescriptor sourceIcon;
  bool _enabled = true;
  int _onStart = 200;
  late Timer _timer;
  String strFromLocation = "From Location", strToLocation = "To Location";

  @override
  void initState() {
    GetUserPosition();
    super.initState();
  }

  void onStartTimer() {
    const oneSec = Duration(seconds: 1);
    _timer =   Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_onStart == 0) {
          setState(() {
            _enabled = false;
          });
        } else {
          setState(() {
            _onStart--;
          });
        }
      },
    );
  }


  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.0), 'assets/images/marker.png')
        .then((onValue) {
      sourceIcon = onValue;
    });
  }

  late GoogleMapController mapController;
  LatLng _center = const LatLng(12.8452, 77.6602);

  final CameraPosition _currentPosition = const CameraPosition(
    target: LatLng(12.8452, 77.6602),
    zoom: 16,
  );
  final Completer<GoogleMapController> _controller = Completer();

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
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.thoroughfare}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}';
    strState = place.administrativeArea.toString();
    strCountry  = place.country.toString();
    strCity  = place.locality.toString();
    strSubLocality = place.subLocality.toString();
    strAdministrativeArea = place.administrativeArea.toString();
    setState(()  {
    });
  }

  Future<void> GetUserPosition()async {
    Position position = await _getGeoLocationPosition();
    location ='Lat: ${position.latitude} , Long: ${position.longitude}';
    _userLatitude = position.latitude.toString();
    _userLongitude = position.longitude.toString();
    _center =  LatLng(position.latitude, position.longitude);
    GetAddressFromLatLong(position);
  }



  @override
  Widget build(BuildContext context) {
    return
      ListView(
      children:[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.gradientBlueColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
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
                            color: AppColors.whiteColor,
                            scale: 1.5,
                          ),
                          Image.asset(
                            "assets/icons/icon_line.png",
                            color: AppColors.whiteColor,
                            scale: 1.5,
                          ),
                          Image.asset(
                            "assets/icons/icon_drop.png",
                            color: AppColors.whiteColor,
                            scale: 2,
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Select a port location",
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                strFromLocation = "MCN Nagar Extension, Thoraipakkam\n, Tamil Nadu 600096";
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5,),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/icon_home.png",
                                                      color: AppColors.blackColor,
                                                      scale: 2,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Chennai Port",
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "MCN Nagar Extension, Thoraipakkam\n, Tamil Nadu 600096",
                                                          maxLines:2,
                                                          style: TextStyle(
                                                            color: AppColors.passwordIconColor,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.directions,
                                                              color: AppColors.blackColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                strFromLocation = "Kunnumpuram Rd, Kunnumupuram Junction,\n Kunnumupuram, Fort Kochi, Kochi,\n Kerala 682001";
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5,),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/icon_home.png",
                                                      color: AppColors.blackColor,
                                                      scale: 2,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Cochin Port",
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Kunnumpuram Rd, Kunnumupuram Junction,\n Kunnumupuram, Fort Kochi, Kochi,\n Kerala 682001",
                                                          maxLines:2,
                                                          style: TextStyle(
                                                            color: AppColors.passwordIconColor,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.directions,
                                                              color: AppColors.blackColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5,),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/icon_home.png",
                                                    color: AppColors.blackColor,
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Bangalore Port",
                                                        style: TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                        maxLines:2,
                                                        style: TextStyle(
                                                          color: AppColors.passwordIconColor,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Icon(
                                                            Icons.directions,
                                                            color: AppColors.blackColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 5,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  strFromLocation,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    fontFamily: "WorkSans",
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18,),
                          Container(
                            color: Colors.white70,
                            height: 1,
                            width: 280,
                          ),
                          SizedBox(height: 18,),
                          InkWell(
                            onTap: (){
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Select a location",
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icons/icon_drop.png",
                                                  color: AppColors.editTextErrorBorderColor,
                                                  scale: 2,
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "Use current location",
                                                  style: TextStyle(
                                                    color: AppColors.editTextErrorBorderColor,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),

                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 25,),
                                              Expanded(
                                                child: Text(
                                                  "Rt Nagar, 14th cross Ananvadya Softech Private \nLimited, Banaglore-560001",
                                                  style: TextStyle(
                                                    color: AppColors.passwordIconColor,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ),
                                              SizedBox(width: 10,),
                                              Image.asset(
                                                "assets/icons/icon_drop.png",
                                                color: AppColors.passwordIconColor,
                                                scale: 2,
                                              ),
                                              SizedBox(width: 10,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Saved addresses",
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                strToLocation = "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001";
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5,),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/icon_home.png",
                                                      color: AppColors.blackColor,
                                                      scale: 2,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Home",
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                          maxLines:2,
                                                          style: TextStyle(
                                                            color: AppColors.passwordIconColor,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height:30,
                                                          width:30,
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: PopupMenuButton(
                                                            icon:const Icon( Icons.more_horiz,
                                                              color: AppColors.blackColor,
                                                              size: 15,),
                                                            color: AppColors.whiteColor,
                                                            onSelected: _selectOption,
                                                            itemBuilder: (BuildContext context){
                                                              return {'Edit', 'Delete'}.map((String choice) {
                                                                return PopupMenuItem<String>(
                                                                  height: 50,
                                                                  value: choice,
                                                                  child: Text(choice,
                                                                    style:const TextStyle(
                                                                        color: AppColors.textColor,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontFamily: "Poppins",
                                                                        letterSpacing: 0.2),),
                                                                );
                                                              }).toList();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height:30,
                                                          width:30,
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.directions,
                                                              color: AppColors.blackColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5,),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/icon_home.png",
                                                    color: AppColors.blackColor,
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Home",
                                                        style: TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                        maxLines:2,
                                                        style: TextStyle(
                                                          color: AppColors.passwordIconColor,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: PopupMenuButton(
                                                          icon:const Icon( Icons.more_horiz,
                                                            color: AppColors.blackColor,
                                                            size: 15,),
                                                          color: AppColors.whiteColor,
                                                          onSelected: _selectOption,
                                                          itemBuilder: (BuildContext context){
                                                            return {'Edit', 'Delete'}.map((String choice) {
                                                              return PopupMenuItem<String>(
                                                                height: 50,
                                                                value: choice,
                                                                child: Text(choice,
                                                                  style:const TextStyle(
                                                                      color: AppColors.textColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontFamily: "Poppins",
                                                                      letterSpacing: 0.2),),
                                                              );
                                                            }).toList();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Icon(
                                                            Icons.directions,
                                                            color: AppColors.blackColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 5,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5,),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/icon_home.png",
                                                    color: AppColors.blackColor,
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Home",
                                                        style: TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                        maxLines:2,
                                                        style: TextStyle(
                                                          color: AppColors.passwordIconColor,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: PopupMenuButton(
                                                          icon:const Icon( Icons.more_horiz,
                                                            color: AppColors.blackColor,
                                                            size: 15,),
                                                          color: AppColors.whiteColor,
                                                          onSelected: _selectOption,
                                                          itemBuilder: (BuildContext context){
                                                            return {'Edit', 'Delete'}.map((String choice) {
                                                              return PopupMenuItem<String>(
                                                                height: 50,
                                                                value: choice,
                                                                child: Text(choice,
                                                                  style:const TextStyle(
                                                                      color: AppColors.textColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontFamily: "Poppins",
                                                                      letterSpacing: 0.2),),
                                                              );
                                                            }).toList();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Icon(
                                                            Icons.directions,
                                                            color: AppColors.blackColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 5,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                            },
                            child: Row(
                              children: [
                                Text(
                                  strToLocation,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 12.0,
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

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Image.asset(
          "assets/images/container.png",
          fit: BoxFit.fill,
          height: 220,
        ),
        SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
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
                    borderRadius: new BorderRadius.circular(50.0),
                  ),
                  onPrimary: AppColors.primaryColor),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SearchAvailableVehicle()));
              },
              child: Container(
                padding: EdgeInsets.all(
                  15.0,
                ),
                child: Text(
                  'Search',
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
        ),
      ],
    );
  }

  void _selectOption(choice){
    switch(choice){
      case 'Edit':
        break;
      case 'Delete':
        break;
    }
  }
}

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String strFromLocation = "Choose Destination", strToLocation = "Choose Port";
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.gradientBlueColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
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
                            color: AppColors.whiteColor,
                            scale: 1.5,
                          ),
                          Image.asset(
                            "assets/icons/icon_line.png",
                            color: AppColors.whiteColor,
                            scale: 1.5,
                          ),
                          Image.asset(
                            "assets/icons/icon_drop.png",
                            color: AppColors.whiteColor,
                            scale: 2,
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap:(){
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Select a location",
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icons/icon_drop.png",
                                                  color: AppColors.editTextErrorBorderColor,
                                                  scale: 2,
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "Use current location",
                                                  style: TextStyle(
                                                    color: AppColors.editTextErrorBorderColor,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),

                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 25,),
                                              Expanded(
                                                child: Text(
                                                  "Rt Nagar, 14th cross Ananvadya Softech Private \nLimited, Banaglore-560001",
                                                  style: TextStyle(
                                                    color: AppColors.passwordIconColor,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ),
                                              SizedBox(width: 10,),
                                              Image.asset(
                                                "assets/icons/icon_drop.png",
                                                color: AppColors.passwordIconColor,
                                                scale: 2,
                                              ),
                                              SizedBox(width: 10,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Saved addresses",
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                strFromLocation = "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001";
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5,),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/icon_home.png",
                                                      color: AppColors.blackColor,
                                                      scale: 2,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Home",
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                          maxLines:2,
                                                          style: TextStyle(
                                                            color: AppColors.passwordIconColor,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height:30,
                                                          width:30,
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: PopupMenuButton(
                                                            icon:const Icon( Icons.more_horiz,
                                                              color: AppColors.blackColor,
                                                              size: 15,),
                                                            color: AppColors.whiteColor,
                                                            onSelected: _selectOption,
                                                            itemBuilder: (BuildContext context){
                                                              return {'Edit', 'Delete'}.map((String choice) {
                                                                return PopupMenuItem<String>(
                                                                  height: 50,
                                                                  value: choice,
                                                                  child: Text(choice,
                                                                    style:const TextStyle(
                                                                        color: AppColors.textColor,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontFamily: "Poppins",
                                                                        letterSpacing: 0.2),),
                                                                );
                                                              }).toList();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height:30,
                                                          width:30,
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.directions,
                                                              color: AppColors.blackColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5,),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/icon_home.png",
                                                    color: AppColors.blackColor,
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Home",
                                                        style: TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                        maxLines:2,
                                                        style: TextStyle(
                                                          color: AppColors.passwordIconColor,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: PopupMenuButton(
                                                          icon:const Icon( Icons.more_horiz,
                                                            color: AppColors.blackColor,
                                                            size: 15,),
                                                          color: AppColors.whiteColor,
                                                          onSelected: _selectOption,
                                                          itemBuilder: (BuildContext context){
                                                            return {'Edit', 'Delete'}.map((String choice) {
                                                              return PopupMenuItem<String>(
                                                                height: 50,
                                                                value: choice,
                                                                child: Text(choice,
                                                                  style:const TextStyle(
                                                                      color: AppColors.textColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontFamily: "Poppins",
                                                                      letterSpacing: 0.2),),
                                                              );
                                                            }).toList();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Icon(
                                                            Icons.directions,
                                                            color: AppColors.blackColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 5,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5,),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/icon_home.png",
                                                    color: AppColors.blackColor,
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Home",
                                                        style: TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                        maxLines:2,
                                                        style: TextStyle(
                                                          color: AppColors.passwordIconColor,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: PopupMenuButton(
                                                          icon:const Icon( Icons.more_horiz,
                                                            color: AppColors.blackColor,
                                                            size: 15,),
                                                          color: AppColors.whiteColor,
                                                          onSelected: _selectOption,
                                                          itemBuilder: (BuildContext context){
                                                            return {'Edit', 'Delete'}.map((String choice) {
                                                              return PopupMenuItem<String>(
                                                                height: 50,
                                                                value: choice,
                                                                child: Text(choice,
                                                                  style:const TextStyle(
                                                                      color: AppColors.textColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontFamily: "Poppins",
                                                                      letterSpacing: 0.2),),
                                                              );
                                                            }).toList();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height:30,
                                                        width:30,
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Icon(
                                                            Icons.directions,
                                                            color: AppColors.blackColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 5,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  strFromLocation,
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    fontFamily: "WorkSans",
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18,),
                          Container(
                            color: Colors.white70,
                            height: 1,
                            width: 280,
                          ),
                          SizedBox(height: 18,),
                          InkWell(
                            onTap: (){
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Select a port location",
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    fontFamily: "WorkSans",
                                                    fontStyle: FontStyle.normal,
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                strToLocation = "MCN Nagar Extension, Thoraipakkam\n, Tamil Nadu 600096";
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5,),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/icon_home.png",
                                                      color: AppColors.blackColor,
                                                      scale: 2,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Chennai Port",
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "MCN Nagar Extension, Thoraipakkam\n, Tamil Nadu 600096",
                                                          maxLines:2,
                                                          style: TextStyle(
                                                            color: AppColors.passwordIconColor,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.directions,
                                                              color: AppColors.blackColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                strToLocation = "Kunnumpuram Rd, Kunnumupuram Junction,\n Kunnumupuram, Fort Kochi, Kochi,\n Kerala 682001";
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5,),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/icon_home.png",
                                                      color: AppColors.blackColor,
                                                      scale: 2,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Cochin Port",
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Kunnumpuram Rd, Kunnumupuram Junction,\n Kunnumupuram, Fort Kochi, Kochi,\n Kerala 682001",
                                                          maxLines:2,
                                                          style: TextStyle(
                                                            color: AppColors.passwordIconColor,
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0,
                                                            fontFamily: "WorkSans",
                                                            fontStyle: FontStyle.normal,
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration:BoxDecoration(
                                                            color:AppColors.passwordIconColor,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Icon(
                                                              Icons.directions,
                                                              color: AppColors.blackColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5,),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/icon_home.png",
                                                    color: AppColors.blackColor,
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Bangalore Port",
                                                        style: TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rt Nagar, 14th cross \n Ananvadya Softech Private Limited, \nBanaglore-560001",
                                                        maxLines:2,
                                                        style: TextStyle(
                                                          color: AppColors.passwordIconColor,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          fontFamily: "WorkSans",
                                                          fontStyle: FontStyle.normal,
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:BoxDecoration(
                                                          color:AppColors.passwordIconColor,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Icon(
                                                            Icons.directions,
                                                            color: AppColors.blackColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 5,),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: AppColors.closeIconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  strToLocation,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 12.0,
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

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Image.asset(
          "assets/images/container.png",
          fit: BoxFit.fill,
          height: 220,
        ),
        SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
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
                    borderRadius: new BorderRadius.circular(50.0),
                  ),
                  onPrimary: AppColors.primaryColor),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MyHomePage()));
              },
              child: Container(
                padding: EdgeInsets.all(
                  15.0,
                ),
                child: Text(
                  'Search',
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
        ),
      ],
    );
  }

  void _selectOption(choice){
    switch(choice){
      case 'Edit':
        break;
      case 'Delete':
        break;
    }
  }
}

