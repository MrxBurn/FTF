import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/styles/styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset('assets/illustrations/boxing_ring.jpg'),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SvgPicture.asset('assets/illustrations/logo.svg'),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Text(
              'Login',
              style: headerStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                const Text(
                  "Don't have an account?",
                  style: bodyStyle,
                ),
                TextButton(
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    onPressed: () => {},
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
