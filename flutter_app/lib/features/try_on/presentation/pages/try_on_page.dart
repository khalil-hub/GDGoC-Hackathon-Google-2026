import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_async_state_view.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../catalog/application/catalog_providers.dart';

class TryOnPage extends ConsumerStatefulWidget {
  const TryOnPage({super.key});

  @override
  ConsumerState<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends ConsumerState<TryOnPage> {
  String activeTab = 'colors';
  String selectedColor = 'Teal';
  bool isFavorite = false;
  int selectedVariant = 0;

  void _showVariantsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                12,
                (index) => ListTile(
                  leading: const Icon(Icons.checkroom_outlined),
                  title: Text('Outfit Option ${index + 1}'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => selectedVariant = index % 3);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRouter.tryOn),
      body: SafeArea(
        child: AppAsyncStateView(
          value: productsAsync,
          onRetry: () => ref.invalidate(productsProvider),
          data: (products) {
            final variants = products.take(3).toList();
            final product = variants.isEmpty ? null : variants[selectedVariant];
            if (product == null) {
              return const EmptyStateView(
                title: 'Try-On item not found',
                description: 'Mock data is empty or unavailable.',
              );
            }

            return ListView(
              children: [
                Stack(
                  children: [
                    AppNetworkImage(
                      imageUrl: product.image,
                      height: 390,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.chevron_left_rounded),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Share sheet integration pending',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share_rounded),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 64,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'AI-POWERED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Perfect Fit Verified',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: FloatingActionButton.small(
                        onPressed: () =>
                            setState(() => isFavorite = !isFavorite),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'EXPLORE PET STYLES',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _showVariantsBottomSheet,
                            child: const Text('12 Options'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: variants.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final outfit = variants[index];
                            final isSelected = index == selectedVariant;
                            return InkWell(
                              onTap: () =>
                                  setState(() => selectedVariant = index),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AppNetworkImage(
                                    imageUrl: outfit.image,
                                    width: 92,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF99F6E4)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'PetFit AI Analysis',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '98% Match',
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Size Recommendation: M (Perfect Fit!)',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'colors', label: Text('Colors')),
                          ButtonSegment(
                            value: 'details',
                            label: Text('Details'),
                          ),
                        ],
                        selected: {activeTab},
                        onSelectionChanged: (value) =>
                            setState(() => activeTab = value.first),
                      ),
                      const SizedBox(height: 12),
                      if (activeTab == 'colors')
                        ...['Teal', 'Cream', 'Gray'].map(
                          (color) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: {
                                'Teal': const Color(0xFF14B8A6),
                                'Cream': const Color(0xFFFFF3C4),
                                'Gray': const Color(0xFF9CA3AF),
                              }[color],
                            ),
                            title: Text(color),
                            subtitle: const Text('In Stock'),
                            trailing: selectedColor == color
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                : null,
                            onTap: () => setState(() => selectedColor = color),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Product Details',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(product.description ?? 'No details'),
                            const SizedBox(height: 10),
                            const Text('Material: 100% Premium Cotton Fleece'),
                            const SizedBox(height: 6),
                            const Text(
                              'Care: Machine wash cold, tumble dry low',
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: const [
                                Chip(label: Text('XS')),
                                Chip(label: Text('S')),
                                Chip(label: Text('M')),
                                Chip(label: Text('L')),
                                Chip(label: Text('XL')),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.sizeOf(context).width - 32,
        child: FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart • \$42.00')),
            );
          },
          icon: const Icon(Icons.shopping_bag_outlined),
          label: const Text('Add to Cart • \$42.00'),
        ),
      ),
    );
  }
}
