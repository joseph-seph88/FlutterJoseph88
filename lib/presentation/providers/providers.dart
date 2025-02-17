import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:o2/data/datasources/chat_remote_data_source.dart';
import 'package:o2/data/datasources/image_data_source.dart';
import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/data/datasources/user_data_source.dart';
import 'package:o2/data/repositories/chat_repository_impl.dart';
import 'package:o2/data/repositories/image_repository_impl.dart';
import 'package:o2/data/repositories/product_repository_impl.dart';
import 'package:o2/data/repositories/user_repository_impl.dart';
import 'package:o2/domain/repositories/chat_repository.dart';
import 'package:o2/domain/repositories/image_repository.dart';
import 'package:o2/domain/repositories/product_repository.dart';
import 'package:o2/domain/repositories/user_repository.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';
import 'package:o2/domain/usecases/user_use_case.dart';
import 'package:o2/presentation/providers/map_provider.dart';

// DataSource Providers
final chatRemoteDataSourceProvider =
    Provider<ChatRemoteDataSource>((ref) => ChatRemoteDataSource());

final imageDataSourceProvider = Provider<ImageDataSource>(
    (ref) => ImageDataSource(FirebaseStorage.instance));

final userDataSourceProvider =
    Provider<UserDataSource>((ref) => UserDataSource());

final productDataSourceProvider =
    Provider<ProductDataSource>((ref) => ProductDataSource());

// Repository Providers
final chatRepositoryProvider = Provider<ChatRepository>(
    (ref) => ChatRepositoryImpl(ref.read(chatRemoteDataSourceProvider)));

final imageRepositoryProvider = Provider<ImageRepository>(
    (ref) => ImageRepositoryImpl(ref.read(imageDataSourceProvider)));

final userRepositoryProvider = Provider<UserRepository>(
    (ref) => UserRepositoryImpl(ref.read(userDataSourceProvider)));

final productRepositoryProvider =
    Provider<ProductRepository>((ref) => ProductRepositoryImpl(
          ref.read(productDataSourceProvider),
          ref.read(imageRepositoryProvider),
        ));

// UseCase Providers
final getChatRoomsUseCaseProvider = Provider<GetChatRoomsUseCase>(
    (ref) => GetChatRoomsUseCase(ref.read(chatRepositoryProvider)));

final getChatMessagesUseCaseProvider = Provider<GetChatMessagesUseCase>(
    (ref) => GetChatMessagesUseCase(ref.read(chatRepositoryProvider)));

final fetchMoreMessagesUseCaseProvider = Provider<FetchMoreMessagesUseCase>(
    (ref) => FetchMoreMessagesUseCase(ref.read(chatRepositoryProvider)));

final createChatRoomUseCaseProvider = Provider<CreateChatRoomUseCase>(
    (ref) => CreateChatRoomUseCase(ref.read(chatRepositoryProvider)));

final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>(
    (ref) => SendChatMessageUseCase(ref.read(chatRepositoryProvider)));

final sendChatImageUseCaseProvider = Provider<SendChatImageUseCase>((ref) =>
    SendChatImageUseCase(
        ref.read(chatRepositoryProvider), ref.read(imageRepositoryProvider)));

final markChatAsReadUseCaseProvider = Provider<MarkChatAsReadUseCase>(
    (ref) => MarkChatAsReadUseCase(ref.read(chatRepositoryProvider)));

final deleteChatMessageUseCaseProvider = Provider<DeleteChatMessageUseCase>(
    (ref) => DeleteChatMessageUseCase(ref.read(chatRepositoryProvider)));

final getUserDataUseCaseProvider = Provider<GetUserDataUseCase>(
    (ref) => GetUserDataUseCase(ref.read(userRepositoryProvider)));

// Utility Providers
final otherUserProvider = Provider((ref) {
  final getUserDataUseCase = ref.read(getUserDataUseCaseProvider);
  return (String otherUserId) => getUserDataUseCase(otherUserId);
});

final getLatLngProvider = Provider((ref) {
  final mapUseCase = ref.read(mapUseCaseProvider);
  return (String placeId) => mapUseCase.getLatLng(placeId);
});
