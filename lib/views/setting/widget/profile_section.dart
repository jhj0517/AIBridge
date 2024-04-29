import 'package:aibridge/providers/auth_provider.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatelessWidget {

  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
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

}