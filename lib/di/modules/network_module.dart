import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase_options.dart';
import '../dependency_injection.dart';
import '../../constants/app_constants.dart';
import 'base_module.dart';

final class NetworkModule extends BaseModule {

  @override
  Future<void> register() async {
    // Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Firebase auth
    locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    // Google Sign-in Scopes
    locator.registerLazySingleton<GoogleSignIn>(() =>
      GoogleSignIn(),
      instanceName:AppConstants.googleNormalSignInScope
    );
    locator.registerLazySingleton<GoogleSignIn>(() =>
      GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/drive',
        ]
      ),
      instanceName: AppConstants.googleDriveSignInScope
    );
  }

}