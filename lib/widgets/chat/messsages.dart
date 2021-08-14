import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _chatSnapshot = FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();

    final User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
      future: Future.value(user),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
            // error
            if (chatSnapshot.hasError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(chatSnapshot.error.toString()),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
            // waiting
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // mapping data
            final chatDocs = chatSnapshot.data!.docs;
            return ListView.builder(
              itemBuilder: (ctx, index) {
                final DocumentSnapshot docsIndex = chatDocs[index];
                return MessageBubble(
                  message: docsIndex['text'],
                  isMe: docsIndex['userId'] == user!.uid,
                  userName: docsIndex['username'],
                  key: ValueKey(docsIndex.id), // this is documentID
                );
              },
              itemCount: chatDocs.length,
              reverse: true,
            );
          },
          stream: _chatSnapshot,
        );
      },
    );
  }
}
