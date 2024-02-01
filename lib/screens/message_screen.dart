import 'dart:async';
import 'dart:convert';
import 'package:typed_data/typed_buffers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt/provider/mqtt_client_provider.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key, required this.topicName});
  final String topicName;
  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  TextEditingController messageController = TextEditingController();

  final StreamController<List<MqttReceivedMessage<MqttMessage>>>
      messageStreamController =
      StreamController<List<MqttReceivedMessage<MqttMessage>>>();

  @override
  Widget build(BuildContext context) {
    // messages to be displayed on screen
    List<String> messages = [];
    // getting all messages from the subscribed topic
    ref
        .read(mqttClientProvider)
        .updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {
      messageStreamController.add(c);

      final recMess = c[0].payload as MqttPublishMessage;
      String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      String decodeMessage = const Utf8Decoder().convert(message.codeUnits);

      messages.add(decodeMessage);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages: ${widget.topicName}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(right: 15, left: 20, bottom: 30, top: 10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
                stream: messageStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: Colors.purple.shade50,
                            title: Text(messages[index]),
                          ),
                        );
                      },
                    );
                  } else {
                    // incase of no messages
                    return Center(
                      child: Text(
                        'Start messages',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // message sending mechanism
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Message to Send: '),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      ref.read(mqttClientProvider).publishMessage(
                            widget.topicName,
                            MqttQos.atLeastOnce,
                            Uint8Buffer()
                              ..addAll(utf8.encode(messageController.text)),
                          );
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
