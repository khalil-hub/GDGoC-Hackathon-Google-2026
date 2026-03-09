import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/demo_state.dart';

final demoStateProvider = StateProvider<DemoState>((_) => DemoState.normal);
