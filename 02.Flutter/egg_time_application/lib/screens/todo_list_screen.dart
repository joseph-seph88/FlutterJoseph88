// 나연님 색상표 불러오기
import 'package:egg_time_application/common/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 쉐어드 프리퍼랜스 불러오기

// 쉐어드프리퍼랜스, 리스트뷰

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

//재료
class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todoItems = [];
  final TextEditingController _controller = TextEditingController();
  // 텍스트 수정, 삭제, 관리하는 객체

  @override // 부모위젯 재정렬
  void initState() {
    // 화면 초기 설정
    super.initState();
    _loadTodoItems(); // 투두 불러오기
  }

  // SharedPreferences에서 투두 항목 불러오기
  Future<void> _loadTodoItems() async {
    final prefs =
        await SharedPreferences.getInstance(); //쉐어드프리퍼렌스에 있는 걸 prefs에 넣기
    final List<String>? items =
        prefs.getStringList('todoItems'); //prefs의 투두아이템스(키값)으로 가져와서 아이템 리스트에 넣기
    if (items != null) {
      // 아이템 리스트에 값이 있으면
      setState(() {
        // 화면 업데이트
        _todoItems.addAll(items); // 투두아이템을 아이템리스트에 다 추가해줘
      });
    }
  }

  // SharedPreferences에 투두 항목 저장하기
  Future<void> _saveTodoItems() async {
    final prefs =
        await SharedPreferences.getInstance(); // 쉐어드프리퍼렌스에 잇는걸 prefs에 넣기
    prefs.setStringList(
        'todoItems', _todoItems); // prefs를 투두아이템스(키값)으로 투두아이템즈 리스트에 저장
  }

  void _addTodoItem() {
    if (_controller.text.isNotEmpty) {
      // 컨트롤러에 있는 글이 있으면
      setState(() {
        // 화면 업데이트
        _todoItems
            .add(_controller.text); //그 글을 투두아이템리스트에 저장 (컨트롤러 가서 쉐어드프리퍼랜스에 저장)
        _saveTodoItems(); // 쉐어드프리퍼랜스에 있는거 투두아이탬즈 리스트에 저장
      });
      _controller.clear(); // 컨트롤러 비우기
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index); //투두아이템즈 리스트에서 몇번째 지우기
      _saveTodoItems(); // 쉐어드프리퍼랜스에 통으로 저장 후 리스트에 저장
    });
  }

  final eggColors = EggColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: eggColors.yellowstyle3,
      appBar: AppBar(
        backgroundColor: eggColors.yellowstyle2,
        title: const Text(
          '병아리의 하루',
          style: TextStyle(fontFamily: 'Hyemin_Bold', fontSize: 40),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50), // 빈 공간 추가
            Padding(
              //주위에 여백 추가
              padding: const EdgeInsets.all(8.0), // 상하좌우 모두 8픽셀의 여백
              child: TextField(
                //사용자 입력 필드
                controller: _controller, // 컨트로러 객체 생성
                cursorColor: Colors.black, // 커서 키 검은 색
                decoration: InputDecoration(
                  //텍스트상자 추가스타일
                  floatingLabelBehavior:
                      FloatingLabelBehavior.never, //힌트 텍스트 입력하지않았을때만 보이게 설정
                  labelText: 'Enter a task', //힌트 텍스트
                  filled: true, // 텍스트 상자 배경색
                  fillColor: eggColors.basestyle2, //색상
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // 텍스트상자 테두리 동그랗게
                    borderSide: BorderSide.none, // 텍스트 상자 테두리 없앰
                  ),
                  suffixIcon: IconButton(
                    // 텍스트상자 오른쪽 아이콘 생성
                    icon: const Icon(Icons.add), //플러스버튼 생성
                    onPressed: _addTodoItem, // 누르면 할 일 추가됨
                  ),
                ),
              ),
            ),
            Expanded(
              // 화면에 꽉 채워줌
              child: ListView.builder(
                //할 일 리스트
                itemCount: _todoItems.length, // 리스트에 표시할 할 일 개수
                itemBuilder: (context, index) {
                  // 항목을 만들어냄 (문자,순서)
                  return ListTile(
                    //리스트의 각 항목을 구성하는 위젯
                    title: Text(
                      _todoItems[index], //_todoItems의 몇 번쨰 데이터
                      style: const TextStyle(
                          fontFamily: 'Hyemin_Regular', color: Colors.black),
                    ),
                    trailing: IconButton(
                      // trailing: 리스트항목에 오른쪽 끝으로 위젯 지정(반대:leading)
                      icon: const Icon(Icons.delete), // 휴지 아이콘 추가
                      onPressed: () =>
                          _removeTodoItem(index), // 버튼 누르면 몇번째가 없어짐
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
