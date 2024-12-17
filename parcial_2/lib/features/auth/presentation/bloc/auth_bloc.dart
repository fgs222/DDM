import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcial_2/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/core/common/entities/user.dart';
import 'package:parcial_2/features/auth/domain/usecases/current_user.dart';
import 'package:parcial_2/features/auth/domain/usecases/user_google_login.dart';
import 'package:parcial_2/features/auth/domain/usecases/user_login.dart';
import 'package:parcial_2/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserGoogleLogin _userGoogleLogin;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserGoogleLogin userGoogleLogin,
  }) : _userSignUp = userSignUp,
      _userLogin = userLogin,
      _currentUser = currentUser,
      _appUserCubit = appUserCubit,
      _userGoogleLogin = userGoogleLogin,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthGoogleSignIn>(_onAuthGoogleSignIn);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  void _isUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        if (user == null) {
          emit(AuthNotLoggedIn());
        } else {
          _emitAuthSuccess(user, emit);
        }
      },
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthGoogleSignIn(AuthGoogleSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _userGoogleLogin(event.idToken);

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}

void _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
  emit(AuthNotLoggedIn());
}


