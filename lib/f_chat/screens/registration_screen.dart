import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/f_chat/components/rounded_button.dart';
import 'package:flash_chat/f_chat/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../interest_calc/input_form.dart';
import '../ui_uitlity.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with WidgetsBindingObserver {
  var _globalFormKey;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool _showPassword = false;
  double _height = 0.0;
  late TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _globalFormKey = GlobalKey<FormState>();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        // height of the TextFormField is calculated here, and we call setState to assign this value to Button
        _height = _globalFormKey.currentContext!.size!.height;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _globalFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            height: 200.0,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      CustomInputForm(
                        formTitle: 'Email',
                        formHint: kEmailHint,
                        inputType: TextInputType.emailAddress,
                        errorMsg: kEmailEmptyError,
                        formTextController: _emailController,
                        leadingIcon: Icons.email,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      CustomInputForm(
                        formTitle: 'Password',
                        formHint: kPasswordHint,
                        inputType: TextInputType.visiblePassword,
                        errorMsg: kPasswordLengthError,
                        formTextController: _passwordController,
                        leadingIcon: Icons.lock,
                        detector: GestureDetector(
                          onTap: () {
                            _toggleVisibility();
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        isObscure: !_showPassword,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                        title: 'Register',
                        colour: Colors.blueAccent,
                        onPressed: () {
                          doSignUp();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void doSignUp() async{
    if (_globalFormKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      setState(() {
        showSpinner = true;
      });
      try {
        final newUser =
            await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushNamed(context, ChatScreen.id);

        debugPrint(newUser.toString());

        setState(() {
          showSpinner = false;
        });
      } on FirebaseAuthException catch (e) {
        print(e);
        UiUtility.showToast(e.code);
        setState(() {
          showSpinner = false;
        });
      }
    } else {
      setState(() {
        showSpinner = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('require all field')),
      );
    }
  }
}
