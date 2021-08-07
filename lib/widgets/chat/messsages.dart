import 'package:chat_app/widgets/chat/message_bubble.dart';
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
        // return ListView(
        //   children: chatSnapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data =
        //         document.data()! as Map<String, dynamic>;
        //     return Text(data['text']);
        //   }).toList(),
        // );
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (ctx, index) => MessageBubble(
            message: chatDocs[index]['text'],
          ),
          itemCount: chatDocs.length,
          reverse: true,
        );
      },
      stream: _chatSnapshot,
    );
  }
}
