import 'package:dio/dio.dart' as dio;

/// Safe, user-readable representation of a network or response failure.
class NetworkFailure implements Exception {
  final int code;
  final String message;

  const NetworkFailure({required this.code, required this.message});

  @override
  String toString() => message;
}

/// Converts low-level Dio and parsing exceptions into [NetworkFailure].
class ErrorHandler {
  ErrorHandler._();

  static NetworkFailure handle(Object error) {
    if (error is NetworkFailure) return error;

    if (error is dio.DioException) {
      return _handleDioError(error);
    }

    if (error is FormatException) {
      return const NetworkFailure(
        code: -7,
        message: 'Format data dari server tidak sesuai. Silakan coba lagi.',
      );
    }

    return const NetworkFailure(
      code: -8,
      message: 'Terjadi kesalahan yang tidak diketahui. Silakan coba lagi.',
    );
  }

  static NetworkFailure _handleDioError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
      case dio.DioExceptionType.transformTimeout:
        return const NetworkFailure(
          code: -1,
          message:
              'Waktu koneksi habis (timeout). Periksa koneksi internet Anda.',
        );
      case dio.DioExceptionType.connectionError:
        return const NetworkFailure(
          code: -6,
          message:
              'Gagal terhubung ke server. Pastikan perangkat terhubung ke internet.',
        );
      case dio.DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? -2;
        return NetworkFailure(
          code: statusCode,
          message: _getFallbackMessage(statusCode),
        );
      case dio.DioExceptionType.cancel:
        return const NetworkFailure(
          code: -3,
          message: 'Permintaan dibatalkan.',
        );
      case dio.DioExceptionType.badCertificate:
        return const NetworkFailure(
          code: -4,
          message: 'Sertifikat keamanan server tidak dapat diverifikasi.',
        );
      case dio.DioExceptionType.unknown:
        return NetworkFailure(
          code: -8,
          message: error.message == null
              ? 'Gangguan koneksi. Silakan coba lagi.'
              : 'Gangguan koneksi: ${error.message}',
        );
      default:
        return NetworkFailure(
          code: -8,
          message: error.message == null
              ? 'Gangguan jaringan yang tidak dikenali. Silakan coba lagi.'
              : 'Gangguan jaringan: ${error.message}',
        );
    }
  }

  static String _getFallbackMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak dapat diproses (400).';
      case 401:
        return 'Akses tidak diizinkan (401).';
      case 403:
        return 'Anda tidak memiliki izin untuk mengakses data ini (403).';
      case 404:
        return 'Data yang diminta tidak ditemukan (404).';
      case 500:
        return 'Server sedang mengalami gangguan (500).';
      case 502:
      case 503:
      case 504:
        return 'Layanan server sedang tidak tersedia. Coba lagi nanti.';
      default:
        return 'Server mengembalikan respons tidak valid ($statusCode).';
    }
  }
}
