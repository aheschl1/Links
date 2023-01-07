import 'package:flutter/material.dart';
import '../../constants/decorations.dart';
import '../../services/auth_service.dart';
import '../../widgets/dialogs.dart';

class SignUp extends StatefulWidget {
  final Function login;
  const SignUp({Key? key, required this.login}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();
  String unit = "Km";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void signup()async{
    if(_formKey.currentState!.validate()){

      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login

      dynamic result = await authService.registerEmailPass(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text,
      );

      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

      if(result is String){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              duration: Duration(
                  seconds: 5
              ),
            )
        );
      }else{
        result.sendEmailVerification();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Welcome"),
              content: new Text("You have been sent an email to verify your email address."),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new TextButton(
                  child: new Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (val){
                          if(val != null && val.isNotEmpty){
                            return null;
                          }else{
                            return "Enter your name";
                          }
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: Decorations(context: context).getTextInput("Name"),
                      ),
                      SizedBox(height: 8,),
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
                      SizedBox(height: 8,),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        validator: (val){
                          if(val!.isNotEmpty && val.length > 5){
                            return null;
                          }else{
                            return "Enter a password with 6 characters or more";
                          }
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: Decorations(context: context).getTextInput("Password"),
                      ),
                      SizedBox(height: 8,),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: confirmPasswordController,
                        validator: (val){
                          if(val!.trim().isNotEmpty && val.trim() == passwordController.text.trim()){
                            return null;
                          }else{
                            return "Passwords do not match";
                          }
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: Decorations(context: context).getTextInput("Confirm password"),
                      ),
                      SizedBox(height: 8,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    style: Decorations().getButtonStyle1(),
                    icon: Icon(Icons.check_circle_outline),
                    label: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Let's go!",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    onPressed: (){
                      signup();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    TextButton(
                      onPressed: widget.login.call(),
                      child: Text(
                        "Login here",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16,)
        ],
      ),
    );
  }


}
