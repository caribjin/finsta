import 'package:finsta/repositories/repositories.dart';
import 'package:finsta/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finsta/screens/signup/cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) => SignupCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: SignupScreen(),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredential();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.error) {
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
                              initialValue: 'YoungJin Lim',
                              decoration: InputDecoration(hintText: 'User Name'),
                              onChanged: (value) => context.read<SignupCubit>().usernameChanged(value),
                              validator: (value) {
                                if (value == null) return null;
                                return value.trim().isEmpty ? 'Please enter a user name' : null;
                              }),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            initialValue: 'caribjin@gmail.com',
                            decoration: InputDecoration(hintText: 'Email'),
                            onChanged: (value) => context.read<SignupCubit>().emailChanged(value),
                            validator: (value) {
                              if (value == null) return null;
                              return !value.contains('@') ? 'Please enter a valid email' : null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: '11211121',
                            decoration: InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            onChanged: (value) => context.read<SignupCubit>().passwordChanged(value),
                            validator: (value) {
                              if (value == null) return null;
                              return value.length < 4 ? 'Must be at least 4 characters' : null;
                            },
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            child: Text('SIGN UP'),
                            onPressed: () => _submitForm(
                              context,
                              state.status == SignupStatus.submitting,
                            ),
                          ),
                          ElevatedButton(
                            child: Text('BACK TO LOGIN'),
                            style: ElevatedButton.styleFrom(primary: Colors.grey[400]),
                            onPressed: () => Navigator.of(context).pop(),
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
    );
  }
}
