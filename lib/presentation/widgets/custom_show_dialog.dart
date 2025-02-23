import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_project/core/app_style.dart';
import 'package:web_project/presentation/controller/schedule_controller.dart';
import 'package:web_project/presentation/widgets/custom_snack_bar.dart';

class CustomShowDialog {
  final controller = Get.put(ScheduleController());

  void showDialog(BuildContext context, String content,
      VoidCallback onConfirm) {
    Get.dialog(
      Dialog(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 15, 8, 15),
                child: Text(content, style: AppStyle.blueGreyMediumBody()),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Get.back();
                  },
                  child: Text('확인', style: AppStyle.blueGraySmallMediumBody()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAddEventDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('새 일정 추가',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                controller: controller.contentController,
                decoration: InputDecoration(
                  labelText: '입력..',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('취소'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.contentController.text.isEmpty) {
                        CustomSnackBar.customSnackBar(
                            context: context, message: '내용을 입력해주세요');
                        Get.back();
                      }else{
                        controller.addSchedule();
                        Get.back();
                      }
                    },
                    child: Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
