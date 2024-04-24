import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/dialogs.dart';

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
    themeProvider = context.watch<ThemeProvider>();
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
            _buildSelectableRow(
                Intl.message("chatGPTKey"),
                themeProvider.attrs.gptLogoPath,
                () => _openKeyDialog(Intl.message("chatGPTKey"), ServiceType.openAI)
            ),
            _buildSelectableRow(
              Intl.message("paLMKey"),
              PathConstants.paLMImage,
              () => _openKeyDialog(Intl.message("paLMKey"), ServiceType.paLM)
            )
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

  Widget _buildSelectableRow(String text, String imagePath, Future<void> Function() onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
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
          thickness: 0.3,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }

  Future<void> _openKeyDialog(String title, ServiceType serviceType) async {
    _setTextByService(serviceType);
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
          _storageKeyByService(serviceType),
          _textFieldControllerKey.text
        );

        Fluttertoast.showToast(msg: title + Intl.message("isSaved"));
    }
  }

  void _setTextByService(ServiceType serviceType){
    switch (serviceType){
      case ServiceType.openAI:
        _textFieldControllerKey.text = keyProvider.openAPIKey != null ? keyProvider.openAPIKey! : "";
        break;
      case ServiceType.paLM:
        _textFieldControllerKey.text = keyProvider.paLMAPIKey != null ? keyProvider.paLMAPIKey! : "";
        break;
    }
  }

  String _storageKeyByService(ServiceType serviceType){
    switch (serviceType) {
      case ServiceType.openAI:
        return SecureStorageConstants.openAI;
      case ServiceType.paLM:
        return SecureStorageConstants.paLM;
    }
  }

}
