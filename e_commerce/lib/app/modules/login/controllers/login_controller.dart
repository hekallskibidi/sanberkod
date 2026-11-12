import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = true.obs;

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _passwordDigitRegex = RegExp(r'[0-9]');

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Alamat email wajib diisi';
    if (!_emailRegex.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Kata sandi wajib diisi';
    if (password.length < 6) return 'Kata sandi minimal 6 karakter';
    if (!_passwordDigitRegex.hasMatch(password)) {
      return 'Kata sandi harus mengandung minimal 1 angka (0-9)';
    }
    return null;
  }

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  void setRememberMe(bool? value) => rememberMe.value = value ?? false;

  Future<void> login() async {
    if (isLoading.value) return;

    // Fail closed: jika Form belum terhubung, jangan izinkan navigasi.
    final form = formKey.currentState;
    if (form == null) {
      Get.snackbar(
        'Form belum siap',
        'Form Login belum terhubung. Muat ulang halaman dan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Jalankan validator agar pesan kesalahan muncul di bawah setiap field.
    final formIsValid = form.validate();

    // Validasi defensif dari nilai controller. Ini juga mencegah login
    // jika tombol terpicu tetapi TextFormField tidak tersambung dengan benar.
    final emailIsValid = validateEmail(emailController.text) == null;
    final passwordIsValid = validatePassword(passwordController.text) == null;

    if (!formIsValid || !emailIsValid || !passwordIsValid) {
      Get.snackbar(
        'Login ditolak',
        'Periksa email dan kata sandi. Keduanya wajib diisi dengan format yang benar.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Simulasi proses lokal; belum memverifikasi akun melalui backend.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (isClosed) return;

      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Simulasi Login Berhasil',
        'Format email dan kata sandi valid. Autentikasi server belum tersedia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
