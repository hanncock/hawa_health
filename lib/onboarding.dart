import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Dash.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  DateTime? _dateOfBirth;
  DateTime? _lastMenstrualPeriod;
  String? _periodFrequency; // 'regular' or 'irregular'
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E9FF), // Light Deep Plum tint
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            
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

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? const Color(0xFF5C2A6B) // Deep Plum
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDobScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          
          // Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF5C2A6B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cake_outlined,
                size: 40,
                color: Color(0xFF5C2A6B),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            "When were you born?",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5C2A6B),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            "We need your date of birth to accurately calculate your cycle and provide personalized insights.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const Spacer(),
          
          // Date Picker Button
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF5C2A6B), // Deep Plum
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _dateOfBirth = picked;
                });
              }
            },
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _dateOfBirth != null
                    ? const Color(0xFF5C2A6B)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _dateOfBirth != null
                      ? const Color(0xFF5C2A6B)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _dateOfBirth != null
                      ? "${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}"
                      : "Tap to select date",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _dateOfBirth != null
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Next Button
          GestureDetector(
            onTap: _dateOfBirth != null ? _nextStep : null,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: _dateOfBirth != null
                    ? const Color(0xFF5C2A6B)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _dateOfBirth != null
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLmpScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          
          // Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF5C2A6B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop_outlined,
                size: 40,
                color: Color(0xFF5C2A6B),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            "When was your last period?",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5C2A6B),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            "This helps us track your cycle and predict your next period more accurately.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const Spacer(),
          
          // Date Picker Button
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 90)),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF5C2A6B), // Deep Plum
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _lastMenstrualPeriod = picked;
                });
              }
            },
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _lastMenstrualPeriod != null
                    ? const Color(0xFF5C2A6B)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _lastMenstrualPeriod != null
                      ? const Color(0xFF5C2A6B)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _lastMenstrualPeriod != null
                      ? "${_lastMenstrualPeriod!.day}/${_lastMenstrualPeriod!.month}/${_lastMenstrualPeriod!.year}"
                      : "Tap to select date",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _lastMenstrualPeriod != null
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Back & Next Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _previousStep,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF5C2A6B),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Back",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5C2A6B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: _lastMenstrualPeriod != null ? _nextStep : null,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _lastMenstrualPeriod != null
                          ? const Color(0xFF5C2A6B)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _lastMenstrualPeriod != null
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFrequencyScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          
          // Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF5C2A6B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 40,
                color: Color(0xFF5C2A6B),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            "How regular is your period?",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5C2A6B),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            "This helps us customize your cycle predictions and health insights.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const Spacer(),
          
          // Regular Option
          GestureDetector(
            onTap: () {
              setState(() {
                _periodFrequency = 'regular';
              });
            },
            child: Container(
              width: double.infinity,
              height: 70,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _periodFrequency == 'regular'
                    ? const Color(0xFF5C2A6B)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _periodFrequency == 'regular'
                      ? const Color(0xFF5C2A6B)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(
                    Icons.check_circle,
                    color: _periodFrequency == 'regular'
                        ? Colors.white
                        : Colors.grey[400],
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Regular",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _periodFrequency == 'regular'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "My cycles come at consistent intervals",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _periodFrequency == 'regular'
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Irregular Option
          GestureDetector(
            onTap: () {
              setState(() {
                _periodFrequency = 'irregular';
              });
            },
            child: Container(
              width: double.infinity,
              height: 70,
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: _periodFrequency == 'irregular'
                    ? const Color(0xFF5C2A6B)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _periodFrequency == 'irregular'
                      ? const Color(0xFF5C2A6B)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Icon(
                    Icons.help_outline,
                    color: _periodFrequency == 'irregular'
                        ? Colors.white
                        : Colors.grey[400],
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Irregular",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _periodFrequency == 'irregular'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "My cycles vary in length or timing",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _periodFrequency == 'irregular'
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Back & Complete Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _previousStep,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF5C2A6B),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Back",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5C2A6B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: _periodFrequency != null ? _completeOnboarding : null,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _periodFrequency != null
                          ? const Color(0xFF5C2A6B)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Complete",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _periodFrequency != null
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Save onboarding data and navigate to dashboard
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingCompletePage(),
      ),
    );
  }
}

// Onboarding complete page - navigates to dashboard
class OnboardingCompletePage extends StatelessWidget {
  const OnboardingCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C2A6B),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome!',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your profile is all set up',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HawaDashboardPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF5C2A6B),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
