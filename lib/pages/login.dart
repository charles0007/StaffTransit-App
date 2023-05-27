import 'dart:convert';
import 'dart:ffi';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:staff_transit2/constant_values.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  String _email = "";
  String _password = "";
  String _name = "";

  bool signinPage = true;
  bool signupPage = false;
  bool _nameSubmited = false;
  bool _emailSubmited = false;
  bool _passwordSubmited = false;
  bool _hasSentValidationEmail = false;

  Color signinBG = yellow;
  Color signupBG = black;

  void tabClick(String tab) {
    print(tab);
    setState(() {
      if (tab == "signin") {
        signinBG = yellow;
        signupBG = black;
        signinPage = true;
        signupPage = false;
      } else if (tab == "signup") {
        signinBG = black;
        signupBG = yellow;
        signinPage = false;
        signupPage = true;
      }
    });
  }

  bool isEmailValid(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      tabClick("signin");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: signinBG,
                      foregroundColor: Colors.white,
                      // minimumSize: const Size(40, 40),
                      // padding: EdgeInsets.only(top: 00),
                      // // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      // textStyle: TextStyle(
                      //   fontSize: 16.0,
                      //
                      // ),
                    ),
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                          color: Colors.white,
                          // fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                ElevatedButton(
                    onPressed: () {
                      tabClick("signup");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: signupBG,
                      foregroundColor: Colors.white,
                      // minimumSize: const Size(40, 40),
                      // padding: EdgeInsets.only(top: 00),
                      // // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      // textStyle: TextStyle(
                      //   fontSize: 16.0,
                      //
                      // ),
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.white,
                          // fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  signupPage
                      ? AnimatedOpacity(
                          opacity: signupPage ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            onChanged: (val) {
                              if (val.length > 2 && !_nameSubmited) {
                                print("_name11");
                                setState(() {
                                  _nameSubmited = true;
                                });
                              } else if (val.length < 3 && _nameSubmited) {
                                print("_name22");
                                setState(() {
                                  _nameSubmited = false;
                                  _email = "";
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                          ))
                      : Container(),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        enabled: signinPage || (signupPage && _nameSubmited)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isEmailValid(value)) {
                        return 'Email is invalid';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  if (_hasSentValidationEmail || signinPage)
                    Column(children: [
                      SizedBox(height: 16.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                    ]),
                  SizedBox(height: 16.0),
                  signinPage
                      ? AnimatedOpacity(
                          opacity: signinPage ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 0),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    // TODO: handle sign-in logic
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  foregroundColor: Colors.white,
                                  // minimumSize: const Size(40, 40),
                                  // padding: EdgeInsets.only(top: 00),
                                  // // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                  // textStyle: TextStyle(
                                  //   fontSize: 16.0,
                                  //
                                  // ),
                                ),
                                child: const Text(
                                  'CONTINUE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        )
                      : Container(),
                  AnimatedOpacity(
                    opacity: signupPage ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 0),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: _hasSentValidationEmail
                          ? ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  // TODO: handle sign-in logic
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                foregroundColor: Colors.white,
                                // minimumSize: const Size(40, 40),
                                // padding: EdgeInsets.only(top: 00),
                                // // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                // textStyle: TextStyle(
                                //   fontSize: 16.0,
                                //
                                // ),
                              ),
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  apiController.validateEmail(_email);
!apiController.isLoading.value?
                                  (ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Success!',
                                        message:
                                        'Route selected successfully!',

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    ))):Container();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                foregroundColor: Colors.white,
                                // minimumSize: const Size(40, 40),
                                // padding: EdgeInsets.only(top: 00),
                                // // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                // textStyle: TextStyle(
                                //   fontSize: 16.0,
                                //
                                // ),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => apiController.isLoading.value
                                        ? CircularProgressIndicator()
                                        : Container()),
                                    // Icon(
                                    //   Icons.favorite,
                                    //   size: 20,
                                    // ),
                                    Text(
                                      'VALIDATE EMAIL',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),

                            ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Obx(() => apiController.isLoading.value
                      ? Container()
                      : Text(apiController.validateEmailAPIStatus.value=="true"?"success":apiController.validateEmailAPIError.value,textAlign: TextAlign.center, style: TextStyle(
                      color: apiController.validateEmailAPIStatus.value=="false"?Colors.redAccent:yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
