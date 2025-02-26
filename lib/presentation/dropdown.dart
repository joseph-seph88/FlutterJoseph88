// Widget buildCitySelector() {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.2),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: InkWell(
//       onTap: () {
//         Get.bottomSheet(
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   '도시 선택',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Divider(),
//                 ...controller.cityList.map((String city) {
//                   return ListTile(
//                     title: Text(city),
//                     onTap: () async {
//                       // 바텀시트 닫기
//                       Get.back();
//                       // 도시 변경 및 데이터 업데이트
//                       controller.selectedCity.value = city;
//                       // await controller.changeData();
//
//                     },
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Row(
//           children: [
//             Obx(() => Text(
//               controller.selectedCity.value,
//               style: TextStyle(color: Colors.white),
//             )),
//             SizedBox(width: 4),
//             Icon(Icons.arrow_drop_down, color: Colors.white),
//           ],
//         ),
//       ),
//     ),
//   );
// }