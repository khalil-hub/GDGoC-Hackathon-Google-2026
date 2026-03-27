import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pet_profile.dart';
import '../data/mock/mock_pet_data.dart';

final petProfileProvider =
    StateNotifierProvider<PetProfileNotifier, PetProfile>(
      (ref) => PetProfileNotifier(),
    );

class PetProfileNotifier extends StateNotifier<PetProfile> {
  PetProfileNotifier() : super(defaultPetProfile);

  void saveProfile(PetProfile next) {
    state = next;
  }
}
