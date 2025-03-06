import 'package:flutter/material.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/utils/app_constant.dart';
import 'package:personal_select_chat/data/models/match_model.dart';

class FavoriteScreen extends StatelessWidget {
  final _searchController = TextEditingController();
  final List<MatchModel> matches = [
    MatchModel(
      name: "수연",
      age: 26,
      occupation: "디자이너",
      distance: 3.2,
      imageUrl: AppImage.totoro,
      interests: ["여행", "음악", "요리"],
    ),
    MatchModel(
      name: "지은",
      age: 29,
      occupation: "마케터",
      distance: 5.7,
      imageUrl: AppImage.catBlack,
      interests: ["영화", "독서", "요가"],
    ),
    MatchModel(
      name: "은지",
      age: 24,
      occupation: "개발자",
      distance: 2.1,
      imageUrl: AppImage.batman,
      interests: ["기술", "여행", "음악"],
    ),
  ];

  FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: _buildSearchBar(context),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  return _buildMatchCard(matches[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
      child: TextField(
          controller: _searchController,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.pink),
              hintText: '관심있는 사람 찾기',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15))),
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(40),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              image: DecorationImage(
                  image: AssetImage(match.imageUrl), fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${match.name}, ${match.age}',
                          style: AppStyle.generalBody()),
                      Icon(Icons.favorite, color: Colors.pink, size: 20),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(match.occupation, style: AppStyle.generalSmallSubBody()),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.pink, size: 16),
                      Text('${match.distance}km 거리',
                          style: AppStyle.generalSmallSubBody()),
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    children: match.interests.map((interest) {
                      return Chip(
                        label: Text(interest, style: AppStyle.pinkSmallBody()),
                        backgroundColor: Colors.pink.withAlpha(20),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
