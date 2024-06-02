import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() => _NewMessage();
}

class _NewMessage extends State<NewMessage> {
  final TextEditingController _messageContrller = TextEditingController();

  @override
  void dispose() {
    _messageContrller.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageContrller.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    //==== CLEAR TEXTFIELD ====
    //Focus.of(context).unfocus();
    _messageContrller.clear();

    //============ "SEND MESSAGE AND OTHER DETAILS TO FIREBASE FIRESTORE" ============
    //== GET THE USER ==
    final user = FirebaseAuth.instance.currentUser!;
    //== GET CURRENT USER DETAILS (USERNAME AND IMAGEURL) ==
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //== SEND DATA TO FIREBASE ==
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url']
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 1),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageContrller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
