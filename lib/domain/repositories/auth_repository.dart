import 'package:dartz/dartz.dart';
import 'package:flutter_training/domain/entities/user.dart';
import 'package:flutter_training/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
}
