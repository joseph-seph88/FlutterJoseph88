import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LikeShopPage extends ConsumerWidget {
  const LikeShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("님이 추천하고 싶은 업체는 어디인가요?"),
            Container(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "업체명으로 검색",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            const Text("혹시 이 업체는 어떠세요?"),
            Container(
              padding: const EdgeInsets.all(12),
              height: 300,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text("업체명"),
                      subtitle: Text("주소"),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
