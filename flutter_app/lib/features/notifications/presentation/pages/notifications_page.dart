import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_async_state_view.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../application/notifications_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: AppAsyncStateView(
        value: notifications,
        onRetry: () => ref.invalidate(notificationsProvider),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyStateView(
              title: 'No notifications yet',
              description:
                  'You will see order updates and AI recommendations here.',
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = items[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: n.backgroundColor,
                  child: Icon(n.icon, color: n.iconColor),
                ),
                title: Text(n.title),
                subtitle: Text(n.message),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRouter.home),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (n.unread)
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xFF14B8A6),
                      ),
                    Text(n.time, style: const TextStyle(fontSize: 11)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
