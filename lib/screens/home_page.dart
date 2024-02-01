// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt/provider/mqtt_client_provider.dart';
import 'package:mqtt/screens/topic_screen.dart';
import 'dart:io';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MQTT Broker",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // connect to mqtt broker and then move to topic screen
            ref.read(mqttClientProvider).secure = true;
            ref.read(mqttClientProvider).securityContext =
                SecurityContext.defaultContext;
            ref.read(mqttClientProvider).keepAlivePeriod = 20;

            ref.read(mqttClientProvider).onConnected = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const TopicScreen();
                  },
                ),
              );
            };
            ref.read(mqttClientProvider).onDisconnected = () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broker Dissconnected'),
                ),
              );
            };

            try {
              await ref
                  .read(mqttClientProvider)
                  .connect('test_user', 'Abcd1234');
            } catch (error) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connection Failed'),
                ),
              );
            }

            // if (clientStatus!.state.toString() == 'connected') {
            //   // ignore: use_build_context_synchronously
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) {
            //         return const TopicScreen();
            //       },
            //     ),
            //   );
            // }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Text(
              'Connect to MQTT Broker',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
