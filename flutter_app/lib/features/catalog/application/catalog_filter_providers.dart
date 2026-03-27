import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoryProvider = StateProvider<String>((_) => 'all');
final homeTabProvider = StateProvider<String>((_) => 'newest');
final searchQueryProvider = StateProvider<String>((_) => '');
