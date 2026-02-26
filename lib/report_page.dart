import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mock_data.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    // Just grab some logs to display recent history
    final recentLogs = MockData.getLogForDate(DateTime.now()); // simplified usage for demo

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
        title: Text(
          'Health Report',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF5C2A6B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5C2A6B), Color(0xFF8A4D9E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C2A6B).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryStat("Avg Cycle", "${user.cycleLength} Days"),
                  Container(width: 1, height: 40, color: Colors.white30),
                  _buildSummaryStat("Avg Period", "${user.periodLength} Days"),
                  Container(width: 1, height: 40, color: Colors.white30),
                  _buildSummaryStat("Regularity", user.isRegular ? "Regular" : "Irregular"),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            _buildSectionTitle("Cycle History"),
            const SizedBox(height: 15),
            
            // Mock Cycle History List
            _buildCycleHistoryItem("Jan 14 - Jan 18", "28 Days", "5 Days"),
            _buildCycleHistoryItem("Dec 17 - Dec 21", "29 Days", "5 Days"),
            _buildCycleHistoryItem("Nov 18 - Nov 22", "27 Days", "5 Days"),

            const SizedBox(height: 30),

            _buildSectionTitle("Symptom Frequency"),
            const SizedBox(height: 15),
            // Mock chart bars for symptoms
            _buildSymptomBar("Cramps", 0.7, Colors.pink),
            _buildSymptomBar("Headache", 0.4, Colors.purple),
            _buildSymptomBar("Mood Changes", 0.5, Colors.orange),
            _buildSymptomBar("Bloating", 0.3, Colors.blue),

          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCycleHistoryItem(String dateRange, String length, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateRange,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                "Cycle Period",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildMiniStat(Icons.loop, length),
              const SizedBox(width: 16),
              _buildMiniStat(Icons.water_drop_outlined, duration),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomBar(String label, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${(percentage * 100).toInt()}%",
                 style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[100],
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
