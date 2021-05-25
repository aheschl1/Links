
import 'package:flutter/material.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/services/auth_service.dart';

class SignIn extends StatefulWidget {

  final Function switchAuth;
  SignIn(this.switchAuth);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  void registerAccount() async{
    AuthService authService = AuthService();

    if(_formKey.currentState.validate()){

      dynamic result = await authService.signInEmailAndPass(email: email, password: password);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        actions: [
          TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: ()=> widget.switchAuth(),
              label: Text("Register", style: TextStyle(color: Colors.white),
              )
          )
        ],
      ),
      body:Container(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 29),
              TextFormField(
                validator: (val){
                  if(val.isNotEmpty){
                    return null;
                  }else{
                    return "Enter your email";
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: Decorations(context: context).getTextInput("Email"),
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                validator: (val){
                  if(val.length >= 6){
                    return null;
                  }else{
                    return "Enter your password";
                  }
                },
                decoration: Decorations(context: context).getTextInput("Password"),
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 22),
              ElevatedButton.icon(
                  onPressed: () => registerAccount(),
                  label: Text("Sign In"),
                  icon:Icon(Icons.check)
              )
            ],
          ),
        ),
      )
    );
  }
}
