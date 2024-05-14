import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';
import 'views/views.dart';
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
            firebaseAuth: locator<FirebaseAuth>(),
            googleSignIn: locator<GoogleSignIn>(instanceName: AppConstants.googleNormalSignInScope),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            prefs: locator<SharedPreferences>()
          ),
        ),
        Provider<SQFliteHelper>(
          create: (context) => SQFliteHelper(
            prefs: locator<SharedPreferences>()
          ),
        ),
        ChangeNotifierProvider<GDriveProvider>(
          create: (context) => GDriveProvider(
            localDB: locator<SQFliteHelper>(),
            googleSignIn: locator<GoogleSignIn>(instanceName: AppConstants.googleDriveSignInScope)
          ),
        ),
        ChangeNotifierProvider<KeyProvider>(
          create: (context) => KeyProvider(
            keyRepository: locator<KeyRepository>()
          ),
        ),
        ChangeNotifierProvider<CharactersProvider>(
          create: (context) => CharactersProvider(
              charactersRepository: locator<CharactersRepository>()
          ),
        ),
        ChangeNotifierProvider<ChatRoomsProvider>(
          create: (context) => ChatRoomsProvider(
            chatRoomsRepository: locator<ChatRoomRepository>()
          ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            chatRepository: locator<ChatRepository>(),
            charactersProvider: context.read<CharactersProvider>(),
            chatRoomsProvider: context.read<ChatRoomsProvider>(),
            keyProvider: context.read<KeyProvider>(),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, child) {
          return MaterialApp(
            title: Intl.message("appTitle"),
            localizationsDelegates: const [
              S.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: themeProvider.attrs.themeData,
            home: const SplashPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      )
    );
  }
}
