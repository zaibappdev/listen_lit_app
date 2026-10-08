import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/storage_service.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => PlayerViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Listen Lit App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsVM.themeMode,
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
