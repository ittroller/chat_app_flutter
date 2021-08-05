import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.submitFn,
    required this.isLoading,
  }) : super(key: key);

  // const AuthForm(this.submitFn);

  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(_userEmail, _userName, _userPassword, _isLogin);
      // Use those values to send our auth request...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      hintText: 'Email address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      controller: usernameController,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Username',
                      ),
                    ),
                  TextFormField(
                    controller: passwordController,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          emailController.clear();
                          usernameController.clear();
                          passwordController.clear();
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
