import 'package:dartz/dartz.dart';
import 'package:flutter_training/core/error/failures.dart';
import 'package:flutter_training/core/network/network_info.dart';
import 'package:flutter_training/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_training/domain/entities/user.dart';
import 'package:flutter_training/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(
          email: email,
          password: password,
        );
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
