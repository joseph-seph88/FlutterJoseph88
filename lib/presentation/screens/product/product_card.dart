import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/domain/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () => context.push('/detail/${product.id}'),
        borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
                child: Image.network(
                  product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AppStyles.defaultSpacing),
              // 상품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.text,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    Text(
                      '${product.location} • ${product.category}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    Text(
                      '${product.price.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          )}원',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.viewCount}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppStyles.smallSpacing),
                        Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.likeCount}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
