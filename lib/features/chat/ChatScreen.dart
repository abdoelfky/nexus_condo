import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/chat/data/message.dart';

import 'controllers/chat_provider.dart';


class GroupChatScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const GroupChatScreen({super.key, required this.userId, required this.userName});

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatStream = ref.watch(groupChatMessagesProvider);
    final chatNotifier = ref.read(groupChatNotifierProvider);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Group Chat',
      ),
      body: BackgroundScreen(
        child: Column(
          children: [
            Expanded(
              child: chatStream.when(
                data: (messages) => messages.isEmpty
                    ? const Center(child: Text('No messages yet'))
                    : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message.senderId == widget.userId;
        
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? AppColors.primaryChatColor : AppColors.secondaryChatColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.senderName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(message.message,style: TextStyle(color: AppColors.whiteTextColor),),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        color: Colors.white, // Text color inside the TextField
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(
                          color: Colors.grey, // Hint text color
                        ),
                        filled: true,
                        fillColor: Colors.black54, // Background color of the TextField
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.white, // Border color
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppColors.appBarColor, // Border color when focused
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.white, // Default border color
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        await chatNotifier.sendMessage(
                          GroupChatMessage(
                            id: '',
                            senderId: widget.userId,
                            senderName: widget.userName,
                            message: message,
                            timestamp: DateTime.now(),
                          ),
                        );
                        _messageController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                    child: const Icon(Icons.send,color: AppColors.whiteColor,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
