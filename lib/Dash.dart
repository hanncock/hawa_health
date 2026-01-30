import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'day_info.dart';

class HawaDashboardPage extends StatefulWidget {
  const HawaDashboardPage({super.key});

  @override
  State<HawaDashboardPage> createState() => _HawaDashboardPageState();
}

class _HawaDashboardPageState extends State<HawaDashboardPage> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _generateDateList() {
    List<DateTime> dates = [];
    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
    for (int i = 0; i < 60; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  String _formatDate(DateTime date) {
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _formatDay(DateTime date) {
    return date.day.toString();
  }

  bool _isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Navigate to different pages based on index
    switch (index) {
      case 0:
        // Already on main dashboard
        break;
      case 1:
        // Navigate to Tips page
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TipsPage()));
        break;
      case 2:
        // Navigate to Add/Log page
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddLogPage()));
        break;
      case 3:
        // Navigate to Report page
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportPage()));
        break;
      case 4:
        // Navigate to Profile page
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
        break;
    }
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Smart health. Every woman. Every stage",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF5C2A6B), // Deep Plum
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Today, January 14",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Dynamic Date Selector
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _generateDateList().length,
                        itemBuilder: (context, index) {
                          final date = _generateDateList()[index];
                          final isSelected = _isToday(date);
                          final isCurrentSelected = _selectedDate.day == date.day && 
                                                   _selectedDate.month == date.month && 
                                                   _selectedDate.year == date.year;
                          
                          return GestureDetector(
                            onTap: () {
                              _onDateSelected(date);
                              _showDayInfoModal();
                            },
                            child: Container(
                              width: 50,
                              height: 65,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isCurrentSelected
                                    ? const Color(0xFFF5E9FF) // Light plum tint
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isCurrentSelected
                                      ? const Color(0xFF5C2A6B) // Deep Plum
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatDate(date),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _formatDay(date),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isCurrentSelected
                                          ? const Color(0xFF5C2A6B) // Deep Plum
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Period Hexagon Display Section
                    GestureDetector(
                      onTap: _showDayInfoModal,
                      child: Container(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background image from assets
                            Image.asset(
                              'assets/dashbg.png',
                              width: 280,
                              height: 280,
                              fit: BoxFit.contain,
                            ),
                            
                            // Text content
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Period:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5C2A6B), // Deep Plum
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Day 3",
                                  style: GoogleFonts.poppins(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF5BAA), // Rose Magenta
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Medium Chance to getting pregnant",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF5C2A6B), // Deep Plum
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Quick View Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quick view",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Edit",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF5C2A6B), // Deep Plum
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Quick View Icons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickViewItem("Protected Sex", Icons.favorite_border),
                        _buildQuickViewItem("Happy", Icons.emoji_emotions_outlined),
                        _buildQuickViewItem("Drink Water", Icons.water_drop_outlined),
                        _buildQuickViewItem("Very Heavy", Icons.bloodtype_outlined),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        buttonBackgroundColor: const Color(0xFF5C2A6B),
        backgroundColor: Colors.transparent,
        color: const Color(0xFF5C2A6B),
        onTap: _onBottomNavTapped,
        items: const [
          Icon(Icons.home_outlined, size: 24, color: Colors.white),
          Icon(Icons.lightbulb_outline, size: 24, color: Colors.white),
          Icon(Icons.add, size: 28, color: Colors.white),
          Icon(Icons.insert_chart_outlined, size: 24, color: Colors.white),
          Icon(Icons.person_outline, size: 24, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildQuickViewItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFF5E9FF), // Light Deep Plum tint
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF5C2A6B), size: 24), // Deep Plum
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Custom painter for hexagonal period display matching the image
class HexagonPeriodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          const Color(0xFFFFF0F5), // Soft light pink
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFFFF5BAA) // Rose Magenta border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 - 30;

    // Create hexagon points
    final points = List.generate(6, (i) {
      final angle = (i * 60.0) * (pi / 180.0);
      return Offset(
        centerX + radius * cos(angle),
        centerY + radius * sin(angle),
      );
    });

    // Create rounded hexagon path
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Add pink dot and line extending from bottom point
    final dotPaint = Paint()
      ..color = const Color(0xFFFF5BAA)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFFFF5BAA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Calculate bottom point (index 3 in the hexagon)
    final bottomPoint = points[3];

    // Draw extending line from bottom point
    canvas.drawLine(
      Offset(bottomPoint.dx, bottomPoint.dy + 5),
      Offset(bottomPoint.dx + 25, bottomPoint.dy + 30),
      linePaint,
    );

    // Draw small dot at the end of the line
    canvas.drawCircle(
      Offset(bottomPoint.dx + 25, bottomPoint.dy + 30),
      3,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for light gray speech bubble
class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]! // Light gray
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Create rounded rectangular bubble with pointer
    final path = Path();
    
    // Main bubble body
    path.addRRect(RRect.fromLTRBR(
      0, 0, size.width - 15, size.height - 8,
      const Radius.circular(12),
    ));
    
    // Pointer/tail pointing down and slightly right
    path.moveTo(size.width - 15, size.height - 15);
    path.lineTo(size.width - 3, size.height - 8);
    path.lineTo(size.width - 15, size.height - 3);
    path.close();

    // Draw shadow first
    canvas.drawPath(path, shadowPaint);
    
    // Draw main bubble
    canvas.drawPath(path, paint);

    // Add text content
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Will end in 4 days\n",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: "Tuesday, 17 September",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(12, (size.height - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Placeholder pages for navigation
class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips'),
        backgroundColor: const Color(0xFF5C2A6B),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Tips Page\n\nHealth tips and advice will be displayed here.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class AddLogPage extends StatelessWidget {
  const AddLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Log'),
        backgroundColor: const Color(0xFF5C2A6B),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Add Log Page\n\nLog your health data here.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color(0xFF5C2A6B),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Reports Page\n\nYour health reports and analytics will be displayed here.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF5C2A6B), width: 4),
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(File(_profileImage!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF5C2A6B),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF6B9A),
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Jane Doe',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'jane.doe@example.com',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // User Bio Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bio Data',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C2A6B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.cake_outlined,
                    label: 'Date of Birth',
                    value: 'March 15, 1995',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: '+1 (555) 123-4567',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: 'New York, USA',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'Last Period',
                    value: 'January 14, 2024',
                  ),

                  const SizedBox(height: 32),
                  Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C2A6B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    child: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (value) {
                        // Will be handled by theme provider
                      },
                      activeColor: const Color(0xFF5C2A6B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5C2A6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5C2A6B),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String label,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5C2A6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5C2A6B),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          if (child != null) child,
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }
}
