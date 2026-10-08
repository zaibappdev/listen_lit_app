import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../auth/login/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDeleteAccountDialog(BuildContext context, AuthViewModel authVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.kSamiDarkColor,
        title: Text('Delete Account', style: TextStyle(color: AppColor.kLightAccentColor)),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and will remove all your local data.',
          style: TextStyle(color: AppColor.kGreyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColor.kGreyColor)),
          ),
          TextButton(
            onPressed: () async {
              await authVM.deleteAccount();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: AppColor.kLightAccentColor)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Preferences', style: TextStyle(color: AppColor.kPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: AppColor.kLightAccentColor)),
            value: settingsVM.isDarkMode,
            activeThumbColor: AppColor.kPrimary,
            onChanged: (val) => settingsVM.setDarkMode(val),
          ),
          const SizedBox(height: 24),
          Text('Account', style: TextStyle(color: AppColor.kPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(Icons.logout, color: AppColor.kLightAccentColor),
            title: Text('Logout', style: TextStyle(color: AppColor.kLightAccentColor)),
            onTap: () async {
              await authVM.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () => _showDeleteAccountDialog(context, authVM),
          ),
          const SizedBox(height: 24),
          Text('About', style: TextStyle(color: AppColor.kPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            title: Text('App Version', style: TextStyle(color: AppColor.kLightAccentColor)),
            trailing: Text('1.0.0', style: TextStyle(color: AppColor.kGreyColor)),
          ),
        ],
      ),
    );
  }
}
