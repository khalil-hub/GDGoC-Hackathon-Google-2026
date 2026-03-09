import 'package:flutter/material.dart';

class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.logo,
    required this.color,
  });

  final String id;
  final String name;
  final String logo;
  final Color color;
}
