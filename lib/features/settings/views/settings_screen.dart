import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../auth/login/screens/login_screen.dart';
import '../../music/viewmodels/player_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showBackgroundPlaybackHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Allow background playback'),
        content: const Text(
          'Some Android devices restrict music when the screen is off. You can allow Listen Lit to run without battery optimization to help playback continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await Permission.ignoreBatteryOptimizations.request();
              } catch (_) {
                await openAppSettings();
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthViewModel authVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Delete Account',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and will remove all your local data.',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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

  void _showThemePicker(BuildContext context, SettingsViewModel settingsVM) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme Mode',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.phone_android,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'System',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: settingsVM.themeMode == ThemeMode.system
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                settingsVM.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.wb_sunny,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Light',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: settingsVM.themeMode == ThemeMode.light
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                settingsVM.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.nightlight_round,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Dark',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: settingsVM.themeMode == ThemeMode.dark
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                settingsVM.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: children),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final authVM = context.read<AuthViewModel>();
    final playerVM = context.read<PlayerViewModel>();
    final theme = Theme.of(context);

    String themeStr = 'System';
    if (settingsVM.themeMode == ThemeMode.light) {
      themeStr = 'Light';
    } else if (settingsVM.themeMode == ThemeMode.dark) {
      themeStr = 'Dark';
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionCard(context, 'Appearance', [
            ListTile(
              leading: Icon(Icons.palette, color: theme.colorScheme.onSurface),
              title: Text(
                'Theme Mode',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                themeStr,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onTap: () => _showThemePicker(context, settingsVM),
            ),
          ]),
          _buildSectionCard(context, 'Playback', [
            ListTile(
              leading: Icon(
                Icons.battery_saver,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                'Background playback',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                'Battery settings for uninterrupted playback',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              onTap: () => _showBackgroundPlaybackHelp(context),
            ),
            SwitchListTile(
              title: Text(
                'Autoplay Similar Songs',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                'Keep music playing when playlist ends',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              value: settingsVM.autoPlay,
              activeThumbColor: theme.colorScheme.primary,
              onChanged: (val) => settingsVM.setAutoPlay(val),
            ),
            SwitchListTile(
              title: Text(
                'High Quality Audio',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                'Stream at 320kbps highest fidelity',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              value: settingsVM.highQualityAudio,
              activeThumbColor: theme.colorScheme.primary,
              onChanged: (val) => settingsVM.setHighQualityAudio(val),
            ),
            ListTile(
              leading: Icon(
                Icons.volume_up,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                'Default Volume',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: settingsVM.volume.clamp(0.0, 1.0),
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) {
                        settingsVM.setVolume(val);
                        playerVM.setVolume(val);
                      },
                    ),
                  ),
                  Text(
                    '${(settingsVM.volume * 100).round()}%',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ]),
          _buildSectionCard(context, 'Library', [
            ListTile(
              leading: Icon(Icons.folder, color: theme.colorScheme.onSurface),
              title: Text(
                'Manage Device Folders',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                'Scan local storage for audio files',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onTap: () {},
            ),
          ]),
          _buildSectionCard(context, 'Storage', [
            ListTile(
              leading: Icon(Icons.storage, color: theme.colorScheme.onSurface),
              title: Text(
                'Clear Cache',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                'Cache size: ${settingsVM.cacheSize}',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              trailing: TextButton(
                onPressed: () => settingsVM.clearCache(),
                child: Text(
                  'Clear',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ]),
          _buildSectionCard(context, 'Account', [
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.onSurface),
              title: Text(
                'Logout',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
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
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _showDeleteAccountDialog(context, authVM),
            ),
          ]),
          _buildSectionCard(context, 'About', [
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                'App Version',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              trailing: Text(
                '1.0.0',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                'Terms of Service',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
