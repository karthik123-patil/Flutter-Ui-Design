import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:trailer_tracking/screens/splash_screen.dart';
import 'package:trailer_tracking/services/notification_service.dart';
import 'package:trailer_tracking/utils/colors.dart';
import 'package:trailer_tracking/utils/internet_connection.dart';
import 'package:trailer_tracking/widgets/internet_error_dialog.dart';

import 'components/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService().setupInteractedMessage();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  await Firebase.initializeApp();

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    print(error.toString());
  });
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late final String _colorMode = "light";
  late ThemeBloc _themeBloc;
  bool isOffline = false;
  late FirebaseMessaging _firebaseMessaging;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String  _strFirebaseToken = "";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _themeBloc = ThemeBloc();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((value){
      _strFirebaseToken = value!;
      print("FCM_TOKEN" + _strFirebaseToken);
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.whiteColor,
        systemNavigationBarColor: AppColors.whiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return StreamBuilder<ThemeData>(
      initialData: _themeBloc.initialTheme(_colorMode).data,
      stream: _themeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          title: 'Trailer Tracking',
          theme: snapshot.data,
          debugShowCheckedModeBanner: false,
          home:   SplashScreen(),
          routes: {
            'Splash_Screen': (BuildContext context) =>   SplashScreen(),
          },
        );
      },
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