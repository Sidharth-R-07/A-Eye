class MessageModel {
  int? id;
  final String message;
  final int chatIndex;
  final String createAt;

  MessageModel(
      {required this.message,
      required this.chatIndex,
      required this.createAt,
      this.id});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      message: json['msg'] as String,
      chatIndex: json['chatIndex'] as int,
      createAt: json['createAt'] as String,
      id: json['id'] as int);
}
