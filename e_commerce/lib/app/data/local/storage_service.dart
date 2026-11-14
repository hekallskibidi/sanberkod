import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service terpusat untuk preferensi sederhana dan inisialisasi Hive CE.
/// Didaftarkan sekali saat bootstrap aplikasi dan hidup selama aplikasi berjalan.
class StorageService extends GetxService {
  static const String _themeKey = 'is_dark_mode';

  late SharedPreferences _prefs;
  final RxBool _isDarkMode = false.obs;
  bool _isChangingTheme = false;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  /// Membaca preferensi tema dan menyiapkan Hive CE sebelum UI dirender.
  Future<StorageService> init({bool initHive = true}) async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;

    if (initHive) {
      await Hive.initFlutter();
    }

    return this;
  }

  /// Mengubah tema, menyimpannya, lalu memberi feedback kepada pengguna.
  Future<void> toggleTheme() async {
    // Mencegah dua tap cepat menulis preferensi secara bersamaan.
    if (_isChangingTheme) return;
    _isChangingTheme = true;

    final nextIsDark = !_isDarkMode.value;

    try {
      final saved = await _prefs.setBool(_themeKey, nextIsDark);
      if (!saved) {
        Get.snackbar(
          'Tema Tidak Tersimpan',
          'Pengaturan tema gagal disimpan. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
          borderRadius: 12,
        );
        return;
      }

      _isDarkMode.value = nextIsDark;
      Get.changeThemeMode(themeMode);
      _showThemeFeedback(isDarkMode: nextIsDark);
    } finally {
      _isChangingTheme = false;
    }
  }

  void _showThemeFeedback({required bool isDarkMode}) {
    final isDark = isDarkMode;

    Get.snackbar(
      isDark ? 'Mode Gelap Diaktifkan' : 'Mode Terang Diaktifkan',
      isDark
          ? 'Tampilan hemat daya dan nyaman untuk mata telah aktif.'
          : 'Tampilan cerah bersemangat telah aktif.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFF4F46E5),
      colorText: Colors.white,
      icon: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: isDark ? const Color(0xFFF59E0B) : Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      borderRadius: 12,
    );
  }
}
