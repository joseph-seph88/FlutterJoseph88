import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/map_provider.dart';
import '../../state/map_state.dart';

class SearchAddressPage extends ConsumerStatefulWidget {
  const SearchAddressPage({super.key});

  @override
  ConsumerState<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends ConsumerState<SearchAddressPage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  List<AutocompletePrediction> _predictions = [];
  late FlutterGooglePlacesSdk _places;

  @override
  void initState() {
    super.initState();
    _places = FlutterGooglePlacesSdk('AIzaSyCWjE7YvMlqTO-Tyb4mSez58w0T1CSwrMk',
        locale: const Locale('ko', 'KR'));
    _places.isInitialized().then((value) {
      debugPrint('Places Initialized: $value');
    });
    _focusNode = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _getPredictions(String input, MapState mapState) async {
    if (input.isEmpty) return;

    await ref.read(mapProvider.notifier).getPredictionList(input);
    setState(() {
      _predictions = mapState.predictionList;
    });
  }

  Future<void> _selectAddress(AutocompletePrediction prediction) async {
    _focusNode.unfocus();

    ref.read(mapProvider.notifier).setAddress(prediction.fullText);
    final selectedAddress = ref.read(mapProvider).transAddress;
    await ref
        .read(mapProvider.notifier)
        .transAddressToPosition(selectedAddress);

    setState(() {
      _predictions = [];
    });
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주소 검색',
          style: AppStyles.titleLarge,
        ),
        leading: IconButton(
            onPressed: () {
              _focusNode.unfocus();
              context.pop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              onTap: (){
                if(_focusNode.hasFocus){
                  _focusNode.unfocus();
                }
              },
              onChanged: (input) {
                _getPredictions(input, mapState);
              },
              decoration: InputDecoration(
                labelText: "주소 입력",
                hintText: "주변 건물 이름, 주소",
                hintStyle: AppStyles.labelLarge.copyWith(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _predictions = [];
                    });
                  },
                ),
              ),
              style: AppStyles.labelLarge.copyWith(color: Colors.black),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                      title: Text(prediction.fullText),
                      onTap: () async {
                        await _selectAddress(prediction);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
