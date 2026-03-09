import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/demo_state_provider.dart';
import '../../../core/models/app_notification.dart';
import '../../../core/models/demo_state.dart';
import '../data/mock/mock_notifications.dart';

final notificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  final mode = ref.watch(demoStateProvider);
  await Future<void>.delayed(const Duration(milliseconds: 240));
  if (mode == DemoState.error) {
    throw Exception('Failed to fetch notifications.');
  }
  if (mode == DemoState.empty) {
    return const <AppNotification>[];
  }
  return mockNotifications;
});
