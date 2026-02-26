import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Health Tips',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF5C2A6B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Cycle Health"),
            const SizedBox(height: 10),
            _buildTipCard(
              "Stay Hydrated",
               "Drinking water helps reduce bloating and cramps during your period.",
               Icons.water_drop_outlined,
               Colors.blue
            ),
            _buildTipCard(
              "Track Your Symptoms",
              "Logging your symptoms daily helps identify patterns and irregularities.",
              Icons.edit_note,
              Colors.purple
            ),
             const SizedBox(height: 20),
            _buildSectionHeader("Self Care"),
             const SizedBox(height: 10),
            _buildTipCard(
              "Gentle Exercise",
              "Light yoga or walking can alleviate menstrual pain and improve mood.",
              Icons.self_improvement,
              Colors.green
            ),
             _buildTipCard(
              "Heat Therapy",
              "Applying a heat patch or hot water bottle can relax uterine muscles.",
              Icons.local_fire_department_outlined,
              Colors.orange
            ),
             const SizedBox(height: 20),
            _buildSectionHeader("Nutrition"),
            const SizedBox(height: 10),
            _buildTipCard(
              "Iron-Rich Foods",
              "Replenish lost iron with leafy greens, beans, and lean meats.",
              Icons.restaurant,
              Colors.red
            ),
             _buildTipCard(
              "Limit Caffeine",
              "Reducing coffee intake can help lower anxiety and breast tenderness.",
              Icons.coffee_outlined,
              Colors.brown
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF5C2A6B),
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
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
