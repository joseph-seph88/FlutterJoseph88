import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/map_entity.dart';
import '../../../providers/map_provider.dart';

class MapStateListener extends ConsumerWidget {
  final Future<void> Function(List<MapEntity> mapData) streamUpdateMarkers;

  const MapStateListener(this.streamUpdateMarkers, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    bool isStream = ref.watch(isStreamProvider);

    ref.listen<AsyncValue<List<MapEntity>>>(
      mapDataStreamProvider,
      (previous, next) {
        next.when(
          data: (newData) async {
            if(isStream){
              await streamUpdateMarkers(newData);
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => debugPrint("스트림 에러 발생: $err, $stack"),
        );
      },
    );

    if (mapState.isLoading) {
      return const CircularProgressIndicator();
    }

    if (mapState.error.isNotEmpty) {
      return Text("Error: ${mapState.error}");
    }

    return const SizedBox.shrink();
  }
}
