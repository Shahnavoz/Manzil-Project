import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/chat/data/models/company_chat_list.dart';
import 'package:intetership_project/feature/chat/presentation/blocs/list_chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int chatId;
  final String senderId;
  final int companyId;
  final CompanyChatListModel? company;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.senderId,
    required this.companyId,
    this.company,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await ref
        .read(messagesProvider(widget.chatId).notifier)
        .sendMessage(text, widget.companyId);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;

    final messagesState = ref.watch(messagesProvider(widget.chatId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхний бар с градиентом и заголовком
            Container(
              width: double.infinity,
              height: isNarrow ? 90 : 110,
              padding: EdgeInsets.symmetric(horizontal: isNarrow ? 12 : 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 134, 176, 239),
                    Color.fromARGB(255, 79, 89, 107),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    iconSize: isNarrow ? 28 : 35,
                    padding: EdgeInsets.zero,
                    splashRadius: 22,
                  ),
                  SizedBox(width: isNarrow ? 12 : 20),
                  Expanded(
                    child: Text(
                      widget.company?.name ?? 'Чат',
                      style: TextStyle(
                        fontSize: isNarrow ? 22 : 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Список сообщений
            Expanded(
              child: messagesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Ошибка: $error')),
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(child: Text('Нет сообщений'));
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: isNarrow ? 8 : 12,
                      vertical: isNarrow ? 6 : 8,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.sender_type == "user";

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: isNarrow ? 3 : 6),
                          padding: EdgeInsets.symmetric(
                            horizontal: isNarrow ? 12 : 14,
                            vertical: isNarrow ? 8 : 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: media.size.width * (isNarrow ? 0.75 : 0.65),
                          ),
                          decoration: BoxDecoration(
                            gradient: isMe
                                ? const LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Color.fromARGB(255, 102, 145, 218),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color:
                                isMe ? null : Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft:
                                  isMe ? const Radius.circular(12) : Radius.zero,
                              bottomRight:
                                  isMe ? Radius.zero : const Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.content ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: isNarrow ? 14 : 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message.timestamp
                                    .toLocal()
                                    .toString()
                                    .substring(0, 16),
                                style: TextStyle(
                                  color: isMe ? Colors.white70 : Colors.black54,
                                  fontSize: isNarrow ? 10 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Ввод сообщения
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 8 : 12, vertical: isNarrow ? 14 : 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 10 : 12,
                          vertical: isNarrow ? 6 : 8,
                        ),
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  SizedBox(width: isNarrow ? 6 : 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue, size: isNarrow ? 24 : 28),
                    onPressed: sendMessage,
                    splashRadius: 22,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
