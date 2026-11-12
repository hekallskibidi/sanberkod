import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _digitRegex = RegExp(r'[0-9]');

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Nama lengkap wajib diisi';
    if (name.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Alamat email wajib diisi';
    if (!_emailRegex.hasMatch(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Kata sandi wajib diisi';
    if (password.length < 6) return 'Kata sandi minimal 6 karakter';
    if (!_digitRegex.hasMatch(password)) {
      return 'Kata sandi harus mengandung minimal 1 angka (0-9)';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final confirmation = value ?? '';
    if (confirmation.isEmpty) return 'Konfirmasi kata sandi wajib diisi';
    if (confirmation != passwordController.text) {
      return 'Konfirmasi kata sandi tidak sama';
    }
    return null;
  }

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  void _showMessage(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError
          ? const Color(0xFFEF4444)
          : const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  /// Kembali ke halaman Login yang sudah ada agar LoginController dan
  /// TextEditingController milik halaman itu tidak ikut di-dispose.
  /// Jika Register dibuka tanpa halaman Login sebelumnya, buat route Login.
  void navigateToLogin() {
    final navigator = Get.key.currentState;
    if (navigator == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    var loginRouteFound = false;
    navigator.popUntil((route) {
      if (route.settings.name == Routes.LOGIN) {
        loginRouteFound = true;
        return true;
      }
      return route.isFirst;
    });

    if (!loginRouteFound) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> register() async {
    if (isLoading.value) return;

    final form = formKey.currentState;
    if (form == null) {
      _showMessage(
        'Form belum siap',
        'Form Register belum terhubung. Tutup lalu buka kembali halaman ini.',
        isError: true,
      );
      return;
    }

    // Validasi FormState dan validasi defensif terhadap nilai controller.
    final formIsValid = form.validate();
    final allValuesAreValid =
        validateName(nameController.text) == null &&
        validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null &&
        validateConfirmPassword(confirmPasswordController.text) == null;

    if (!formIsValid || !allValuesAreValid) {
      _showMessage(
        'Pendaftaran belum berhasil',
        'Periksa kembali nama, email, kata sandi, dan konfirmasi kata sandi.',
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Simulasi lokal sesuai materi; belum ada request ke backend.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (isClosed) return;

      // Matikan loading sebelum halaman Register dilepas dari navigator.
      isLoading.value = false;
      navigateToLogin();
      _showMessage(
        'Pendaftaran berhasil',
        'Validasi berhasil. Silakan masuk menggunakan data yang baru diisi.',
      );
    } catch (error, stackTrace) {
      debugPrint('Register navigation error: $error\n$stackTrace');
      if (!isClosed) {
        isLoading.value = false;
        _showMessage(
          'Gagal membuka Login',
          'Pendaftaran valid, tetapi navigasi gagal. Gunakan tombol kembali.',
          isError: true,
        );
      }
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
