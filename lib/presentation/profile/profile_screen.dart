import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/utils/app_constant.dart';
import 'package:personal_select_chat/core/app/router/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          key: Key('profileScrollView'),
          child: Column(
            children: [
              _buildProfile(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('내 정보'),
                    SizedBox(height: 16),
                    _buildInfoItem(Icons.location_on, '위치', '서울특별시 강남구'),
                    _buildInfoItem(Icons.work, '직업', '소프트웨어 개발자'),
                    _buildInfoItem(Icons.school, '학력', '서울대학교'),
                    _buildInfoItem(Icons.height, '키', '175cm'),
                    _buildInfoItem(Icons.smoking_rooms, '흡연', '비흡연'),
                    _buildInfoItem(Icons.local_bar, '음주', '가끔'),
                    SizedBox(height: 24),
                    _buildSectionTitle('내 관심사'),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInterestChip('여행'),
                        _buildInterestChip('음악'),
                        _buildInterestChip('영화'),
                        _buildInterestChip('요리'),
                        _buildInterestChip('독서'),
                        _buildInterestChip('헬스'),
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildSectionTitle('자기소개'),
                    SizedBox(height: 16),
                    _buildSelf(),
                    SizedBox(height: 24),
                    _buildSectionTitle('나의 활동'),
                    SizedBox(height: 16),
                    _buildActivityItem(
                        Icons.favorite, '받은 좋아요', '128', Colors.red),
                    _buildActivityItem(
                        Icons.message, '진행중인 대화', '5', Colors.blue),
                    _buildActivityItem(
                        Icons.remove_red_eye, '프로필 조회수', '342', Colors.purple),
                    SizedBox(height: 40),
                    _buildLogout(context),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      color: Colors.pink.withAlpha(20),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage(AppImage.batman)),
                Positioned(
                  right: 130,
                  bottom: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.pink, shape: BoxShape.circle),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.camera_alt,
                          color: Colors.white, size: 20)),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text('김프릭, 28', style: AppStyle.generalLargeBody()),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: Text('활동중', style: AppStyle.generalWhiteSmallLabel()),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit),
            label: Text('프로필 편집', style: AppStyle.purpleSmallBoldBody()),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink, size: 20),
          SizedBox(width: 16),
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.pink[50],
      labelStyle: TextStyle(
        color: Colors.pink,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSelf() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Text(
        '안녕하세요! 저는 소프트웨어 개발자로 일하고 있는 김하트입니다. 취미로 여행과 음악 감상을 즐기고 있어요. 같이 대화하면서 서로에 대해 알아갈 수 있는 인연을 찾고 있습니다. 잘 부탁드려요! 😊',
        style: TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildActivityItem(
      IconData icon, String label, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Center(
      child: TextButton.icon(
        key: Key('logoutButton'),
        onPressed: () {
          context.go(AppRouter.login);
        },
        icon: Icon(Icons.logout, color: Colors.grey, size: 18),
        label: Text('로그아웃', style: AppStyle.generalLargeSubBody()),
      ),
    );
  }
}
