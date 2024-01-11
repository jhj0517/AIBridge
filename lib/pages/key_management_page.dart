import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class KeyManagementPage extends StatefulWidget {
  const KeyManagementPage({Key? key}) : super(key: key);

  @override
  State createState() => KeyManagementPageState();
}

class KeyManagementPageState extends State<KeyManagementPage> {

  late ThemeProvider themeProvider;
  late KeyProvider keyProvider;
  late TextEditingController _textFieldControllerKey;

  @override
  void initState() {
    super.initState();
    themeProvider = context.read<ThemeProvider>();
    keyProvider = context.read<KeyProvider>();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: themeProvider.attrs.backgroundColor,
      appBar: AppBar(
        title: Text(
          Intl.message("keyPageTitle"),
          style: const TextStyle(
            color: ColorConstants.appbarTextColor,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: themeProvider.attrs.appbarColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            _buildSelectableRow(Intl.message("chatGPTKey"), themeProvider.attrs.gptLogoPath, () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _apiKeyDialog(context, Intl.message("chatGPTKey"), ServiceType.openAI);
                  }
              );
            }),
            _buildSelectableRow(Intl.message("paLMKey"), PathConstants.paLMImage, () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _apiKeyDialog(context, Intl.message("paLMKey"), ServiceType.paLM);
                  }
              );
            })
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

  void _init(){
    _textFieldControllerKey = TextEditingController();
  }

  Widget _buildSelectableRow(String text, String imagePath, VoidCallback onTap) {
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
          color: themeProvider.attrs.dividerColor,
        ),
      ],
    );
  }

  Widget _apiKeyDialog(BuildContext context, String title, ServiceType serviceType){
    String storeKey;
    if (serviceType== ServiceType.openAI){
      storeKey = SecureStorageConstants.openAI;
      _textFieldControllerKey.text = keyProvider.openAPIKey == null ? "" : keyProvider.openAPIKey!;
    } else if (serviceType == ServiceType.paLM){
      storeKey = SecureStorageConstants.paLM;
      _textFieldControllerKey.text = keyProvider.paLMAPIKey == null ? "" : keyProvider.paLMAPIKey!;
    } else {
      throw(Exception("unfounded service"));
    }

    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: ColorConstants.themeColor,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              Intl.message("neverLeakAPIKey"),
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: _textFieldControllerKey,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),  // change border color here
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),  // and here
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),  // and here
                        ),
                        labelText: Intl.message("pasteAPIKey"),
                        labelStyle: const TextStyle(
                            color: Colors.white38,
                            fontSize: 15
                        )
                    ),
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                  ),
                ),
                Material(
                  color: ColorConstants.themeColor, // Match the background color
                  child: IconButton(
                    icon: const Icon(
                      Icons.content_paste,
                      color: Colors.white,
                    ),
                    splashColor: Colors.white.withOpacity(0.3), // Set the splash color here
                    onPressed: () async {
                      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
                      Fluttertoast.showToast(msg: Intl.message("textIsPasted"));
                      if (clipboardData != null) {
                        _textFieldControllerKey.text = clipboardData.text!;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.grey.withOpacity(0.2);
                      return Colors.transparent;
                    },
                  ),
                ),
                onPressed: () async {
                  keyProvider.saveKey(storeKey, _textFieldControllerKey.text);
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: title+Intl.message("isSaved"));
                },
                child: Text(
                  Intl.message("registerAPI"),
                  style: const TextStyle(
                    color: ColorConstants.themeColor,
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}
