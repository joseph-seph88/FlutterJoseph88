import 'package:flutter/material.dart';
import 'package:o2/data/dummy/dummy_products.dart';
import 'package:o2/presentation/screens/product/product_card.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dummyProducts.length,
      itemBuilder: (context, index) {
        final product = dummyProducts[index];
        return ProductCard(product: product);
      },
    );
  }
}
