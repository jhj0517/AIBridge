import 'package:aibridge/providers/auth_provider.dart';
import 'package:aibridge/providers/providers.dart';
import 'package:aibridge/widgets/character_creation_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../pages/pages.dart';
import '../utils/utilities.dart';
import '../localdb/localdb.dart';
import '../widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  late SQFliteHelper sqFliteHelper;
  late ThemeProvider themeProvider;
  late SocialAuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    sqFliteHelper = context.read<SQFliteHelper>();
    authProvider = context.read<SocialAuthProvider>();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: themeProvider.attrs.backgroundColor,
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
        backgroundColor: themeProvider.attrs.appbarColor,
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
                _buildMoreRow(Intl.message('signIn'), Icons.person, () async {
                  final social = await showDialog(
                    context: context,
                    builder: (context) => const SignInDialog()
                  );
                  await authProvider.handleSocialSignIn(social);
                }),
                _buildMoreRow(themeProvider.attrs.toggleThemeName, themeProvider.attrs.toggleThemeIcon, (){
                  themeProvider.toggleTheme();
                }),
                _buildMoreRow(Intl.message('chatRoomSetting'), Icons.settings, () async {
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatRoomSettingPage(),
                        )
                    );
                  }
                }),
                _buildMoreRow(Intl.message('privacyPolicy'), Icons.lock, () async {
                  if(Intl.getCurrentLocale()=="ko"){
                    Utilities.launchURL(AppConstants.privacyPolicyKO);
                  } else {
                    Utilities.launchURL(AppConstants.privacyPolicyEN);
                  }
                }),
                _buildMoreRow(Intl.message('usagePolicy'), Icons.gavel_sharp, (){
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UsagePolicyPage(),
                        )
                    );
                  }
                }),
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
        const ProfilePicture(
            width: 50,
            height: 50
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Column(
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
                    color: themeProvider.attrs.fontColor,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: themeProvider.attrs.fontColor
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 0.1,
          thickness: 0.2,
          color: themeProvider.attrs.dividerColor,
        ),
      ],
    );
  }

}
