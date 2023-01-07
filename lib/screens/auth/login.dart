import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../constants/decorations.dart';
import '../../services/auth_service.dart';

class Login extends StatefulWidget {
  final Function signup;
  const Login({Key? key, required this.signup}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool resettingPassword = false;
  bool startAnimation = false;

  void login() async {
    if(_formKey.currentState!.validate()){
      dynamic result = await authService.signInEmailAndPass(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );

      if(result is String){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              duration: Duration(
                  seconds: 5
              ),
            )
        );
      }


    }
  }

  void forgotPassword(){
    setState(() {
      resettingPassword = true;
    });
    if(_formKey.currentState!.validate()){
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An email has been sent to ${emailController.text.trim()}'),
            duration: Duration(
                seconds: 5
            ),
          )
      );
      emailController.text = "";
    }
    setState(() {
      resettingPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (val){
                      if(val != null && val.isNotEmpty){
                        return null;
                      }else{
                        return "Enter your email";
                      }
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: Decorations(context: context).getTextInput("Email"),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                    validator: (val){
                      if((val != null && val.isNotEmpty) || resettingPassword){
                        return null;
                      }else{
                        return "Enter your password";
                      }
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: Decorations(context: context).getTextInput("Password"),
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text('Forgot my password'),
                        onPressed: ()=>forgotPassword(),
                      ),
                      ElevatedButton.icon(
                        style: Decorations().getButtonStyle1(),
                        icon: Icon(Icons.check_circle_outline),
                        label: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Let's go!",
                            style: TextStyle(
                              fontSize: 20,

                            ),
                          ),
                        ),
                        onPressed: (){
                          login();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Need to signup?",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold

                  ),
                ),
                TextButton(
                  onPressed: widget.signup.call(),
                  child: Text(
                    "Create an account",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startAnimationEvent() async {
    await Future.delayed(const Duration(seconds : 5));
    if(!mounted) {
      return;
    }
    startAnimation = true;

  }

  @override
  void initState() {
    super.initState();
    startAnimationEvent();
  }
}
