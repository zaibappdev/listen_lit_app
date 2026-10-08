import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../music/viewmodels/player_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final authVM = context.read<AuthViewModel>();
    final playerVM = context.read<PlayerViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile', style: TextStyle(color: AppColor.kLightAccentColor)),
        centerTitle: true,
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
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Music Lover',
                style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'user@listenlit.com',
                style: TextStyle(color: AppColor.kGreyColor, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Divider(color: AppColor.kGreyColor.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorite Songs',
                  style: TextStyle(color: AppColor.kLightAccentColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              profileVM.favorites.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('No favorite songs yet', style: TextStyle(color: AppColor.kGreyColor)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileVM.favorites.length,
                      itemBuilder: (context, index) {
                        final song = profileVM.favorites[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(song.coverUrl, width: 48, height: 48, fit: BoxFit.cover),
                          ),
                          title: Text(song.title, style: TextStyle(color: AppColor.kLightAccentColor)),
                          subtitle: Text(song.artist, style: TextStyle(color: AppColor.kGreyColor)),
                          onTap: () => playerVM.playSong(profileVM.favorites, index),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
