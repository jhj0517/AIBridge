import 'package:aibridge/views/common/appbars/normal_app_bar.dart';
import 'package:aibridge/views/setting/widget/backup_progress_bar.dart';
import 'package:aibridge/views/setting/widget/profile_section.dart';
import 'package:aibridge/views/setting/widget/setting_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../constants/constants.dart';
import '../views.dart';
import '../../utils/utilities.dart';
import '../../widgets/widgets.dart';
import '../../providers/providers.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: NormalAppBar(title: Intl.message('settingsPageTitle')),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                const ProfileSection(),
                const SizedBox(height: 10),
                Divider(
                  height: 0.1,
                  thickness: 0.2,
                  color: Theme.of(context).dividerColor,
                ),
                SettingRow(
                  label: Intl.message('signIn'),
                  icon: Icons.person,
                  onTap: () async {
                    final social = await showDialog(
                        context: context,
                        builder: (context) => const SignInDialog()
                    );
                    await authProvider.handleSocialSignIn(social);
                  }
                ),
                SettingRow(
                  label: Intl.message('backupData'),
                  icon: Icons.backup,
                  onTap: () async {
                    await gDriveProvider.upload();
                  }
                ),
                SettingRow(
                  label: Intl.message('loadData'),
                  icon: Icons.cloud_download_outlined,
                  onTap: () async {
                    await gDriveProvider.download();
                  }
                ),
                SettingRow(
                  label: themeProvider.attrs.toggleThemeName,
                  icon: themeProvider.attrs.toggleThemeIcon,
                  onTap: () async {
                    themeProvider.toggleTheme();
                  }
                ),
                SettingRow(
                  label: Intl.message('chatRoomSetting'),
                  icon: Icons.settings,
                  onTap: () async {
                    if (context.mounted) {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ChatRoomSettingPage(),
                          )
                      );
                    }
                  }
                ),
                SettingRow(
                  label: Intl.message('privacyPolicy'),
                  icon: Icons.lock,
                  onTap: () async {
                    if(Intl.getCurrentLocale()=="ko"){
                      Utilities.launchURL(AppConstants.privacyPolicyKO);
                    } else {
                      Utilities.launchURL(AppConstants.privacyPolicyEN);
                    }
                  }
                ),
                SettingRow(
                  label: Intl.message('usagePolicy'),
                  icon: Icons.gavel_sharp,
                  onTap: () async {
                    if(Intl.getCurrentLocale()=="ko"){
                      Utilities.launchURL(AppConstants.usagePolicyKO);
                    } else {
                      Utilities.launchURL(AppConstants.usagePolicyEN);
                    }
                  }
                ),
              ],
            ),
          ),
          const Positioned(
            child: BackUpProgressBar()
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

}
