import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';

class DayInfoPage extends StatefulWidget {
  final DateTime selectedDate;

  const DayInfoPage({super.key, required this.selectedDate});

  @override
  State<DayInfoPage> createState() => _DayInfoPageState();
}

class _DayInfoPageState extends State<DayInfoPage> {
  int _selectedTabIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: HawaColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(HawaRadius.large)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: HawaColors.ink12,
              borderRadius: BorderRadius.circular(HawaRadius.pill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: HawaColors.ink),
                ),
                Expanded(
                  child: Text(
                    'Day details',
                    textAlign: TextAlign.center,
                    style: HawaTypography.body(size: 18, weight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share_outlined, color: HawaColors.ink),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _tab('Logs', 0),
                const SizedBox(width: 8),
                _tab('Cycles', 1),
                const SizedBox(width: 8),
                _tab('Timeline', 2),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  DateFormat.yMMMM().format(widget.selectedDate),
                  style: HawaTypography.body(size: 16, weight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: HawaColors.ink60, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(alignment: Alignment.centerLeft, child: HawaPrivacyBadge()),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                _logEntry(widget.selectedDate),
                const SizedBox(height: 12),
                _logEntry(widget.selectedDate.add(const Duration(days: 1))),
                const SizedBox(height: 12),
                _logEntry(widget.selectedDate.add(const Duration(days: 2))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final selected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: HawaCurves.smooth,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? HawaColors.primary : HawaColors.creamDark,
            borderRadius: BorderRadius.circular(HawaRadius.pill),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: HawaTypography.body(
              size: 13,
              weight: FontWeight.w600,
              color: selected ? HawaColors.white : HawaColors.ink60,
            ),
          ),
        ),
      ),
    );
  }

  Widget _logEntry(DateTime date) {
    return HawaCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text('${date.day}'.padLeft(2, '0'), style: HawaTypography.body(size: 24, weight: FontWeight.w700)),
              Text(DateFormat.MMM().format(date), style: HawaTypography.bodySecondary(size: 11)),
              Text('${date.year}', style: HawaTypography.bodySecondary(size: 11)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: HawaColors.primary,
                  borderRadius: BorderRadius.circular(HawaRadius.pill),
                ),
                child: Text('+ Add', style: HawaTypography.body(size: 10, weight: FontWeight.w600, color: HawaColors.white)),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [
                _metric(Icons.water_drop_outlined, 'Flow', HawaColors.accent),
                const SizedBox(height: 8),
                _metric(Icons.favorite_border, 'Intercourse', HawaColors.secondary),
                const SizedBox(height: 8),
                _metric(Icons.psychology_outlined, 'Mood', HawaColors.accent),
                const SizedBox(height: 8),
                _valueRow('Weight', '43 kg'),
                const SizedBox(height: 8),
                _valueRow('Temperature', '98° F'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(HawaRadius.pill),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 10),
        Text(label, style: HawaTypography.body(size: 14, weight: FontWeight.w500)),
      ],
    );
  }

  Widget _valueRow(String label, String value) {
    return Row(
      children: [
        const SizedBox(width: 38),
        Text(label, style: HawaTypography.body(size: 14)),
        const Spacer(),
        Text(value, style: HawaTypography.body(size: 14, weight: FontWeight.w700)),
      ],
    );
  }
}
