import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/pages/login_or_register_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  //sign user out method
  signUserOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginOrRegisterPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('DashBoard',), // Set the background color to black
        actions: [
          IconButton(
            onPressed: () {
              signUserOut(context);
            },
            icon: const  Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          
          
          child: Text(
            'LOGGED IN AS: ${user?.email ?? ""}',
            style: const TextStyle(fontSize: 20,color: Colors.black),
          ),
        ),
      ),
    );
  }
}
