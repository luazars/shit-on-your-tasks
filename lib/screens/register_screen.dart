import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_register/screens/home_screen.dart';
import 'package:login_register/shared/bg_widget.dart';
import 'package:login_register/shared/button.dart';

import '../services/firebase.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final signUpButton = BasicButton(
        "SignUp",
        () => signUp(emailEditingController.text, passwordController.text),
        false);

    final loadingButton = BasicButton("", () {
      Fluttertoast.showToast(msg: "Please stay patient");
    }, true);

    final firstNameTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: firstNameEditingController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter your first name");
            }
            if (value.length < 3) {
              return ("Your name is to short");
            }
            if (value.length > 10) {
              return ("Your name is to long)");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            firstNameEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_circle_rounded),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "First Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    final secondNameTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: secondNameEditingController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter your second name");
            }
            if (value.toString().length < 3) {
              return ("Your name is to short");
            }
            if (value.length > 30) {
              return ("Your name is to long)");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            secondNameEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_circle_rounded),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Second Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    final emailTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: emailEditingController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter your Email");
            }
            if (value.toString().length < 4) {
              return ("Your Email is to short");
            }
            if (value.length > 30) {
              return ("Your Email is to long");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            emailEditingController.text = value!;
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
              return ("Please enter your password");
            }
            if (value.toString().length < 8) {
              return ("Your password is to short (min. 8)");
            }
            if (value.length > 30) {
              return ("Your password is to long");
            }
            return null;
          },
          obscureText: true,
          onSaved: (value) {
            passwordController.text = value!;
          },
          textInputAction: TextInputAction.next,
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

    final confirmTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: confirmController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please confirm your password");
            }
            if (passwordController.text != confirmController.text) {
              return ("The passwords don't match");
            }
            return null;
          },
          obscureText: true,
          onSaved: (value) {
            confirmController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key_rounded),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Confirm Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    return Background(
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    firstNameTextField,
                    secondNameTextField,
                    emailTextField,
                    passwordTextField,
                    confirmTextField,
                    loading ? loadingButton : signUpButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Firebase.registerNewUser(
            firstNameEditingController.text, secondNameEditingController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        setState(() {
          loading = false;
        });
      });
    }
  }
}
