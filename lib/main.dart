import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:audio_session/audio_session.dart' as audio_session;
import 'data/services/storage_service.dart';
import 'data/services/audio_service.dart' as playback;
import 'data/services/notification_permission_service.dart';
import 'core/constant/app_theme.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/auth/login/screens/login_screen.dart';
import 'features/music/viewmodels/player_viewmodel.dart';
import 'features/home/viewmodels/home_viewmodel.dart';
import 'features/profile/viewmodels/profile_viewmodel.dart';
import 'features/settings/viewmodels/settings_viewmodel.dart';
import 'features/on_boarding/screens/on_boarding_screen.dart';
import 'features/main_navigation/views/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await (await audio_session.AudioSession.instance).configure(
    const audio_session.AudioSessionConfiguration.music(),
  );
  final handler = await audio_service.AudioService.init(
    builder: playback.AudioService.new,
    config: const audio_service.AudioServiceConfig(
      androidNotificationChannelId: 'com.listenlit.app.audio',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/ic_stat_music',
    ),
  );
  await handler.configureAudioSession();
  runApp(MyApp(audioHandler: handler));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.audioHandler, super.key});

  final playback.AudioService audioHandler;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<playback.AudioService>.value(value: audioHandler),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (context) =>
              PlayerViewModel(context.read<playback.AudioService>()),
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, child) {
          return MaterialApp(
            navigatorKey: appNavigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Listen Lit App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsVM.themeMode,
            themeAnimationDuration: const Duration(milliseconds: 250),
            builder: (context, child) {
              final brightness = Theme.of(context).brightness;
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Theme.of(
                    context,
                  ).colorScheme.surface,
                  statusBarIconBrightness: brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
                  systemNavigationBarIconBrightness:
                      brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
                ),
              );
              return child ?? const SizedBox.shrink();
            },
            home: _getInitialScreen(),
          );
        },
      ),
    );
  }

  Widget _getInitialScreen() {
    final permissionHandled = StorageService.getPermissionHandled();
    final user = StorageService.getUser();
    if (!permissionHandled) {
      return const OnBoardingScreen();
    } else if (user == null) {
      return LoginScreen();
    } else {
      return const MainNavigationScreen();
    }
  }
}
