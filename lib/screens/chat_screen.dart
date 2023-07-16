import '../barrel/export.dart';

class ChatScreen extends StatefulWidget {
  final String receiveUserEmail;
  final String receiveUserID;

  const ChatScreen(
      {super.key, required this.receiveUserEmail, required this.receiveUserID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiveUserID, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserEmail),
      ),
      body: Column(
        // messages
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildMessageInput(),

          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(
        widget.receiveUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No messages');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final document = snapshot.data!.docs[index];
              return _buildMessageItem(document);
            },
          );
        }
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user , otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(
              height: 5,
            ),
            ChatBubble(
              message: data['message'],
              timestamp: data['timestamp'].toDate(),
            )
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),

          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
            ),
          ),
        ],
      ),
    );
  }
}
