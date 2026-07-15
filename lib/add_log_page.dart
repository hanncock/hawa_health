import 'package:flutter/material.dart';

import 'api/hawa_api.dart';
import 'api/symptom_mapper.dart';
import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';
import 'mock_data.dart';
import 'services/session_service.dart';

class AddLogPage extends StatefulWidget {
  const AddLogPage({super.key});

  @override
  State<AddLogPage> createState() => _AddLogPageState();
}

class _AddLogPageState extends State<AddLogPage> {
  DateTime _selectedDate = DateTime.now();
  FlowIntensity? _selectedFlow;
  Mood? _selectedMood;
  final List<String> _selectedSymptoms = [];
  final TextEditingController _notesController = TextEditingController();

  final _api = HawaApi();
  final _session = SessionService();
  bool _saving = false;

  static const _symptoms = [
    'Cramps', 'Headache', 'Bloating', 'Fatigue', 'Acne',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveLog() async {
    setState(() => _saving = true);
    try {
      final username = await _session.getUsername();
      if (username == null) throw Exception('Not signed in');

      final cycles = await _api.getCycles(username);
      if (cycles.cycleRecords.isEmpty) {
        throw Exception('No cycle found. Complete onboarding first.');
      }

      final cycleId = cycles.cycleRecords.last.id;
      final fieldMap = <String, String>{};
      var headache = false;
      var acneFlare = false;

      for (final symptom in _selectedSymptoms) {
        final field = SymptomMapper.symptomToField(symptom);
        if (field == 'headache') headache = true;
        if (field == 'acne') acneFlare = true;
        if (field == 'pain') fieldMap['painLevel'] = 'HIGH';
        if (field == 'bloating') fieldMap['bloating'] = 'HIGH';
        if (field == 'fatigue') fieldMap['fatigue'] = 'HIGH';
      }

      await _api.addSymptom(
        username,
        cycleId: cycleId,
        bleeding: SymptomMapper.flowToBleeding(_selectedFlow),
        mood: SymptomMapper.moodToIntensity(_selectedMood),
        fatigue: fieldMap['fatigue'],
        bloating: fieldMap['bloating'],
        painLevel: fieldMap['painLevel'],
        headache: headache,
        acneFlare: acneFlare,
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: HawaColors.white, size: 20),
              const SizedBox(width: 10),
              Text('Log saved', style: HawaTypography.body(color: HawaColors.white, weight: FontWeight.w600)),
            ],
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save log: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.cream,
      appBar: AppBar(
        title: Text('Log health', style: HawaTypography.body(size: 18, weight: FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: _saving ? null : _saveLog,
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: HawaColors.creamDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedDate.day} ${_month(_selectedDate.month)} ${_selectedDate.year}',
                    style: HawaTypography.body(size: 17, weight: FontWeight.w700, color: HawaColors.primary),
                  ),
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_outlined, color: HawaColors.primary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section('Menstrual Flow'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: FlowIntensity.values.map((flow) {
                      final label = flow.name[0].toUpperCase() + flow.name.substring(1);
                      return HawaChip(
                        label: label,
                        selected: _selectedFlow == flow,
                        onTap: () => setState(() {
                          _selectedFlow = _selectedFlow == flow ? null : flow;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  _section('Mood'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Mood.values.map((mood) {
                      final label = mood.name[0].toUpperCase() + mood.name.substring(1);
                      return HawaChip(
                        label: label,
                        selected: _selectedMood == mood,
                        onTap: () => setState(() {
                          _selectedMood = _selectedMood == mood ? null : mood;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  _section('Symptoms'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptoms.map((symptom) {
                      final selected = _selectedSymptoms.contains(symptom);
                      return HawaChip(
                        label: symptom,
                        selected: selected,
                        onTap: () => setState(() {
                          if (selected) {
                            _selectedSymptoms.remove(symptom);
                          } else {
                            _selectedSymptoms.add(symptom);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  _section('Notes'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    style: HawaTypography.body(size: 15),
                    decoration: InputDecoration(
                      hintText: 'Anything else to note today?',
                      hintStyle: HawaTypography.body(color: HawaColors.ink60),
                      filled: true,
                      fillColor: HawaColors.white,
                      border: UnderlineInputBorder(borderSide: BorderSide(color: HawaColors.ink12)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: HawaColors.ink12)),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: HawaColors.primary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  HawaPrimaryButton(
                    label: _saving ? 'Saving…' : 'Save log',
                    enabled: !_saving,
                    onPressed: _saveLog,
                  ),
                  const SizedBox(height: 16),
                  const Center(child: HawaPrivacyBadge()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Text(title, style: HawaTypography.body(size: 17, weight: FontWeight.w700));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: buildHawaTheme(), child: child!),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}
