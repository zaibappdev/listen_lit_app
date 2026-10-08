import 'package:flutter/foundation.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/services/storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthViewModel() {
    _loadUser();
  }

  void _loadUser() {
    final data = StorageService.getUser();
    if (data != null) {
      _currentUser = UserModel.fromJson(Map<String, dynamic>.from(data));
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // simulate network
    _currentUser = UserModel(uid: '1', name: email.split('@')[0], email: email, avatarUrl: 'https://picsum.photos/seed/user_avatar/200/200');
    await StorageService.saveUser(_currentUser!.toJson());

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // simulate network
    _currentUser = UserModel(uid: '1', name: name, email: email, avatarUrl: 'https://picsum.photos/seed/user_avatar/200/200');
    await StorageService.saveUser(_currentUser!.toJson());

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> updateProfile(String name, String email, String avatarUrl) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      uid: _currentUser!.uid,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
    await StorageService.saveUser(_currentUser!.toJson());
    notifyListeners();
  }

  Future<void> logout() async {
    await StorageService.clearUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await StorageService.clearUser();
    _currentUser = null;
    notifyListeners();
  }
}
