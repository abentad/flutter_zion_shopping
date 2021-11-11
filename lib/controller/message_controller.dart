import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/model/conversation.dart';
import 'package:flutter_node_auth/model/message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MessageController extends GetxController {
  //secure storage
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = "token";
  //socket io stuff
  //connection working
  late Socket _socket;
  Socket get socket => _socket;
  //
  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;
  //
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  void clearData() {
    _conversations = [];
    _messages = [];
    update();
  }

  //
  MessageController() {
    connectToServer();
  }

  //connects the device to the socket io server
  void connectToServer() {
    try {
      _socket = io(kbaseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      _socket.connect();
      _socket.on('connect', onConnect);
      _socket.on('receive-message-from-room', onReceiveMessage);
    } catch (e) {
      print(e.toString());
    }
  }

  //prints the socket id when device connects to the socket
  void onConnect(_) {
    print('connected to socket with id: ${_socket.id}');
  }

  //creates a unique set of integers so it can be used when creating notifications and other stuff that requires a unique id
  int createUniqueId() {
    return DateTime.now().millisecond;
  }

  //creates a basic notification with title and body using awesome notification plugin
  Future<void> createBasicNotificaton({required String title, required String body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: title.capitalize,
      body: body,
      notificationLayout: NotificationLayout.Default,
    ));
  }

  //adds new message received from socket io to the list of messages
  void onReceiveMessage(message) {
    int convId = 1;
    int senderId = 1;
    int messageId = 1;
    String senderName = Get.find<AuthController>().currentUser!.username.toString();
    _messages.add(
      Message(conversationId: convId, senderId: senderId, senderName: senderName, messageText: message, timeSent: DateTime.now(), id: messageId),
    );
    // createBasicNotificaton(title: "sender", body: message);
    convId = convId + 1;
    senderId = senderId + 1;
    messageId = messageId + 1;
    print('message: $message');
    update();
  }

  //posts message, finds device token by using receiverId, sends notification using the device token, emits the message to the room with the convId
  Future<bool> sendMessageToRoom({required String message, required String convId, required String senderId, required String senderName, required String receiverId}) async {
    // print('send message called using:\nmessage: $message\nconvId: $convId\nsenderId: $senderId\nsenderName: $senderName\nreceiverId: $receiverId');
    try {
      bool result = await postMessage(convId: convId, senderId: senderId, senderName: senderName, messageText: message);
      if (result) {
        print('***saved message to DB successfully');
        bool updateConvResult = await updateConversationInfo(convId, message, senderId);
        if (updateConvResult) {
          print('***conversation info updated successfully');
        } else {
          print('failed updating conversation info');
        }
        //find device token using receiverId
        Map<String, dynamic> result = await findDeviceToken(receiverId);
        if (result['result']) {
          if (result['deviceToken'] != "") {
            bool notificationResult = await sendNotificationUsingDeviceToken(result['deviceToken'], senderName, message);
            if (notificationResult) {
              print("***notification sent successfully");
            } else {
              print("something went wrong while sending notification");
            }
          } else {
            print('device token empty not sending notification');
          }
        }
        _socket.emit('send-message-to-room', {"message": message, "roomName": convId});
        print('***emmited message successfully');
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  //update conversation info
  Future<bool> updateConversationInfo(String convId, String lastMessage, String lastMessageSenderId) async {
    // String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 100000,
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.put(
        '/chat/conv/updlmsg',
        data: {
          "convId": convId,
          "lastMessage": lastMessage,
          "lastMessageSenderId": lastMessageSenderId,
          "lastMessageTimeSent": DateTime.now().toString(),
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  //for finding device token by using the users id
  Future<Map<String, dynamic>> findDeviceToken(String userId) async {
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.get('/user/getDeviceToken?userId=$userId');
      // print('finding token for userid: $userId');
      if (response.statusCode == 200) {
        return {"result": true, "deviceToken": response.data['deviceToken']};
      } else if (response.statusCode == 201) {
        return {"result": true, "deviceToken": ""};
      }
    } catch (e) {
      print(e);
      print('failed finding device token');
      return {"result": false};
    }
    print('failed finding device token');
    return {"result": false};
  }

  //for sending notification by using device token
  Future<bool> sendNotificationUsingDeviceToken(String deviceToken, String messageTitle, String messageBody) async {
    print('send notification called using:\ndeviceToken: $deviceToken\nmessageTitle: $messageTitle\nmessagebody: $messageBody');
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.get('/user/sendNotification?deviceToken=$deviceToken&messageTitle=${messageTitle.capitalize}&messageBody=$messageBody');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //for posting new message
  Future<bool> postMessage({required String convId, required String senderId, required String senderName, required String messageText}) async {
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.post(
        '/chat/message',
        data: {"conversationId": convId, "senderId": senderId, "senderName": senderName, "messageText": messageText, "timeSent": DateTime.now().toString()},
      );
      if (response.statusCode == 201) {
        _messages.add(Message.fromJson(response.data));
        update();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //for getting all conversations based on the user id
  Future<bool> getConversations(String userId) async {
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.get('/chat/conv?id=$userId');
      if (response.statusCode == 200) {
        _conversations.clear();
        for (final conv in response.data) {
          _conversations.add(Conversation.fromJson(conv));
        }
        print('${_conversations.length} conversations has been added to list');
        update();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  //for getting all conversations based on the user id
  Future<Map<String, dynamic>> findConversation({required String senderId, required String receiverId}) async {
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
      // will not throw errors
      validateStatus: (status) => true,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.get('/chat/conv/check?sId=$senderId&rId=$receiverId');
      if (response.statusCode == 200) {
        return {"result": true, "conv": Conversation.fromJson(response.data)};
      }
    } catch (e) {
      print(e);
      return {"result": false};
    }
    return {"result": false};
  }

  //posting new conversation
  Future<Map<String, dynamic>> postConversation({
    required String senderId,
    required String receiverId,
    required String senderName,
    required String receiverName,
    required String senderProfileUrl,
    required String receiverProfileUrl,
    required String lastMessage,
    required String lastMessageSenderId,
  }) async {
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.post(
        '/chat/conv',
        data: {
          "senderId": senderId,
          "receiverId": receiverId,
          "senderName": senderName,
          "receiverName": receiverName,
          "senderProfileUrl": senderProfileUrl,
          "receiverProfileUrl": receiverProfileUrl,
          "lastMessage": lastMessage,
          "lastMessageTimeSent": DateTime.now().toString(),
          "lastMessageSenderId": lastMessageSenderId,
        },
      );
      if (response.statusCode == 200) {
        return {"result": true, "conv": Conversation.fromJson(response.data)};
      }
    } catch (e) {
      print(e);
      return {"result": false};
    }
    return {"result": false};
  }

  //for getting messages based on conversation id
  Future<bool> getMessages(String convId) async {
    String? _token = await _storage.read(key: _tokenKey);
    joinRoom(convId);
    print('joined room: ' + convId);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.get('/chat/message?convId=$convId');
      if (response.statusCode == 200) {
        _messages.clear();
        for (final message in response.data) {
          _messages.add(Message.fromJson(message));
        }
        print('${_messages.length} messages has been added to list');
        update();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  //for joining socket room
  void joinRoom(String roomName) {
    _socket.emit('join-room', roomName);
  }
}
