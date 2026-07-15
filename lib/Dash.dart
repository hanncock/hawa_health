import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'add_log_page.dart';
import 'api/hawa_api.dart';
import 'api/models.dart';
import 'day_info.dart';
import 'design/hawa_components.dart';
import 'design/hawa_design_system.dart';
import 'login_page.dart';
import 'report_page.dart';
import 'services/auth_service.dart';
import 'services/session_service.dart';
import 'tips_page.dart';

class HawaDashboardPage extends StatefulWidget {
  const HawaDashboardPage({super.key});

  @override
  State<HawaDashboardPage> createState() => _HawaDashboardPageState();
}

class _HawaDashboardPageState extends State<HawaDashboardPage> {
  int _selectedIndex = 0;
  int _selectedChip = 0;
  DateTime _selectedDate = DateTime.now();
  late final ScrollController _scrollController;

  final _api = HawaApi();
  final _session = SessionService();

  UserModel? _user;
  bool _loading = true;
  String? _error;

  int? _periodDay;
  String _fertilityLabel = 'Loading insights…';
  String _periodEndsLabel = '';

  static const _topics = [
    'Fertility',
    'Pregnancy',
    'Perimenopause',
    'Cycle',
    'Wellness',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final username = await _session.getUsername();
      if (username == null) throw Exception('Not signed in');

      final user = await _api.getUser(username);
      PredictionModel? prediction;
      try {
        prediction = await _api.latestPrediction(username);
      } catch (_) {
        try {
          prediction = await _api.predictForUser(username);
        } catch (_) {}
      }

      final lastPeriod = await _session.getLastPeriodStart();
      int? periodDay;
      String fertility = 'Track your cycle for insights';
      String endsLabel = '';

      if (lastPeriod != null) {
        final daysSince = DateTime.now().difference(
          DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day),
        ).inDays;
        if (daysSince >= 0 && daysSince < (prediction?.predictedPeriodLength ?? 7)) {
          periodDay = daysSince + 1;
          final remaining = (prediction?.predictedPeriodLength ?? 5) - periodDay;
          endsLabel = remaining > 0 ? 'Ends in ~$remaining days' : 'Period ending soon';
        }
      }

      if (prediction != null) {
        fertility = '${prediction.confidenceLevel} confidence · ${prediction.predictedCycleLength}d cycle';
      }

      if (!mounted) return;
      setState(() {
        _user = user;
        _periodDay = periodDay;
        _fertilityLabel = fertility;
        _periodEndsLabel = endsLabel;
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

  String get _displayName => _user?.username ?? 'there';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _generateDateList() {
    final start = DateTime.now().subtract(const Duration(days: 30));
    return List.generate(60, (i) => start.add(Duration(days: i)));
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, _smoothRoute(const TipsPage()));
        break;
      case 2:
        Navigator.push(context, _smoothRoute(const AddLogPage()));
        break;
      case 3:
        Navigator.push(context, _smoothRoute(const ReportPage()));
        break;
      case 4:
        Navigator.push(context, _smoothRoute(const ProfilePage()));
        break;
    }
  }

