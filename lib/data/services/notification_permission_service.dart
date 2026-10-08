import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'storage_service.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

class NotificationPermissionService {
  static Future<void> requestIfNeeded() async {
    try {
      if ((await Permission.notification.status).isGranted ||
          StorageService.getNotificationPromptHandled()) {
        return;
      }
      await StorageService.setNotificationPromptHandled(true);
      final context = appNavigatorKey.currentContext;
      if (context == null) {
        await Permission.notification.request();
        return;
      }
      if (!context.mounted) return;
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Show playback controls'),
          content: const Text(
            'Listen Lit can show your current song and playback controls in the notification shade and on your lock screen. Music will still play if you decline.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Not now'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      if (shouldRequest == true) await Permission.notification.request();
    } catch (_) {
      // Notification access is optional; playback must continue if unavailable.
    }
  }
}
