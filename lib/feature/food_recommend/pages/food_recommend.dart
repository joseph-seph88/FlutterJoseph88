import 'dart:math';
import 'package:flutter/material.dart';

class FoodRecommend extends StatefulWidget {
  const FoodRecommend({Key? key}) : super(key: key);

  @override
  State<FoodRecommend> createState() => _FoodGameScreenState();
}

class _FoodGameScreenState extends State<FoodRecommend>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<String> _foodOptions = [
    '한식',
    '중식',
    '일식',
    '양식',
    '분식',
    '패스트푸드',
    '베트남음식',
    '태국음식',
    '인도음식',
    '멕시코음식',
    '카페',
    '디저트',
    '치킨',
    '피자',
    '족발보쌈'
  ];

  // 주사위 관련 변수
  int _diceValue = 1;
  bool _isDiceRolling = false;
  String _selectedFood = '';

  // 사다리타기 관련 변수
  final List<String> _ladderOptions = [];
  final List<String> _ladderDestinations = [];
  final int _ladderCount = 4;
  List<List<bool>> _ladderPaths = [];
  List<List<bool>> _ladderSelectedPaths = [];
  List<int> _ladderResults = [];
  bool _isLadderAnimating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 초기 사다리타기 게임 설정
    _ladderOptions.addAll(['밥먹기', '면먹기', '고기먹기', '패스트푸드']);
    _ladderDestinations.addAll(['한식', '중식', '고깃집', '버거킹']);
    _initializeLadder();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // 사다리 게임 초기화
  void _initializeLadder() {
    final random = Random();
    _ladderPaths = List.generate(_ladderCount - 1,
        (row) => List.generate(_ladderCount, (col) => random.nextBool()));

    _ladderSelectedPaths = List.generate(
        _ladderCount - 1, (row) => List.generate(_ladderCount, (col) => false));

    _ladderResults = List.generate(_ladderCount, (i) => -1);
  }

  // 주사위 던지기
  void _rollDice() {
    if (_isDiceRolling) return;

    setState(() {
      _isDiceRolling = true;
      _selectedFood = '';
    });

    // 주사위 애니메이션 효과
    int rollCount = 0;
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        _diceValue = Random().nextInt(6) + 1;
      });
      rollCount++;
      return rollCount < 10;
    }).then((_) {
      // 최종 값 결정 및 음식 선택
      final index = Random().nextInt(_foodOptions.length);
      setState(() {
        _isDiceRolling = false;
        _selectedFood = _foodOptions[index];
      });
    });
  }

  // 사다리타기 시작
  void _startLadder(int startIndex) {
    if (_isLadderAnimating) return;

    setState(() {
      _isLadderAnimating = true;
      _ladderSelectedPaths = List.generate(_ladderCount - 1,
          (row) => List.generate(_ladderCount, (col) => false));
      _ladderResults = List.generate(_ladderCount, (i) => -1);
    });

    // 사다리 애니메이션 효과
    _animateLadder(startIndex, 0, true);
  }

  // 사다리 애니메이션
  void _animateLadder(int col, int row, bool isVertical) async {
    if (row >= _ladderPaths.length && isVertical) {
      // 최종 목적지 도달
      setState(() {
        _ladderResults[col] = col;
        _isLadderAnimating = false;
      });
      return;
    }

    await Future.delayed(Duration(milliseconds: 200));

    if (isVertical) {
      // 세로 이동
      setState(() {
        if (row > 0 && _ladderPaths[row - 1][col]) {
          // 왼쪽으로 이동하는 가로 사다리가 있는 경우
          _ladderSelectedPaths[row - 1][col] = true;
          _animateLadder(col, row, false);
        } else if (col < _ladderCount - 1 &&
            row < _ladderPaths.length &&
            _ladderPaths[row][col]) {
          // 오른쪽으로 이동하는 가로 사다리가 있는 경우
          _ladderSelectedPaths[row][col] = true;
          _animateLadder(col, row, false);
        } else {
          // 가로 사다리 없음, 아래로 계속 진행
          _animateLadder(col, row + 1, true);
        }
      });
    } else {
      // 가로 이동
      if (row > 0 && _ladderPaths[row - 1][col]) {
        // 왼쪽으로 이동
        _animateLadder(col - 1, row, true);
      } else if (col < _ladderCount - 1 && _ladderPaths[row][col]) {
        // 오른쪽으로 이동
        _animateLadder(col + 1, row, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 뭐 먹지?'),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '주사위 게임'),
            Tab(text: '사다리타기 게임'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiceGame(),
          _buildLadderGame(),
        ],
      ),
    );
  }

  // 주사위 게임 UI
  Widget _buildDiceGame() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepOrange[200]!, Colors.deepOrange[50]!],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            '오늘의 음식을 뽑아보세요!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange[800],
            ),
          ),
          const SizedBox(height: 40),

          // 주사위 이미지
          GestureDetector(
            onTap: _rollDice,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _isDiceRolling
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                      )
                    : Image.asset(
                        'assets/dice_$_diceValue.png',
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          // 이미지 로드 실패 시 대체 UI
                          return Text(
                            '$_diceValue',
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 결과 표시
          if (_selectedFood.isNotEmpty)
            Column(
              children: [
                Text(
                  '오늘의 음식은...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepOrange[700],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _selectedFood,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[800],
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 40),

          // 주사위 던지기 버튼
          ElevatedButton(
            onPressed: _rollDice,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _isDiceRolling ? '주사위 굴리는 중...' : '주사위 던지기',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 사다리타기 게임 UI
  Widget _buildLadderGame() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[200]!, Colors.blue[50]!],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '음식 종류를 골라보세요!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '상단의 항목을 선택하여 시작하세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 30),

          // 사다리 그리기
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 시작점 옵션
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_ladderCount, (index) {
                        return GestureDetector(
                          onTap: _isLadderAnimating
                              ? null
                              : () => _startLadder(index),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: _isLadderAnimating
                                    ? Colors.grey
                                    : Colors.blue,
                                child: Text(
                                  _ladderOptions[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 2,
                                height: 20,
                                color: Colors.blue[300],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  // 사다리 경로
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: LadderPainter(
                        ladderCount: _ladderCount,
                        paths: _ladderPaths,
                        selectedPaths: _ladderSelectedPaths,
                      ),
                    ),
                  ),

                  // 목적지 옵션
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_ladderCount, (index) {
                        final bool isSelected = _ladderResults.contains(index);
                        return Column(
                          children: [
                            Container(
                              width: 2,
                              height: 20,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(height: 5),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.blue[300],
                              child: Text(
                                _ladderDestinations[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 다시하기 버튼
          ElevatedButton(
            onPressed: _isLadderAnimating ? null : _initializeLadder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '사다리 다시 만들기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// 사다리 그리기 위한 커스텀 페인터
class LadderPainter extends CustomPainter {
  final int ladderCount;
  final List<List<bool>> paths;
  final List<List<bool>> selectedPaths;

  LadderPainter({
    required this.ladderCount,
    required this.paths,
    required this.selectedPaths,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final selectedPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final columnWidth = size.width / ladderCount;
    final rowHeight = size.height / (paths.length + 1);

    // 세로 선 그리기
    for (int i = 0; i < ladderCount; i++) {
      final x = columnWidth / 2 + i * columnWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // 가로 선 그리기
    for (int row = 0; row < paths.length; row++) {
      for (int col = 0; col < ladderCount - 1; col++) {
        if (paths[row][col]) {
          final y = rowHeight / 2 + row * rowHeight;
          final x1 = columnWidth / 2 + col * columnWidth;
          final x2 = columnWidth / 2 + (col + 1) * columnWidth;

          canvas.drawLine(
            Offset(x1, y),
            Offset(x2, y),
            selectedPaths[row][col] ? selectedPaint : paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
