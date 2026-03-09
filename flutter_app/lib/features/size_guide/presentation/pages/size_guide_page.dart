import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';

class SizeGuidePage extends StatelessWidget {
  const SizeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('XS', '20-25', '30-35', '20-25'),
      ('S', '25-30', '35-45', '25-30'),
      ('M', '30-40', '45-60', '30-40'),
      ('L', '40-50', '60-75', '40-50'),
      ('XL', '50-60', '75-90', '50-60'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Size Guide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Measure neck, chest, and back length while your pet is standing for best results.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Size')),
              DataColumn(label: Text('Neck')),
              DataColumn(label: Text('Chest')),
              DataColumn(label: Text('Back')),
            ],
            rows: rows
                .map(
                  (r) => DataRow(
                    cells: [
                      DataCell(Text(r.$1)),
                      DataCell(Text(r.$2)),
                      DataCell(Text(r.$3)),
                      DataCell(Text(r.$4)),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.petProfile),
            child: const Text('Update Pet Measurements'),
          ),
        ],
      ),
    );
  }
}
