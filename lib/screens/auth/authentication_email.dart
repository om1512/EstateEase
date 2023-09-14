import 'package:estateease/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationEmail extends StatefulWidget {
  const AuthenticationEmail({super.key});

  @override
  State<AuthenticationEmail> createState() => _AuthenticationEmailState();
}

class _AuthenticationEmailState extends State<AuthenticationEmail> {
  bool _isVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signInWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Theme.of(context).colorScheme.background;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: myColor,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: myColor),
              decoration: InputDecoration(
                label: Text("Email"),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Color.fromARGB(255, 176, 175, 175)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 176, 175, 175)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 87, 87, 87)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 176, 175, 175)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: myColor,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: myColor),
              obscureText: _isVisible ? false : true,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                      _isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                ),
                label: Text("Password"),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Color.fromARGB(255, 176, 175, 175)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 176, 175, 175)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 87, 87, 87)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 176, 175, 175)),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 31, 46, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: signInUser,
                child: Text(
                  "Verify",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      size: 15,
                      color: Color.fromARGB(255, 175, 175, 175),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                        "If you come for the first than please sign up with credentials",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 10,
                            color: const Color.fromARGB(255, 175, 175, 175))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
