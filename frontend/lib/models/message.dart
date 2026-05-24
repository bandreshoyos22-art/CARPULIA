class Message {
  final String sender;
  final String text;
  final String time;

  Message({
    required this.sender,
    required this.text,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'time': time,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
      time: json['time'],
    );
  }
}