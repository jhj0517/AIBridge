import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../common/dialogs/base/base_dialog.dart';
import '../common/dialogs/export/text_paster.dart';
import 'widget/key_row.dart';

class KeyManagementPage extends StatefulWidget {
  const KeyManagementPage({Key? key}) : super(key: key);

  @override
  State createState() => KeyManagementPageState();
}

class KeyManagementPageState extends State<KeyManagementPage> {

  late ThemeProvider themeProvider;
  late KeyProvider keyProvider;
  final TextEditingController _textFieldControllerKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    keyProvider = context.read<KeyProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          Intl.message("keyPageTitle"),
          style: const TextStyle(
            color: ColorConstants.appbarTextColor,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            KeyRow(
              title: Intl.message("chatGPTKey"),
              imagePath: themeProvider.attrs.gptLogoPath,
              onTap: () async {
                await _openKeyDialog(Intl.message("chatGPTKey"), AIPlatformType.openAI);
              }
            ),
            KeyRow(
                title: Intl.message("paLMKey"),
                imagePath: PathConstants.paLMImage,
                onTap: () async {
                  await _openKeyDialog(Intl.message("paLMKey"), AIPlatformType.paLM);
                }
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldControllerKey.dispose();
    super.dispose();
  }

  Future<void> _openKeyDialog(String title, AIPlatformType platform) async {
    _setTextByService(platform);
    final dialogResult = await showDialog(
      context: context,
      builder: (context) => TextPaster(
        title: title,
        subTitle: Intl.message("neverLeakAPIKey"),
        labelText: Intl.message("pasteAPIKey"),
        buttonText: Intl.message("registerAPI"),
        textFieldController: _textFieldControllerKey,
        isPassword: true,
      ),
    );

    switch(dialogResult){
      case DialogResult.yes:
        await keyProvider.saveKey(
          platform,
          _textFieldControllerKey.text
        );

        Fluttertoast.showToast(msg: title + Intl.message("isSaved"));
    }
  }

  void _setTextByService(AIPlatformType platform){
    switch (platform){
      case AIPlatformType.openAI:
        _textFieldControllerKey.text = keyProvider.openAPIKey ?? "";
        break;
      case AIPlatformType.paLM:
        _textFieldControllerKey.text = keyProvider.paLMAPIKey ?? "";
        break;
    }
  }

}
