
import 'package:flutter/material.dart';

import '../../../../utils/StringConstants.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/shared_preff.dart';
import '../manage_address_screen.dart';
import '../user_current_location_screen.dart';

class NewAddressAppBar extends StatelessWidget with PreferredSizeWidget {
  final String latitude, longitude, strCartValue, strSavedValue, strItemCounts;
  final String strCountry, strState, strCity;
  const NewAddressAppBar({Key? key, required this.latitude, required this.longitude, required this.strCartValue, required this.strSavedValue, required this.strItemCounts, required this.strCountry, required this.strState, required this.strCity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      leading: IconButton(
        onPressed: ()async{
          String location = "FROM_LOCATIONS";
          if(location == "FROM_LOCATION"){
            Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context)=>UserCurrentLocationScreen(latitude: latitude, longitude: longitude, address: "", strCartValue: strCartValue, strSavedValue: strSavedValue, strItemCounts: strItemCounts,strCountry:strCountry, strState: strState, strCity: strCity)));
          }else{
            Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context)=> ManageAddressScreen(strCartValue: strCartValue, strSavedValue: strSavedValue, strItemCounts: strItemCounts, strCountry:strCountry, strState: strState, strCity: strCity)));
          }
        },
        icon: const Icon(Icons.arrow_back, color: AppColors.blackColor,),
        iconSize: 15,
      ),
      title: const Text(
        'Add New Address',
        style:   TextStyle(
            color: AppColors.blackColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            fontFamily: "WorkSans",
            fontStyle: FontStyle.normal),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
