import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trailer_tracking/screens/User%20Module/About/feedback_screen.dart';
import 'package:trailer_tracking/screens/User%20Module/About/invite_friend_screen.dart';
import 'package:trailer_tracking/screens/User%20Module/address/manage_address_screen.dart';
import 'package:trailer_tracking/screens/User%20Module/trip_request/bided_trip_request.dart';
import 'package:trailer_tracking/utils/colors.dart';
import '../../../utils/app_theme.dart';
import '../models/tabIcon_data.dart';
import '../trip_request/booking_status.dart';
import '../user_drawer/drawer_user_controller.dart';
import '../user_drawer/home_drawer.dart';
import 'new_dashboard.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> with TickerProviderStateMixin{

  AnimationController? animationController;
  bool multiple = true;
  Widget? screenView;
  DrawerIndex? drawerIndex;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AppColors.background,
  );

  @override
  void initState() {
    screenView = UserImportExportDashboard();
    drawerIndex = DrawerIndex.HOME;
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = UserImportExportDashboard();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        body: DrawerUserController(
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
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UserHomeScreen()));
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
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> BidTripRequestScreen()));
                          },
                          child: Icon(Icons.book, color: AppColors.closeIconColor,),),
                      ),
                      Align(
                        alignment:const Alignment(0.25, 0),
                        child: InkWell(
                          onTap: (){
                          },
                          child: Image.asset("assets/icons/icon_refer.png",scale: 0.5,
                            color: AppColors.closeIconColor,
                            height: 20.6,
                            width: 20.42,),),
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
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UserHomeScreen()));
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
                        alignment:const Alignment(-0.32, 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> BidTripRequestScreen()));
                          },
                          child: const Text(
                            "Bid Status",
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
                            "Refer & Earn",
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
          screenView = const UserImportExportDashboard();
        });
      } else if (drawerIndex == DrawerIndex.Bookings) {
        setState(() {
          screenView = BookingStatusScreen();
        });
      }else if (drawerIndex == DrawerIndex.Address) {
        setState(() {
          screenView = ManageAddressScreen(strCartValue: "0", strSavedValue: "0", strItemCounts: "0", strCountry: "", strState: "", strCity: "");
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
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
