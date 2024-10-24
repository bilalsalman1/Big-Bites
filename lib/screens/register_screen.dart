import 'package:bigs_bites/screens/bottomnavigation.dart';
import 'package:bigs_bites/style/button_styles.dart';
import 'package:bigs_bites/style/color_styles.dart';
import 'package:bigs_bites/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();

  bool isLogin = true;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn != null && isLoggedIn) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()));
    }
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      print('Form validation failed');
      return;
    }

    try {
      if (isLogin) {
        final userCredential = await firebase.signInWithEmailAndPassword(
          email: _loginEmailController.text,
          password: _loginPasswordController.text,
        );
        print('User logged in successfully: ${userCredential.user}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()));
      } else {
        final userCredential = await firebase.createUserWithEmailAndPassword(
          email: _signupEmailController.text,
          password: _signupPasswordController.text,
        );
        print('User registered successfully: ${userCredential.user}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()));
      }
    } on FirebaseAuthException catch (error) {
      print('FirebaseAuthException: ${error.code}, Message: ${error.message}');
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
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                dynamicTitleText(
                    text: 'Deliver Favorite Food',
                    fontSize: 21,
                    color: ColorStyles.white),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height:
                      isLogin ? MediaQuery.of(context).size.height * 0.5 : 390,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: ColorStyles.deepPurple.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 25, right: 20, left: 20),
                    child: Column(
                      children: [
                        dynamicTitleText(
                            text: isLogin ? 'Login' : 'Sign up',
                            fontSize: 25,
                            color: ColorStyles.white),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _form,
                          child: Column(
                            children: [
                              if (!isLogin) ...[
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a username.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefix: const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    contentPadding:
                                        const EdgeInsets.only(left: 20),
                                    hintText: 'UserName',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                              TextFormField(
                                controller: isLogin
                                    ? _loginEmailController
                                    : _signupEmailController,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains("@")) {
                                    return ("Please enter a valid email address");
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefix: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  contentPadding:
                                      const EdgeInsets.only(left: 20),
                                  hintText: 'example@gmail.com',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                obscureText: _obscureText,
                                controller: isLogin
                                    ? _loginPasswordController
                                    : _signupPasswordController,
                                decoration: InputDecoration(
                                    prefix: const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    contentPadding:
                                        const EdgeInsets.only(left: 20),
                                    hintText: 'Password',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Colors.white))),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return ("Password must be at least 6 character long.");
                                  }
                                  return null;
                                },
                              ),
                              Visibility(
                                visible: isLogin,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text('Forgot Password'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ButtonStyles(
                                  onPressed: _submit,
                                  text: isLogin ? 'Login' : 'Create Account'),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: dynamicTitleText(
                                        text: 'Or',
                                        color: Colors.red,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.facebook_rounded,
                                    size: 27,
                                    color: ColorStyles.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    dynamicTitleText(
                        text: isLogin
                            ? 'Don\'t have an Account'
                            : ' Already have an Account',
                        fontSize: 16,
                        color: ColorStyles.white,
                        fontWeight: FontWeight.w400),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: dynamicTitleText(
                          text: isLogin ? 'REGISTER' : 'LOGIN',
                          color: ColorStyles.white,
                          fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
