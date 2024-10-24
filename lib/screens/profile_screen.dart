import 'package:bigs_bites/models/profilelist.dart';
import 'package:bigs_bites/screens/register_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()));
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bj.jpg'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 100,
                  ),
                  height: 128,
                  width: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Bilal Salman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'bilalsalman123@gmail.com',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              ProfileList(
                  onpressed: () {}, icon: Icons.person, title: 'UserDetails'),
              const SizedBox(
                height: 10,
              ),
              ProfileList(
                  onpressed: () {}, icon: Icons.settings, title: 'Settings'),
              const SizedBox(
                height: 10,
              ),
              ProfileList(
                  onpressed: () {}, icon: Icons.help, title: 'Help & Details'),
              const SizedBox(
                height: 10,
              ),
              ProfileList(
                  onpressed: () {},
                  icon: Icons.language,
                  title: 'Change Language'),
              const SizedBox(
                height: 10,
              ),
              ProfileList(
                  onpressed: () {
                    _signOut(context);
                  },
                  icon: Icons.logout,
                  title: 'Log out'),
            ],
          ),
        ),
      ),
    );
  }
}
