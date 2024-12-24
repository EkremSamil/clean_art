import 'package:dartz/dartz.dart';
import 'package:flutter_training/core/error/failures.dart';
import 'package:flutter_training/domain/entities/user.dart';
import 'package:flutter_training/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}
