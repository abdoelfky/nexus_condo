import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/chat/data/message.dart';

final groupChatMessagesProvider = StreamProvider.autoDispose((ref) {
  final firestore = FirebaseFirestore.instance;
  final chatStream = firestore
      .collection('group_chat')
      .orderBy('timestamp', descending: true)
      .snapshots();

  return chatStream.map((snapshot) => snapshot.docs.map((doc) {
    return GroupChatMessage.fromFirestore(doc.id, doc.data());
  }).toList());
});

final groupChatNotifierProvider = Provider.autoDispose((ref) => GroupChatNotifier());

class GroupChatNotifier {
  final _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(GroupChatMessage message) async {
    await _firestore.collection('group_chat').add(message.toFirestore());
  }
}
