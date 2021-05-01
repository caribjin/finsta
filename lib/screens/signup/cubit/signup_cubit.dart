import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/models/models.dart';
import 'package:finsta/repositories/auth/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void usernameChanged(String username) {
    emit(state.copyWith(username: username, status: SignupStatus.initial));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: SignupStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: SignupStatus.initial));
  }

  Future<void> signUpWithCredential() async {
    try {
      if (!state.isFormValid || state.status == SignupStatus.submitting) return;

      emit(state.copyWith(status: SignupStatus.submitting));

      await _authRepository.signUpWithEmailAndPassword(username: state.username.trim(), email: state.email.trim(), password: state.password.trim());

      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (error) {
      emit(state.copyWith(failure: error, status: SignupStatus.error));
    }
  }
}
