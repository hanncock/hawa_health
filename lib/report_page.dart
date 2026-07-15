import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'api/hawa_api.dart';
import 'api/models.dart';
import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';
import 'services/session_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _api = HawaApi();
  final _session = SessionService();

  bool _loading = true;
  String? _error;
  UserCyclesModel? _cycles;
  PredictionModel? _prediction;
  List<SymptomLogModel> _symptoms = [];

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final username = await _session.getUsername();
      if (username == null) throw Exception('Not signed in');

      final cycles = await _api.getCycles(username);
      PredictionModel? prediction;
      try {
        prediction = await _api.latestPrediction(username);
      } catch (_) {}

      List<SymptomLogModel> symptoms = [];
      try {
        symptoms = await _api.getUserSymptoms(username);
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _cycles = cycles;
        _prediction = prediction;
        _symptoms = symptoms;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Map<String, double> _symptomFrequency() {
    if (_symptoms.isEmpty) return {};

    final counts = <String, int>{};
    for (final log in _symptoms) {
      if (log.headache) counts['Headache'] = (counts['Headache'] ?? 0) + 1;
      if (log.acneFlare) counts['Acne'] = (counts['Acne'] ?? 0) + 1;
      if (log.bloating == 'HIGH') counts['Bloating'] = (counts['Bloating'] ?? 0) + 1;
      if (log.fatigue == 'HIGH') counts['Fatigue'] = (counts['Fatigue'] ?? 0) + 1;
      if (log.bleeding == 'HIGH') counts['Heavy flow'] = (counts['Heavy flow'] ?? 0) + 1;
    }

    final total = _symptoms.length;
    return counts.map((k, v) => MapEntry(k, v / total));
  }

  @override
  Widget build(BuildContext context) {
    final prediction = _prediction;
    final cycleRecords = _cycles?.cycleRecords ?? [];
    final freq = _symptomFrequency();

    return Scaffold(
      backgroundColor: HawaColors.cream,
      appBar: AppBar(
        title: Text('Health report', style: HawaTypography.body(size: 18, weight: FontWeight.w600)),
        actions: [
          IconButton(onPressed: _loadReport, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: HawaColors.primary))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Could not load report', style: HawaTypography.body(weight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(_error!, style: HawaTypography.bodySecondary(size: 13), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        HawaPrimaryButton(label: 'Retry', onPressed: _loadReport),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      'Your cycle at a glance',
                      style: HawaTypography.display('Your cycle at a glance', size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text('Insights from your API data', style: HawaTypography.bodySecondary(size: 14)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [HawaColors.primary, Color(0xFF7A3D8C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(HawaRadius.large),
                        boxShadow: HawaShadows.card,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat(
                            prediction != null ? '${prediction.predictedCycleLength}d' : '—',
                            'Avg cycle',
                          ),
                          _divider(),
                          _stat(
                            prediction != null ? '${prediction.predictedPeriodLength}d' : '—',
                            'Avg period',
                          ),
                          _divider(),
                          _stat(
                            prediction?.confidenceLevel ?? 'N/A',
                            'Confidence',
                          ),
                        ],
                      ),
                    ),
                    if (prediction != null) ...[
                      const SizedBox(height: 16),
                      HawaCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Next period forecast', style: HawaTypography.body(size: 15, weight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(
                              '${DateFormat.yMMMd().format(prediction.nextPeriodStart)} – ${DateFormat.yMMMd().format(prediction.nextPeriodEnd)}',
                              style: HawaTypography.bodySecondary(size: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Algorithm: ${prediction.algorithmUsed}',
                              style: HawaTypography.bodySecondary(size: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    const HawaSectionTitle('Cycle history'),
                    const SizedBox(height: 12),
                    if (cycleRecords.isEmpty)
                      Text('No cycles logged yet.', style: HawaTypography.bodySecondary(size: 14))
                    else
                      ...cycleRecords.reversed.take(5).map(_historyTile),
                    const SizedBox(height: 28),
                    const HawaSectionTitle('Symptom frequency'),
                    const SizedBox(height: 12),
                    if (freq.isEmpty)
                      Text('Log symptoms to see frequency trends.', style: HawaTypography.bodySecondary(size: 14))
                    else
                      ...freq.entries.map((e) => _bar(e.key, e.value)),
                    const SizedBox(height: 16),
                    const Center(child: HawaPrivacyBadge()),
                  ],
                ),
    );
  }

  Widget _historyTile(CycleModel cycle) {
    final range = '${DateFormat.MMMd().format(cycle.startDate)} – ${DateFormat.MMMd().format(cycle.endDate)}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HawaCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(range, style: HawaTypography.body(size: 15, weight: FontWeight.w700)),
                  Text('Cycle period', style: HawaTypography.bodySecondary(size: 12)),
                ],
              ),
            ),
            _mini(Icons.water_drop_outlined, '${cycle.periodLengthDays} days'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: HawaTypography.body(size: 20, weight: FontWeight.w700, color: HawaColors.white)),
        const SizedBox(height: 4),
        Text(label, style: HawaTypography.body(size: 11, color: HawaColors.white.withValues(alpha: 0.8))),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 36, color: HawaColors.white.withValues(alpha: 0.25));

  Widget _mini(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: HawaColors.ink60),
        const SizedBox(width: 4),
        Text(text, style: HawaTypography.bodySecondary(size: 13)),
      ],
    );
  }

  Widget _bar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: HawaTypography.body(size: 14, weight: FontWeight.w500)),
              Text('${(value * 100).toInt()}%', style: HawaTypography.bodySecondary(size: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(HawaRadius.pill),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: HawaColors.creamDark,
              color: HawaColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
