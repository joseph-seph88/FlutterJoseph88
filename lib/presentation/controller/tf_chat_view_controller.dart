import 'dart:async';
import 'package:chatbots/data/data_sources/chat_mock_data_source.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TfChatViewController extends GetxController {
  final ChatMockDataSource _mockDataSource = ChatMockDataSource();
  late final TextEditingController textController;
  late final ImagePicker _imagePicker;
  late final Gemini _gemini;
  Timer? _debounceTimer;
  final _maxHistoryLength = 10;

  var image = Rx<XFile?>(null);

  final myUser = ChatUser(
    id: '1',
    firstName: 'Joseph',
    lastName: '88',
  ).obs;
  final geminiUser = ChatUser(
    id: '2',
    firstName: 'Mark',
    lastName: '22',
  ).obs;

  var isFeature = false.obs;
  var isTyping = false.obs;
  var isSpeeching = false.obs;
  var isSelectedImage = false.obs;

  var featureIndex = 0.obs;
  var tfSelect = ['T', 'F'].obs;
  var contentList = <Content>[].obs;

  var message = "".obs;
  var messages = <ChatMessage>[].obs;


  @override
  void onInit() {
    super.onInit();
    initInstance();
  }

  void initInstance(){
    textController = TextEditingController();
    _imagePicker = ImagePicker();
    _gemini = Gemini.instance;
  }

  void updateMessage(String text) {
    message.value = text;
  }

  void selectImage() async {
    image.value = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image.value != null) {
      isSelectedImage.value = true;
    }
  }

  void sendChatMessage() async {
    final inputText = textController.text;
    if (inputText.isEmpty) return;
    final askText = "[질문]: $inputText";

    if (isSelectedImage.value && image.value != null) {
      _addContentListWithTextImage(askText);
      _addDashChatWithTextImage(inputText);
      _geminiResponse();
    } else {
      _addContentListWithTextUser(askText);
      _addDashChatWithText(inputText, myUser.value);
      _geminiResponse();
    }
    message.value = "";
    textController.clear();
    image.value = null;
  }


  void _addContentListWithTextImage(String askText) async {
    isSelectedImage.value = false;
    var imageBytes = await image.value?.readAsBytes();
    contentList.add(Content(parts: [
      Part.text(_mockDataSource.tfFeature[featureIndex.value]),
      Part.text(askText),
      Part.bytes(imageBytes!)
    ], role: 'user'));

    if (contentList.length > _maxHistoryLength) {
      contentList.removeAt(0);
    }
  }

  void _addContentListWithTextUser(String resultText) {
    contentList.add(Content(parts: [
      Part.text(_mockDataSource.tfFeature[featureIndex.value]),
      Part.text(resultText)
    ], role: 'user'));
    if (contentList.length > _maxHistoryLength) {
      contentList.removeAt(0);
    }
  }

  void _addContentListWithTextGemini(String resultText) {
    contentList.add(Content(parts: [Part.text(resultText)], role: 'model'));
    if (contentList.length > _maxHistoryLength) {
      contentList.removeAt(0);
    }
  }

  void _addDashChatWithTextImage(String askText) {
    ChatMessage msgData = ChatMessage(
        user: myUser.value,
        createdAt: DateTime.now(),
        text: askText,
        medias: [
          ChatMedia(
            url: image.value!.path,
            fileName: image.value!.name,
            type: MediaType.image,
          )
        ]);
    messages.insert(0, msgData);
  }

  void _addDashChatWithText(String resultText, ChatUser chatUser) {
    ChatMessage msgData = ChatMessage(
      user: chatUser,
      createdAt: DateTime.now(),
      text: resultText,
    );
    messages.insert(0, msgData);
  }

  void _geminiResponse() {
    isTyping.value = true;
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _gemini
          .chat(
        contentList,
        // safetySettings: [
        //   SafetySetting(
        //     category: SafetyCategory.harassment,
        //     threshold: SafetyThreshold.blockLowAndAbove,
        //   ),
        //   SafetySetting(
        //     category: SafetyCategory.hateSpeech,
        //     threshold: SafetyThreshold.blockOnlyHigh,
        //   )
        // ],
        generationConfig: GenerationConfig(
          temperature: 1,
          maxOutputTokens: 150,
        ),
      )
          .then((value) async {
        if (value?.output != null) {
          String? geminiResponse = value?.output;
          if (geminiResponse == null) return;
          _addContentListWithTextGemini(geminiResponse);
          _addDashChatWithText(geminiResponse, geminiUser.value);
        }
        isTyping.value = false;
      }).catchError((e) {
        debugPrint('[CTLR] _geminiResponse Error "${e.toString()}"');
      });
    });
  }
}
