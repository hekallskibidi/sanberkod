import 'package:flutter/material.dart';
import 'package:e_commerce/app/core/theme/app_colors.dart';

/// Komponen kartu produk pada katalog beranda.
class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final double rating;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
    this.onAddToCart,
    this.onToggleFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    ),
                  ),

                  // Badge kategori produk.
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(160),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Tombol favorit. Statusnya dikirim dari HomeView melalui Obx.
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: isDark
                          ? Colors.black.withAlpha(160)
                          : Colors.white.withAlpha(225),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onToggleFavorite,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: isFavorite
                                ? Colors.redAccent
                                : (isDark ? Colors.white70 : Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            price,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: onAddToCart,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
