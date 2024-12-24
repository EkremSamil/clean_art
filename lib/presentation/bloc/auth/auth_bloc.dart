import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_training/domain/usecases/login_usecase.dart';
import 'package:flutter_training/presentation/bloc/auth/auth_state.dart';
import 'auth_event.dart';
import 'package:flutter_training/core/error/failures.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    emit(
      result.fold(
        (failure) => AuthError(_mapFailureToMessage(failure)),
        (user) => AuthSuccess(user),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Sunucu hatası oluştu';
      case NetworkFailure:
        return 'İnternet bağlantınızı kontrol edin';
      default:
        return 'Beklenmeyen bir hata oluştu';
    }
  }
}
