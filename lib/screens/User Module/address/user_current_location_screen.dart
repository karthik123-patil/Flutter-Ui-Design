import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:skeletons/skeletons.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../utils/pin_pill_info.dart';
import '../../../widgets/internet_error_dialog.dart';
import 'add_new_address.dart';
import 'manage_address_screen.dart';

const kGoogleApiKey = 'AIzaSyCLOG6cNqwSL-85l90ZTzlArpUk_hSiwm4';
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(12.8452, 77.6602);

class UserCurrentLocationScreen extends StatefulWidget {
  final String latitude, longitude, address,strCartValue, strSavedValue, strItemCounts;
  final String strCountry, strState, strCity;
  const UserCurrentLocationScreen({Key? key, required this.latitude, required this.longitude, required this.address, required this.strCartValue, required this.strSavedValue, required this.strItemCounts, required this.strCountry, required this.strState, required this.strCity}) : super(key: key);

  @override
  _UserCurrentLocationScreenState createState() => _UserCurrentLocationScreenState();
}

class _UserCurrentLocationScreenState extends State<UserCurrentLocationScreen> {
  bool isConnected = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isOffline = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isCheckboxCheck = false;
  bool isShow = false;
  final TextEditingController _searchController = TextEditingController();
  String _userLatitude= "0.0", _userLongitude = "0.0", Address = "";
  Set<Marker> markers = {};
  MarkerId markerId = const MarkerId("YOUR-MARKER-ID");
  late String _markerString,  _houseNum = "", _strAddress = "", _strStateName = "", _strCityName, _strCountry = "", _strPincode = "", _streetDetails = "";
  double pinPillPosition = -100;
  bool isProfilePic = false;
  String location ='Null, Press Button';
  bool _enabled = true;
  final Set<Marker> _markers = <Marker>{};
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: const LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late BitmapDescriptor sourceIcon;
  late Timer _timer;
  int _start = 500;
  int _onStart = 200;

  @override
  void initState() {
    _strCityName = widget.strCity;
    _strStateName = widget.strState;
    _userLatitude = widget.latitude;
    _userLongitude = widget.longitude;
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    setSourceAndDestinationIcons();
    GetUserPosition();
   // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _timer.cancel();
    super.dispose();
  }



  void startTimer() {
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
    zoom: 12,
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
    if(widget.address.isNotEmpty){
      Address = widget.address;
    }else{
      Address = '${place.street}, ${place.thoroughfare}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}';
    }
    _strAddress = '${place.thoroughfare}' + '${place.subLocality}';
    _houseNum = '${place.street}';
    _streetDetails = '${place.thoroughfare}' + '${place.subLocality}';
    _strPincode = '${place.postalCode}';
    _strStateName = '${place.administrativeArea}';
    _strCityName = place.locality.toString();
    _strCountry = '${place.country}';
    setState(()  {
    });
  }

