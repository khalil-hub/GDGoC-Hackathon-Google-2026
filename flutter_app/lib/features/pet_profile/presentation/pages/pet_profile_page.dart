import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/pet_profile.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../application/pet_profile_provider.dart';
import '../../data/mock/mock_pet_data.dart';

class PetProfilePage extends ConsumerStatefulWidget {
  const PetProfilePage({super.key});

  @override
  ConsumerState<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends ConsumerState<PetProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _weightController = TextEditingController();
  final _neckController = TextEditingController();
  final _chestController = TextEditingController();
  final _backController = TextEditingController();

  final _breedFocus = FocusNode();
  String _unit = 'KG';

  @override
  void initState() {
    super.initState();
    final current = ref.read(petProfileProvider);
    _nameController.text = current.name;
    _breedController.text = current.breed;
    _weightController.text = current.weight.toString();
    _neckController.text = current.neckGirth.toString();
    _chestController.text = current.chestGirth.toString();
    _backController.text = current.backLength.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _neckController.dispose();
    _chestController.dispose();
    _backController.dispose();
    _breedFocus.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final next = PetProfile(
      id: '1',
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      weight: double.tryParse(_weightController.text.trim()) ?? 0,
      neckGirth: double.tryParse(_neckController.text.trim()) ?? 0,
      chestGirth: double.tryParse(_chestController.text.trim()) ?? 0,
      backLength: double.tryParse(_backController.text.trim()) ?? 0,
    );
    ref.read(petProfileProvider.notifier).saveProfile(next);
    Navigator.pushReplacementNamed(context, AppRouter.home);
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Take photo'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera integration pending'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Gallery integration pending'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final typedBreed = _breedController.text.trim().toLowerCase();
    final suggestions = typedBreed.isEmpty
        ? dogBreeds.take(5).toList()
        : dogBreeds
              .where((b) => b.toLowerCase().contains(typedBreed))
              .take(5)
              .toList();
    final showSuggestions = _breedFocus.hasFocus && suggestions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Pet Profile')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: PrimaryButton(
          label: 'Save Profile',
          icon: Icons.arrow_forward_rounded,
          onPressed: _saveProfile,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              const Text('Step 1 of 2'),
              const SizedBox(height: 4),
              const Text(
                'Tell us about your friend',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Provide accurate info for a perfect AI-powered fit.'),
              const SizedBox(height: 16),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFFCCFBF1),
                      child: Text('🐾', style: TextStyle(fontSize: 40)),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _showImageSourceSheet,
                        borderRadius: BorderRadius.circular(20),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: _showImageSourceSheet,
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Upload Pet Photo'),
              ),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  hintText: 'e.g. Buddy',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Pet name is required'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _breedController,
                focusNode: _breedFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  hintText: 'e.g. Golden Retriever',
                  suffixIcon: Icon(Icons.search_rounded),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Breed is required'
                    : null,
                onChanged: (_) => setState(() {}),
              ),
              if (showSuggestions)
                Card(
                  margin: const EdgeInsets.only(top: 6),
                  child: Column(
                    children: suggestions
                        .map(
                          (breed) => ListTile(
                            dense: true,
                            title: Text(breed),
                            onTap: () {
                              setState(() {
                                _breedController.text = breed;
                                _breedController.selection =
                                    TextSelection.collapsed(
                                      offset: breed.length,
                                    );
                              });
                              _breedFocus.unfocus();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        hintText: '0.0',
                      ),
                      validator: (value) {
                        final n = double.tryParse(value ?? '');
                        if (n == null || n <= 0) {
                          return 'Valid weight is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SegmentedButton<String>(
                    selected: {_unit},
                    onSelectionChanged: (set) =>
                        setState(() => _unit = set.first),
                    segments: const [
                      ButtonSegment(value: 'KG', label: Text('KG')),
                      ButtonSegment(value: 'LB', label: Text('LB')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  border: Border.all(color: const Color(0xFF99F6E4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Measurements',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRouter.sizeGuide),
                          icon: const Icon(Icons.help_outline_rounded),
                        ),
                      ],
                    ),
                    const Text(
                      'Accurate measurements help us find the best fit.',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _neckController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Neck Girth (cm)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _chestController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Chest Girth (cm)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _backController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Back Length (cm)',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF111827),
                    child: Icon(Icons.straighten_rounded, color: Colors.white),
                  ),
                  title: const Text(
                    'Not sure how to measure?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text('View visual guide'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.sizeGuide),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
