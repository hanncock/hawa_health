import 'package:flutter/material.dart';

import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.cream,
      appBar: AppBar(
        title: Text('Care tips', style: HawaTypography.body(size: 18, weight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Guidance for every stage',
            style: HawaTypography.display('Guidance for every stage', size: 26),
          ),
          const SizedBox(height: 6),
          Text('Curated insights for your wellbeing', style: HawaTypography.bodySecondary(size: 14)),
          const SizedBox(height: 24),
          const HawaSectionTitle('Cycle Health'),
          const SizedBox(height: 12),
          _tip(
            '01',
            'Stay Hydrated',
            'Drinking water helps reduce bloating and cramps during your period.',
            Icons.water_drop_outlined,
          ),
          _tip(
            '02',
            'Track Your Symptoms',
            'Logging daily helps identify patterns and irregularities.',
            Icons.edit_note_outlined,
          ),
          const SizedBox(height: 20),
          const HawaSectionTitle('Self Care'),
          const SizedBox(height: 12),
          _tip(
            '03',
            'Gentle Exercise',
            'Light yoga or walking can alleviate pain and improve mood.',
            Icons.self_improvement,
          ),
          _tip(
            '04',
            'Heat Therapy',
            'A warm patch relaxes uterine muscles and eases discomfort.',
            Icons.local_fire_department_outlined,
          ),
          const SizedBox(height: 20),
          const HawaSectionTitle('Nutrition'),
          const SizedBox(height: 12),
          _tip(
            '05',
            'Iron-Rich Foods',
            'Replenish iron with leafy greens, beans, and lean meats.',
            Icons.restaurant_outlined,
          ),
          _tip(
            '06',
            'Limit Caffeine',
            'Reducing coffee can lower anxiety and breast tenderness.',
            Icons.coffee_outlined,
          ),
          const SizedBox(height: 16),
          const Center(child: HawaPrivacyBadge()),
        ],
      ),
    );
  }

  Widget _tip(String number, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: HawaCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: HawaTypography.display(number, size: 28, style: FontStyle.normal)
                  .copyWith(color: HawaColors.secondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: HawaColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(title, style: HawaTypography.body(size: 16, weight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(description, style: HawaTypography.bodySecondary(size: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
