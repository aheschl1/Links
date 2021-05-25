import 'package:flutter/material.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/services/auth_service.dart';

class Register extends StatefulWidget {

  final Function switchAuth;
  Register(this.switchAuth);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String email = "";
  String password = "";
  String confirmPassword = "";
  String name = "";

  final _formKey = GlobalKey<FormState>();

  void registerAccount() async{
    AuthService authService = AuthService();

    if(_formKey.currentState.validate()){

      dynamic result = await authService.registerEmailPass(email: email, password: password, name: name);

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
        title: Text("Register"),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: ()=> widget.switchAuth(),
            label: Text("Sign In", style: TextStyle(color: Colors.white),
            )
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 29),
              TextFormField(
                style: TextStyle(color: Colors.black),
                validator: (val){
                  if(val.isNotEmpty){
                    return null;
                  }else{
                    return "Enter your name";
                  }
                },
                decoration: Decorations(context: context).getTextInput("Name"),
                onChanged: (val){
                  setState(() {
                    name = val;
                  });
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                style: TextStyle(color: Colors.black),
                validator: (val){
                  if(val.isNotEmpty){
                    return null;
                  }else{
                    return "Enter an email";
                  }
                },
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
                    return "Password must be 6 chars";
                  }
                },
                decoration: Decorations(context: context).getTextInput("Password"),
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                validator: (val){
                  if(val == password){
                    return null;
                  }else{
                    return "Passwords don't match";
                  }
                },
                decoration: Decorations(context: context).getTextInput("Confirm Password"),

                onChanged: (val){
                  setState(() {
                    confirmPassword = val;
                  });
                },
              ),
              SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: () => registerAccount(),
                label: Text("Create Account"),
                icon:Icon(Icons.check)
              )
            ],
          ),
        ),
      ),
    );
  }
}
