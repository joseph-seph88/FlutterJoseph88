import 'package:flutter/material.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/theme/widget_style.dart';
import 'package:personal_select_chat/core/utils/app_constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset(AppConstant.couple002,
            height: 48,
            errorBuilder: (context, error, stackTrace) =>
                Text('JOSEPH88', style: AppStyle.imageErrorBody())),
        actions: [
          _buildAppBarIcon(Icons.notifications_outlined),
          SizedBox(width: 8),
          _buildAppBarIcon(Icons.settings_outlined),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('발견하기', style: AppStyle.generalLargeBody())),
                  _buildFilterChips(),
                  SizedBox(height: 20),
                  Expanded(
                    child: PageView(
                      children: List.generate(5, (index) {
                        return _buildProfileCard();
                      }),
                    ),
                  ),
                  _buildSwipeActions(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon) {
    return Container(
      decoration: WidgetStyle.generalGreyBtnDecoration(),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey.shade800),
        onPressed: () {},
      ),
    );
  }

  Widget _buildFilterChips() {
    //BlocBuilder 추가 예정
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip('모두', isSelected: true),
          _buildFilterChip('인기'),
          _buildFilterChip('근처'),
          _buildFilterChip('최근 활동'),
          _buildFilterChip('새로운 사람'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF4D67) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(label, style: AppStyle.dynamicWhiteMediumLabel(isSelected)),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(AppConstant.person200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: Icon(Icons.image,
                          size: 100, color: Colors.grey.shade600)))),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(180),
                  ],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
          ),
          // Profile info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('유진, 27', style: AppStyle.generalWhiteLargeBody()),
                      SizedBox(width: 8),
                      Icon(Icons.verified, color: Colors.blue, size: 24),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Text('서울에서 3km', style: AppStyle.generalWhite70SubBody()),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInterestTag(AppConstant.travel),
                      _buildInterestTag(AppConstant.music),
                      _buildInterestTag(AppConstant.movie),
                      _buildInterestTag(AppConstant.cook),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: WidgetStyle.generalWhiteLabelDecoration(),
      child: Text(label, style: AppStyle.generalWhiteSmallLabel()),
    );
  }

  Widget _buildSwipeActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            Icons.close,
            Colors.white,
            Colors.red,
            () {},
          ),
          SizedBox(width: 16),
          _buildActionButton(
            Icons.star,
            Colors.white,
            Colors.blue,
            () {},
            size: 72,
          ),
          SizedBox(width: 16),
          _buildActionButton(
            Icons.favorite,
            Colors.white,
            Color(0xFFFF4D67),
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    Color iconColor,
    Color backgroundColor,
    VoidCallback onPressed, {
    double size = 56,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: backgroundColor.withAlpha(80),
              blurRadius: 12,
              offset: Offset(0, 4)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: size * 0.5),
        onPressed: onPressed,
      ),
    );
  }
}
