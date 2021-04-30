import 'package:flutter/material.dart';
import 'package:finsta/screens/screens.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Finsta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                          onChanged: (value) => print(value),
                          validator: (value) {
                            if (value == null) return null;
                            return !value.contains('@') ? 'Please enter a valid email' : null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Password'),
                          onChanged: (value) => print(value),
                          validator: (value) {
                            if (value == null) return null;
                            return value.length < 4 ? 'Must be at least 4 characters' : null;
                          },
                        ),
                        const SizedBox(height: 28.0),
                        ElevatedButton(
                          child: Text('LOGIN'),
                          onPressed: () => print('Login'),
                        ),
                        ElevatedButton(
                          child: Text('SIGN UP'),
                          style: ElevatedButton.styleFrom(primary: Colors.grey[400]),
                          onPressed: () => print('Sign up'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
