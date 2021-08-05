import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat App'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (itemIndentifier) {
              if (itemIndentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats/ectVBoIS88rXoBXdjajI/messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Center(
              child: Text(streamSnapshot.error.toString()),
            );
          }

          if (!streamSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final documents = (streamSnapshot.data!).docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/ectVBoIS88rXoBXdjajI/messages')
                .add({'text': 'Message added !'});
          }),
    );
  }
}