  PageRouteBuilder<T> _smoothRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: HawaCurves.smooth)),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  void _showDayInfoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayInfoPage(selectedDate: _selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.cream,
      floatingActionButton: HawaFab(
        icon: Icons.water_drop_outlined,
        onPressed: () => Navigator.push(context, _smoothRoute(const AddLogPage())),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: HawaColors.primary))
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Could not load dashboard', style: HawaTypography.body(weight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(_error!, style: HawaTypography.bodySecondary(size: 13), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          HawaPrimaryButton(label: 'Retry', onPressed: _loadDashboardData),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${greetingForTime()}, $_displayName',
                      style: HawaTypography.display('${greetingForTime()}, $_displayName', size: 30),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your cycle today',
                      style: HawaTypography.bodySecondary(size: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: HawaCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Period · Day ${_periodDay ?? '—'}', style: HawaTypography.body(size: 13, color: HawaColors.ink60)),
                            const SizedBox(height: 6),
                            Text(
                              _fertilityLabel,
                              style: HawaTypography.body(size: 18, weight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _periodEndsLabel.isNotEmpty ? _periodEndsLabel : 'Log symptoms for better predictions',
                              style: HawaTypography.bodySecondary(size: 13),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _showDayInfoModal,
                        child: SizedBox(
                          width: 88,
                          height: 88,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset('assets/dashbg.png', fit: BoxFit.contain),
                              Text(
                                '${_periodDay ?? '—'}',
                                style: HawaTypography.body(
                                  size: 32,
                                  weight: FontWeight.w700,
                                  color: HawaColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: _topics.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    return HawaChip(
                      label: _topics[i],
                      selected: _selectedChip == i,
                      onTap: () => setState(() => _selectedChip = i),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('This week', style: HawaTypography.body(size: 16, weight: FontWeight.w700)),
                    Text(
                      DateFormat.MMMd().format(DateTime.now()),
                      style: HawaTypography.body(size: 13, color: HawaColors.primary, weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 76,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _generateDateList().length,
                  itemBuilder: (context, index) {
                    final date = _generateDateList()[index];
                    final selected = _selectedDate.year == date.year &&
                        _selectedDate.month == date.month &&
                        _selectedDate.day == date.day;
                    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedDate = date);
                        _showDayInfoModal();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: HawaCurves.smooth,
                        width: 52,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: selected ? HawaColors.primary : HawaColors.creamDark,
                          borderRadius: BorderRadius.circular(HawaRadius.medium),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekdays[date.weekday - 1],
                              style: HawaTypography.body(
                                size: 11,
                                color: selected ? HawaColors.white.withValues(alpha: 0.8) : HawaColors.ink60,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${date.day}',
                              style: HawaTypography.body(
                                size: 16,
                                weight: FontWeight.w700,
                                color: selected ? HawaColors.white : HawaColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    HawaFeatureCard(
                      number: '01',
                      title: 'Track symptoms',
                      subtitle: 'Log flow, mood & more daily',
                      onTap: () => Navigator.push(context, _smoothRoute(const AddLogPage())),
                    ),
                    const SizedBox(height: 12),
                    HawaFeatureCard(
                      number: '02',
                      title: 'Health insights',
                      subtitle: 'Patterns across your cycles',
                      onTap: () => Navigator.push(context, _smoothRoute(const ReportPage())),
                    ),
                    const SizedBox(height: 12),
                    HawaFeatureCard(
                      number: '03',
                      title: 'Care tips',
                      subtitle: 'Guidance for every stage',
                      onTap: () => Navigator.push(context, _smoothRoute(const TipsPage())),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quick view', style: HawaTypography.body(size: 16, weight: FontWeight.w700)),
                    Text('Edit', style: HawaTypography.body(size: 13, color: HawaColors.primary, weight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _quickViewItem('Protected', Icons.favorite_border),
                    _quickViewItem('Happy', Icons.emoji_emotions_outlined),
                    _quickViewItem('Hydrated', Icons.water_drop_outlined),
                    _quickViewItem('Heavy', Icons.bloodtype_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: HawaPrivacyBadge()),
              const SizedBox(height: 88),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HawaBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _quickViewItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: HawaColors.creamDark,
            borderRadius: BorderRadius.circular(HawaRadius.pill),
          ),
          child: Icon(icon, color: HawaColors.primary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: HawaTypography.bodySecondary(size: 11), textAlign: TextAlign.center),
      ],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileImage;
  final _auth = AuthService();
  final _session = SessionService();
  UserModel? _user;
  DateTime? _lastPeriod;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await _session.loadUser();
    final lastPeriod = await _session.getLastPeriodStart();
    if (mounted) {
      setState(() {
        _user = user;
        _lastPeriod = lastPeriod;
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _profileImage = image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HawaColors.cream,
      appBar: AppBar(
        title: Text('Profile', style: HawaTypography.body(size: 18, weight: FontWeight.w600)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: HawaColors.primary))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            HawaCard(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: HawaColors.secondary, width: 3),
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(File(_profileImage!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? const Icon(Icons.person_outline, size: 52, color: HawaColors.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: HawaColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(color: HawaColors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, size: 16, color: HawaColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user?.username ?? 'User',
                    style: HawaTypography.display(_user?.username ?? 'User', size: 26, style: FontStyle.normal),
                  ),
                  const SizedBox(height: 4),
                  Text(_user?.email ?? '', style: HawaTypography.bodySecondary(size: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: HawaSectionTitle('Bio Data'),
            ),
            const SizedBox(height: 12),
            _infoTile(Icons.cake_outlined, 'Age', '${_user?.age ?? '—'} years'),
            const SizedBox(height: 10),
            _infoTile(Icons.phone_outlined, 'Phone', _user?.phone ?? 'Not set'),
            const SizedBox(height: 10),
            _infoTile(
              Icons.calendar_today_outlined,
              'Last Period',
              _lastPeriod != null ? DateFormat.yMMMd().format(_lastPeriod!) : 'Not set',
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: HawaSectionTitle('Settings'),
            ),
            const SizedBox(height: 12),
            HawaCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: HawaColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(HawaRadius.small),
                    ),
                    child: const Icon(Icons.shield_outlined, color: HawaColors.primary, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy', style: HawaTypography.body(size: 15, weight: FontWeight.w600)),
                        Text('End-to-end encrypted', style: HawaTypography.bodySecondary(size: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: HawaColors.ink60),
                ],
              ),
            ),
            const SizedBox(height: 12),
            HawaSecondaryButton(label: 'Sign out', onPressed: _logout),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return HawaCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: HawaColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(HawaRadius.small),
            ),
            child: Icon(icon, color: HawaColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: HawaTypography.bodySecondary(size: 12)),
                Text(value, style: HawaTypography.body(size: 15, weight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
