// import 'package:flutter/material.dart';
//
// // --- Hawa Health Design System ---
// // Define the core color palette based on the prompt's aesthetic.
// const Color kPrimaryTeal = Color(0xFF00ADB5); // Deep Teal for CTAs and Trust
// const Color kPastelPeach = Color(0xFFFED7AA); // Soft pastel for cycle focus
// const Color kPastelLavender = Color(0xFFD8BFD8); // Soft pastel for mood/sleep
// const Color kBackgroundColor = Color(0xFFFFFFFF); // Clean white background
// const Color kLabelColor = Color(0xFF6B7280); // Subtle grey for labels
//
// // Helper to represent a simplified data point for the dashboard
// class HealthMetric {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;
//
//   HealthMetric(this.label, this.value, this.icon, this.color);
// }
//
// // Custom Bottom-Bordered Input Field (Minimalistic Style)
// class MinimalistInputField extends StatelessWidget {
//   final String label;
//   final String hint;
//   final Widget? suffixIcon;
//   final VoidCallback? onTap;
//
//   const MinimalistInputField({
//     required this.label,
//     required this.hint,
//     this.suffixIcon,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             color: kLabelColor,
//             fontSize: 14,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.only(bottom: 8),
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   hint,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: onTap != null ? Colors.black87 : Colors.grey.shade400,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//                 if (suffixIcon != null) suffixIcon!,
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }