


import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailer_tracking/components/style.dart';
import 'package:trailer_tracking/screens/User%20Module/wallet/wallet_screen.dart';
import '../../../utils/AppUtils.dart';
import '../../../utils/StringConstants.dart';
import '../../../utils/colors.dart';
import '../../../utils/internet_connection.dart';

class WalletActivitiesScreen extends StatefulWidget {
  static const String id = StringConstants.walletActivitiesScreen;
  const WalletActivitiesScreen({Key? key}) : super(key: key);

  @override
  _WalletActivitiesScreenState createState() => _WalletActivitiesScreenState();
}

class _WalletActivitiesScreenState extends State<WalletActivitiesScreen> {
  late StreamSubscription _connectionChangeStream;
  bool isConnected = true;
  bool isOffline = false;
  bool isCheckboxCheck = false;
  bool isShow = false;
  String _strTotalCart = "", _strDeviceId ="";
  bool isCartTotal = false;

  @override
  void initState() {
    super.initState();
    getDeviceId();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  void getDeviceId() async{
    AppUtils().getId().then((value){
      _strDeviceId = value.toString();
    });
  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: _onBackPressed,

        child: Scaffold(

          //appBar:   WalletActivitiesAppBar(strCountry:widget.strCountry, strState: widget.strState, strCity: widget.strCity),
          body: (isOffline)
              ? const Center(
            child:  Text(
              StringConstants.internetError,
              style:  TextStyle(
                  color: AppColors.textColor,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: "Poppins"),
            ),
          )
              : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  AppUtils().UserWalletActivitiesAppBar(context, "Wallet Activities"),
                  const SizedBox(
                    height: 20,
                  ),
                  const TabBar(
                    indicatorColor: AppColors.blueColor,
                    labelStyle: txtStyle.tabTextStyle,
                    labelColor: AppColors.iconDarkColor,
                    unselectedLabelColor: AppColors.closeIconColor,
                    tabs: [
                      Tab(
                        text: 'All',
                      ),
                      Tab(
                        text: 'Recharges',
                      ),
                      // Tab(text: 'Cashbacks',),
                      Tab(
                        text: 'Transactions',
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppColors.textColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const TabBarView(
                      children: [
                        AllActivities(),
                        AllRecharges(),
                        // AllCashback(),
                        AllTransActivities(),
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

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>   WalletScreen()));
    return true;
  }
}

class AllActivities extends StatefulWidget {
  const AllActivities({Key? key}) : super(key: key);

  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 250),
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Text("All Activities")
        ]),
      ),
    );
  }
}

class AllRecharges extends StatefulWidget {
  const AllRecharges({Key? key}) : super(key: key);

  @override
  _AllRechargesState createState() => _AllRechargesState();
}

class _AllRechargesState extends State<AllRecharges> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 250),
      child: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(children: [
              const SizedBox(
                height: 10,
              ),
              Text("All Recharges")
            ])
          ],
        ),
      ),
    );
  }
}

class AllTransActivities extends StatefulWidget {
  const AllTransActivities({Key? key}) : super(key: key);

  @override
  _AllTransActivitiesState createState() => _AllTransActivitiesState();
}

class _AllTransActivitiesState extends State<AllTransActivities> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // for(int k=0;k<total[i]['totalData'].length;k++)
    return SingleChildScrollView(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text("All Transaction")
            ],
          )
        ],
      ),
    );
  }
}
