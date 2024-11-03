import 'package:egg_time_application/common/color_styles.dart';
import 'package:egg_time_application/common/text_styles.dart';
import 'package:egg_time_application/db_helper/time_storage.dart';
import 'package:egg_time_application/screens/report.dart';
import 'package:flutter/material.dart'; //각종 임포트(material, async, audio, untl, color, text, timestorage)
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class PomodoroTimerScreen extends StatefulWidget {
  //Stateful 위젯 생성

  const PomodoroTimerScreen({super.key});

  @override
  PomodoroTimerScreenState createState() => PomodoroTimerScreenState();
}

class PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  //state 생성 : stf은 화면의 구조와 초기 설정만 정의하고, 화면의 상태 관리는 state에 위임해서 처리
  //역할 : state클래스는 상태를 관리하고 build메서드에서 상태에 따라 UI그리는데 집중함
  //정리 : stateful - 위젯 자체를 정의 / state - 위젯의 상태와 변화에 따른 UI관리
  final TimeStorage timeStorage = TimeStorage();
  // 시간을 저장하고 불러오기 위한 TimeStorage 인스턴스 생성
  // TimeStorage클래스 : SharedPreferences 패키지를 이용해 앱 데이터를 영구 저장하고 불러오는 역할을 담당하는 클래스
  int studySeconds = 10; // 집중시간 - 초단위
  int breakSeconds = 5; // 휴식시간
  int currentSeconds = 10; // 남은시간
  int accumulatedStudySeconds = 0; // 누적 집중시간
  int todayStudySeconds = 0; // 오늘 누적 집중시간
  int cycleCount = 0; // 사이클 수(집중+휴식 1세트)
  bool isStudying = true; // 현재 상태(true: 집중, false: 휴식)
  bool soundOn = false; // 사운드 활성화(true: 재생, false: 중지)
  bool isTimerRunning = false; // 타이머의 실행 상태(true: 실행, false: 일시정지)
  bool isCycleComplete = false; // (true: 사이클 완료 상태)
  Timer? timer; // 타이머 관리용 객체(null일 수 있음)
  String currentDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now()); // 현재 날짜 저장하여 일별 데이터 관리에 사용

  late final AudioPlayer _audioPlayer = AudioPlayer()
    //_audioPlayer를 사용해 오디오 제어
    // late : 객체가 처음 사용될 때 까지 초기화를 미루는 역할(불필요한 리소스 낭비 방지)
    ..setReleaseMode(ReleaseMode.loop); //릴리즈 반복재생모드로 설정
  //AudioPlayer 플러터 기본 제공 도구.
  //import 'package:audioplayers/audioplayers.dart';
  //final audioPlayer = AudioPlayer();  // AudioPlayer 객체 생성
  // // 오디오 재생
  // await audioPlayer.setSource(AssetSource('assets/sound.mp3')); // 로컬 파일 설정
  // await audioPlayer.play(); // 재생
  // // 일시 정지
  // await audioPlayer.pause();
  // // 정지
  // await audioPlayer.stop();
  // // 반복 재생 설정
  // audioPlayer.setReleaseMode(ReleaseMode.loop);

  @override
  void initState() {
    // initState 위젯 생성 시 한번만 호출, 위젯의 초기화 작업을 수행
    // 주로 비동기데이터를 로드하거나, 타이머, 에니메이션컨트롤러, 오디오재생기 같은 객체를 초기화
    // 위젯 처음 생성 시 필요한 초기 설정을 위해 사용되므로, 반복 초기화가 필요 없는 작업을 여기에 작성.

    super.initState();
    _loadData(); //저장된 데이터 호출(앱을 꺼도 데이터 유지)
  }

  //SharedPreferences에 저장하고 불러오는 함수들
  Future<void> _loadData() async {
    accumulatedStudySeconds = await timeStorage.loadAccumulatedTime();
    //누적공부시간 초단위 저장, loadAccumulatedTime()는 누적공부시간 불러옴
    todayStudySeconds = await timeStorage.loadTodayTime(); //오늘공부시간 초단위 저장
    cycleCount = await timeStorage.loadCycleCount(); //사이클횟수 저장
    setState(() {});
  }

  Future<void> saveTimeData() async {
    await timeStorage.saveAccumulatedTime(accumulatedStudySeconds);
    await timeStorage.saveTodayTime(todayStudySeconds);
  }

  Future<void> saveCycleData() async {
    await timeStorage.saveCycleCount(cycleCount);
  }

  Future<void> stopSound() async {
    await _audioPlayer.pause();
    setState(() {
      soundOn = false;
    });
  }

  // 로그 저장 함수
  Future<void> _saveLog(String action) async {
    String timestamp = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    String log = '$timestamp - $action';
    await timeStorage.saveLog(log);
  }

  void toggleTimer() {
    if (isTimerRunning) {
      timer?.cancel();
      stopSound();
      _saveLog("Paused"); // 일시정지 시 로그 저장
    } else {
      if (isCycleComplete) resetCycle();
      startTimer();
      if (!soundOn) toggleSound();
      _saveLog("Started"); // 시작 시 로그 저장
    }
    setState(() {
      isTimerRunning = !isTimerRunning;
    });
  }

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (currentSeconds > 0) {
        setState(() {
          currentSeconds--;
          if (isStudying) {
            accumulatedStudySeconds++;
            todayStudySeconds++;
            saveTimeData();
          }
        });
      } else {
        t.cancel();
        if (isStudying) {
          cycleCount++;
          if (cycleCount == 4) {
            showRestartButton();
          } else {
            startBreak();
          }
        } else {
          startStudy();
        }
      }
      checkDateChange();
    });
  }

  void startStudy() {
    setState(() {
      currentSeconds = studySeconds;
      isStudying = true;
      startTimer();
    });
  }

  void startBreak() {
    setState(() {
      currentSeconds = breakSeconds;
      isStudying = false;
      startTimer();
    });
  }

  void showRestartButton() {
    setState(() {
      isCycleComplete = true;
      isTimerRunning = false;
    });
  }

  void checkDateChange() {
    String newDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (newDate != currentDate) {
      setState(() {
        currentDate = newDate;
        todayStudySeconds = 0;
        timeStorage.saveTodayTime(todayStudySeconds);
      });
    }
  }

  Future<void> toggleSound() async {
    if (soundOn) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setSource(AssetSource('audios/frying_egg.wav'));
      await _audioPlayer.resume();
    }
    setState(() {
      soundOn = !soundOn;
    });
  }

  void resetCycle() {
    setState(() {
      currentSeconds = studySeconds;
      isStudying = true;
      isCycleComplete = false;
      isTimerRunning = false;
    });
  }

  String getCurrentEggImage() {
    final interval = (studySeconds / 3).floor();
    if (currentSeconds > 2 * interval) {
      return 'assets/egg11.png';
    } else if (currentSeconds > interval) {
      return 'assets/egg22.png';
    } else {
      return 'assets/egg33.png';
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _onBottomTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReportScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EggColors().yellowstyle3,
        title: Text(
          'Egg Time',
          style: TextStyle(
              fontFamily: 'Hyemin_Bold', color: EggColors().yellowstyle7),
        ),
        iconTheme: IconThemeData(
          color: EggColors().yellowstyle6,
        ),
        actions: [
          IconButton(
            icon: Icon(
              soundOn ? Icons.volume_up : Icons.volume_off,
              color: EggColors().yellowstyle6,
            ),
            onPressed: toggleSound,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: EggColors().yellowstyle3),
              child: const Text(
                'Egg Timer Menu',
                style: TextStyle(fontFamily: 'Hyemin_Bold', fontSize: 24),
              ),
            ),
            buildDrawerItem(Icons.person, 'Character', () {
              Navigator.pop(context);
            }),
            buildDrawerItem(Icons.timer, 'Egg Timer', () {
              Navigator.pop(context);
            }),
            buildDrawerItem(Icons.check_circle_outline, 'To-Do', () {
              Navigator.pop(context);
            }),
            buildDrawerItem(Icons.bar_chart, 'Records', () {
              Navigator.pop(context);
            }),
            buildDrawerItem(Icons.settings, 'Settings', () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          final double screenHeight =
              MediaQuery.of(context).size.height; // 전체 화면 높이
          final double appBarHeight = Scaffold.of(context).appBarMaxHeight ??
              kToolbarHeight; // AppBar의 높이 (없으면 기본 툴바 높이 사용)
          const double bottomNavBarHeight =
              kBottomNavigationBarHeight; // BottomNavigationBar 기본 높이

          final totalBodyHeight =
              screenHeight - appBarHeight - bottomNavBarHeight; // body의 높이 계산

          return Container(
            color: EggColors().basestyle2,
            child: Stack(
              children: [
                if (!isCycleComplete) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: double.infinity,
                      height: totalBodyHeight *
                          (isStudying
                              ? (studySeconds - currentSeconds) / studySeconds
                              : (breakSeconds - currentSeconds) / breakSeconds),
                      color: EggColors().redstyle2,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Image.asset(
                        getCurrentEggImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                if (isCycleComplete)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        foregroundColor: EggColors().yellowstyle6,
                        backgroundColor: EggColors().basestyle1,
                        textStyle: const TextStyle(fontSize: 30),
                      ),
                      onPressed: resetCycle,
                      child: const Text('RESTART'),
                    ),
                  ),
                if (!isCycleComplete)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 20),
                          child: Column(
                            children: [
                              Text(
                                isStudying ? '집중시간' : '휴식시간',
                                style: getYellowOutlineTextStyle(55),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                formatTimeMMSS(currentSeconds),
                                style: getYellowOutlineTextStyle(90),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 2.7),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              foregroundColor: EggColors().yellowstyle6,
                              backgroundColor: EggColors().basestyle1,
                              textStyle: const TextStyle(
                                  fontSize: 30, fontFamily: 'Hyemin_Regular'),
                            ),
                            onPressed: toggleTimer,
                            child: Text(isTimerRunning ? 'PAUSE' : 'START'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (context) => _onBottomTap(),
        selectedItemColor: EggColors().yellowstyle6,
        unselectedItemColor: EggColors().yellowstyle6,
        backgroundColor: EggColors().basestyle2,
        items: [
          BottomNavigationBarItem(
            label: 'TOTAL',
            icon: Text(
              formatTime(accumulatedStudySeconds),
              style: TextStyle(
                  fontSize: 16,
                  color: EggColors().yellowstyle6,
                  fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            label: 'TODAY',
            icon: Text(
              formatTime(todayStudySeconds),
              style: TextStyle(
                  fontSize: 16,
                  color: EggColors().yellowstyle6,
                  fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            label: 'CYCLE',
            icon: Text(
              cycleCount.toString(),
              style: TextStyle(
                  fontSize: 16,
                  color: EggColors().yellowstyle6,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: EggColors().yellowstyle6),
      title: Text(title),
      onTap: onTap,
    );
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatTimeMMSS(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
