import 'auth.dart';

class User {
  BaseAuth auth;
  ConversationList conversations;
}

class ConversationList{
  List conversations;

  ConversationList(this.conversations);
}

class Conversation {
  String user1;
  String user2;
  List<Message> messages;

  Conversation(this.user1, this.user2, this.messages);

  @override
  String toString() {
    return "user1: $user1, user2: $user2, messages:$messages";
  }
}

class Message {
  String sender;
  String receiver;
  String text;

  Message(this.sender, this.receiver, this.text);
  @override
  String toString() {
    return "sender: $sender, receiver: $receiver, text:$text";
  }
}