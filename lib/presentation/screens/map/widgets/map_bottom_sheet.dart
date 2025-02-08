import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import '../../../providers/map_provider.dart';

class MapBottomSheet {
  void mapBottomSheetWithTwoBtn(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: AppStyles.defaultPadding,
              height: 220,
              width: double.infinity,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      ref.read(mapProvider.notifier).clearStateSearchData();
                      Navigator.of(context).pop();
                      context.push('/map/recommendShop');
                    },
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.grey[200]),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.green),
                        SizedBox(width: 20),
                        Text('업체 후기')
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(mapProvider.notifier).clearStateSearchData();
                      Navigator.of(context).pop();
                      context.push('/map/addShop');
                    },
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.grey[200]),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.orange),
                        SizedBox(width: 20),
                        Text('업체 등록')
                      ],
                    ),
                  ),
                ],
              ));
        });
  }
}
