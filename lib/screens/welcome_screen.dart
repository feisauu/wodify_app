import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/screens/signin_screen.dart';
import 'package:flutter_workout_tracker/screens/signup_screen.dart';
import 'package:flutter_workout_tracker/theme/theme.dart';
import 'package:flutter_workout_tracker/widgets/custom_scaffold.dart';
import 'package:flutter_workout_tracker/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome!\n',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text:
                            'Let\'s Start Living Healthy!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: Color(0xFFCB0505),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
