import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/storage_service.dart';

class ChatScreen extends StatefulWidget {
  final String userEmail;

  const ChatScreen({
    super.key,
    required this.userEmail,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {
  final TextEditingController _controller =
      TextEditingController();

  List<Message> _messages = [];

  late String _chatId;

  @override
  void initState() {
    super.initState();

    final currentUser =
        StorageService().currentUser;

    final currentEmail =
        currentUser?.email ?? 'anonimo';

    _chatId =
        '${currentEmail}_${widget.userEmail}';

    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final data =
        await StorageService()
            .loadMessages(_chatId);

    setState(() {
      _messages = data
          .map(
            (item) => Message(
              sender: item['sender'],
              text: item['text'],
              time: item['time'],
            ),
          )
          .toList();
    });
  }

  Future<void> _saveMessages() async {
    final data = _messages
        .map(
          (m) => {
            'sender': m.sender,
            'text': m.text,
            'time': m.time,
          },
        )
        .toList();

    await StorageService().saveMessages(
      _chatId,
      data,
    );
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    final currentUser =
        StorageService().currentUser;

    final sender =
        currentUser?.email ?? 'Usuario';

    final message = Message(
      sender: sender,
      text: _controller.text.trim(),
      time: TimeOfDay.now().format(context),
    );

    setState(() {
      _messages.add(message);
    });

    _controller.clear();

    await _saveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat con ${widget.userEmail}',
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,

              itemBuilder: (context, index) {
                final message =
                    _messages[index];

                final currentUser =
                    StorageService()
                        .currentUser;

                final isMe =
                    message.sender ==
                    currentUser?.email;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                    padding:
                        const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blue.shade100
                          : Colors.grey.shade300,

                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          message.sender,

                          style:
                              const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 4),

                        Text(message.text),

                        const SizedBox(height: 4),

                        Text(
                          message.time,

                          style:
                              const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(12),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,

                    decoration:
                        const InputDecoration(
                          hintText:
                              'Escribe un mensaje...',
                          border:
                              OutlineInputBorder(),
                        ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon:
                      const Icon(Icons.send),

                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}