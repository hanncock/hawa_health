/*import 'package:flutter/material.dart';

import 'health_dah.dart';
import 'health_metric.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: HawaHealthApp(),
    );
  }
}*/

/*
class HawaHealthApp extends StatefulWidget {
  const HawaHealthApp({Key? key}) : super(key: key);

  @override
  State<HawaHealthApp> createState() => _HawaHealthAppState();
}

class _HawaHealthAppState extends State<HawaHealthApp> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HealthDashboardScreen(), // 1. Dashboard
    // Placeholder screens for other tabs
    const Center(child: Text('Tracking & Logging', style: TextStyle(color: Colors.black))), // 2. Tracking
    const Center(child: Text('Insights & Predictions', style: TextStyle(color: Colors.black))), // 3. Insights
    const Center(child: Text('Telemedicine & Care', style: TextStyle(color: Colors.black))), // 4. Telemedicine
    const Center(child: Text('Profile & Marketplace', style: TextStyle(color: Colors.black))), // 5. Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hawa Health',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryTeal,
        fontFamily: 'Poppins', // Use a modern sans-serif font
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: kBackgroundColor,
        body: _widgetOptions.elementAt(_selectedIndex),

        // Custom Bottom Navigation Bar (Minimalist)
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Tracking'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Insights'),
            BottomNavigationBarItem(icon: Icon(Icons.local_hospital_outlined), label: 'Care'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryTeal, // Deep teal for active tab
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed, // Ensure all icons are visible
          onTap: _onItemTapped,
          elevation: 8, // Subtle separation
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

void main() {
  runApp(const HawaSignInReplica());
}

class HawaSignInReplica extends StatelessWidget {
  const HawaSignInReplica({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hawa Health - Sign In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginPage(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// void main() {
//   runApp(const SignInReplicaApp());
// }
//
// class SignInReplicaApp extends StatelessWidget {
//   const SignInReplicaApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sign In Replica',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         textTheme: GoogleFonts.poppinsTextTheme(),
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const SignInPage(),
//     );
//   }
// }
//
// class SignInPage extends StatefulWidget {
//   const SignInPage({super.key});
//
//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }
//
// class _SignInPageState extends State<SignInPage> {
//   bool _obscure = true;
//   bool _remember = false;
//   final _emailController = TextEditingController(text: 'example@gmail.com');
//   final _passwordController = TextEditingController(text: 'password');
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   // Color palette similar to hawa.health (soft peach/blush + deep brown).
//   final Color bgStart = const Color(0xFFFFE6E1);
//   final Color bgEnd = const Color(0xFFFFD6C9);
//   final Color accentDark = const Color(0xFF4A2C2A); // buttons / accents
//   final Color textDark = const Color(0xFF2D1C1B);
//   final Color secondaryText = const Color(0xFF8B8B8B);
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     // Card width responsive (on phone ~ 88%).
//     final cardWidth = width * 0.92;
//
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [bgStart, bgEnd],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(vertical: 18.0),
//               child: Column(
//                 children: [
//                   // Small top spacing and optional decorative stars
//                   SizedBox(height: 12),
//                   // Center card container
//                   Container(
//                     width: cardWidth,
//                     constraints: const BoxConstraints(
//                       maxWidth: 520,
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 22.0, vertical: 26.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(28),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.06),
//                           blurRadius: 18,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // top logo badge
//                         Container(
//                           width: 64,
//                           height: 64,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFFE6EE),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.bubble_chart_rounded,
//                               size: 32,
//                               color: const Color(0xFFFF6B9A),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         // Title
//                         Text(
//                           'Sign in',
//                           style: TextStyle(
//                             color: textDark,
//                             fontSize: 22,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Log in to access your account',
//                           style: TextStyle(
//                             color: secondaryText,
//                             fontSize: 13.5,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 18),
//                         // Email field
//                         _buildInputField(
//                           controller: _emailController,
//                           hint: 'example@gmail.com',
//                           label: 'Email',
//                           prefix: Icons.email_outlined,
//                           obscure: false,
//                         ),
//                         const SizedBox(height: 12),
//                         // Password field
//                         _buildInputField(
//                           controller: _passwordController,
//                           hint: 'password',
//                           label: 'password',
//                           prefix: Icons.lock_outline,
//                           obscure: true,
//                           obscureToggle: () {
//                             setState(() => _obscure = !_obscure);
//                           },
//                           isObscured: _obscure,
//                         ),
//                         const SizedBox(height: 8),
//                         // Remember me & forgot (row)
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   height: 22,
//                                   width: 22,
//                                   child: Checkbox(
//                                     value: _remember,
//                                     onChanged: (v) =>
//                                         setState(() => _remember = v ?? false),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(6.0)),
//                                     activeColor: accentDark,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Remember me',
//                                   style: TextStyle(
//                                     color: secondaryText,
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             TextButton(
//                               onPressed: () {},
//                               style: TextButton.styleFrom(
//                                 padding: EdgeInsets.zero,
//                                 minimumSize: const Size(40, 28),
//                                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                               ),
//                               child: Text(
//                                 'Forgot?',
//                                 style: TextStyle(
//                                   color: secondaryText,
//                                   fontSize: 13.0,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         // Sign in button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 52,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: accentDark,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               elevation: 2,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 24, vertical: 6),
//                               textStyle: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             child: const Text('Sign in'),
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         // or login with
//                         Row(
//                           children: [
//                             const Expanded(
//                               child: Divider(thickness: 1, height: 1),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(horizontal: 12.0),
//                               child: Text(
//                                 'or login with',
//                                 style: TextStyle(
//                                   color: secondaryText,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ),
//                             const Expanded(
//                               child: Divider(thickness: 1, height: 1),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 14),
//                         // Social buttons
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: () {},
//                                 style: OutlinedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12)),
//                                   side: BorderSide(
//                                       color: Colors.grey.shade300, width: 1),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     // simple 'G' badge as placeholder for Google logo
//                                     Container(
//                                       width: 28,
//                                       height: 28,
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                               color: Colors.grey.shade200)),
//                                       child: const Center(
//                                         child: Text(
//                                           'G',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     const Text('Google'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: () {},
//                                 style: OutlinedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12)),
//                                   side: BorderSide(
//                                       color: Colors.grey.shade300, width: 1),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     // Apple icon - using built-in icon (may vary by platform)
//                                     const Icon(Icons.apple, size: 22),
//                                     const SizedBox(width: 10),
//                                     const Text('Apple'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 18),
//                         // Bottom text
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Don't have an account? ",
//                               style: TextStyle(
//                                   color: secondaryText,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: Text(
//                                 'Sign up',
//                                 style: TextStyle(
//                                   color: const Color(0xFFFF6B9A),
//                                   fontSize: 13.2,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // small bottom rounded bar hint (like the phone home indicator)
//                   const SizedBox(height: 18),
//                   Container(
//                     width: cardWidth * 0.36,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.06),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hint,
//     required String label,
//     required IconData prefix,
//     required bool obscure,
//     VoidCallback? obscureToggle,
//     bool isObscured = false,
//   }) {
//     final inputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2),
//     );
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label[0].toUpperCase() + label.substring(1),
//           style: TextStyle(
//             color: const Color(0xFF8B8B8B),
//             fontSize: 12.5,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: obscure ? isObscured : false,
//           keyboardType:
//           obscure ? TextInputType.visiblePassword : TextInputType.emailAddress,
//           decoration: InputDecoration(
//             contentPadding:
//             const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//             isDense: true,
//             hintText: hint,
//             prefixIcon: Icon(prefix, size: 20, color: Colors.grey.shade600),
//             suffixIcon: obscure
//                 ? IconButton(
//               splashRadius: 20,
//               onPressed: obscureToggle,
//               icon: Icon(
//                 isObscured ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey.shade600,
//               ),
//             )
//                 : null,
//             filled: true,
//             fillColor: Colors.white,
//             enabledBorder: inputBorder,
//             focusedBorder: inputBorder.copyWith(
//                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.3)),
//             border: inputBorder,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
