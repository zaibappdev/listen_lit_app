import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../music/viewmodels/player_viewmodel.dart';
import '../../../../shared/widgets/network_image_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, AuthViewModel authVM) {
    final user = authVM.currentUser;
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final avatarController = TextEditingController(text: user?.avatarUrl ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.kSamiDarkColor,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: AppColor.kLightAccentColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: AppColor.kLightAccentColor),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppColor.kGreyColor),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                style: TextStyle(color: AppColor.kLightAccentColor),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppColor.kGreyColor),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: avatarController,
                style: TextStyle(color: AppColor.kLightAccentColor),
                decoration: InputDecoration(
                  labelText: 'Avatar Image URL',
                  labelStyle: TextStyle(color: AppColor.kGreyColor),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColor.kGreyColor)),
          ),
          TextButton(
            onPressed: () async {
              await authVM.updateProfile(
                nameController.text.trim(),
                emailController.text.trim(),
                avatarController.text.trim(),
              );
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: AppColor.kPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final playerVM = context.read<PlayerViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColor.kLightAccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColor.kPrimary),
            onPressed: () => _showEditProfileDialog(context, authVM),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColor.kPrimary,
                child: user?.avatarUrl.isNotEmpty == true
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: NetworkImageWidget(
                          url: user!.avatarUrl,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : Text(
                        user?.name.isNotEmpty == true
                            ? user!.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Music Lover',
                style: TextStyle(
                  color: AppColor.kLightAccentColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'user@listenlit.com',
                style: TextStyle(color: AppColor.kGreyColor, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Divider(color: AppColor.kGreyColor.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              // Favorite Songs
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorite Songs (${profileVM.favorites.length})',
                  style: TextStyle(
                    color: AppColor.kLightAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              profileVM.favorites.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No favorite songs yet',
                        style: TextStyle(color: AppColor.kGreyColor),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileVM.favorites.length,
                      itemBuilder: (context, index) {
                        final song = profileVM.favorites[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: NetworkImageWidget(
                            url: song.coverUrl,
                            width: 48,
                            height: 48,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            song.title,
                            style: TextStyle(color: AppColor.kLightAccentColor),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: TextStyle(color: AppColor.kGreyColor),
                          ),
                          onTap: () =>
                              playerVM.playSong(profileVM.favorites, index),
                        );
                      },
                    ),
              const SizedBox(height: 24),
              // Recently Played
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recently Played (${profileVM.recentlyPlayed.length})',
                  style: TextStyle(
                    color: AppColor.kLightAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              profileVM.recentlyPlayed.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No recently played tracks',
                        style: TextStyle(color: AppColor.kGreyColor),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileVM.recentlyPlayed.length,
                      itemBuilder: (context, index) {
                        final song = profileVM.recentlyPlayed[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: NetworkImageWidget(
                            url: song.coverUrl,
                            width: 48,
                            height: 48,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            song.title,
                            style: TextStyle(color: AppColor.kLightAccentColor),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: TextStyle(color: AppColor.kGreyColor),
                          ),
                          onTap: () => playerVM.playSong(
                            profileVM.recentlyPlayed,
                            index,
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
