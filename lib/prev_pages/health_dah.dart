// import 'package:flutter/material.dart';
//
// import 'health_metric.dart';
//
// class HealthDashboardScreen extends StatefulWidget {
//   const HealthDashboardScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
// }
//
// class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
//   // Mock data for the dynamic dashboard based on life stage
//   final String currentLifeStage = 'Fertility'; // Change to 'Menstruation' or 'Menopause'
//
//   final List<HealthMetric> wearablesData = [
//     HealthMetric('Sleep Score', '85', Icons.nights_stay, kPastelLavender),
//     HealthMetric('Steps', '7,200', Icons.directions_run, kPastelPeach),
//     HealthMetric('HRV (Stress)', '52ms', Icons.monitor_heart, kPrimaryTeal.withOpacity(0.7)),
//   ];
//
//   final List<String> aiInsights = [
//     'Low Magnesium: Recommended supplement today.',
//     'Sleep low: Increase activity to boost HRV tomorrow.',
//     'Your predicted cycle length is stable at 28 days.',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       body: CustomScrollView(
//         slivers: [
//           // 1. Dynamic Header (Profile & Trust Indicator)
//           SliverAppBar(
//             backgroundColor: kBackgroundColor,
//             elevation: 0,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Hawa Health',
//                   style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     const Icon(Icons.shield_outlined, color: kPrimaryTeal, size: 20),
//                     const SizedBox(width: 4),
//                     Text(
//                       'Data Secure',
//                       style: TextStyle(color: kPrimaryTeal, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             pinned: true,
//             automaticallyImplyLeading: false,
//           ),
//
//           SliverList(
//             delegate: SliverChildListDelegate([
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Text('Hello, ${userData == null ? '---' : userData[1]['name']} 👋', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//
//                     // 2. Central Dynamic Card (Digital Twin)
//                     _buildDynamicCard(),
//                     const SizedBox(height: 30),
//
//                     // 3. Wearables Data Snapshot
//                     Text(
//                       'Biometrics Snapshot',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: wearablesData.map((metric) => _buildMetricChip(metric)).toList(),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // 4. AI Insights Stream (Horizontal)
//                     Text(
//                       'AI Insights Stream',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       height: 100,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: aiInsights.length,
//                         itemBuilder: (context, index) => _buildInsightCard(aiInsights[index]),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDynamicCard() {
//     String title = currentLifeStage == 'Fertility' ? 'Fertile Window Forecast' : 'Next Period In';
//     String value = currentLifeStage == 'Fertility' ? 'Peak Ovulation: Oct 12' : '7 Days (Oct 13)';
//     Color color = currentLifeStage == 'Fertility' ? kPastelPeach : kPastelLavender;
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color, width: 2),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton.icon(
//             onPressed: () { /* Navigate to detailed tracking */ },
//             icon: const Icon(Icons.arrow_forward_ios, size: 14),
//             label: const Text('View Full Calendar'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kPrimaryTeal,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMetricChip(HealthMetric metric) {
//     return Expanded(
//       child: Card(
//         color: metric.color.withOpacity(0.1),
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(metric.icon, color: metric.color, size: 24),
//               const SizedBox(height: 4),
//               Text(
//                 metric.value,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 metric.label,
//                 style: const TextStyle(fontSize: 10, color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInsightCard(String insight) {
//     return Container(
//       width: 250,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.lightbulb_outline, color: kPrimaryTeal, size: 20),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Text(
//               insight,
//               style: const TextStyle(fontSize: 14, height: 1.4),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }