import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/StringConstants.dart';
import '../utils/colors.dart';

class InternetErrorDialog extends StatefulWidget {
  const InternetErrorDialog({Key? key}) : super(key: key);

  @override
  _InternetErrorDialogState createState() => _InternetErrorDialogState();
}

class _InternetErrorDialogState extends State<InternetErrorDialog> {
  bool isOffline = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
    return AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo.png",
                scale: 5,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Internet Connection Lost",
                style: TextStyle(
                  color: AppColors
                      .textPrimaryColor,
                  fontSize: 14.0,
                  fontWeight:
                  FontWeight.w500,
                  letterSpacing: 1,
                  fontFamily: "WorkSans",
                  fontStyle:
                  FontStyle.normal,
                ),
              )
            ],
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/img_no_signal.png",
                  scale: 7,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Expanded(
                  child: Text(
                    "To use this application please connect to a stable network.",
                    style: TextStyle(
                      color: AppColors
                          .textPrimarySubColor,
                      fontSize: 12.0,
                      fontWeight:
                      FontWeight.w500,
                      letterSpacing: 0.2,
                      fontFamily: "WorkSans",
                      fontStyle:
                      FontStyle.normal,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        const Divider(
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              initConnectivity();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: AppColors.primaryColor)
                  )
              ),
            ),
            child: const Text(StringConstants.btnRetry, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,letterSpacing: 1, fontFamily: "Poppins", fontStyle: FontStyle.normal)),
          ),

        ),
      ],
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          isOffline = false;
          Navigator.of(context).pop(true);
         }
        );
        break ;
      case ConnectivityResult.mobile:
        setState(() {
          isOffline = false;
          Navigator.of(context).pop(true);
          }
        );
        break ;
      case ConnectivityResult.none:
        setState(() {
          isOffline = true;
        });
        break;
      default:
        setState(() {
          isOffline = true;
         }
        );
        break;
    }
  }


}



