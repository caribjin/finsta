import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/models/models.dart';
import 'package:finsta/repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  Future<void> logInWithCredential() async {
    try {
      if (!state.isFormValid || state.status == LoginStatus.submitting) return;

      emit(state.copyWith(status: LoginStatus.submitting));

      await _authRepository.loginWithEmailAndPassword(email: state.email.trim(), password: state.password.trim());

      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (error) {
      emit(state.copyWith(failure: error, status: LoginStatus.error));
    }
  }
}
