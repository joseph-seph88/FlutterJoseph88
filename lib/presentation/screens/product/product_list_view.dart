import 'package:flutter/material.dart';
import 'package:o2/presentation/screens/product/product_card.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 10, // 임시 데이터 개수
      itemBuilder: (context, index) {
        return ProductCard(
          title: '오래함께 일하실 분 찾아요',
          location: '수택동',
          category: '알바',
          price: 220000,
          imageUrl: 'https://picsum.photos/200', // 임시 이미지
          viewCount: 124,
          likeCount: 167,
        );
      },
    );
  }
}
