import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/pages/verify_code.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '+91 1234567890',
                fillColor: Colors.white, 
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: 
                  BorderSide(
                    color: Colors.white,
                    ),
                  ),
                ),
            ),
            const SizedBox(
              height: 50,
            ),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Login',style: TextStyle(color: Colors.black,),),
            
              onPressed: loading==true
                  ? null
                  : () async {
                      if (phoneNumberController.text.isEmpty ) {
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      // Handle button tap
                      final String phoneNumber =
                          phoneNumberController.text.trim();
                      final PhoneVerificationCompleted verificationCompleted =
                          (PhoneAuthCredential credential) async {
                        setState(() {
                          loading = false;
                        });
                      };
                      final PhoneVerificationFailed verificationFailed =
                          (FirebaseAuthException e) {
                        setState(() {
                          loading = false;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text('Error',
                              style: TextStyle(color: Colors.black,),),
                              content:
                                  Text(e.message ?? 'Verification failed.',style: TextStyle(color: Colors.black,),),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK',style: TextStyle(color: Colors.black,),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      };
                      final PhoneCodeSent codeSent =
                          (String verificationId, int? forceResendingToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCodeScreen(
                              verificationId: verificationId,
                            ),
                          ),
                        );
                        setState(() {
                          loading = false;
                        });
                      };
                      final PhoneCodeAutoRetrievalTimeout
                          codeAutoRetrievalTimeout = (String verificationId) {
                        setState(() {
                          loading = false;
                        });
                      };

                      try {
                        await auth.verifyPhoneNumber(
                          phoneNumber: '+91${phoneNumber}',
                          verificationCompleted: verificationCompleted,
                          verificationFailed: verificationFailed,
                          codeSent: codeSent,
                          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
                        );
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(e.toString()),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
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
