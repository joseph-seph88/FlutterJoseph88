import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/chat_remote_data_source.dart';
import 'package:o2/data/datasources/image_data_source.dart';
import 'package:o2/data/repositories/chat_repository_impl.dart';
import 'package:o2/data/repositories/image_repository_impl.dart';
import 'package:o2/domain/repositories/chat_repository.dart';
import 'package:o2/domain/repositories/image_repository.dart';
import 'package:o2/domain/usecases/chat_use_case.dart';

final chatRemoteDataSourceProvider =
    Provider<ChatRemoteDataSource>((ref) => ChatRemoteDataSourceImpl());

final imageDataSourceProvider =
    Provider<ImageDataSource>((ref) => ImageDataSourceImpl());

final chatRepositoryProvider = Provider<ChatRepository>(
    (ref) => ChatRepositoryImpl(ref.read(chatRemoteDataSourceProvider)));

final imageRepositoryProvider = Provider<ImageRepository>(
    (ref) => ImageRepositoryImpl(ref.read(imageDataSourceProvider)));

final getChatRoomsUseCaseProvider = Provider<GetChatRoomsUseCase>(
    (ref) => GetChatRoomsUseCase(ref.read(chatRepositoryProvider)));

final getChatMessagesUseCaseProvider = Provider<GetChatMessagesUseCase>(
    (ref) => GetChatMessagesUseCase(ref.read(chatRepositoryProvider)));

final createChatRoomUseCaseProvider = Provider<CreateChatRoomUseCase>(
    (ref) => CreateChatRoomUseCase(ref.read(chatRepositoryProvider)));

final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>(
    (ref) => SendChatMessageUseCase(ref.read(chatRepositoryProvider)));

final sendChatImageUseCaseProvider = Provider<SendChatImageUseCase>((ref) =>
    SendChatImageUseCase(
        ref.read(chatRepositoryProvider), ref.read(imageRepositoryProvider)));

final markChatAsReadUseCaseProvider = Provider<MarkChatAsReadUseCase>(
    (ref) => MarkChatAsReadUseCase(ref.read(chatRepositoryProvider)));
