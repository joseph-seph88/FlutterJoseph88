import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';

final bottomSheetProvider = Provider((ref) => CustomBottomSheets());

class CustomBottomSheets {
  void bottomSheetWithTwoBtn(BuildContext context) {
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
                      Navigator.of(context).pop();
                      context.push('/map/likeShop');
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
