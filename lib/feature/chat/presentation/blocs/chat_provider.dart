import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/chat/data/models/chat_message_by_id_model.dart';
import 'package:intetership_project/feature/chat/data/models/chat_model.dart';
import 'package:intetership_project/feature/chat/data/repos/chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

final chatProvider = StateNotifierProvider.family<
  ChatNotifier,
  AsyncValue<List<ChatMessageByIdModel>>,
  int
>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService: chatService, chatId: chatId);
});

class ChatNotifier
    extends StateNotifier<AsyncValue<List<ChatMessageByIdModel>>> {
  final ChatService chatService;
  final int chatId;

  ChatNotifier({required this.chatService, required this.chatId})
    : super(const AsyncValue.loading()) {
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final chatListResponse = await chatService.fetchChats();
      // берем список чатов из объекта-обертки
      final messages = chatListResponse.results;
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(
    String text,
    String senderId,
    int companyId,
    int chatId,
  ) async {
    try {
      await chatService.sendMessage(
        chatId: chatId,
        text: text,
        companyId: companyId,
      );
      await fetchMessages();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  //   void sendMessage(String text) async {
  //   final newMessage = await chatService.sendMessage(text);
  //   state = [newMessage, ...state];
  // }
}
