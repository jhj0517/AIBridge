import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../constants/constants.dart';
import '../pages/pages.dart';
import '../utils/utilities.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  late ThemeProvider themeProvider;
  late SocialAuthProvider authProvider;
  late GDriveProvider gDriveProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    authProvider = context.read<SocialAuthProvider>();
    gDriveProvider = context.read<GDriveProvider>();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                const SizedBox(height: 10),
                _buildProfileSection(),
                const SizedBox(height: 10),
                Divider(
                  height: 0.1,
                  thickness: 0.2,
                  color: Theme.of(context).dividerColor,
                ),
                _buildRow(Intl.message('signIn'), Icons.person, () async {
                  final social = await showDialog(
                    context: context,
                    builder: (context) => const SignInDialog()
                  );
                  await authProvider.handleSocialSignIn(social);
                }),
                _buildRow(Intl.message('backupData'), Icons.backup, () async {
                  await gDriveProvider.upload();
                }),
                _buildRow(Intl.message('loadData'), Icons.cloud_download_outlined, () async {
                  await gDriveProvider.download();
                }),
                _buildRow(themeProvider.attrs.toggleThemeName, themeProvider.attrs.toggleThemeIcon, (){
                  themeProvider.toggleTheme();
                }),
                _buildRow(Intl.message('chatRoomSetting'), Icons.settings, () async {
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatRoomSettingPage(),
                        )
                    );
                  }
                }),
                _buildRow(Intl.message('privacyPolicy'), Icons.lock, () async {
                  if(Intl.getCurrentLocale()=="ko"){
                    Utilities.launchURL(AppConstants.privacyPolicyKO);
                  } else {
                    Utilities.launchURL(AppConstants.privacyPolicyEN);
                  }
                }),
                _buildRow(Intl.message('usagePolicy'), Icons.gavel_sharp, (){
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
          Positioned(
            child: _buildProgressBar()
          )
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
    return Consumer<SocialAuthProvider>(
      builder: (context, authProvider, child) {
        final AuthStatus status = authProvider.status;
        final User? user = authProvider.currentUser;

        if (status == AuthStatus.authenticating){
          return const CircularProgressIndicator(
            color: Colors.purple,
          );
        }

        if (user == null){
          return const SizedBox.shrink();
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            ProfilePicture(
              width: 50,
              height: 50,
              photoURL: user.photoURL!,
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
                      user.displayName!,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.email!,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(String text, Object iconOrImagePath, VoidCallback onTap) {
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
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }

  Widget _buildProgressBar(){
    return Consumer<GDriveProvider>(
      builder: (context, gDriveProvider, child) {
        final GDriveStatus status = gDriveProvider.status;

        Widget content;

        switch (status){
          case GDriveStatus.initialized:
          case GDriveStatus.isOnTask:
            content = const CircularProgressIndicator(color: Colors.purple);
          case GDriveStatus.downloadComplete:
            Future.delayed(const Duration(milliseconds: 1000), () {
              Phoenix.rebirth(context);
            });
            content = const Icon(Icons.check, color: Colors.green, size: 60);
          default:
            return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(child: content),
        );
      },
    );
  }

}