  Future<void> GetUserPosition()async {
    if(widget.latitude.isNotEmpty && widget.longitude.isNotEmpty){
      List<Placemark> newPlace = await placemarkFromCoordinates(double.parse(widget.latitude), double.parse(widget.longitude));
      Placemark placeMark  = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;
      setState(() {
        Address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
        _houseNum = "$name, $subLocality, $locality";
        _streetDetails = "$administrativeArea";
        _strPincode = postalCode.toString();
      });
      _userLatitude = widget.latitude;
      _userLongitude = widget.longitude;
      _center =  LatLng(double.parse(widget.latitude), double.parse(widget.longitude));
      String startCoordinatesString = '(${double.parse(widget.latitude)}, ${double.parse(widget.longitude)})';
      _markerString = '(${double.parse(widget.latitude)}, ${double.parse(widget.longitude)})';
      Marker startMarker = Marker(
        draggable: true,
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: Address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        )
      );
      markers.add(startMarker);
      updatePinOnMap(widget.latitude, widget.longitude);

    }else{
      Position position = await _getGeoLocationPosition();
      location ='Lat: ${position.latitude} , Long: ${position.longitude}';
      _userLatitude = position.latitude.toString();
      _userLongitude = position.longitude.toString();
      _center =  LatLng(position.latitude, position.longitude);
      GetAddressFromLatLong(position);
      String startCoordinatesString = '(${position.latitude}, ${position.longitude})';
      _markerString = '(${position.latitude}, ${position.longitude})';
      Marker startMarker = Marker(
        draggable: true,
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: Address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      );
      markers.add(startMarker);
      updatePinOnMap(position.latitude.toString(), position.longitude.toString());

    }
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
          leading: IconButton(
            onPressed: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  ManageAddressScreen(strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity))),
            icon: const Icon(Icons.arrow_back, color: AppColors.blackColor,),
            iconSize: 15,
          ),
          title:  Container(
              height: 40,
              margin: const  EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child:
              TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: AppColors.iconDarkColor,
                  fontSize: 12, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontFamily: "Poppins",
                ),
                onTap: (){
                  _handlePressButton();
                },
                decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5))),
                    hintStyle:  TextStyle(color: AppColors.closeIconColor, fontSize: 12, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    hintText: "Search for area, street or apartment"),
              )
          ),
        ),
        body:
        (isOffline)? const Center(child: Text(StringConstants.internetError, style: TextStyle(color: AppColors.textColor, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "Poppins"),),) :
        Stack(
          children: [
            GoogleMap(
              compassEnabled: true,
              tiltGesturesEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(_userLatitude),  double.parse(_userLongitude)),
                zoom: 14.4746,
              ),
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                showPinsOnMap();
              },
              onTap: (LatLng loc) {
                pinPillPosition = -20;
              },
              onCameraMove: ((_position) => _updatePosition(_position)),
            ),
          ],
        ),
        bottomNavigationBar:
         Container(
          height: 200,
          decoration:const BoxDecoration(
            color: AppColors.gradientBlueColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(2), topLeft:  Radius.circular(2)),
          ),
          child:
          _enabled?
          Skeleton(
            duration: const Duration(milliseconds: 200),
            shimmerGradient: const LinearGradient(
              colors: [
                Color(0xFFD8E3E7),
                Color(0xFFC8D5DA),
                Color(0xFFD8E3E7),
              ],
              stops: [
                0.1,
                0.5,
                0.9,
              ],
            ),
            darkShimmerGradient: const LinearGradient(
              colors: [
                Color(0xFF222222),
                Color(0xFF242424),
                Color(0xFF2B2B2B),
                Color(0xFF242424),
                Color(0xFF222222),
              ],
              stops: [
                0.0,
                0.2,
                0.5,
                0.8,
                1,
              ],
              begin: Alignment(-2.4, -0.2),
              end: Alignment(2.4, 0.2),
              tileMode: TileMode.clamp,
            ),
            isLoading: _enabled, 
            skeleton: SkeletonListView(),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              //randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 4,
                              maxLength: MediaQuery.of(context).size.width / 2,
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ):
          Column(
            children: [
              const SizedBox(height: 15,),
              _enabled?
              SkeletonListView():
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const[
                    SizedBox(width: 15,),
                    Text(
                      'Delivery Location',
                      style:   TextStyle(
                          color: AppColors.passwordIconColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          fontFamily: "WorkSans",
                          fontStyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
              _enabled?
              SkeletonListView():
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15,),
                    SizedBox(
                      width:250,
                      child: Text(
                        Address,
                        style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            fontFamily: "WorkSans",
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: (){
                          addUserLocation();
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side:const BorderSide(color: AppColors.whiteColor),
                              )
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/icons/icon_drop.png",
                                  scale: 2,
                                  color: AppColors.gradientBlueColor,
                                ),
                                const VerticalDivider(
                                  color: AppColors.gradientBlueColor,
                                ),
                                const Text(
                                  'Confirm Location',
                                  style:   TextStyle(
                                      color: AppColors.gradientBlueColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                      fontFamily: "WorkSans",
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ManageAddressScreen(strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity)));
    return true;
  }

  Future<void> _updatePosition(CameraPosition _position) async {
    setState(() {
      _enabled = true;
    });

    Marker marker = _markers.firstWhere(
            (p) => p.markerId == const MarkerId('sourcePin'));

    _markers.remove(marker);
    _markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ),
    );
    setState(() {});
    List<Placemark> newPlace = await placemarkFromCoordinates(_position.target.latitude, _position.target.longitude);
    Placemark placeMark  = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    setState(() {
      onStartTimer();
      Address = "${name}, ${subLocality}, $locality, $administrativeArea ${postalCode}, ${country}";
      _houseNum = "${name}, ${subLocality}, ${locality}";
      _streetDetails = "${administrativeArea}";
      _strPincode = postalCode.toString();
      _strStateName = placeMark.administrativeArea.toString();
      _strCityName = placeMark.locality.toString();
    });
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

  void showPinsOnMap() {
    var pinPosition =
    LatLng(double.parse(_userLatitude), double.parse(_userLongitude));
    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: LatLng(double.parse(_userLatitude),  double.parse(_userLongitude)),
        pinPath: "assets/images/marker.png",
        avatarPath: "assets/friend1.jpg",
        labelColor: Colors.blueAccent);
    _markers.add(Marker(
        markerId:const MarkerId('sourcePin'),
        position: pinPosition,
        draggable: true,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        onDragEnd: ((newPosition) async {
          print("New Position"+ newPosition.latitude.toString());
          print(newPosition.longitude);
          _userLatitude = newPosition.latitude.toString();
          _userLongitude =  newPosition.longitude.toString();
          List<Placemark> newPlace = await placemarkFromCoordinates(double.parse(_userLatitude), double.parse(_userLongitude));
          Placemark placeMark  = newPlace[0];
          String? name = placeMark.name;
          String? subLocality = placeMark.subLocality;
          String? locality = placeMark.locality;
          String? administrativeArea = placeMark.administrativeArea;
          String? postalCode = placeMark.postalCode;
          String? country = placeMark.country;
          setState(() {
            Address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
            _houseNum = "$name, $subLocality, $locality";
            _streetDetails = "$administrativeArea";
            _strPincode = postalCode.toString();
            _strStateName = placeMark.administrativeArea.toString();
            _strCityName = placeMark.locality.toString();
          });
        }),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        )));
  }

  void updatePinOnMap(String lat, String lng) async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(double.parse(lat), double.parse(lng)),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() async {
      var pinPosition =
      LatLng(double.parse(lat), double.parse(lng));
      sourcePinInfo.location = pinPosition;
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          draggable: true,
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          onDragEnd: ((newPosition) async{
            _userLatitude = newPosition.latitude.toString();
            _userLongitude =  newPosition.longitude.toString();
            List<Placemark> newPlace = await placemarkFromCoordinates(double.parse(_userLatitude), double.parse(_userLongitude));
            Placemark placeMark  = newPlace[0];
            String? name = placeMark.name;
            String? subLocality = placeMark.subLocality;
            String? locality = placeMark.locality;
            String? administrativeArea = placeMark.administrativeArea;
            String? postalCode = placeMark.postalCode;
            String? country = placeMark.country;
            setState(() {
              Address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
              _houseNum = "$name, $subLocality, $locality";
              _streetDetails = "$administrativeArea";
              _strPincode = postalCode.toString();
              _strStateName = placeMark.administrativeArea.toString();
              _strCityName = placeMark.locality.toString();
            });
          }),
          position: pinPosition, // updated position
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          )));
    });
  }

  void movePinOnMap(String lat, String lng) async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(double.parse(lat), double.parse(lng)),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() async {
      var pinPosition =
      LatLng(double.parse(lat), double.parse(lng));
      sourcePinInfo.location = pinPosition;
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          draggable: true,
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          onDragEnd: ((newPosition) async{
            _userLatitude = newPosition.latitude.toString();
            _userLongitude =  newPosition.longitude.toString();
            List<Placemark> newPlace = await placemarkFromCoordinates(double.parse(_userLatitude), double.parse(_userLongitude));
            Placemark placeMark  = newPlace[0];
            String? name = placeMark.name;
            String? subLocality = placeMark.subLocality;
            String? locality = placeMark.locality;
            String? administrativeArea = placeMark.administrativeArea;
            String? postalCode = placeMark.postalCode;
            String? country = placeMark.country;
            setState(() {
              Address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
              _houseNum = "$name, $subLocality, $locality";
              _streetDetails = "$administrativeArea";
              _strPincode = postalCode.toString();
              _strStateName = placeMark.administrativeArea.toString();
              _strCityName = placeMark.locality.toString();
            });
          }),
          position: pinPosition, // updated position
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          )));

      List<Placemark> newPlace = await placemarkFromCoordinates(double.parse(lat.toString()), double.parse(lng.toString()));
      Placemark placeMark  = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? street = placeMark.street;
      String? country = placeMark.country;
      setState(() {
        _houseNum = "$name, $subLocality, $locality";
        _streetDetails = "$street";
        _strPincode = postalCode.toString();
        Address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
        _strStateName = placeMark.administrativeArea.toString();
        _strCityName = placeMark.locality.toString();
      });
    });
  }

  Future<void> _handlePressButton() async {
    void onError(PlacesAutocompleteResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Unknown error'),
        ),
      );
    }
    final p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.fullscreen,
      language: 'en',
      components: [Component(Component.country, 'IN')],
    );

    await displayPrediction(p!, ScaffoldMessenger.of(context));
  }
  Future<void> displayPrediction(Prediction p, ScaffoldMessengerState messengerState) async {
    if (p == null) {
      return;
    }
    final _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );

    final detail = await _places.getDetailsByPlaceId(p.placeId??"");
    final geometry = detail.result.geometry;
    final lat = geometry!.location.lat;
    final lng = geometry.location.lng;
    List<Placemark> newPlace = await placemarkFromCoordinates(double.parse(geometry.location.lat.toString()), double.parse(geometry.location.lng.toString()));
    Placemark placeMark  = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? street = placeMark.street;
    setState(() {
      _houseNum = "${name}, ${subLocality}, ${locality}";
      _streetDetails = "${street}";
      _strPincode = postalCode.toString();
    });
    setState(() {
      Address = Address = '${p.description}';
      _userLongitude = geometry.location.lng.toString();
      _userLatitude = geometry.location.lat.toString();
      _strAddress = p.description.toString();
      _searchController.text = '${p.description}';
      _strStateName = placeMark.administrativeArea.toString();
      _strCityName = placeMark.locality.toString();
      updatePinOnMap(lat.toString(), lng.toString());
    });
  }

  void addUserLocation() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(
        builder: (context) =>
         NewAddressScreen(houseNo: _houseNum, streetDetails: _streetDetails, pinCode: _strPincode,longitude: _userLatitude, latitude: _userLongitude, strCartValue: widget.strCartValue, strSavedValue: widget.strSavedValue, strItemCounts: widget.strItemCounts, strCountry:widget.strCountry, strState: _strStateName, strCity: _strCityName)));

  }
}
