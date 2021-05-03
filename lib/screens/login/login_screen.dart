import 'package:finsta/repositories/repositories.dart';
import 'package:finsta/screens/screens.dart';
import 'package:finsta/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finsta/screens/login/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) => LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredential();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(content: state.failure.message ?? ''),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
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
                              onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
                              validator: (value) {
                                if (value == null) return null;
                                return !value.contains('@') ? 'Please enter a valid email' : null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
                              validator: (value) {
                                if (value == null) return null;
                                return value.length < 4 ? 'Must be at least 4 characters' : null;
                              },
                            ),
                            const SizedBox(height: 28.0),
                            ElevatedButton(
                              child: Text('LOGIN'),
                              onPressed: () => _submitForm(
                                context,
                                state.status == LoginStatus.submitting,
                              ),
                            ),
                            ElevatedButton(
                              child: Text('SIGN UP'),
                              style: ElevatedButton.styleFrom(primary: Colors.grey[400]),
                              onPressed: () => Navigator.of(context).pushNamed(SignupScreen.routeName),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
