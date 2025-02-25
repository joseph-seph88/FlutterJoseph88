import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:web_project/core/theme/widget_style.dart';
import 'package:web_project/presentation/controller/schedule_controller.dart';
import '../../core/theme/app_style.dart';
import '../../data/model/schedule.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_show_dialog.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Mark2 Scheduler', style: AppStyle.blackTitle()),
        actions: [
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: controller.changeCalendarFormat),
        ],
      ),
      body: RefreshIndicator(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextButton(
                        onPressed: controller.onOffSummary,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 28),
                              Obx(() => controller.isProgress.value
                                  ? Text('진행중 목록',
                                      style: AppStyle.greyMediumBody())
                                  : Text('완료 목록',
                                      style: AppStyle.greyMediumBody())),
                              SizedBox(width: 202),
                              IconButton(
                                  onPressed: () => controller.onOffProgress(),
                                  icon: Icon(Icons.format_list_bulleted,
                                      size: 24, color: Colors.grey))
                            ]))),
              ],
            )),
            Obx(() => controller.isSummary.value
                ? controller.isProgress.value
                    ? _buildSummary(controller.progressSchedule)
                    : _buildSummary(controller.finishSchedule)
                : SliverToBoxAdapter()),
            SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(14, 30, 14, 8),
                    child: Divider())),
            SliverToBoxAdapter(
              child: Obx(() {
                return _buildTableCalendar();
              }),
            ),
            SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(14, 12, 14, 30),
                    child: Divider())),
            Obx(() => _buildSchedule(controller.scheduleToday)),
          ],
        ),
        onRefresh: () async {},
      ),
      bottomNavigationBar: CustomBottomBar(),
      floatingActionButton: CustomFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSummary(List<Schedule> dataList) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 315,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          itemCount: (dataList.length / 3).ceil(),
          itemBuilder: (context, pageIndex) {
            int startIndex = pageIndex * 3;
            int endIndex = startIndex + 3;

            List<Schedule> pageData = dataList.sublist(startIndex,
                endIndex > dataList.length ? dataList.length : endIndex);

            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: WidgetStyle().whiteShadowBoxDecoration(),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                      itemCount: pageData.length,
                      itemBuilder: (context, index) {
                        final data = pageData[index];
                        String formattedDate =
                            controller.transTimeFormat(data.makeTime);
                        final itemColors = [
                          Color(0xFFFFF8E7),
                          Color(0xFFF0F7FF),
                          Color(0xFFFFF0F0),
                        ];

                        return GestureDetector(
                          onLongPress: () {
                            if (controller.isProgress.value) {
                              CustomShowDialog().showDialog(
                                  context,
                                  '완료 목록으로 변경하시겠습니까?',
                                  () => controller.completeSchedule(data));
                            } else {
                              CustomShowDialog().showDialog(
                                  context,
                                  '진행중 목록으로 변경하시겠습니까?',
                                  () => controller.restoreSchedule(data));
                            }
                          },
                          child: SizedBox(
                            height: 100,
                            child: Card(
                              elevation: 5,
                              color: itemColors[index],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.content,
                                        overflow: TextOverflow.visible,
                                        style:
                                            AppStyle.blueGraySmallMediumBody(),
                                      ),
                                    ),
                                    Text(formattedDate,
                                        style: AppStyle.greySmallBody()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      focusedDay: controller.focusedDay.value,
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      calendarFormat: controller.calendarFormat.value,
      eventLoader: (value) => controller.getEventLoader(value),
      onDaySelected: (selectedDay, focusedDay) {
        controller.selectedDay.value = selectedDay;
        controller.focusedDay.value = focusedDay;
        controller.getSelectSchedule();
      },
      selectedDayPredicate: (day) =>
          isSameDay(controller.selectedDay.value, day),
      availableCalendarFormats: {
        CalendarFormat.month: '주간 보기',
        CalendarFormat.twoWeeks: '월간 보기',
        CalendarFormat.week: '2주 보기',
      },
      onFormatChanged: (format) => controller.calendarFormat.value = format,
      onPageChanged: (focusedDay) {
        controller.focusedDay.value = focusedDay;
        controller.getMonthSchedule();
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
            color: Colors.teal.withAlpha(100), shape: BoxShape.circle),
        selectedDecoration:
            BoxDecoration(color: Colors.teal[400], shape: BoxShape.circle),
        markerDecoration:
            BoxDecoration(color: Colors.teal[200], shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildSchedule(List<Schedule> dataList) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 350,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          itemCount: (dataList.length / 3).ceil(),
          itemBuilder: (context, pageIndex) {
            int startIndex = pageIndex * 3;
            int endIndex = startIndex + 3;

            List<Schedule> pageData = dataList.sublist(startIndex,
                endIndex > dataList.length ? dataList.length : endIndex);

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemCount: pageData.length,
              itemBuilder: (context, index) {
                final data = pageData[index];
                final makeTime = controller.transTimeFormat(data.makeTime);

                return Card(
                  elevation: 5,
                  color: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(children: [
                    Obx(() {
                      final isProgress = controller.checkProgress(data);
                      return isProgress
                          ? Icon(Icons.check_box_outlined, color: Colors.grey)
                          : Icon(Icons.check_circle, color: Colors.green);
                    }),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.content,
                              overflow: TextOverflow.visible,
                              style: AppStyle.blueGraySmallMediumBody()),
                          Text(makeTime, style: AppStyle.greySmallBody()),
                        ],
                      ),
                    ),
                  ]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
