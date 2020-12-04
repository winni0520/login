import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_auth/Screens/Authentication/google_login.dart';
import 'package:flutter_auth/Screens/Main/main_screen.dart';
import 'package:flutter_auth/Screens/Authentication/components/body.dart';
import 'package:flutter_auth/Screens/Authentication/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// {
//   @override
//   _BodyState createState() => _BodyState();
// }
// class _BodyState extends State<Body>
class SignInPage extends StatefulWidget{
  @override
  SignInPageState createState() => SignInPageState();
    // return pageState;
}
 class SignInPageState extends State<SignInPage>{

  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            /*SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),*/
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MainScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.03),
            Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: doRemember,
                  onChanged: (newValue) {
                    setState(() {
                      doRemember = newValue;
                    });
                  },
                ),
                Text("Remember Me")
              ],
            ),
          ),
          (fp.getUser() != null && fp.getUser().emailVerified == false)
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(color: Colors.red[300]),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Mail authentication did not complete."
                          "\nPlease check your verification email.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.lightBlue[400],
                        textColor: Colors.white,
                        child: Text("Resend Verify Email"),
                        onPressed: () {
                          FocusScope.of(context)
                              .requestFocus(new FocusNode()); // 키보드 감춤
                          fp.getUser().sendEmailVerification();
                        },
                      )
                    ],
                  ),
                )
              : Container(),

            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MainScreen();
                    },
                  ),
                );
                  },
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MainScreen();
                    },
                  ),
                );
                  },
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {
                    // signInWithGoogle().then((result){
                    //   if(result != null){
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context){
                    //         return MainScreen();
                    //       },
                    //       ),
                    //     );
                    //   }
                    // });
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _signInWithGoogle();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  setRememberInfo() async {
    logger.d(doRemember);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPasswd", _pwCon.text);
    }
  }
  getRememberInfo() async {
    logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("doRemember") ?? false);
    });
    if (doRemember) {
      setState(() {
        _mailCon.text = (prefs.getString("userEmail") ?? "");
        _pwCon.text = (prefs.getString("userPasswd") ?? "");
      });
    }
  }
  void _signIn() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-In...")
          ],
        ),
      ));
    bool result = await fp.signInWithEmail(_mailCon.text, _pwCon.text);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if (result == false) showLastFBMessage();
  }
  void _signInWithGoogle() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-In...")
          ],
        ),
      ));
    bool result = await fp.signInWithGoogleAccount();
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if (result == false) showLastFBMessage();
  }
  showLastFBMessage() {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content: Text(fp.getLastFBMessage()),
        action: SnackBarAction(
          label: "Done",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ));
  }
}