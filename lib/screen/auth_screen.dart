import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
              child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black45,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'My Shop',
                      style: TextStyle(
                        fontSize: 46,
                        color: Theme.of(context).textTheme.title.color,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _passwoardController = TextEditingController();
  var _isLoading = false;
  var _authData = {
    'email': '',
    'password': '',
  };
  AnimationController _controller;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  void _toggleAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
      return;
    }
    setState(() {
      _authMode = AuthMode.Login;
    });
    _controller.reverse();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.Login) {
      await Provider.of<Auth>(context, listen: false)
          .login(
        _authData['email'],
        _authData['password'],
      )
          .catchError((error) {
        // print(error);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('$error'),
          duration: Duration(seconds: 3),
        ));
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      await Provider.of<Auth>(context, listen: false).signup(
        _authData['email'],
        _authData['password'],
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _authMode == AuthMode.Signup ? 300 : 240,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 300 : 240,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email.isEmpty || !email.contains('@')) {
                      return 'Please enter a valid email address.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (email) {
                    _authData['email'] = email;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwoardController,
                  validator: (pass) {
                    if (pass.length < 6) {
                      return 'Password must be at least 6 digit.';
                    }
                    return null;
                  },
                  onSaved: (pass) {
                    _authData['password'] = pass;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (pass) {
                        if (pass != _passwoardController.text) {
                          return 'the password does not match.';
                        }
                      },
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: RaisedButton(
                        onPressed: _onSubmit,
                        child: Text(
                            _authMode == AuthMode.Login ? 'Login' : 'Sign Up'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
                    if (_isLoading)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                        color: Colors.white60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
                FlatButton(
                  onPressed: _toggleAuthMode,
                  child: Text(_authMode == AuthMode.Login ? 'SignUp' : 'Login'),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
