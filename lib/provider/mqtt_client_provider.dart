import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final mqttClientProvider = StateProvider<MqttServerClient>(
  (ref) => MqttServerClient.withPort(
    // server details
    'b99b7426c3734558bc66a266411f83f3.s2.eu.hivemq.cloud',
    'Test',
    8883,
  ),
);
