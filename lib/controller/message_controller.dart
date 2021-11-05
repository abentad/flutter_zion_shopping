// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// class MessageController extends GetxController {
//   final List<Conversation> _conversations = [];
//   List<Conversation> conversations() => _conversations;
//   final List<Message> _oldMessages = [];
//   List<Message> oldMessages() => _oldMessages;

//   List<Message> _messages = [];
//   List<Message> get messages => _messages;

//   ChatController() {
//     connectToServer();
//   }

//   //socket io stuff
//   //connection working
//   late Socket _socket;
//   Socket get socket => _socket;

//   //
//   void connectToServer() {
//     try {
//       _socket = io(kbaseUrl, <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': false,
//       });
//       _socket.connect();
//       _socket.on('connect', onConnect);
//       _socket.on('receive-message-from-room', onReceiveMessage);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void onConnect(_) {
//     print('connect: ${_socket.id}');
//   }

//   void onReceiveMessage(message) {
//     int convId = 1;
//     int senderId = 1;
//     int messageId = 1;
//     String senderName = Get.find<UserController>().currentUser!.name;
//     _messages.add(
//       Message(
//         conversationId: convId.toString(),
//         senderId: senderId.toString(),
//         senderName: senderName,
//         text: message,
//         timeSent: DateTime.now(),
//         id: messageId.toString(),
//         v: 0,
//       ),
//     );
//     Get.find<NotificationController>().createBasicNotificaton(
//       title: 'sender name place holer',
//       body: message,
//     );
//     convId = convId + 1;
//     senderId = senderId + 1;
//     messageId = messageId + 1;
//     print('message: $message');
//     update();
//   }

//   void sendMessageToRoom(String message, String convId, String senderId, String senderName) async {
//     try {
//       bool result = await createAndSaveMessage(convId: convId, senderId: senderId, senderName: senderName, text: message);
//       if (result) {
//         _socket.emit('send-message-to-room', {"message": message, "roomName": convId});
//         print('emmited message successfully');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   //mongodb stuff
//   //

//   Future<bool> createAndSaveMessage({required String convId, required String senderId, required String senderName, required String text}) async {
//     print('save message called');
//     Dio _dio = Dio(BaseOptions(baseUrl: kbaseUrl, connectTimeout: 20000, receiveTimeout: 100000, responseType: ResponseType.json));
//     try {
//       final response = await _dio.post(
//         '/api/message',
//         data: {"conversationId": convId, "senderId": senderId, "senderName": senderName, "text": text, "timeSent": DateTime.now().toString()},
//       );
//       print(response.statusCode);
//       if (response.statusCode == 201) {
//         print('worked nice');
//         _oldMessages.add(Message.fromJson(response.data));
//         _messages.add(Message.fromJson(response.data));
//         update();
//         return true;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }

//   void getConversations(String userId) async {
//     Dio _dio = Dio(BaseOptions(baseUrl: kbaseUrl, connectTimeout: 10000, receiveTimeout: 100000, responseType: ResponseType.json));
//     try {
//       final response = await _dio.get('/api/conversation?userId=$userId');
//       if (response.statusCode == 200) {
//         _conversations.clear();

//         for (final conv in response.data) {
//           _conversations.add(Conversation.fromJson(conv));
//         }
//         print('${_conversations.length} conversations has been added to list');
//         update();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   void getMessages(String convId) async {
//     Dio _dio = Dio(BaseOptions(baseUrl: kbaseUrl, connectTimeout: 10000, receiveTimeout: 100000, responseType: ResponseType.json));
//     try {
//       final response = await _dio.get('/api/message?conversationId=$convId');
//       if (response.statusCode == 200) {
//         _oldMessages.clear();
//         _messages.clear();
//         for (final message in response.data) {
//           _oldMessages.add(Message.fromJson(message));
//         }
//         _messages = List.from(_oldMessages);
//         joinRoom(convId);
//         print('${_oldMessages.length} messages has been added to list');
//         update();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   void clearOldMessages() {
//     _oldMessages.clear();
//     update();
//   }

//   void joinRoom(String roomName) {
//     _socket.emit('join-room', roomName);
//   }
// }
