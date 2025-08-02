import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/chat/data/models/chat_message_by_id_model.dart';
import 'package:intetership_project/feature/chat/data/models/last_message_model.dart';
import 'package:intetership_project/feature/chat/data/repos/chat_service.dart';
import 'package:intetership_project/feature/chat/presentation/blocs/chat_provider.dart';

final messagesProvider = StateNotifierProvider.family<
  MessagesNotifier,
  AsyncValue<List<ChatMessageByIdModel>>,
  int
>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return MessagesNotifier(chatService: chatService, chatId: chatId);
});

class MessagesNotifier
    extends StateNotifier<AsyncValue<List<ChatMessageByIdModel>>> {
  final ChatService chatService;
  final int chatId;

  MessagesNotifier({required this.chatService, required this.chatId})
    : super(const AsyncValue.loading()) {
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final messages = await chatService.fetchAllMessages(chatId);
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Future<void> sendMessage(String text, int companyId) async {
  //   try {
  //     await chatService.sendMessage(
  //       chatId: chatId,
  //       text: text,
  //       companyId: companyId,
  //     );
  //     await fetchMessages();
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }
  Future<void> sendMessage(String text, int companyId) async {
    try {
      final newMessage = await chatService.sendMessage(
        chatId: chatId,
        text: text,
        companyId: companyId,
      );

      // Добавляем сообщение вручную
      state = AsyncValue.data([newMessage, ...state.value ?? []]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
