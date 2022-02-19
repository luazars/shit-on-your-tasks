import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_register/screens/home_screen.dart';
import 'package:login_register/screens/register_screen.dart';
import 'package:login_register/shared/button.dart';
import 'package:progress_state_button/progress_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //loading
  bool loading = false;
  ButtonState stateLoginButton = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    void signIn(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        setState(() => loading = true);
        try {
          await _auth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((uid) => {
                    Fluttertoast.showToast(msg: "Login Successful"),
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                  });
        } on FirebaseAuthException catch (error) {
          Fluttertoast.showToast(msg: error.code);
          setState(() => loading = false);
        }
      }
    }

    final loginButton = BasicButton("Login", () {
      signIn(emailController.text, passwordController.text);
    }, false);

    final loadingButton = BasicButton("", () {
      Fluttertoast.showToast(msg: "Please stay patient");
    }, true);

    final signUpText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegisterScreen())),
          child: Text(
            "SignUp",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary),
          ),
        )
      ],
    );

    final emailTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter your Email");
            }
            if (value.toString().length < 4) {
              return ("Please enter a real Email");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            emailController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_rounded),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    final passwordTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: passwordController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter your Password");
            }
            return null;
          },
          obscureText: true,
          onSaved: (value) {
            passwordController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key_rounded),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 65),
                  emailTextField,
                  passwordTextField,
                  loading ? loadingButton : loginButton,
                  const SizedBox(height: 25),
                  signUpText,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
