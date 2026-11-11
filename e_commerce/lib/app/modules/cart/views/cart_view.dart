import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/routes/app_pages.dart';
import '../../../data/models/cart_item_model.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            'Keranjang (${controller.totalItemCount})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Obx(
            () => controller.items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Kosongkan Keranjang',
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: AppColors.error,
                    ),
                    onPressed: () => _confirmClearCart(context),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 76,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan sneakers dari katalog untuk mulai berbelanja.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () => Get.offNamed(Routes.HOME),
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Jelajahi Produk'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _CartItemTile(
            item: controller.items[index],
            controller: controller,
            isDark: isDark,
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.items.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 60 : 15),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryRow(
                  label: 'Subtotal',
                  value: controller.formattedSubtotal,
                  isDark: isDark,
                ),
                const SizedBox(height: 7),
                _SummaryRow(
                  label: 'PPN (${CartController.taxRatePercent}%)',
                  value: controller.formattedTax,
                  isDark: isDark,
                ),
                const SizedBox(height: 7),
                _SummaryRow(
                  label: 'Ongkos Kirim',
                  value: controller.formattedShippingFee,
                  isDark: isDark,
                ),
                const Divider(height: 22),
                _SummaryRow(
                  label: 'Total Pembayaran',
                  value: controller.formattedTotalAmount,
                  isDark: isDark,
                  emphasize: true,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payment_rounded),
                    label: const Text('Lanjut ke Pembayaran'),
                    onPressed: () => Get.toNamed(Routes.CHECKOUT),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kosongkan Keranjang?'),
        content: const Text('Semua item di keranjang akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              controller.clearCart();
              Navigator.pop(dialogContext);
            },
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.controller,
    required this.isDark,
  });

  final CartItemModel item;
  final CartController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 82,
              height: 82,
              color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Ukuran ${item.selectedSize}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.product.formattedPrice,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Subtotal: ${item.formattedSubtotal}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              IconButton(
                tooltip: 'Hapus item',
                visualDensity: VisualDensity.compact,
                onPressed: () => controller.removeItem(item.id),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => controller.decreaseQuantity(item.id),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.remove_rounded, size: 15),
                      ),
                    ),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.increaseQuantity(item.id),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.add_rounded, size: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.emphasize = false,
  });
  final String label;
  final String value;
  final bool isDark;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 14 : 12,
            fontWeight: emphasize ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasize ? 17 : 13,
            fontWeight: FontWeight.w800,
            color: emphasize ? AppColors.primary : color,
          ),
        ),
      ],
    );
  }
}
