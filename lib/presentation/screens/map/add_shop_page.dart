import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddShopPage extends ConsumerWidget {
  AddShopPage({super.key});

  final _searchController = TextEditingController();
  final _searchController2 = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            const Text("새로 등록할 업체의 위치를 선택해 주세요"),
            Container(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "주변 건물 이름, 주소",
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                      child: NaverMap(
                    options: NaverMapViewOptions(
                        initialCameraPosition: NCameraPosition(
                            target: NLatLng(37.499889, 126.920056), zoom: 15)),
                  )),
                  Positioned(
                    right: 20,
                    bottom: 80,
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.my_location),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController2,
                    decoration: InputDecoration(
                      hintText: "(선택) 상세 주소 입력",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300]),
                        child: const Text("선택", style: TextStyle(color: Colors.white),)),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
