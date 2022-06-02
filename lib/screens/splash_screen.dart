import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:trailer_tracking/screens/registeration/login_screen.dart';
import '../utils/colors.dart';
import '../widgets/internet_error_dialog.dart';
import 'Transporter_Module/dashboard/transporter_dashboard.dart';
import 'User Module/dashboard/home_screen.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  static const String id = 'Splash_Screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOffline = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final startAddressController = TextEditingController();

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
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin:   Alignment(-1.5, -4.0),
              end:  Alignment(1.5, 4.0),
              stops:  [0.4, 1],
              colors: [  Color(0XFFFFFFFF),  Color(0XFFFFFFFF)],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 130.0,
                width: 125.0,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
           /* const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/loader.png',height: 20,),
                const SizedBox(width: 10,),
                const Text(
                  "Launching",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            )*/
          ],
        ),
      ),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          isOffline = false;
          Timer(const Duration(milliseconds: 3000), () async{
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
          });
        }
        );
        break ;
      case ConnectivityResult.mobile:
        setState(() {
          isOffline = false;
          Timer(const Duration(milliseconds: 3000), () async{
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
          });
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
