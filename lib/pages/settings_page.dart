import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../pages/pages.dart';
import '../utils/utilities.dart';
import '../localdb/localdb.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  late SQFliteHelper sqFliteHelper;

  @override
  void initState() {
    super.initState();
    sqFliteHelper = context.read<SQFliteHelper>();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Intl.message('settingsPageTitle'),
              style: const  TextStyle(
                color: ColorConstants.appbarTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: ColorConstants.appbarBackgroundColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildMoreRow(Intl.message('chatRoomSetting'), Icons.settings, () async {
                  //onTab chatRoomSetting
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatRoomSettingPage(),
                        )
                    );
                  }
                }
                ),
                _buildMoreRow(Intl.message('privacyPolicy'), Icons.lock, () async {
                  //onTab Privacy Policy
                  if(Intl.getCurrentLocale()=="ko"){
                    Utilities.launchURL(AppConstants.privacyPolicyKO);
                  } else {
                    Utilities.launchURL(AppConstants.privacyPolicyEN);
                  }
                }
                ),
                _buildMoreRow(Intl.message('usagePolicy'), Icons.gavel_sharp, (){
                  //onTab Usage Policy
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UsagePolicyPage(),
                        )
                    );
                  }
                }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    // Initialize something
  }

  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 30),
        Stack(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: ClipOval(
                child: Image.network(
                  "", // Replace with your image URL
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.themeColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return const Icon(
                      Icons.account_circle,
                      size: 50,
                      color: ColorConstants.greyColor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Guest", // Replace with the actual nickname
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "", // Replace with the actual email
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreRow(String text, Object iconOrImagePath, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                const SizedBox(width: 10),
                // Check if the object is IconData or String
                if (iconOrImagePath is IconData)
                  Icon(
                    iconOrImagePath,
                    size: 24,
                  )
                else if (iconOrImagePath is String)
                  Image.asset(
                    iconOrImagePath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: ColorConstants.dividerColor, // Very light grey color
        ),
      ],
    );
  }

}
