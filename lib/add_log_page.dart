import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mock_data.dart'; // Import for Enums

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

  final List<String> _availableSymptoms = [
    "Cramps", "Headache", "Bloating", "Fatigue", "Acne", 
    "Backache", "Nausea", "Insomnia", "Cravings"
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveLog() {
    // In a real app, this would save to a database or state management store
    // For now, we just pop back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log saved successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Log Daily Health',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF5C2A6B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _saveLog,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date Selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: const Color(0xFFF5E9FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5C2A6B),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                         builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF5C2A6B),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, color: Color(0xFF5C2A6B)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flow Section
                  _buildSectionTitle("Menstrual Flow"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: FlowIntensity.values.map((flow) {
                      return _buildChoiceChip(
                        label: flow.name[0].toUpperCase() + flow.name.substring(1),
                        selected: _selectedFlow == flow,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFlow = selected ? flow : null;
                          });
                        },
                        color: Colors.pinkAccent,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 30),

                  // Mood Section
                  _buildSectionTitle("Mood"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12, // add vertical spacing
                    children: Mood.values.map((mood) {
                      return _buildChoiceChip(
                        label: mood.name[0].toUpperCase() + mood.name.substring(1),
                        selected: _selectedMood == mood,
                        onSelected: (selected) {
                          setState(() {
                            _selectedMood = selected ? mood : null;
                          });
                        },
                         color: Colors.purpleAccent,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Symptoms Section
                  _buildSectionTitle("Symptoms"),
                   const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                     runSpacing: 12,
                    children: _availableSymptoms.map((symptom) {
                      final isSelected = _selectedSymptoms.contains(symptom);
                      return FilterChip(
                        label: Text(symptom),
                        labelStyle: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSymptoms.add(symptom);
                            } else {
                              _selectedSymptoms.remove(symptom);
                            }
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF5C2A6B),
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF5C2A6B) : Colors.grey[400]!,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Notes Section
                  _buildSectionTitle("Notes"),
                   const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Add any additional notes here...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5C2A6B)),
                      ),
                    ),
                  ),
                  
                   const SizedBox(height: 40),
                   
                   SizedBox(
                     width: double.infinity,
                     height: 50,
                     child: ElevatedButton(
                       onPressed: _saveLog,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFF5C2A6B),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12),
                         ),
                       ),
                       child: Text(
                         "Save Log",
                         style: GoogleFonts.poppins(
                           fontSize: 16,
                           fontWeight: FontWeight.w600,
                           color: Colors.white,
                         ),
                       ),
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

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required Color color,
  }) {
    return ChoiceChip(
      label: Text(label),
      labelStyle: GoogleFonts.poppins(
        color: selected ? Colors.white : Colors.black87,
        fontSize: 14,
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? color : Colors.grey[400]!,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
