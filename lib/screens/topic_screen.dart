import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt/provider/mqtt_client_provider.dart';
import 'package:mqtt/screens/message_screen.dart';
import 'package:mqtt_client/mqtt_client.dart';

class TopicScreen extends ConsumerStatefulWidget {
  const TopicScreen({super.key});

  @override
  ConsumerState<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends ConsumerState<TopicScreen> {
  TextEditingController topicController = TextEditingController();

  void onSubscriptioni(String message, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MessagesScreen(
            topicName: message,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Topic Subscription",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
      ),
      body: Center(
        child: Column(
          children: [
            // input for text field
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextField(
                controller: topicController,
                decoration: const InputDecoration(
                  label: Text('Topic Name: '),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // button to subscribe to the topic
            Container(
              padding: const EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple,
              ),
              child: TextButton(
                onPressed: () async {
                  // subscribe to topic
                  ref.read(mqttClientProvider).onSubscribed = (String message) {
                    onSubscriptioni(message, context);
                  };
                  try {
                    ref.read(mqttClientProvider).subscribe(
                          topicController.text,
                          MqttQos.atLeastOnce,
                        );
                  } catch (error) {
                    print(error);
                  }
                },

                // button decoration
                child: const Center(
                  child: Text(
                    'Subscribe',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
