import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_controller.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authController) : super(LoginState.initial());

  final AuthController _authController;

  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value, clearError: true));
  }

  Future<bool> submit({required String email, required String password}) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _authController.signIn(
        email: email,
        password: password,
        rememberMe: state.rememberMe,
      );
      if (!isClosed) {
        emit(state.copyWith(isSubmitting: false, clearError: true));
      }
      return true;
    } on FirebaseAuthException catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: error.message ?? error.code,
          ),
        );
      }
      return false;
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(isSubmitting: false, errorMessage: error.toString()),
        );
      }
      return false;
    }
  }
}
