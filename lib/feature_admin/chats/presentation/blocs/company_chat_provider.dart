import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/chat/data/models/chat_company_model.dart';
import 'package:intetership_project/feature/chat/data/models/chat_message_by_id_model.dart';
import 'package:intetership_project/feature/chat/data/repos/chat_company_service.dart';
import 'package:intetership_project/feature_admin/chats/data/models/company_get_chat_model.dart';
import 'package:intetership_project/feature_admin/chats/data/repos/company_chat_service.dart';



final companyChatServiceProvider=Provider<CompanyChatService>((ref){
  return CompanyChatService();
});

final companyChatProvider=StateNotifierProvider.family<CompanyChatNotifier,AsyncValue<List<CompanyGetChatModel>>,int>((ref,chatId){
final companyChatService=ref.watch(companyChatServiceProvider);
return CompanyChatNotifier(companyChatService: companyChatService, chatId: chatId);
});





class CompanyChatNotifier
    extends StateNotifier<AsyncValue<List<CompanyGetChatModel>>> {
  final CompanyChatService companyChatService;
  final int chatId;

  CompanyChatNotifier({required this.companyChatService, required this.chatId})
    : super(const AsyncValue.loading()) {
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final chatList = await companyChatService.fetchCompanyChat(chatId);
      // берем список чатов из объекта-обертки
      final messages = chatList;
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Future<void> sendMessage(
  //   String text,
  //   String senderId,
  //   int companyId,
  //   int chatId,
  // ) async {
  //   try {
  //     await chatCompanyService.sendMessage(
  //       chatId: chatId,
  //       text: text,
  //       companyId: companyId,
  //     );
  //     await fetchMessages();
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }
  //   void sendMessage(String text) async {
  //   final newMessage = await chatService.sendMessage(text);
  //   state = [newMessage, ...state];
  // }
}
