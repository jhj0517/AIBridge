import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktoken/tiktoken.dart' as tiktokenizer;
import 'package:intl/intl.dart';

import '../../providers/providers.dart';
import '../../localdb/localdb.dart';
import '../../constants/constants.dart';
import '../main_navigation/main_navigation_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  late CharactersProvider charactersProvider;
  late KeyProvider keyProvider;
  ValueNotifier<String> loadingProgress = ValueNotifier("");

  @override
  void initState() {
    charactersProvider = context.read<CharactersProvider>();
    keyProvider = context.read<KeyProvider>();

    Future.delayed(const Duration(seconds: 1), () async {
      // just delay for showing this slash page
      await _initData();
      if(context.mounted){
        await charactersProvider.insertDefaultCharacters();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationPage()),
        );
      }
    });
    super.initState();
  }

  Future<void> _initData() async{
    loadingProgress.value = Intl.message("checkingAPIKeys");
    await keyProvider.initKeys();
    loadingProgress.value = Intl.message("InitializingTokenizer");
    _initTokenizer();
  }

  void _initTokenizer() async {
    final encoding = tiktokenizer.encodingForModel(ModelConstants.chatGPT3dot5Id);
    encoding.encode("Initialize tokenizer, 토크나이저 초기화, トークナイザーの初期化");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              PathConstants.appIconImage,
              width: 130, //screenWidth/4
              height: 130,
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: loadingProgress,
              builder: (context, value, child) {
                return Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
