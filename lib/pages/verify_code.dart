import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/pages/home_page.dart';


class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black, // Set the background color to black
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '6 digit code',
              fillColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white,),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
              
              ),
            ),
            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: Text('Verify',style: TextStyle(color: Colors.black),),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationCodeController.text.toString(),
                );
                try {
                  await auth.signInWithCredential(credential);
///////////navigator.push_replacement
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('Error',
                        style: TextStyle(color: Colors.black,),
                        ),
                        content: Text(e.toString()),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK',style: TextStyle(color: Colors.black,),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
