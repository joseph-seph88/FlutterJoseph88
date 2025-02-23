// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../../core/app_style.dart';
// import 'package:get/get.dart';
// import '../../data/schedule_event.dart';
// import '../controller/schedule_controller.dart';
//
// class TestView extends GetView<ScheduleController> {
//   const TestView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 40,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: controller.changeCalendarFormat,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text('일정 요약', style: AppStyle.blackMediumBody())),
//             Obx(() {
//               var upcomingEvents = controller.upcomingEvents;
//
//               if (controller.isSummary.value) {
//                 return Container(
//                   height: 200,
//                   child: ListView.builder(
//                       itemCount: upcomingEvents.length,
//                       itemBuilder: (context, index) {
//                         final event = upcomingEvents[index];
//                         return ListTile(
//                           leading: Container(
//                               width: 12,
//                               height: 12,
//                               decoration: BoxDecoration(
//                                   color: Colors.blue, shape: BoxShape.circle)),
//                           title: Text(
//                             event.title,
//                             style: AppStyle.blackTitle(),
//                           ),
//                           subtitle: Text(DateFormat('MM/dd HH:mm')
//                               .format(event.startTime)),
//                           onTap: () {
//                             // _showEventDetails(context, event);
//                           },
//                         );
//                       }),
//                 );
//               }
//               return Container();
//             }),
//             Container(
//                 height: 500,
//                 child: Obx(() {
//                   return TableCalendar(
//                     focusedDay: controller.focusedDay.value,
//                     firstDay: DateTime.utc(2020, 1, 1),
//                     lastDay: DateTime.utc(2030, 12, 31),
//                     calendarFormat: controller.calendarFormat.value,
//                     selectedDayPredicate: (day) {
//                       return isSameDay(controller.selectedDay.value, day);
//                     },
//                     eventLoader: controller.getEventsForDay,
//                     onDaySelected: (selectedDay, focusedDay) {
//                       controller.selectedDay.value = selectedDay;
//                       controller.focusedDay.value = focusedDay;
//                     },
//                     onFormatChanged: (format) {
//                       controller.calendarFormat.value = format;
//                     },
//                     onPageChanged: (focusedDay) {
//                       controller.focusedDay.value = focusedDay;
//                     },
//                     calendarStyle: CalendarStyle(
//                       todayDecoration: BoxDecoration(
//                         color: Colors.indigo.withOpacity(0.5),
//                         shape: BoxShape.circle,
//                       ),
//                       selectedDecoration: BoxDecoration(
//                         color: Colors.indigo,
//                         shape: BoxShape.circle,
//                       ),
//                       markerDecoration: BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   );
//                 })),
//             Divider(),
//             Container(
//               height: 200,
//               child: Obx(() {
//                 final dayEvents =
//                     controller.getEventsForDay(controller.selectedDay.value);
//
//                 return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         DateFormat('yyyy년 MM월 dd일')
//                             .format(controller.selectedDay.value),
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Expanded(
//                       child: dayEvents.isEmpty
//                           ? Center(child: Text('일정이 없습니다.'))
//                           : ListView.builder(
//                               itemCount: dayEvents.length,
//                               itemBuilder: (context, index) {
//                                 final event = dayEvents[index];
//                                 return Card(
//                                   margin: EdgeInsets.symmetric(
//                                     horizontal: 16.0,
//                                     vertical: 4.0,
//                                   ),
//                                   child: ListTile(
//                                     leading: Container(
//                                       width: 12,
//                                       height: 12,
//                                       decoration: BoxDecoration(
//                                         color: event.color,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     title: Text(event.title),
//                                     subtitle: Text(
//                                       '${DateFormat('HH:mm').format(event.startTime)} - '
//                                       '${DateFormat('HH:mm').format(event.endTime)}\n'
//                                       '${event.description}',
//                                     ),
//                                     trailing: IconButton(
//                                       icon: Icon(Icons.delete_outline),
//                                       onPressed: () {
//                                         controller.removeEvent(event.id);
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//                   ],
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           // _showAddEventDialog(context);
//           controller.isSummary.value = !controller.isSummary.value;
//           controller.event22();
//         },
//       ),
//     );
//   }
//
//   void _showAddEventDialog(BuildContext context) {
//     final titleController = TextEditingController();
//     final descController = TextEditingController();
//     final startDate = DateTime.now();
//     final endDate = startDate.add(Duration(hours: 1));
//
//     final startDateController = Rx<DateTime>(startDate);
//     final endDateController = Rx<DateTime>(endDate);
//     final selectedColor = Rx<Color>(Colors.blue);
//
//     Get.dialog(
//       Dialog(
//         child: Container(
//           width: 500,
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('새 일정 추가',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(height: 16),
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: '제목',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: descController,
//                 decoration: InputDecoration(
//                   labelText: '설명',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Obx(() => ListTile(
//                           title: Text('시작 시간'),
//                           subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
//                               .format(startDateController.value)),
//                           onTap: () async {
//                             final date = await showDatePicker(
//                               context: context,
//                               initialDate: startDateController.value,
//                               firstDate: DateTime(2020),
//                               lastDate: DateTime(2030),
//                             );
//
//                             if (date != null) {
//                               final time = await showTimePicker(
//                                 context: context,
//                                 initialTime: TimeOfDay.fromDateTime(
//                                     startDateController.value),
//                               );
//
//                               if (time != null) {
//                                 startDateController.value = DateTime(
//                                   date.year,
//                                   date.month,
//                                   date.day,
//                                   time.hour,
//                                   time.minute,
//                                 );
//                               }
//                             }
//                           },
//                         )),
//                   ),
//                   Expanded(
//                     child: Obx(() => ListTile(
//                           title: Text('종료 시간'),
//                           subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
//                               .format(endDateController.value)),
//                           onTap: () async {
//                             final date = await showDatePicker(
//                               context: context,
//                               initialDate: endDateController.value,
//                               firstDate: DateTime(2020),
//                               lastDate: DateTime(2030),
//                             );
//
//                             if (date != null) {
//                               final time = await showTimePicker(
//                                 context: context,
//                                 initialTime: TimeOfDay.fromDateTime(
//                                     endDateController.value),
//                               );
//
//                               if (time != null) {
//                                 endDateController.value = DateTime(
//                                   date.year,
//                                   date.month,
//                                   date.day,
//                                   time.hour,
//                                   time.minute,
//                                 );
//                               }
//                             }
//                           },
//                         )),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Text('색상: '),
//                     SizedBox(width: 8),
//                     ...Colors.primaries.take(8).map((color) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                           child: Obx(() => GestureDetector(
//                                 onTap: () {
//                                   selectedColor.value = color;
//                                 },
//                                 child: CircleAvatar(
//                                   radius: 12,
//                                   backgroundColor: color,
//                                   child: selectedColor.value == color
//                                       ? Icon(Icons.check,
//                                           size: 16, color: Colors.white)
//                                       : null,
//                                 ),
//                               )),
//                         )),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Get.back(),
//                     child: Text('취소'),
//                   ),
//                   SizedBox(width: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (titleController.text.isEmpty) {
//                         Get.snackbar('오류', '제목을 입력해주세요.');
//                         return;
//                       }
//
//                       if (endDateController.value
//                           .isBefore(startDateController.value)) {
//                         Get.snackbar('오류', '종료 시간은 시작 시간 이후여야 합니다.');
//                         return;
//                       }
//
//                       final newEvent = ScheduleEvent(
//                         id: DateTime.now().millisecondsSinceEpoch.toString(),
//                         title: titleController.text,
//                         description: descController.text,
//                         startTime: startDateController.value,
//                         endTime: endDateController.value,
//                         color: selectedColor.value,
//                       );
//
//                       controller.addEvent(newEvent);
//                       Get.back();
//                     },
//                     child: Text('저장'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showEventDetails(BuildContext context, ScheduleEvent event) {
//     Get.dialog(
//       Dialog(
//         child: Container(
//           width: 400,
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 16,
//                     height: 16,
//                     decoration: BoxDecoration(
//                       color: event.color,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       event.title,
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(),
//               SizedBox(height: 8),
//               Text(
//                 '시간:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 '${DateFormat('yyyy년 MM월 dd일 HH:mm').format(event.startTime)} - '
//                 '${DateFormat('HH:mm').format(event.endTime)}',
//               ),
//               SizedBox(height: 16),
//               Text(
//                 '설명:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 4),
//               Text(event.description.isEmpty ? '(없음)' : event.description),
//               SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       controller.removeEvent(event.id);
//                       Get.back();
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.red,
//                     ),
//                     child: Text('삭제'),
//                   ),
//                   SizedBox(width: 16),
//                   ElevatedButton(
//                     onPressed: () => Get.back(),
//                     child: Text('닫기'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:web_project/core/utils/app_constant.dart';
// import 'package:web_project/core/widget_style.dart';
// import 'package:web_project/presentation/controller/schedule_controller.dart';
// import '../../core/app_style.dart';
//
// class NewScheduleView extends GetView<ScheduleController> {
//   const NewScheduleView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Text('Mark2 SCHEDULER', style: AppStyle.blackTitle()),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.calendar_today),
//               onPressed: controller.changeCalendarFormat),
//         ],
//       ),
//       body: RefreshIndicator(
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                         child: TextButton(
//                             onPressed: controller.onOffSummary,
//                             child: Text('My Schedule Summary',
//                                 style: AppStyle.greySmallBody()))),
//                   ],
//                 )),
//             Obx(() => controller.isSummary.value
//                 ? SliverToBoxAdapter(
//               child: SizedBox(
//                 height: 350,
//                 child: PageView.builder(
//                   controller: PageController(viewportFraction: 0.9),
//                   itemCount: (9 / 3).ceil(),
//                   itemBuilder: (context, pageIndex) {
//                     int startIndex = pageIndex * 3;
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       child: Container(
//                         padding: const EdgeInsets.all(12.0),
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: AssetImage(
//                                     AppConstant.coffeeBack402),
//                                 fit: BoxFit.cover
//                             )),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Text('TODO',
//                                 //     style: AppStyle.blackMediumBody()),
//                                 Icon(Icons.more_horiz),
//                               ],
//                             ),
//                             // Divider(),
//                             Expanded(
//                               child: ListView.builder(
//                                 physics: BouncingScrollPhysics(),
//                                 padding:
//                                 EdgeInsets.symmetric(vertical: 8),
//                                 itemCount: min(3, 9 - startIndex),
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     decoration: WidgetStyle()
//                                         .customBoxDecoration(),
//                                     child: ListTile(
//                                       contentPadding:
//                                       EdgeInsets.symmetric(
//                                           horizontal: 12),
//                                       title: Text('항목',
//                                           style:
//                                           AppStyle.blackMediumBody()),
//                                       subtitle: Text('항목에 대한 간단한 설명입니다',
//                                           style:
//                                           AppStyle.greySmallBody()),
//                                       trailing: Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 16,
//                                         color: Colors.black,
//                                       ),
//                                       // shape: RoundedRectangleBorder(
//                                       //     borderRadius:
//                                       //         BorderRadius.circular(8)),
//                                       onTap: () {},
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             )
//                 : SliverToBoxAdapter()),
//             SliverToBoxAdapter(
//               child: Obx(() {
//                 return TableCalendar(
//                   focusedDay: controller.focusedDay.value,
//                   firstDay: DateTime.utc(2025, 1, 1),
//                   lastDay: DateTime.utc(2025, 12, 31),
//                   calendarFormat: controller.calendarFormat.value,
//                   selectedDayPredicate: (day) {
//                     return isSameDay(controller.selectedDay.value, day);
//                   },
//                   // eventLoader: controller.getEventsForDay,
//                   // onDaySelected: (selectedDay, focusedDay) {
//                   //   controller.selectedDay.value = selectedDay;
//                   //   controller.focusedDay.value = focusedDay;
//                   // },
//                   // onFormatChanged: (format) {
//                   //   controller.calendarFormat.value = format;
//                   // },
//                   // onPageChanged: (focusedDay) {
//                   //   controller.focusedDay.value = focusedDay;
//                   // },
//                   // calendarStyle: CalendarStyle(
//                   //   todayDecoration: BoxDecoration(
//                   //     color: Colors.indigo.withOpacity(0.5),
//                   //     shape: BoxShape.circle,
//                   //   ),
//                   //   selectedDecoration: BoxDecoration(
//                   //     color: Colors.indigo,
//                   //     shape: BoxShape.circle,
//                   //   ),
//                   //   markerDecoration: BoxDecoration(
//                   //     color: Colors.red,
//                   //     shape: BoxShape.circle,
//                   //   ),
//                   // ),
//                 );
//               }),
//             )
//           ],
//         ),
//         onRefresh: () async {},
//       ),
//     );
//   }
//
//   Widget trendingSection() {
//     return SizedBox(
//       height: 200,
//       width: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             child: Container(
//               width: 180,
//               margin: EdgeInsets.only(right: 16),
//               decoration: WidgetStyle().whiteShadowBoxDecoration(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ClipRRect(
//                   //     borderRadius: BorderRadius.only(
//                   //         topLeft: Radius.circular(12),
//                   //         topRight: Radius.circular(12)),
//                   //     child: AspectRatio(
//                   //       aspectRatio: 1,
//                   //       child:
//                   //       Image.asset(trendImage![index], fit: BoxFit.cover),
//                   //     )),
//                   Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('trendBrand![index]',
//                             style: AppStyle.greyVerySmallBody()),
//                         SizedBox(height: 4),
//                         Text('trendTitle![index]',
//                             style: AppStyle.blackSmallBody(),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis)
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // SliverToBoxAdapter(
// //   child: Container(
// //     height: 200,
// //     margin: EdgeInsets.symmetric(vertical: 16),
// //     child: PageView(
// //       children: [
// //         _buildBannerItem(
// //           AppConstant.banner_003,
// //           '2025 WINTER COLLECTION',
// //           'The best styles',
// //         ),
// //         _buildBannerItem(
// //           AppConstant.banner_004,
// //           'WE ARE STYLE',
// //           'Find the best model',
// //         ),
// //         _buildBannerItem(
// //           AppConstant.banner_001,
// //           'NEW SEASON COLLECTION',
// //           'Discover the latest styles',
// //         ),
// //         _buildBannerItem(
// //           AppConstant.banner_002,
// //           'SUMMER SALE',
// //           'Up to 50% off',
// //         ),
// //       ],
// //     ),
// //   ),
// // ),
// // SliverToBoxAdapter(
// //   child: Padding(
// //     padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
// //     child: Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text('TRENDING NOW', style: AppStyle.blackMediumTitle()),
// //         TextButton(
// //           onPressed: () {
// //             controller.isTrendingSection.value =
// //                 !controller.isTrendingSection.value;
// //           },
// //           child: Text('See All', style: AppStyle.greySmallBody()),
// //         ),
// //       ],
// //     ),
// //   ),
// // ),
//
// // SliverToBoxAdapter(
// //   child: Padding(
// //     padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
// //     child: Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text('NEW ARRIVALS', style: AppStyle.blackMediumTitle()),
// //         TextButton(
// //           onPressed: () {
// //             controller.isNewProductSection.value =
// //                 !controller.isNewProductSection.value;
// //           },
// //           child: Text('See All', style: AppStyle.greySmallBody()),
// //         ),
// //       ],
// //     ),
// //   ),
// // ),
// // Obx(() => controller.isNewProductSection.value
// //     ? SliverGrid(
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: controller.crossAxisCount.value,
// //           childAspectRatio: 0.65,
// //           mainAxisSpacing: 16,
// //           crossAxisSpacing: 16,
// //         ),
// //         delegate: SliverChildBuilderDelegate((context, index) {
// //           final productMap = controller.productList;
// //           if (productMap.isEmpty) {
// //             return Container();
// //           }
// //           return _buildProductCard(productMap, index);
// //         }, childCount: controller.productList['image']?.length),
// //       )
// //     : SliverToBoxAdapter()),
// //
// //   Widget _buildBannerItem(String image, String title, String subtitle) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16),
// //       decoration: WidgetStyle().imageBackBoxDecoration(image),
// //       child: Container(
// //         decoration: WidgetStyle().bannerBoxDecoration(),
// //         padding: EdgeInsets.all(24),
// //         alignment: Alignment.bottomLeft,
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(title, style: AppStyle.whiteMediumTitle()),
// //             SizedBox(height: 8),
// //             Text(subtitle, style: AppStyle.whiteSubTitle()),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //                 onPressed: () {},
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.white,
// //                   foregroundColor: Colors.black,
// //                   textStyle: TextStyle(fontWeight: FontWeight.bold),
// //                   minimumSize: Size(120, 40),
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(20)),
// //                 ),
// //                 child: Text('SHOP NOW')),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
//
// //
// //   Widget _buildProductCard(Map<String, List<String>> productMap, int index) {
// //     return GestureDetector(
// //       onTap: () {
// //         Get.lazyPut(() => ProductDetailViewController());
// //         Get.to(WebDetailView(index: index));
// //       },
// //       child: Container(
// //         margin: EdgeInsets.symmetric(horizontal: 8),
// //         decoration: WidgetStyle().whiteShadowBoxDecoration(),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Expanded(
// //               child: ClipRRect(
// //                 borderRadius: BorderRadius.only(
// //                     topLeft: Radius.circular(12),
// //                     topRight: Radius.circular(12)),
// //                 child: AspectRatio(
// //                   aspectRatio: 0.85,
// //                   child: Stack(
// //                     fit: StackFit.expand,
// //                     children: [
// //                       Image.asset(productMap['image']![index],
// //                           fit: BoxFit.cover),
// //                       Positioned(
// //                         top: 8,
// //                         right: 8,
// //                         child: Container(
// //                           padding:
// //                               EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                           decoration: WidgetStyle().blackBasicBoxDecoration(),
// //                           child:
// //                               Text('NEW', style: AppStyle.whiteVerySmallBody()),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsets.all(12),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(productMap['brand']![index],
// //                       style: AppStyle.greySmallBody()),
// //                   SizedBox(height: 4),
// //                   Text(productMap['title']![index],
// //                       style: AppStyle.blackSmallBody(),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis),
// //                   SizedBox(height: 6),
// //                   Text(productMap['price']![index],
// //                       style: AppStyle.blackSmallBody()),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
