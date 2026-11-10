import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = controller.product;
    final sizes = controller.availableSizes;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Detail Produk'),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Favorit',
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.isFavorite.value ? AppColors.error : null,
              ),
              onPressed: controller.toggleFavorite,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  product['image'] as String? ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product['category'] as String? ?? 'Sneakers',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product['rating'] ?? 4.8} / 5.0 (120+ ulasan)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              product['title'] as String? ?? 'Sneakers Premium',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['price'] as String? ?? 'Rp 0',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Pilih Ukuran (EU)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sizes.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final size = sizes[index];

                  return Obx(() {
                    final isSelected = controller.selectedSize.value == size;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.selectSize(size),
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkSurfaceCard
                                    : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$size',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Deskripsi Produk',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sepatu sneakers edisi terbatas dengan material kulit sintetis '
              'premium berkualitas tinggi. Dirancang khusus untuk memberikan '
              'kenyamanan maksimal sepanjang hari dengan sol antiselip dan '
              'sirkulasi udara yang optimal.',
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah Pembelian',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Kurangi jumlah',
                        icon: const Icon(Icons.remove_rounded, size: 18),
                        onPressed: controller.decrementQuantity,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Obx(
                          () => Text(
                            '${controller.quantity.value}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tambah jumlah',
                        icon: const Icon(Icons.add_rounded, size: 18),
                        onPressed: controller.incrementQuantity,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 50 : 20),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: controller.addToCart,
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: const Text('Tambah ke Keranjang'),
            ),
          ),
        ),
      ),
    );
  }
}
