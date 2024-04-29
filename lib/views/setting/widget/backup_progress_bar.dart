import 'package:aibridge/providers/g_drive_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class BackUpProgressBar extends StatelessWidget {

  const BackUpProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GDriveProvider>(
      builder: (context, gDriveProvider, child) {
        final GDriveStatus status = gDriveProvider.status;

        Widget content;

        switch (status){
          case GDriveStatus.initialized:
          case GDriveStatus.isOnTask:
            content = const CircularProgressIndicator(color: Colors.purple);
          case GDriveStatus.downloadComplete:
            Future.delayed(const Duration(milliseconds: 1000), () {
              Phoenix.rebirth(context);
            });
            content = const Icon(Icons.check, color: Colors.green, size: 60);
          default:
            return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(child: content),
        );
      },
    );
  }

}