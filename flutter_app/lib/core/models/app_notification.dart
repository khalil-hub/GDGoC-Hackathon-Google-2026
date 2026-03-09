import 'package:flutter/material.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.unread = false,
  });

  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool unread;
}
