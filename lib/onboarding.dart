import 'package:flutter/material.dart';

import 'Dash.dart';
import 'api/hawa_api.dart';
import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';
import 'services/session_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  bool _submitting = false;
  DateTime? _dateOfBirth;
  DateTime? _lastMenstrualPeriod;
  String? _periodFrequency;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: HawaProgressBar(current: _currentStep, total: 3),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDobScreen(),
                  _buildLmpScreen(),
                  _buildFrequencyScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepShell({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget content,
    required List<Widget> actions,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: HawaColors.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: HawaColors.primary),
            ),
          ),
          const SizedBox(height: 32),
          Text(title, style: HawaTypography.display(title, size: 28)),
          const SizedBox(height: 10),
          Text(subtitle, style: HawaTypography.bodySecondary(size: 14)),
          const SizedBox(height: 28),
          content,
          const Spacer(),
          ...actions,
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDobScreen() {
    return _buildStepShell(
      icon: Icons.cake_outlined,
      title: 'When were you born?',
      subtitle: 'We use this to personalize your cycle insights — never shared without consent.',
      content: _DatePickerTile(
        value: _dateOfBirth,
        placeholder: 'Select your date of birth',
        onTap: () => _pickDate(
          initial: DateTime.now().subtract(const Duration(days: 365 * 25)),
          first: DateTime(1950),
          last: DateTime.now(),
          onPicked: (d) => setState(() => _dateOfBirth = d),
        ),
      ),
      actions: [
        HawaPrimaryButton(
          label: 'Continue',
          enabled: _dateOfBirth != null,
          onPressed: _nextStep,
        ),
      ],
    );
  }

  Widget _buildLmpScreen() {
    return _buildStepShell(
      icon: Icons.water_drop_outlined,
      title: 'Last period start?',
      subtitle: 'This helps us predict your next cycle with greater accuracy.',
      content: _DatePickerTile(
        value: _lastMenstrualPeriod,
        placeholder: 'Select last period date',
        onTap: () => _pickDate(
          initial: DateTime.now(),
          first: DateTime.now().subtract(const Duration(days: 90)),
          last: DateTime.now(),
          onPicked: (d) => setState(() => _lastMenstrualPeriod = d),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(child: HawaSecondaryButton(label: 'Back', onPressed: _previousStep)),
            const SizedBox(width: 12),
            Expanded(
              child: HawaPrimaryButton(
                label: 'Continue',
                enabled: _lastMenstrualPeriod != null,
                onPressed: _nextStep,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyScreen() {
    return _buildStepShell(
      icon: Icons.calendar_today_outlined,
      title: 'How regular is your cycle?',
      subtitle: 'Choose the option that best describes your experience.',
      content: Column(
        children: [
          _FrequencyOption(
            title: 'Regular',
            subtitle: 'Consistent intervals each month',
            icon: Icons.check_circle_outline,
            selected: _periodFrequency == 'regular',
            onTap: () => setState(() => _periodFrequency = 'regular'),
          ),
          const SizedBox(height: 12),
          _FrequencyOption(
            title: 'Irregular',
            subtitle: 'Cycles vary in length or timing',
            icon: Icons.help_outline,
            selected: _periodFrequency == 'irregular',
            onTap: () => setState(() => _periodFrequency = 'irregular'),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(child: HawaSecondaryButton(label: 'Back', onPressed: _previousStep)),
            const SizedBox(width: 12),
            Expanded(
              child: HawaPrimaryButton(
                label: 'Complete',
                enabled: _periodFrequency != null && !_submitting,
                onPressed: _completeOnboarding,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate({
    required DateTime initial,
    required DateTime first,
    required DateTime last,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(data: buildHawaTheme(), child: child!);
      },
    );
    if (picked != null) onPicked(picked);
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: HawaCurves.smooth,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: HawaCurves.smooth,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_lastMenstrualPeriod == null || _periodFrequency == null) return;

    setState(() => _submitting = true);
    try {
      final session = SessionService();
      final username = await session.getUsername();
      if (username == null) throw Exception('No active session');

      final api = HawaApi();
      const defaultPeriodLength = 5;
      final endDate = _lastMenstrualPeriod!.add(const Duration(days: defaultPeriodLength - 1));

      await api.createCycle(
        username,
        startDate: _lastMenstrualPeriod!,
        endDate: endDate,
        periodLength: defaultPeriodLength,
        status: _periodFrequency,
      );

      try {
        await api.predictForUser(username);
      } catch (_) {
        // Prediction may fail if insufficient cycle history.
      }

      await session.setOnboardingComplete(lastPeriodStart: _lastMenstrualPeriod);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingCompletePage(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: HawaCurves.smooth),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save onboarding: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final DateTime? value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HawaCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      color: value != null ? HawaColors.primary : HawaColors.white,
      child: Row(
        children: [
          Icon(
            Icons.event_outlined,
            color: value != null ? HawaColors.white : HawaColors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value != null
                  ? '${value!.day}/${value!.month}/${value!.year}'
                  : placeholder,
              style: HawaTypography.body(
                size: 16,
                weight: FontWeight.w600,
                color: value != null ? HawaColors.white : HawaColors.ink60,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: value != null ? HawaColors.white : HawaColors.ink60,
          ),
        ],
      ),
    );
  }
}

class _FrequencyOption extends StatelessWidget {
  const _FrequencyOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HawaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      color: selected ? HawaColors.primary : HawaColors.white,
      child: Row(
        children: [
          Icon(icon, color: selected ? HawaColors.white : HawaColors.secondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: HawaTypography.body(
                    size: 16,
                    weight: FontWeight.w700,
                    color: selected ? HawaColors.white : HawaColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: HawaTypography.body(
                    size: 12,
                    color: selected ? HawaColors.white.withValues(alpha: 0.85) : HawaColors.ink60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingCompletePage extends StatefulWidget {
  const OnboardingCompletePage({super.key});

  @override
  State<OnboardingCompletePage> createState() => _OnboardingCompletePageState();
}

class _OnboardingCompletePageState extends State<OnboardingCompletePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _controller, curve: HawaCurves.spring);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: HawaColors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, size: 52, color: HawaColors.white),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'You\'re all set',
                style: HawaTypography.display('You\'re all set', size: 34).copyWith(
                  color: HawaColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your personalized care journey begins now',
                style: HawaTypography.body(
                  size: 15,
                  color: HawaColors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HawaDashboardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HawaColors.white,
                    foregroundColor: HawaColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HawaRadius.pill),
                    ),
                    textStyle: HawaTypography.body(size: 16, weight: FontWeight.w700, color: HawaColors.primary),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Privacy first — your data stays yours',
                style: HawaTypography.body(
                  size: 12,
                  color: HawaColors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
