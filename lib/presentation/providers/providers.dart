import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/chat_remote_data_source.dart';
import 'package:o2/data/repositories/chat_repository_impl.dart';
import 'package:o2/domain/repositories/chat_repository.dart';
import 'package:o2/domain/usecases/chat_usecases.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>(
    (ref) => ChatRemoteDataSourceImpl());

final chatRepositoryProvider = Provider<ChatRepository>(
    (ref) => ChatRepositoryImpl(ref.read(chatRemoteDataSourceProvider)));

final getChatRoomsUseCaseProvider = Provider<GetChatRoomsUseCase>(
    (ref) => GetChatRoomsUseCase(ref.read(chatRepositoryProvider)));

final getChatMessagesUseCaseProvider = Provider<GetChatMessagesUseCase>(
    (ref) => GetChatMessagesUseCase(ref.read(chatRepositoryProvider)));

final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>(
    (ref) => SendChatMessageUseCase(ref.read(chatRepositoryProvider)));