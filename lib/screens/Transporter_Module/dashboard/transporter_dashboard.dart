import 'package:flutter/material.dart';
import 'package:trailer_tracking/screens/Transporter_Module/driver/add_driver_details.dart';
import 'package:trailer_tracking/screens/Transporter_Module/driver/driver_details.dart';
import 'package:trailer_tracking/screens/Transporter_Module/transporter_drawer/drawer_transporter_controller.dart';
import 'package:trailer_tracking/screens/Transporter_Module/transporter_drawer/transporter_home_drawer.dart';
import 'package:trailer_tracking/screens/Transporter_Module/dashboard/transporter_home_page.dart';
import 'package:trailer_tracking/screens/Transporter_Module/vehicle/vehicle_details.dart';

import '../../../utils/app_theme.dart';
import '../../../utils/colors.dart';
import '../../User Module/About/feedback_screen.dart';
import '../../User Module/About/invite_friend_screen.dart';
import '../../User Module/wallet/wallet_screen.dart';
import '../trip_request/all_trip_request.dart';

class TransporterDashboardScreen extends StatefulWidget {
  const TransporterDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TransporterDashboardScreen> createState() => _TransporterDashboardScreenState();
}

class _TransporterDashboardScreenState extends State<TransporterDashboardScreen> {
  AnimationController? animationController;
  bool multiple = true;
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    screenView = TransporterHomePage();
    drawerIndex = DrawerIndex.HOME;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        body: DrawerTransporterController(
          screenIndex: drawerIndex,
          drawerWidth: MediaQuery.of(context).size.width * 0.75,
          onDrawerCall: (DrawerIndex drawerIndexdata) {
            changeIndex(drawerIndexdata);
            //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
          },
          screenView: screenView,
          //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
        ),
        bottomNavigationBar:
        BottomAppBar(
            elevation: 5,
            color:AppColors.whiteColor,
            shape:const CircularNotchedRectangle(), //shape of notch
            notchMargin: 5,
            //notche margin between floating button and bottom appbar
            child:
            SizedBox(
              height: 60,
              child:
              Column(
                children: [
                  const SizedBox(height: 10,),
                  Stack(
                    children: [
                      Align(
                        alignment:const Alignment(-0.8, 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
                          },
                          child: Image.asset("assets/icons/icon_home.png",
                            color: AppColors.gradientBlueColor,
                            height: 20.6,
                            width: 20.42,),),
                      ),
                      Align(
                        alignment:const Alignment(-0.3, 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AllTripRequest()));
                          },
                          child: Icon(Icons.book, color: AppColors.closeIconColor,),),
                      ),
                      Align(
                        alignment:const Alignment(0.28, 0),
                        child: InkWell(
                          onTap: (){
                          },
                          child: Icon(Icons.emoji_transportation, color: AppColors.closeIconColor,),),
                      ),

                      Align(
                        alignment:const Alignment(0.8, 0),
                        child: InkWell(
                          child: Image.asset("assets/icons/icon_user.png",scale: 0.5,
                            color: AppColors.closeIconColor,
                            height: 20.6,
                            width: 20.42,),),
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment:const Alignment(-0.82, 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TransporterDashboardScreen()));
                          },
                          child: const Text(
                            "Home",
                            style:TextStyle(
                                color: AppColors.gradientBlueColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontFamily: "WorkSans",
                                fontStyle: FontStyle.normal
                            ),
                          ),),
                      ),
                      Align(
                        alignment:const Alignment(-0.36, 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AllTripRequest()));
                          },
                          child: const Text(
                            "Booking Status",
                            style:TextStyle(
                                color: AppColors.closeIconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontFamily: "WorkSans",
                                fontStyle: FontStyle.normal
                            ),
                          ),),
                      ),
                      Align(
                        alignment: const Alignment(0.32, 0),
                        child: InkWell(
                          onTap: (){
                          },
                          child: const Text(
                            "On Board",
                            textAlign: TextAlign.center,
                            style:TextStyle(
                                color: AppColors.closeIconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontFamily: "WorkSans",
                                fontStyle: FontStyle.normal
                            ),
                          ),),
                      ),

                      Align(
                        alignment:const Alignment(0.88, 0),
                        child: InkWell(
                          child: const Text(
                            "Profile",
                            textAlign: TextAlign.center,
                            style:TextStyle(
                                color: AppColors.closeIconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                fontFamily: "WorkSans",
                                fontStyle: FontStyle.normal
                            ),
                          ),),
                      )
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const TransporterHomePage();
        });
      } else if (drawerIndex == DrawerIndex.addDriver) {
        setState(() {
          screenView = AddDriverDetails();
        });
      }else if (drawerIndex == DrawerIndex.driverDetails) {
        setState(() {
          screenView = DriverDetailsScreen();
        });
      } else if (drawerIndex == DrawerIndex.vehicleDetails) {
        setState(() {
          screenView = VehicleDetailsScreen();
        });
      }else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
