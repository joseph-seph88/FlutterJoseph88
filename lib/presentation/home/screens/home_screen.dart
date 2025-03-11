import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/bloc/auth/auth_bloc.dart';
import 'package:personal_select_chat/bloc/auth/auth_event.dart';
import 'package:personal_select_chat/bloc/home/home_bloc.dart';
import 'package:personal_select_chat/bloc/home/home_event.dart';
import 'package:personal_select_chat/bloc/home/home_state.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/theme/widget_style.dart';
import 'package:personal_select_chat/core/utils/app_constant.dart';
import 'package:personal_select_chat/presentation/home/widgets/action_button.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  HomeScreen({super.key});

  void slidePage(int pageIndex) {
    if (pageIndex < 4) {
      _pageController.animateToPage(
        pageIndex + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Align(alignment: Alignment.center, child: Text('매력을 평가해주세요')),
          content: BlocSelector<HomeBloc, HomeState, int>(selector: (state) {
            if (state is HomeFormState) {
              return state.starIndex;
            }
            return 0;
          }, builder: (context, starIndex) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: IconButton(
                      onPressed: () {
                        context
                            .read<HomeBloc>()
                            .add(HomeFormEvent(starIndex: index + 1));
                        context.pop();
                      },
                      icon: Icon(
                        index < starIndex ? Icons.star : Icons.star_border,
                        color: Colors.pink[100],
                        size: 48,
                      ),
                    ),
                  );
                }));
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> userName = ['유진', '미소', '사라', '제인', '수잔'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset(AppImage.couple002,
            height: 48,
            errorBuilder: (context, error, stackTrace) => Text(
                'JOSEPH88: ${error.toString()} ${stackTrace.toString()}',
                style: AppStyle.imageErrorBody())),
        actions: [
          _buildAppBarIcon(Icons.notifications_outlined, context),
          SizedBox(width: 8),
          _buildAppBarIcon(Icons.settings_outlined, context),
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
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: 5,
                        onPageChanged: (page) {
                          context
                              .read<HomeBloc>()
                              .add(HomeFormEvent(pageIndex: page));
                        },
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildProfileCard(userName[index]);
                        }),
                  ),
                  _buildSwipeActions(context),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, BuildContext context) {
    return Container(
      decoration: WidgetStyle.generalGreyBtnDecoration(),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey.shade800),
        onPressed: () {
          context.read<AuthLogicBloc>().add(SignOutLogicEvent());
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<String> filterTypeList = [];
        int selectedIndex = 0;
        if (state is HomeFormState) {
          filterTypeList = state.filterType;
          selectedIndex = state.selectedIndex;
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: filterTypeList.length,
            itemBuilder: (context, index) {
              final filterType = filterTypeList[index];

              return GestureDetector(
                key: Key('chips_$index'),
                onTap: () {
                  context
                      .read<HomeBloc>()
                      .add(HomeFormEvent(selectedIndex: index));
                },
                child: Container(
                  key: Key('chipContainer_$index'),
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Color(0xFFFF4D67)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      filterType,
                      style: AppStyle.dynamicWhiteMediumLabel(
                          selectedIndex == index),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(String userName) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(AppImage.person200,
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
                      Text('$userName, 27',
                          style: AppStyle.generalWhiteLargeBody()),
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
                      _buildInterestTag(AppString.travel),
                      _buildInterestTag(AppString.music),
                      _buildInterestTag(AppString.movie),
                      _buildInterestTag(AppString.cook),
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

  Widget _buildSwipeActions(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocSelector<HomeBloc, HomeState, int>(selector: (state) {
            if (state is HomeFormState) {
              return state.pageIndex;
            }
            return 0;
          }, builder: (context, pageIndex) {
            return ActionButton(
              key: Key('closeButton'),
              iconData: Icons.close,
              iconColor: Colors.white,
              backgroundColor: Colors.red,
              onPressed: () => slidePage(pageIndex),
            );
          }),
          SizedBox(width: 16),
          ActionButton(
              key: Key('starButton'),
              iconData: Icons.star,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              onPressed: () => _showRatingDialog(context),
              size: 72),
          SizedBox(width: 16),
          BlocSelector<HomeBloc, HomeState, int>(selector: (state) {
            if (state is HomeFormState) {
              return state.pageIndex;
            }
            return 0;
          }, builder: (context, pageIndex) {
            return ActionButton(
              key: Key('favoriteButton'),
              iconData: Icons.favorite,
              iconColor: Colors.white,
              backgroundColor: Color(0xFFFF4D67),
              onPressed: () => slidePage(pageIndex),
            );
          })
        ],
      ),
    );
  }
}
