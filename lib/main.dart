import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';
import 'pages/pages.dart';
import 'constants/constants.dart';
import 'providers/providers.dart';
import 'repositories/repositories.dart';
import 'localdb/localdb.dart';
import 'di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.register();

  runApp(
      Phoenix(
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocialAuthProvider>(
          create: (context) => SocialAuthProvider(
            firebaseAuth: locator.get<FirebaseAuth>(),
            googleSignIn: locator.get<GoogleSignIn>(instanceName: AppConstants.googleNormalSignInScope),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            prefs: locator.get<SharedPreferences>()
          ),
        ),
        Provider<SQFliteHelper>(
          create: (context) => SQFliteHelper(
            prefs: locator.get<SharedPreferences>()
          ),
        ),
        ChangeNotifierProvider<GDriveProvider>(
          create: (context) => GDriveProvider(
            localDB: locator.get<SQFliteHelper>(),
            googleSignIn: locator.get<GoogleSignIn>(instanceName: AppConstants.googleDriveSignInScope)
          ),
        ),
        ChangeNotifierProvider<KeyProvider>(
          create: (context) => KeyProvider(
            keyRepository: locator.get<KeyRepository>()
          ),
        ),
        ChangeNotifierProvider<CharactersProvider>(
          create: (context) => CharactersProvider(
              charactersRepository: locator.get<CharactersRepository>()
          ),
        ),
        ChangeNotifierProvider<ChatRoomsProvider>(
          create: (context) => ChatRoomsProvider(
            chatRoomsRepository: locator.get<ChatRoomRepository>()
          ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            chatRepository: locator.get<ChatRepository>(),
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
