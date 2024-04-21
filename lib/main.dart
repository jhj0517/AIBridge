import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'generated/l10n.dart';
import 'pages/pages.dart';
import 'constants/constants.dart';
import 'providers/providers.dart';
import 'repositories/repositories.dart';
import 'localdb/localdb.dart';

Future<SharedPreferences> _initSharedPreference() async {
  WidgetsFlutterBinding.ensureInitialized();
  return await SharedPreferences.getInstance();
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> _initDotEnv() async{
  await dotenv.load(fileName: ".env");
}

void main() async {
  await _initDotEnv();
  final SharedPreferences prefs = await _initSharedPreference();
  await _initFirebase();

  runApp(
      Phoenix(
          child: MyApp(
            prefs: prefs,
          )
      )
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({
    super.key,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocialAuthProvider>(
          create: (context) => SocialAuthProvider(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn()
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            prefs: prefs
          ),
        ),
        Provider<SQFliteHelper>(
          create: (context) => SQFliteHelper(
            prefs: prefs
          ),
        ),
        ChangeNotifierProvider<GDriveProvider>(
          create: (context) => GDriveProvider(
            localDB: context.read<SQFliteHelper>(),
            googleSignIn:  GoogleSignIn(
              scopes: [
                'email',
                'https://www.googleapis.com/auth/drive',
              ]
            )
          ),
        ),
        ChangeNotifierProvider<KeyProvider>(
          create: (context) => KeyProvider(
            keyRepository: KeyRepository(
                secureStorage: const FlutterSecureStorage()
            ),
          ),
        ),
        ChangeNotifierProvider<CharactersProvider>(
          create: (context) => CharactersProvider(
              charactersRepository: CharactersRepository(
                  sqfliteHelper: context.read<SQFliteHelper>()
              )
          ),
        ),
        ChangeNotifierProvider<ChatRoomsProvider>(
          create: (context) => ChatRoomsProvider(
            chatRoomsRepository: ChatRoomRepository(
                prefs: prefs,
                sqfliteHelper: context.read<SQFliteHelper>()
            ),
          ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            chatRepository: ChatRepository(
              sqfliteHelper: context.read<SQFliteHelper>(),
              prefs: prefs,
            ),
            charactersProvider: context.read<CharactersProvider>(),
            chatRoomsProvider: context.read<ChatRoomsProvider>(),
            keyProvider: context.read<KeyProvider>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: Intl.message("appTitle"),
        localizationsDelegates: const [
          S.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          primaryColor: ColorConstants.themeColor,
          primarySwatch: MaterialColor(0xff000000, ColorConstants.swatchColor),
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: ColorConstants.textSelectionHandlerColor, // Change the color of the selection handle
            selectionColor: ColorConstants.textSelectionColor,
          ),
        ),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      )
    );
  }
}
